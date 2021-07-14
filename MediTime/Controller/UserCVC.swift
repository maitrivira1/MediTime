//
//  UserCVC.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class UserCVC: UICollectionViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var sickLabel: UILabel!
    
    func setup(with user: Data){
        userNameLabel.text = user.name
        sickLabel.text = user.name
    }
    
}
