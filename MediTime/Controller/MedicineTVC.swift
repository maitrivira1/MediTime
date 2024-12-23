//
//  MedicineTVC.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit
import CoreData

class MedicineTVC: UITableViewCell {
    
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineAmount: UILabel!
    @IBOutlet weak var medicineTime: UILabel!
    @IBOutlet weak var medicineEaten: UILabel!
    @IBOutlet weak var medicineBackground: UIView!
    @IBOutlet weak var timeBackground: UIView!
    @IBOutlet weak var eatBackground: UIView!
    @IBOutlet weak var medicineCheck: UIImageView!
    @IBOutlet weak var medicineImage: UIImageView!
    @IBOutlet weak var medicineLine: UIView!
    
    var medicine = [Medicine]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension MedicineTVC: Setup{
    
    func setupUI() {
        medicineBackground.layer.cornerRadius = 8
        timeBackground.layer.cornerRadius = 8
        eatBackground.layer.cornerRadius = 8
    }
    
    func userData(with data: Medicine){
        let hour = Calendar.current.component(.hour, from: Date())
        if hour > data.time - 1 && hour < data.time + 1 {
            medicineBackground.backgroundColor = UIColor(red: 0.18, green: 0.76, blue: 0.67, alpha: 1.00)
        }else{
            medicineBackground.backgroundColor = UIColor(red: 0.91, green: 0.99, blue: 0.98, alpha: 1.00)
        }
        
        if data.isFinish == true{
            medicineBackground.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
            medicineName.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
            medicineAmount.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
            medicineLine.backgroundColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
            medicineTime.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
            medicineEaten.textColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
            medicineCheck.image = UIImage(named: "uncheck")
        }
        
        eatBackground.isHidden = data.bentukObat == "tetes" || data.bentukObat == "oles" ? true : false
        
        let jenis = data.bentukObat == "padat" ? "Pil" : data.bentukObat == "cair" ? "spoon".localized() : data.bentukObat == "tetes" ? "drops".localized() : "topical2".localized()
        
        medicineName.text = data.nama
        medicineAmount.text = "\(data.jumlahPemakaian ?? "0") \(jenis)"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH.mm"
        let time = Calendar.current.date(bySettingHour: Int(data.time), minute: 0, second: 0, of: Date())!
        
        medicineTime.text = timeFormat.string(from: time)
        medicineEaten.text = data.waktuMakan
        medicineImage.image = UIImage(data: (data.photo)!)
    }
}
