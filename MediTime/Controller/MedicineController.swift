//
//  MedicineController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class MedicineController: UIViewController {
    
    @IBOutlet weak var saveButton: UIView!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var padatButton: UIButton!
    @IBOutlet weak var cairButton: UIButton!
    @IBOutlet weak var tetesButton: UIButton!
    @IBOutlet weak var olesButton: UIButton!
    
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var jumlahObatTextField: UITextField!
    @IBOutlet weak var dosisTextField: UITextField!
    @IBOutlet weak var jumlahPemakaiTextField: UITextField!
    @IBOutlet weak var eatingTextField: UITextField!
    
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var unitLine: UIView!
    @IBOutlet weak var eatingView: UIView!
    @IBOutlet weak var eatingLine: UIView!
    @IBOutlet weak var jumlahPemakaianView: UIView!
    @IBOutlet weak var jumlahPemakaianLine: UIView!
    @IBOutlet weak var jadwalView: UIView!
    @IBOutlet weak var tableView: UIView!
    
    @IBOutlet weak var scheduleTable: UITableView!
    @IBOutlet weak var hariView: UIView!
    @IBOutlet weak var hariLabel: UILabel!
    
    let dosisPicker = UIPickerView()
    let eatPicker = UIPickerView()
    
    let toolbar = UIToolbar()
    
    let dosis = ["1 x sehari", "2 x sehari", "3 x sehari", "4 x sehari"]
    let eat = ["Sebelum Makan", "Sesudah Makan"]
    
    var jumlahObat = 0
    var jumlahPemakaian = 0
    var jumlahDosis = 0
    
    var type = "padat"
    
    var reminderDatas = [ReminderData]()
    
    var dosisSelected = 0
    var dosisCount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func imageTapped(_ sender: UIButton) {
        showAction()
    }
    
    @IBAction func bentukObatTapped(_ sender: UIButton) {
        type = sender.currentTitle!
        getMedicine()
        showDay()
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
        
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.tableFooterView = UIView()
        
        dosisTextField.inputView = dosisPicker
        eatingTextField.inputView = eatPicker
        
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([cancelButton], animated: true)
        self.toolbar.tintColor = UIColor.systemBlue
        dosisTextField.inputAccessoryView = toolbar
        eatingTextField.inputAccessoryView = toolbar
        
        saveButton.layer.cornerRadius = 12
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        hariLabel.text = ""
        hariLabel.isHidden = true
        hariView.isHidden = true
        jadwalView.isHidden = true
        tableView.isHidden = true
        
        let nib = UINib(nibName: "ScheduleListTVC", bundle: nil)
        scheduleTable.register(nib, forCellReuseIdentifier: "ScheduleListTVC")
        
        getMedicine()
        showDay()
        
    }
    
    @objc func dismissKeyboard(){
        
        self.view.endEditing(true)
        showDay()
        showSchedule()
        scheduleTable.reloadData()
        
    }
    
    func showAction(){
        
        let action = UIAlertController(title: "", message: "Choose the photo from", preferredStyle: .actionSheet)
        
        let galleryButton = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.showImagePickerController()
        }
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.showCameraController()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
        
        action.addAction(galleryButton)
        action.addAction(cameraButton)
        action.addAction(cancelButton)
        
        present(action, animated: true, completion: nil)
        
    }
    
    func showSchedule(){
        
        guard let dosisText = dosisTextField.text, !dosisText.isEmpty else{
            return
        }
        dosisSelected =  Int(dosisText.prefix(1))!
        
        jadwalView.isHidden = false
        tableView.isHidden = false
        
        reminderDatas = []
        if dosisSelected == 2 {
            reminderDatas.append(ReminderData(hour: 8))
            reminderDatas.append(ReminderData(hour: 20))
        }else if dosisSelected == 3 {
            reminderDatas.append(ReminderData(hour: 7))
            reminderDatas.append(ReminderData(hour: 15))
            reminderDatas.append(ReminderData(hour: 23))
        }else if dosisSelected == 4 {
            reminderDatas.append(ReminderData(hour: 6))
            reminderDatas.append(ReminderData(hour: 12))
            reminderDatas.append(ReminderData(hour: 18))
            reminderDatas.append(ReminderData(hour: 24))
        }else{
            reminderDatas.append(ReminderData(hour: 9))
        }
        
    }
    
    func showDay(){
        
        guard let obatText = jumlahObatTextField.text, !obatText.isEmpty,
            let pemakaianText = jumlahPemakaiTextField.text, !pemakaianText.isEmpty,
            let dosisText = dosisTextField.text, !dosisText.isEmpty
        else {
            return
        }
        
        hariLabel.isHidden = false
        hariView.isHidden = false
        hariLabel.text = "Obat akan habis dalam \(getDay()) hari"
        
    }
    
    func getDay() -> Int{
        
        if type == "padat" || type == "cair" {
            
            guard let obatText = jumlahObatTextField.text, !obatText.isEmpty,
                let pemakaianText = jumlahPemakaiTextField.text, !pemakaianText.isEmpty,
                let dosisText = dosisTextField.text, !dosisText.isEmpty
            else {
                return 0
            }
            
            jumlahObat = Int(obatText) ?? 0
            jumlahPemakaian = Int(pemakaianText) ?? 0
            let dosisSuffix = dosisText.prefix(1)
            jumlahDosis = Int(dosisSuffix) ?? 0
            
            let perhari = jumlahDosis * jumlahPemakaian
            let jumlahHari = Double(jumlahObat) / Double(perhari)
            let hari = Int(ceil(jumlahHari))
            
            return hari
        }else {
            hariLabel.isHidden = true
            hariView.isHidden = true
        }
        
        return 0
        
    }
    
    func getMedicine() {
        
        padatButton.setImage(UIImage(named: type != "padat" ? "padat ijo" : "padat putih"), for: .normal)
        cairButton.setImage(UIImage(named: type != "cair" ? "cair ijo" : "cair putih"), for: .normal)
        tetesButton.setImage(UIImage(named: type != "tetes" ? "oles ijo" : "oles putih"), for: .normal)
        olesButton.setImage(UIImage(named: type != "oles" ? "oles ijo" : "oles putih"), for: .normal)
    
        if type == "cair" {
            unitView.isHidden = true
            unitLine.isHidden = true
            eatingView.isHidden = false
            eatingLine.isHidden = false
            jumlahPemakaianView.isHidden = false
            jumlahPemakaianLine.isHidden = false
            
            if hariLabel.text != ""{
                hariLabel.isHidden = false
                hariView.isHidden = false
            }
            
            if reminderDatas.count != 0 {
                jadwalView.isHidden = false
                tableView.isHidden = false
            }
            
            
        }else if type == "tetes" {
            unitView.isHidden = true
            unitLine.isHidden = true
            eatingView.isHidden = true
            eatingLine.isHidden = true
            jumlahPemakaianView.isHidden = false
            jumlahPemakaianLine.isHidden = false
            hariLabel.isHidden = true
            hariView.isHidden = true
        }else if type == "oles"{
            unitView.isHidden = true
            unitLine.isHidden = true
            eatingView.isHidden = true
            eatingLine.isHidden = true
            jumlahPemakaianView.isHidden = true
            jumlahPemakaianLine.isHidden = true
            hariLabel.isHidden = true
            hariView.isHidden = true
        }else{
            unitView.isHidden = false
            unitLine.isHidden = false
            eatingView.isHidden = false
            eatingLine.isHidden = false
            jumlahPemakaianView.isHidden = false
            jumlahPemakaianLine.isHidden = false
            
            if hariLabel.text != ""{
                hariLabel.isHidden = false
                hariView.isHidden = false
            }
            
            if reminderDatas.count != 0 {
                jadwalView.isHidden = false
                tableView.isHidden = false
            }
            
        }
        
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
        imagePickerController.view.tintColor = UIColor.systemBlue
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
            imageButton.setImage(editedImage, for: .normal)
        }else{
            imageButton.setImage(UIImage.init(systemName: "photo"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension MedicineController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminderDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userIndex = reminderDatas[indexPath.row]
        let cell = scheduleTable.dequeueReusableCell(withIdentifier: "ScheduleListTVC", for: indexPath) as! ScheduleListTVC
        
        cell.userData(with: userIndex, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

