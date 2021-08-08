//
//  MedicineController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit
import CoreData

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
    
    var medicine = [Medicine]()
    var userSelected: User?
    var status = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
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
    var times = [Time]()
    
    var dosisSelected = 0
    var dosisCount = ""
    
    let ext = Extension()
    
    var profileImage: UIImage? = nil
    
    var pickerIndex: Int?
    var pickerCount = 0
    var pickerSelect = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        setupUI()
        print("user selected medicine controller", userSelected!)
    }
    
    @IBAction func imageTapped(_ sender: UIButton) {
        showAction()
    }
    
    @IBAction func bentukObatTapped(_ sender: UIButton) {
        type = sender.currentTitle!
        getMedicine()
        showDay()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveAllData()
    }
    
    func saveAllData(){
        var id = self.medicine.count + 1
        
        var date = Date()
        var dateComponent = DateComponents()
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "yyyy-MM-dd"
        
        let hari = getDay()
        let waktu = dosisSelected
        var jam = [9 ,8, 7, 6]
        let interval = [0, 12, 8, 6]
        
        for _ in 0..<hari{
            
            for _ in 0..<waktu{
                
                addData(id: id, date: timeFormat.string(from: date), time: jam[waktu - 1])
                
                id+=1
                jam[waktu - 1] += interval[waktu - 1]
                
            }
            
            dateComponent.day = 1
            let currentTime = Calendar.current.date(byAdding: dateComponent, to: date)
            date = currentTime!
            jam = [9 ,8, 7, 6]
            
        }
        
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
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
        showDay()
        showSchedule()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 180
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
        
        let timeOneFirst = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!

        let timeTwoFirst = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
        let timeTwoSecond = Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!

        let timeThreeFirst = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        let timeThreeSecond = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
        let timeThreeThird = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!

        let timeFourFirst = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
        let timeFourSecond = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let timeFourThird = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
        let timeFourFouth = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        
        times = []
        
        if dosisSelected == 2 {
            times.append(Time(fullDate: timeTwoFirst))
            times.append(Time(fullDate: timeTwoSecond))
        }else if dosisSelected == 3 {
            times.append(Time(fullDate: timeThreeFirst))
            times.append(Time(fullDate: timeThreeSecond))
            times.append(Time(fullDate: timeThreeThird))
            print(times)
        }else if dosisSelected == 4 {
            times.append(Time(fullDate: timeFourFirst))
            times.append(Time(fullDate: timeFourSecond))
            times.append(Time(fullDate: timeFourThird))
            times.append(Time(fullDate: timeFourFouth))
        }else{
            times.append(Time(fullDate: timeOneFirst))
        }
        
        scheduleTable.reloadData()
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
        
        return 3
        
    }
    
    func getMedicine() {
        
        padatButton.setImage(UIImage(named: type != "padat" ? "padat ijo" : "padat putih"), for: .normal)
        cairButton.setImage(UIImage(named: type != "cair" ? "cair ijo" : "cair putih"), for: .normal)
        tetesButton.setImage(UIImage(named: type != "tetes" ? "tetes ijo" : "tetes putih"), for: .normal)
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
    
    func makeNotification(date: Date){
        
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Hore... waktunya minum obat"
        content.sound = .default
        content.body = "Cek jadwal obat sekarang yuk"
        
        let dataComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents, repeats: false)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request)
        
        center.add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        
    }
    
}

extension MedicineController : SetupData{
    
    func addData(id: Int, date: String, time: Int) {
        
        guard let name = namaTextField.text, !name.isEmpty,
              var unit = unitTextField.text,
              let total = jumlahObatTextField.text , !total.isEmpty,
              let dosis = dosisTextField.text, !dosis.isEmpty,
              var pemakaian = jumlahPemakaiTextField.text,
              var waktu = eatingTextField.text,
              !type.isEmpty,
              profileImage != nil
        else{
            self.ext.showAlertConfirmation(on: self , title: "Keterangan Obat", message: "Silahkan masukan foto dan lengkapi data", status: "kosong")
            return
        }
        
        if type == "cair"{
            unit = ""
        }else if type == "tetes"{
            unit = ""
            waktu = ""
        }else if type == "oles"{
            pemakaian = ""
        }
        
        let medicine = Medicine(context: self.context)
        let photo = profileImage!.jpegData(compressionQuality: 1)
        
        medicine.bentukObat = type
        medicine.date = date
        medicine.dosis = dosis
        medicine.id = Int16(id)
        medicine.isFinish = false
        medicine.jumlahObat = total
        medicine.jumlahPemakaian = pemakaian
        medicine.nama = name
        medicine.photo = photo
        medicine.time = Int16(time)
        medicine.unit = unit
        medicine.waktuMakan = waktu
        medicine.users = userSelected
        
        self.medicine.append(medicine)
        
        do {
            try context.save()
            print("save: \(medicine)")
            
            ext.showAlertConfirmation(on: self , title: "Keterangan Obat", message: "Berhasil ditambahkan", status: "berhasil")
            
        } catch let error as NSError {
            print("error: \(error)")
            
            ext.showAlertConfirmation(on: self , title: "Keterangan Obat", message: "Gagal ditambahkan", status: "gagal")
        }
    }
    
}

extension MedicineController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dosisPicker {
            pickerCount = dosis.count
            pickerSelect = "dosisPicker"
            return dosis.count
        } else if pickerView == eatPicker{
            pickerCount = eat.count
            pickerSelect = "eatPicker"
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
        pickerIndex = row
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
            profileImage = editedImage
            imageButton.setImage(editedImage, for: .normal)
        }else{
            imageButton.setImage(UIImage.init(systemName: "photo"), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension MedicineController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userIndex = times[indexPath.row]
        let cell = scheduleTable.dequeueReusableCell(withIdentifier: "ScheduleListTVC", for: indexPath) as! ScheduleListTVC
        
        cell.userData(data: userIndex, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MedicineController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}
