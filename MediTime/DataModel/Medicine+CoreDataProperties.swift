//
//  Medicine+CoreDataProperties.swift
//  MediTime
//
//  Created by Maitri Vira on 05/08/21.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var bentukObat: String?
    @NSManaged public var dosis: String?
    @NSManaged public var jumlahObat: String?
    @NSManaged public var jumlahPemakaian: String?
    @NSManaged public var nama: String?
    @NSManaged public var photo: Data?
    @NSManaged public var unit: String?
    @NSManaged public var waktuMakan: String?
    @NSManaged public var id: Int16
    @NSManaged public var users: User?

}

extension Medicine : Identifiable {

}
