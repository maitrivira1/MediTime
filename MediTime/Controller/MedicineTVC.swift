//
//  MedicineTVC.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class MedicineTVC: UITableViewCell {
    
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var medicineAmount: UILabel!
    @IBOutlet weak var medicineTime: UILabel!
    @IBOutlet weak var medicineEaten: UILabel!
    @IBOutlet weak var medicineBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        medicineBg.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(with data: Data){
        medicineName.text = data.name
        medicineAmount.text = data.sick
    }
}
