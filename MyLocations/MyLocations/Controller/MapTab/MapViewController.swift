//
//  MapViewController.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 21.06.2021.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var managedObjectContext: NSManagedObjectContext! {
        didSet {
            NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext, queue: OperationQueue.main) { _ in
                if self.isViewLoaded {
                    self.updateLocations()
                }
            }
        }
    }
    var locations = [Location]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // извлекает Location объекты и показывает их на карте при загрузке представления
        updateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let controller = segue.destination as! LocationDetailsViewController
            controller.managedObjectContext = managedObjectContext
            let button = sender as! UIButton
            let location = locations[button.tag]
            controller.locationToEdit = location
        }
    }

    // MARK: - Actions
    @IBAction func showUser() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations() {
        // для вычисления разумной области
        let theRegion = region(for: locations)
        mapView.setRegion(theRegion, animated: true)
    }
    // MARK: - Helper method
    func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = Location.entity()
        
        let fetchRequset = NSFetchRequest<Location>()
        fetchRequset.entity = entity
        
        locations = try! managedObjectContext.fetch(fetchRequset)
        mapView.addAnnotations(locations)
    }
    
    func region(for annnotations: [MKAnnotation]) -> MKCoordinateRegion {
        
        let region: MKCoordinateRegion
        
        switch annnotations.count {
        // Аннотаций нет. Центрируем карту по текущему положению пользователя
        case 0:
            region = MKCoordinateRegion(center: mapView.userLocation.coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        // Есть только одна аннотация. Центрируем карту на ней
        case 1:
            let annotation = annnotations[annnotations.count - 1]
            region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        // Есть две и более анотации, расчитываем степень их досягаемости и добавляем отступов
        default:
            var topLeft = CLLocationCoordinate2D(latitude: -90,
                                                 longitude: 180)
            var bottomRight = CLLocationCoordinate2D(latitude: 90,
                                                     longitude: -180)
            
            for annotation in annnotations {
                topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
                topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
                
                bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
                bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
            }
            let center = CLLocationCoordinate2D(latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2,
                                                longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace,
                                        longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }
    
    // MARK: - showLocationDetails
    @objc func showLocationDetails(_ sender: UIButton) {
        performSegue(withIdentifier: "EditLocation", sender: sender)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // могут быть и другие объекты кроме Location объекта, которые хотят быть анотациями на карте, к примеру местоположение юзера
        guard annotation is Location else { return nil }
        
        // просим повторно использовать объект вида аннотации
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            let pinView = MKPinAnnotationView(annotation: annotation,
                                              reuseIdentifier: identifier)
            
            // настройка аннотации
            pinView.isEnabled = true
            pinView.canShowCallout = true
            pinView.animatesDrop = false
            pinView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            
            // добавляем кнопку раскрытия деталей анностации
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.addTarget(self, action: #selector(showLocationDetails(_:)), for: .touchUpInside)
            
            pinView.rightCalloutAccessoryView = rightButton
            annotationView = pinView
        }
        if let annotationView = annotationView {
            annotationView.annotation = annotation
            
            let button = annotationView.rightCalloutAccessoryView as! UIButton
            if let index = locations.firstIndex(of: annotation as! Location) {
                button.tag = index
            }
        }
        return annotationView
    }
}
