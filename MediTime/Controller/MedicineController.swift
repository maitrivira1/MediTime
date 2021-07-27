//
//  MedicineController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class MedicineController: UIViewController {
    
    @IBOutlet weak var saveButton: UIView!
    @IBOutlet weak var dosisTextField: UITextField!
    @IBOutlet weak var eatingTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    
    let dosisPicker = UIPickerView()
    let eatPicker = UIPickerView()
    
    let dosis = ["1 x sehari", "2 x sehari", "3 x sehari", "4 x sehari"]
    let eat = ["Sebelum Makan", "Sesudah Makan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func imageTapped(_ sender: UIButton) {
        showImagePickerController()
    }
    
}

extension MedicineController: Setup{
    
    func setupUI(){
        navigationItem.title = "Keterangan Obat"
        navigationItem.largeTitleDisplayMode = .never
        
        dosisPicker.delegate = self
        dosisPicker.dataSource = self
        
        eatPicker.delegate = self
        eatPicker.dataSource = self
        
        dosisTextField.inputView = dosisPicker
        eatingTextField.inputView = eatPicker
        
        saveButton.layer.cornerRadius = 12
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
}

extension MedicineController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dosisPicker {
            return dosis.count
        } else if pickerView == eatPicker{
             return eat.count
        }

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dosisPicker  {
            return dosis[row]
        }else if pickerView == eatPicker {
            return eat[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dosisPicker {
            dosisTextField.text = dosis[row]
        }else if pickerView == eatPicker {
            eatingTextField.text = eat[row]
        }
    }

}

extension MedicineController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showImagePickerController(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageButton.setImage(editedImage, for: .normal)
        }else{
            imageButton.setImage(UIImage.init(systemName: "photo"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

//import UIKit
//import UserNotifications
//
//class ViewController: UIViewController, UNUserNotificationCenterDelegate {
//
//    struct Notification {
//
//        struct Category {
//            static let tutorial = "tutorial"
//        }
//
//        struct Action {
//            static let readLater = "readLater"
//            static let showDetails = "showDetails"
//            static let unsubscribe = "unsubscribe"
//        }
//
//    }
//
//    // Input dari Date
//
//    var tahun: Int = 0
//    var bulan: Int = 0
//    var hari: Int = 0
//    var jam: Int = 0
//    var menit: Int = 0
//    var detik: Int = 0
//    var stahun: Int = 0
//    var sbulan: Int = 0
//    var shari: Int = 0
//    var sjam: Int = 0
//    var smenit: Int = 0
//    var sdetik: Int = 0
//
//    var dlmSehari: Int = 0
//    var brpHari: Int = 0
//    var detik2: Int = 10
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // 2 kali makan obat jam 8, jam 20; 3 kali makan obat, jam 8, jam 16, jam 24, jam 8, jam 14, jam 20, jam 2
//        // jika sehari 2 kali, dlmSehari = 2, jika 3 kali, dlmSehari = 3
//        // dlmSehari 1x s/d 4x
//        dlmSehari = 3
//        brpHari = 5
//
//        let date = Date()
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        tahun = components.year ?? 0
//        bulan = components.month ?? 0
//        hari = components.day ?? 0
//        jam = components.hour ?? 0
//        menit = components.minute ?? 0
//        detik = 0
//
//        print(detik)
//        menit += 1
//        detik += 10
//        print(detik)
//
//        // test
//        print(tahun)
//        print(bulan)
//        print(hari)
//        print(jam)
//        print(menit)
//        print(detik)
//
//        for indek1 in 1...brpHari {
//            // hitung future, kemudian future diambil tahun.... s/d detik
//
//            for indek2 in 1...dlmSehari {
//                detik += 3
//                notif(mes: indek2, stahun:tahun, sbulan: bulan, shari: hari, sjam: jam, smenit: menit, sdetik: detik)
//                print("Hari ke: \(indek1)")
//                print("Obat ke: \(indek2)")
//            }
//            detik2 = detik
//        }
//
//    }
//
//    func notif(mes: Int, stahun: Int, sbulan: Int, shari: Int, sjam: Int, smenit: Int, sdetik: Int) {
//
//        // Step 1: Ask for permission
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//
//        // Define Actions
//        let actionReadLater = UNNotificationAction(identifier: Notification.Action.readLater, title: "Aksi Satu", options: [])
//        let actionShowDetails = UNNotificationAction(identifier: Notification.Action.showDetails, title: "Aksi Dua", options: [.foreground])
//        let actionUnsubscribe = UNNotificationAction(identifier: Notification.Action.unsubscribe, title: "Aksi Tiga", options: [.destructive, .authenticationRequired])
//
//        // Define Category
//        let tutorialCategory = UNNotificationCategory(identifier: Notification.Category.tutorial, actions: [actionReadLater, actionShowDetails, actionUnsubscribe], intentIdentifiers: [], options: [])
//
//        // Register Category
//        UNUserNotificationCenter.current().setNotificationCategories([tutorialCategory])
//
//        // Step 2: Create th enotification content
//        let content = UNMutableNotificationContent()
//        if mes == 1 {
//            content.title = "1. Obat Pertama"
//            content.body = "Tetap semangat untuk kesembuhan 💪"
//        } else if mes == 2 {
//            content.title = "2. Obat Kedua"
//            content.body = "Semangat lagi untuk kesembuhan 💪"
//        } else {
//            content.title = "3. Obat Ketiga"
//            content.body = "Lagi-lagi, semangat lagi untuk kesembuhan 💪"
//        }
//        content.categoryIdentifier = Notification.Category.tutorial
//        content.sound = .default
//
//        // Step 3: Create the notification trigger
//        let dateComponents = DateComponents(year: tahun, month: bulan, day: hari, hour: jam, minute: menit, second: detik)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//        // Step 4: Create the request
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
//
//        // Step 5: Register & request
//        center.add(request) {(error) in
//
//        }
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                didReceive response: UNNotificationResponse,
//                withCompletionHandler completionHandler:
//                   @escaping () -> Void) {
//
//        switch response.actionIdentifier {
//        case Notification.Action.readLater:
//            print("Save Tutorial For Later")
//        case Notification.Action.unsubscribe:
//            print("Unsubscribe Reader")
//        default:
//            print("Other Action")
//        }
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//             willPresent notification: UNNotification,
//             withCompletionHandler completionHandler:
//                @escaping (UNNotificationPresentationOptions) -> Void) {
//
//       // Don't alert the user for other types.
//       completionHandler(UNNotificationPresentationOptions(rawValue: 0))
//    }
//
//}

