//
//  UserStoryTVC.swift
//  MediTime
//
//  Created by Dian Tresnawan on 06/08/21.
//

import UIKit

class UserStoryTVC: UITableViewCell {

    @IBOutlet weak var userStoryImg: UIImageView!
    @IBOutlet weak var userStoryMed: UILabel!
    @IBOutlet weak var userStoryUnit: UILabel!
    @IBOutlet weak var userStoryDosis: UILabel!
    @IBOutlet weak var userBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userBackground.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func userData(data: Medicine){
        
        guard let photo = data.photo else{
            return
        }
        
        userStoryImg.image = UIImage(data: photo)
        userStoryMed.text = data.nama
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH : mm"
        
        userStoryUnit.text = ("\(String(data.time)).00")
        userStoryDosis.text = data.date
    }
    
}
