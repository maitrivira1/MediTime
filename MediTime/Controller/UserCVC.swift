//
//  UserCVC.swift
//  MediTime
//
//  Created by Maitri Vira on 15/07/21.
//

import UIKit

class UserCVC: UICollectionViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSick: UILabel!
    @IBOutlet weak var userView: UIView!
    
}

extension UserCVC: Setup{
    
    func setupUI() {}
    
    func userData(data: DataExample){
        userName.text = data.name
        userSick.text = data.sick
        
        userView.layer.cornerRadius = 8
        userImg.layer.cornerRadius = (userImg.frame.width / 2)
    }
    
    func changeBackgroundSelected(){
        userView.backgroundColor = UIColor(red: 0.02, green: 0.33, blue: 0.28, alpha: 1.00)
    }
    
    func changeBackgrounUnselected(){
        userView.backgroundColor = UIColor(red: 0.24, green: 0.59, blue: 0.55, alpha: 1.00)
    }
    
}
