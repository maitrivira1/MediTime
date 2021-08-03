//
//  User+CoreDataProperties.swift
//  MediTime
//
//  Created by Maitri Vira on 02/08/21.
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
    @NSManaged public var medicines: Medicine?

}

extension User : Identifiable {

}
