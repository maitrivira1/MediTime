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
        
        guard let photo = data.photo, let date = data.date else{
            return
        }
        
        userStoryImg.image = UIImage(data: photo)
        userStoryMed.text = data.nama
        
        let year = date.prefix(4)
        let index = date.index(date.startIndex, offsetBy: 5)
        var middle = date.suffix(from: index)
        middle = middle.prefix(2)
        let day = date.suffix(2)
        
        userStoryUnit.text = "\(day)-\(middle)-\(year)"
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH : mm"
        
        userStoryDosis.text = ("\(String(data.time)).00")
    }
    
}
