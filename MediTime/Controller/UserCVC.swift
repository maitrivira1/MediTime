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
    
    func userData(data: User){
        userName.text = data.name
        userSick.text = data.sick
        
        guard let photo = data.photo else{
            return
        }
        
        userImg.image = UIImage(data: photo)
        userView.layer.cornerRadius = 8
        userImg.layer.cornerRadius = (userImg.frame.width / 2)
    }
    
    func changeBackgroundSelected(){
        userView.backgroundColor = UIColor(red: 0.18, green: 0.76, blue: 0.67, alpha: 1.00)
    }
    
    func changeBackgrounUnselected(){
        userView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00)
    }
    
}
