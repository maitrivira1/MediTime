//
//  ScheduleListTVC.swift
//  MediTime
//
//  Created by Maitri Vira on 02/08/21.
//

import UIKit

class ScheduleListTVC: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ScheduleListTVC: Setup{
    
    func setupUI() {}
    
    func userData(data: Time, index: Int){
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH : mm"
        
        nameLabel.text = String("Waktu Minum \(index + 1)")
        timeLabel.text = String("\(timeFormat.string(from: data.fullDate))")
    }
    
}
