//
//  NoneCVC.swift
//  MediTime
//
//  Created by Maitri Vira on 16/07/21.
//

import UIKit

class NoneCVC: UICollectionViewCell {
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var addView: UIView!
    
}

extension NoneCVC: Setup{
    
    func setupUI() {}
    
    func setup(){
        addView.layer.cornerRadius = 8
    }
    
}
