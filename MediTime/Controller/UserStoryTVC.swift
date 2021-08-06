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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
