//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 19.06.2021.
//

import UIKit
import CoreLocation
import CoreData
import AudioToolbox

class CurrentLocationViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeTextLabel: UILabel!
    @IBOutlet weak var longitudeTextLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    let locationManager = CLLocationManager()
    // CLGeocoder - это объект, который будет выполнять геокодирование
    let geocoder = CLGeocoder()
    // CLPlacemark объект, содержащий результаты адреса
    var placemark: CLPlacemark?
    var location: CLLocation?
    var perfromReverseGeocoding = false
    var updateLocation = false
    var logoVisible = false
    var lastLocationError: Error?
    var lastGeocodingError: Error?
    var timer: Timer?
    var managedObjectContext: NSManagedObjectContext?
    var soundID: SystemSoundID = 0
    
    lazy var logoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "Logo"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        button.center.x = self.view.bounds.midX
        button.center.y = 220
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSoundEffect("Sound.caf")
        updateLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    // MARK: - Actions
    @IBAction func getLocation() {
        // запрашиваем разрешение на доступ к информации местоположения
        let authStatus = locationManager.authorizationStatus
        // .notDeterminedозначает, что это приложение еще не запрашивало разрешение
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        // показывает алерт если отклонили запрос о получении местоположении
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if logoVisible {
            hideLogoView()
        }
        
        if updateLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
    }
    
    // MARK: - Helper Alert Location Method
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UpdateLabels
    func updateLabels() {
        
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
            
            // Показать адрес пользователю
            if let placemark = placemark {
                addressLabel.text = "\(placemark)"
            } else if perfromReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
            latitudeTextLabel.isHidden = false
            longitudeTextLabel.isHidden = false
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
        
        let statusMessage: String
        // проверка ошибки
        if let error = lastLocationError as NSError? {
            if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                statusMessage = "Службы геолокации отключены"
            } else {
                statusMessage = "Ошибка определения местоположения"
            }
        } else if !CLLocationManager.locationServicesEnabled() {
            statusMessage = "Служба геолокации отключены"
        } else if updateLocation {
            statusMessage = "Поиск..."
        } else {
            statusMessage = ""
            showLogoView()
        }
        messageLabel.text = statusMessage
        latitudeTextLabel.isHidden = true
        longitudeTextLabel.isHidden = true
        }
        configureGetButton()
    }
    // MARK: - configureGetButton
    // если приложение в настоящее время обновляет местоположение
    func configureGetButton() {
        let spinnerTag = 1000
        
        if updateLocation {
            getButton.setTitle("Stop", for: .normal)
            
            if view.viewWithTag(spinnerTag) == nil {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.center = messageLabel.center
                spinner.center.y += spinner.bounds.size.height / 2 + 25
                spinner.startAnimating()
                spinner.tag = spinnerTag
                containerView.addSubview(spinner)
            }
        } else {
            getButton.setTitle("Get My Location", for: .normal)
            
            if let spinner = view.viewWithTag(spinnerTag) {
                spinner.removeFromSuperview()
            }
        }
    }
    // MARK: - String
    func string(from placemark: CLPlacemark) -> String {
        
        var line1 = ""
        var line2 = ""
        // subThoroughfare это причудливое название для номера дома
        line1.add(text: placemark.subThoroughfare)
        // thoroughfare названия улицы
        line1.add(text: placemark.thoroughfare, separatorFor: " ")
        
        // населенный пункт
        line2.add(text: placemark.locality)
        // административный район
        line2.add(text: placemark.administrativeArea, separatorFor: " ")
        // почтовый индекс
        line2.add(text: placemark.postalCode, separatorFor: " ")
        
        line1.add(text: line2, separatorFor: "\n")
        return line1
    }
    // MARK: - showLogoView & hideLogoView
    func showLogoView() {
        if !logoVisible {
            logoVisible = true
            containerView.isHidden = true
            view.addSubview(logoButton)
        }
    }
    
    func hideLogoView() {
        if !logoVisible { return }
        
        logoVisible = false
        containerView.isHidden = false
        containerView.center.x = view.bounds.size.width * 2
        containerView.center.y = 40 + containerView.bounds.size.height / 2
        
        // MARK: - Animation Logo
        let centerX = view.bounds.midX
        
        let panelMover = CABasicAnimation(keyPath: "position")
        panelMover.isRemovedOnCompletion = false
        panelMover.fillMode = CAMediaTimingFillMode.forwards
        panelMover.duration = 0.6
        panelMover.fromValue = NSValue(cgPoint: containerView.center)
        panelMover.toValue = NSValue(cgPoint: CGPoint(x: centerX, y: containerView.center.y))
        panelMover.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        panelMover.delegate = self
        containerView.layer.add(panelMover, forKey: "panelMover")
        
        let logoMover = CABasicAnimation(keyPath: "position")
        logoMover.isRemovedOnCompletion = false
        logoMover.fillMode = CAMediaTimingFillMode.forwards
        logoMover.duration = 0.5
        logoMover.fromValue = NSValue(cgPoint: logoButton.center)
        logoMover.toValue = NSValue(cgPoint: CGPoint(x: -centerX, y: logoButton.center.y))
        logoMover.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        logoButton.layer.add(logoMover, forKey: "logoMover")
        
        let logoRotator = CABasicAnimation(keyPath: "transform.rotation.z")
        logoRotator.isRemovedOnCompletion = false
        logoRotator.fillMode = CAMediaTimingFillMode.forwards
        logoRotator.duration = 0.5
        logoRotator.fromValue = 0.0
        logoRotator.toValue = -2 * Double.pi
        logoRotator.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        logoButton.layer.add(logoRotator, forKey: "logoRotator")
    }

    // MARK: - StartLocationManager
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            // включаете диспетчер местоположения тогда, когда хотим исправить местоположение
            // и выключаем его снова, когда вы получили пригодное для использования местоположение
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updateLocation = true
            
            // Если к этому моменту приложение еще не нашло местоположение, мы указываем iOS выполнить метод через минуту
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: - StopLocationManager
    func stopLocationManager() {
        
        if updateLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updateLocation = false
            // остонавливаем таймер
            if let timer = timer {
                timer.invalidate()
            }
        }
    }
    // didTimeOut() всегда вызывается через одну минуту
    @objc func didTimeOut() {
        print("*** Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TagLocation" {
            let controller = segue.destination as! LocationDetailsViewController
            controller.coordinate = location!.coordinate
            controller.placemark = placemark
            controller.managedObjectContext = managedObjectContext
        }
    }
    
    // MARK: - Sound Effect
    func loadSoundEffect(_ name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            let fileURL = URL(fileURLWithPath: path, isDirectory: false)
            let error = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
            if error != kAudioServicesNoError {
                print("Error code: \(error), loading sound: \(path)")
            }
        }
    }
    
    func unloadSoundEffect() {
        AudioServicesDisposeSystemSoundID(soundID)
        soundID = 0
    }
    
    func playSoundEffect() {
        AudioServicesPlaySystemSound(soundID)
    }
}

// MARK: - CLLocationManagerDelegate
extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("didFailWithError \(error.localizedDescription)")
        
        // местоположение в настоящее время неизвестно, попробовать еще раз
        if(error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        // В случае более серьезной ошибки вы сохраняете объект ошибки
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // удаляем старую ошибку, если местоположение все таки найдено
        lastLocationError = nil
        
        // Если предыдущего показания не было, то
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        let newLocation = locations.last!
        print("didUpdateLocation \(newLocation)")
        // Улучшение результатов GPS
        // Предоставляет последнее найденное местоположение
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        // определяет, являются ли новые показания более точными, чем предыдущие
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        // вычисляет расстояние между новым показанием и предыдущим показанием
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        // определяете, является ли новое чтение более полезным, чем предыдущее
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            // очищает любую предыдущую ошибку
            lastLocationError = nil
            location = newLocation
        }
        // остановливаем диспетчер местоположения
        if distance > 0 {
            perfromReverseGeocoding = false
        }
        // Если точность нового местоположения равна или лучше, чем желаемая точность, вы можете прекратить запрашивать обновления
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("*** Мы закончили!")
            stopLocationManager()
        }
        updateLabels()
        
        if !perfromReverseGeocoding {
            print("*** Начали геокодирование")
            perfromReverseGeocoding = true
            geocoder.reverseGeocodeLocation(newLocation) { [weak self] placemarks, error in
                // Обработка ошибок обратного геокодирования
                self?.lastGeocodingError = error
                if error == nil, let places = placemarks, !places.isEmpty {
                    if self?.placemark == nil {
                        self?.playSoundEffect()
                    }
                    self?.placemark = places.last!
                } else {
                    self?.placemark = nil
                }
                self?.perfromReverseGeocoding = false
                self?.updateLabels()
            }
        } else if distance < 1 {
            
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** Force done!")
                stopLocationManager()
                updateLabels()
            }
        }
    }
}
// MARK: - CAAnimation delegate
extension CurrentLocationViewController: CAAnimationDelegate {
    // очищает после анимации и удаляет кнопку с логотипом
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        containerView.layer.removeAllAnimations()
        containerView.center.x = view.bounds.size.width / 2
        containerView.center.y = 40 + containerView.bounds.size.height / 2
        logoButton.layer.removeAllAnimations()
        logoButton.removeFromSuperview()
    }
}

