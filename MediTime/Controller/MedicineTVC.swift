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
    @IBOutlet weak var medicineBackground: UIView!
    @IBOutlet weak var timeBackground: UIView!
    @IBOutlet weak var eatBackground: UIView!
    
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
    
    func userData(with data: Data){
//        medicineName.text = data.name
//        medicineAmount.text = data.sick
    }
    
}
