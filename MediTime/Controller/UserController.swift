//
//  UserController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit
import CoreData
import Photos

class UserController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var sickTextfield: UITextField!
    @IBOutlet weak var addPhoto: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var disease: UILabel!
    
    var users = [User]()
    var usersName = [User]()
    var userSelected: User?
    var status = ""
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var statusName = false
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
        showAction(sender)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        status == "edit" ? updateData() : addData()
    }
    
}

extension UserController: Setup{
    
    func setupUI(){
        navigationItem.title = "fill.user.data".localized()
        navigationItem.largeTitleDisplayMode = .never
        
        saveButton.layer.cornerRadius = 12
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        if status == "edit" {
            
            guard let user = userSelected, let photo = userSelected?.photo else {
                ext.showCrash(on: self)
                return
            }
            
            nameTextfield.text = user.name
            sickTextfield.text = user.sick
            profileImageButton.setImage(UIImage(data: photo), for: .normal)
        }
        
        addPhoto.text = "add.photo".localized()
        name.text = "name".localized()
        nameTextfield.placeholder = "name.placeholder".localized()
        disease.text = "disease".localized()
        sickTextfield.placeholder = "disease.placeholder".localized()
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func showAction(_ sender: Any){
        let actionsheet = UIAlertController(title: "", 
                                            message: "Choose the photo from",
                                            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.showImagePickerController()
        }
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showCameraController()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (action) in }
        
        actionsheet.addAction(galleryButton)
        actionsheet.addAction(cameraButton)
        actionsheet.addAction(cancelButton)
        
        if let popoverController = actionsheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.barButtonItem = sender as? UIBarButtonItem
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(actionsheet, animated: true, completion: nil)
    }
    
}

extension UserController: SetupData{
    
    func loadData(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            try users = manageObjectContext.fetch(userRequest)
        } catch {
            print("error")
        }
    }
    
    func loadDataName(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        
        do {
            try usersName = manageObjectContext.fetch(userRequest)
            usersName = usersName.filter{$0.name == nameTextfield.text}
            
            if usersName.isEmpty {
                statusName = true
            }
            
        } catch {
            print("error")
        }
    }
    
    func addData() {
        
        guard let name = nameTextfield.text, !name.isEmpty,
              let sick = sickTextfield.text, !sick.isEmpty,
              profileImage != nil, let profile = profileImage
        else{
            self.ext.showAlertConfirmation(on: self , 
                                           title: "fill.user.data".localized(),
                                           message: "fill.user.data.warning".localized(),
                                           status: "kosong")
            return
        }
        
        loadDataName()
        
        if statusName == true {
            
            let entity = NSEntityDescription.entity(forEntityName: "User", in: manageObjectContext)
            
            guard let newEntity = entity else{
                ext.showCrash(on: self)
                return
            }
            
            let newUser = NSManagedObject(entity: newEntity, insertInto: manageObjectContext)
            
            let photo = profile.jpegData(compressionQuality: 1)
            
            let id = users.count + 1
            newUser.setValue(id, forKey: "id")
            newUser.setValue(name, forKey: "name")
            newUser.setValue(photo, forKey: "photo")
            newUser.setValue(sick, forKey: "sick")
            
            do {
                try manageObjectContext.save()
                ext.showAlertConfirmation(on: self , 
                                          title: "fill.user.data".localized(),
                                          message: "fill.user.data.success".localized(),
                                          status: "berhasil")
                
            } catch {
                ext.showAlertConfirmation(on: self , 
                                          title: "fill.user.data".localized(),
                                          message: "fill.user.data.failed".localized(),
                                          status: "gagal")
            }
            
        } else {
            self.ext.showAlertConfirmation(on: self , 
                                           title: "fill.user.data.already.exist.title".localized(),
                                           message: "fill.user.data.already.exist".localized(),
                                           status: "gagal")
            return
        }
        
    }
    
    func updateData(){
        
        profileImage = profileImage == nil ? profileImageButton.image(for: .normal) : profileImage
        
        guard let name = nameTextfield.text, !name.isEmpty,
              let sick = sickTextfield.text, !sick.isEmpty,
              profileImage != nil, let profile = profileImage
        else{
            self.ext.showAlertConfirmation(on: self , 
                                           title: "fill.user.data".localized(),
                                           message: "fill.user.data.warning".localized(),
                                           status: "kosong")
            return
        }
        
        let photo = profile.jpegData(compressionQuality: 1)
        
        userSelected?.setValue(name, forKey: "name")
        userSelected?.setValue(sick, forKey: "sick")
        userSelected?.setValue(photo, forKey: "photo")
        
        do{
            try manageObjectContext.save()
            
            ext.showAlertConfirmation(on: self , 
                                      title: "fill.user.data".localized(),
                                      message: "fill.user.data.success".localized(),
                                      status: "berhasil")
        } catch{
            print(error)
            
            ext.showAlertConfirmation(on: self , 
                                      title: "fill.user.data".localized(), 
                                      message: "fill.user.data.failed".localized(),
                                      status: "gagal")
        }
        
    }
    
}

extension UserController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(){
        let photos = PHPhotoLibrary.authorizationStatus()
        
        switch photos {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .authorized:
                    self.goToPhotoLibrary()
                case .limited:
                    self.showAlertSelectAllPhoto()
                case .denied:
                    DispatchQueue.main.async {
                        self.showAlertGoToSettings(title: "permission.gallery".localized())
                    }
                default:
                    DispatchQueue.main.async {
                        self.showAlertGoToSettings(title: "permission.gallery".localized())
                    }
                }
            })
        case .authorized:
            self.goToPhotoLibrary()
        case .limited:
            self.showAlertSelectAllPhoto()
        case .restricted: fallthrough
        case .denied :
            DispatchQueue.main.async {
                self.showAlertGoToSettings(title: "permission.gallery".localized())
            }
        default:
            DispatchQueue.main.async {
                self.showAlertGoToSettings(title: "permission.gallery".localized())
            }
        }
    }
    
    func showCameraController(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                DispatchQueue.main.async {
                    let imageCameraController = UIImagePickerController()
                    imageCameraController.view.tintColor = UIColor.systemBlue
                    imageCameraController.delegate = self
                    imageCameraController.allowsEditing = true
                    imageCameraController.sourceType = .camera
                    self.present(imageCameraController, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlertGoToSettings(title: "permission.camera".localized())
                }
            }
        }
    }
    
    func showAlertGoToSettings(title: String) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            self.goToSettings()
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertSelectAllPhoto() {
        let alertController = UIAlertController(title: "permission.select.all.photo".localized(),
                                                message: "",
                                                preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            self.goToSettings()
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func goToSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    func goToPhotoLibrary() {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.view.tintColor = UIColor.systemBlue
            self.present(imagePickerController, animated: true, completion: nil)
        }
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
