//
//  Extension.swift
//  MediTime
//
//  Created by Maitri Vira on 22/07/21.
//

import Foundation
import CoreData
import UIKit

class DatabaseHandler{
    var image: UIImage? = nil
    var entity = ""
    
    func saveImage(){
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDe.persistentContainer.viewContext
        
        if entity == "User"{
            let photoObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! User
            photoObject.photo = image?.jpegData(compressionQuality: 1) as Data?
        }else{
            let photoObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: context) as! Medicine
            photoObject.photo = image?.jpegData(compressionQuality: 1) as Data?
        }
        
        do {
            try context.save()
            print("photo saved")
        } catch {
            print("error")
        }
    }
    
    func retrieveData() -> [User]{
        var photos = [User]()
        let appDe = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDe.persistentContainer.viewContext
        
        do {
            photos = try (context.fetch(User.fetchRequest()))
        } catch {
            print("error")
        }
        return photos
    }
    
}
