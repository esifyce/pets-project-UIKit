//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Sabir Myrzaev on 21.06.2021.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var category: String
    @NSManaged public var date: Date
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locationDescription: String
    @NSManaged public var placemark: CLPlacemark?
    @NSManaged public var photoID: NSNumber?

}

extension Location : Identifiable {

}
