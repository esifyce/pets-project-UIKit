//
//  LocationDetailViewController.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 20.06.2021.
//

import UIKit
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class LocationDetailsViewController: UITableViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
        
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var managedObjectContext: NSManagedObjectContext!
    var date = Date()
    var descriptionText = ""
    var observer: Any!
    var image: UIImage? {
        didSet {
            if let theImage = image {
                show(image: theImage)
            }
        }
    }
    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listenForBackgroundNotification()

        if let location = locationToEdit {
            title = "Edit Location"
            if location.hasPhoto {
                if let theImage = location.photoImage {
                    show(image: theImage)
                }
            }
        }
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No address found"
        }

        dateLabel.text = format(date: date)
        
        // скрыть клавиатуру
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    // убирает клавиатуру при касании на любое другое место
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if let indexPath = indexPath {
            if indexPath.section == 0 && indexPath.row == 0 {
                descriptionTextView.resignFirstResponder()
            }
        } else {
        descriptionTextView.resignFirstResponder()
        }
    }
    
// MARK: - Actions
    @IBAction func done() {
        // HUD
        guard let mainView = navigationController?.parent?.view else { return }
        let hudView = HudView.hud(inView: mainView, animated: true)
        
        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Update"
            location = temp
        } else {
        hudView.text = "Tagged"
        location = Location(context: managedObjectContext)
        location.photoID = nil
        }
        
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        
        do {
            try managedObjectContext.save()
            // GCD, закрыть view через 0.6 секунд
            afterDelay(0.6) {
                hudView.hide(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            fatalCoreDataError(error)
        }
        if let image = image {
            // должны получить новый идентификатор
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID() as NSNumber
            }
            // преобразует UIImageв формат JPEG и возвращает Dataобъект
            if let data = image.jpegData(compressionQuality: 0.5) {
                // охраняете Dataобъект по пути, заданному photoURL свойством
                do {
                    try data.write(to: location.photoURL, options: .atomic)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
// MARK: - Helper method
    func string(from placemark: CLPlacemark) -> String {
        
        var line = ""
        
        line.add(text: placemark.subThoroughfare)
        line.add(text: placemark.thoroughfare, separatorFor: ", ")
        line.add(text: placemark.locality, separatorFor: ", ")
        line.add(text: placemark.administrativeArea, separatorFor: " ")
        line.add(text: placemark.postalCode, separatorFor: ", ")
        line.add(text: placemark.country, separatorFor: " ")

        return line
    }
    // просит DateFormatterпревратить Date в String
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func listenForBackgroundNotification() {
        observer = NotificationCenter.default.addObserver(forName: UIScene.didEnterBackgroundNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] _ in
            if self?.presentedViewController != nil {
                self?.dismiss(animated: false, completion: nil)
            }
            self?.descriptionTextView.resignFirstResponder()
        }
    }
    
    deinit {
        print("*** deinit \(self)")
        NotificationCenter.default.removeObserver(observer!)
    }
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
// MARK: - Table biew delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
}

// MARK: - UIImagePickerController & UINavigationController delegates
extension  LocationDetailsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Helper image method
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.view.tintColor = view.tintColor
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // вызывается, когда пользователь выбирает фотографию
        image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
//        if let theImage = image {
//            show(image: theImage)
//        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take a photo", style: .default) { [weak self] _ in
            self?.takePhotoWithCamera()
        }
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose photo from library", style: .default) { [weak self] _ in
            self?.choosePhotoFromLibrary()
        }
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    func show(image: UIImage) {
        imageView.image = image
        imageView.isHidden = false
        addPhotoLabel.text = ""
        imageHeight.constant = (image.size.width / image.size.height) * 120
        tableView.reloadData()
    }
}


