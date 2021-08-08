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
        userImage.image = UIImage(data: (data.photo)!)
        userName.text = data.name
        userMedicine.text = data.sick
    }
    
}
