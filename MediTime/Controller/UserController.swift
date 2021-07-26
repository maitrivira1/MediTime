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
        showImagePickerController()
    }
    
}

extension UserController: Setup{
    
    func setupUI(){
        navigationItem.title = "Isi Data Pengguna"
        navigationItem.largeTitleDisplayMode = .never
        
        saveButton.layer.cornerRadius = 12
    }
    
}

// MARK: - image picker
extension UserController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
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
