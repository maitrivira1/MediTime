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
    
    func userData(with data: DataExample){
        userName.text = data.name
        userSick.text = data.sick
        
        userView.layer.cornerRadius = 8
        userImg.layer.cornerRadius = (userImg.frame.width / 2)
    }
    
}
