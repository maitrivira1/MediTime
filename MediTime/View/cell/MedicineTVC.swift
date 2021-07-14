//
//  MedicineTVC.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class MedicineTVC: UITableViewCell {
    
    @IBOutlet weak var medicineImg: UIImageView!
    @IBOutlet weak var medicineBg: UIView!
    
    //    var userIndex: userData

    override func awakeFromNib() {
        super.awakeFromNib()
        medicineBg.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(){
        
    }
    
}
