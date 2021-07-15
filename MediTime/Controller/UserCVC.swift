//
//  UserCVC.swift
//  MediTime
//
//  Created by Maitri Vira on 15/07/21.
//

import UIKit

class UserCVC: UICollectionViewCell {
    
    @IBOutlet weak var userImg: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSick: UILabel!
    
    func setup(with data: Data){
        userName.text = data.name
        userSick.text = data.sick
    }
    
}
