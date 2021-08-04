//
//  User+CoreDataProperties.swift
//  MediTime
//
//  Created by Maitri Vira on 04/08/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var sick: String?
    @NSManaged public var id: Int16
    @NSManaged public var medicines: NSSet?

}

// MARK: Generated accessors for medicines
extension User {

    @objc(addMedicinesObject:)
    @NSManaged public func addToMedicines(_ value: Medicine)

    @objc(removeMedicinesObject:)
    @NSManaged public func removeFromMedicines(_ value: Medicine)

    @objc(addMedicines:)
    @NSManaged public func addToMedicines(_ values: NSSet)

    @objc(removeMedicines:)
    @NSManaged public func removeFromMedicines(_ values: NSSet)

}

extension User : Identifiable {

}
