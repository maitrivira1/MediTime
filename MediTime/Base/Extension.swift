//
//  Extension.swift
//  MediTime
//
//  Created by Maitri Vira on 02/08/21.
//

import UIKit

class Extension: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //alert
    
    func showAlertConfirmation(on vc: UIViewController, title: String, message: String, status: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            
            if status == "berhasil"{
                vc.navigationController?.popToRootViewController(animated: true)
            }
            
        }))
        
        vc.present(alert, animated: true)
        
    }
    
    //action
    func showActionSheet(on vc: UIViewController){
        let actionsheet = UIAlertController(title: "", message: "Choose the photo from", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { [self] (action) in
            showImagePickerController(on: vc)
        }
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { [self] (action) in
            showCameraController(on: vc)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        actionsheet.addAction(galleryButton)
        actionsheet.addAction(cameraButton)
        actionsheet.addAction(cancelButton)
        
        vc.present(actionsheet, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(on vc: UIViewController){
        let imagePickerController = UIImagePickerController()
        imagePickerController.view.tintColor = UIColor.systemBlue
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        vc.present(imagePickerController, animated: true, completion: nil)
    }
    
    func showCameraController(on vc: UIViewController){
        let imageCameraController = UIImagePickerController()
        imageCameraController.view.tintColor = UIColor.systemBlue
        imageCameraController.delegate = self
        imageCameraController.allowsEditing = true
        imageCameraController.sourceType = .camera
        vc.present(imageCameraController, animated: true, completion: nil)
    }
    
}
