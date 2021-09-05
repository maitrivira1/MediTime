//
//  UserListTVC.swift
//  MediTime
//
//  Created by Maitri Vira on 26/07/21.
//

import UIKit

class UserListTVC: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMedicine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func userData(data: User){
        
        guard let photo = data.photo, let name = data.name, let sick = data.sick else{
            userImage.image = UIImage.init(systemName: "photo")
            return
        }
        
        userImage.image = UIImage(data: (photo))
        userName.text = name
        userMedicine.text = sick
    }
    
}
