//
//  UserController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit
import CoreData

class UserController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var sickTextfield: UITextField!
    
    var users = [User]()
    var userSelected: User?
    var status = ""
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    weak var delegate: UserDataDelegate?
    
    let ext = Extension()
    
    var profileImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = appDelegate?.persistentContainer.viewContext{
            manageObjectContext = context
        }else{
            ext.showCrash(on: self)
        }

        setupUI()
        loadData()
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        showAction()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        status == "edit" ? updateData() : addData()
    }
    
}

extension UserController: Setup{
    
    func setupUI(){
        navigationItem.title = "Isi Data Pengguna"
        navigationItem.largeTitleDisplayMode = .never
        
        saveButton.layer.cornerRadius = 12
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if status == "edit"{
            
            guard let user = userSelected, let photo = userSelected?.photo else {
                ext.showCrash(on: self)
                return
            }
            
            nameTextfield.text = user.name
            sickTextfield.text = user.sick
            profileImageButton.setImage(UIImage(data: photo), for: .normal)
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func showAction(){
        let actionsheet = UIAlertController(title: "", message: "Choose the photo from", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.showImagePickerController()
        }
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showCameraController()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        actionsheet.addAction(galleryButton)
        actionsheet.addAction(cameraButton)
        actionsheet.addAction(cancelButton)
        
        present(actionsheet, animated: true, completion: nil)
    }
    
}

extension UserController: SetupData{
    
    func addData() {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: manageObjectContext)
        
        guard let newEntity = entity else{
            ext.showCrash(on: self)
            return
        }
        
        let newUser = NSManagedObject(entity: newEntity, insertInto: manageObjectContext)
        
        guard let name = nameTextfield.text, !name.isEmpty,
              let sick = sickTextfield.text, !sick.isEmpty,
              profileImage != nil, let profile = profileImage
        else{
            self.ext.showAlertConfirmation(on: self , title: "Isi Data Pengguna", message: "Silahkan masukan foto dan lengkapi data", status: "kosong")
            return
        }
        
        let photo = profile.jpegData(compressionQuality: 1)
        
        let id = users.count + 1
        newUser.setValue(id, forKey: "id")
        newUser.setValue(name, forKey: "name")
        newUser.setValue(photo, forKey: "photo")
        newUser.setValue(sick, forKey: "sick")
        
        do {
            try manageObjectContext.save()
            print("save: \(newUser)")
            
            ext.showAlertConfirmation(on: self , title: "Isi Data Pengguna", message: "Berhasil ditambahkan", status: "berhasil")
            
        } catch let error as NSError {
            print("error: \(error)")
            
            ext.showAlertConfirmation(on: self , title: "Isi Data Pengguna", message: "Gagal ditambahkan", status: "gagal")
        }
    }
    
    func updateData(){
        
        profileImage = profileImage == nil ? profileImageButton.image(for: .normal) : profileImage
        
        guard let name = nameTextfield.text, !name.isEmpty,
              let sick = sickTextfield.text, !sick.isEmpty,
              profileImage != nil, let profile = profileImage
        else{
            self.ext.showAlertConfirmation(on: self , title: "Isi Data Pengguna", message: "Silahkan masukan foto dan lengkapi data", status: "kosong")
            return
        }
        
        let photo = profile.jpegData(compressionQuality: 1)
        
        userSelected?.setValue(name, forKey: "name")
        userSelected?.setValue(sick, forKey: "sick")
        userSelected?.setValue(photo, forKey: "photo")
        
        do{
            try manageObjectContext.save()
            
            ext.showAlertConfirmation(on: self , title: "Isi Data Pengguna", message: "Berhasil ditambahkan", status: "berhasil")
        } catch{
            print(error)
            
            ext.showAlertConfirmation(on: self , title: "Isi Data Pengguna", message: "Gagal ditambahkan", status: "gagal")
        }
        
    }
    
    func loadData(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            try users = manageObjectContext.fetch(userRequest)
        } catch {
            print("error")
        }
    }

}

extension UserController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.view.tintColor = UIColor.systemBlue
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func showCameraController(){
        let imageCameraController = UIImagePickerController()
        imageCameraController.view.tintColor = UIColor.systemBlue
        imageCameraController.delegate = self
        imageCameraController.allowsEditing = true
        imageCameraController.sourceType = .camera
        present(imageCameraController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImage = editedImage
            profileImageButton.setImage(editedImage, for: .normal)
        }else{
            profileImageButton.setImage(UIImage.init(systemName: "photo"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
