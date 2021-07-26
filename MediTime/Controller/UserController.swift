//
//  UserController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class UserController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
}

extension UserController: Setup{
    
    func setupUI(){
        navigationItem.title = "Isi Data Pengguna"
        navigationItem.largeTitleDisplayMode = .never
        
        saveButton.layer.cornerRadius = 12
    }
    
}
