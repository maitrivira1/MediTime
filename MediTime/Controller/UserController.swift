//
//  UserController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class UserController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        showActionSheet()
    }
    
}

extension UserController: Setup{
    
    func setupUI(){
        navigationItem.title = "Isi Data Pengguna"
        navigationItem.largeTitleDisplayMode = .never
        
        saveButton.layer.cornerRadius = 12
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func showActionSheet(){
        let actionsheet = UIAlertController(title: "", message: "Choose the photo from", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.showImagePickerController()
        }
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("camera")
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        actionsheet.addAction(galleryButton)
        actionsheet.addAction(cameraButton)
        actionsheet.addAction(cancelButton)
        
        present(actionsheet, animated: true, completion: nil)
    }
    
}

extension UserController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.view.tintColor = UIColor.systemBlue
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImageButton.setImage(editedImage, for: .normal)
        }else{
            profileImageButton.setImage(UIImage.init(systemName: "photo"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
