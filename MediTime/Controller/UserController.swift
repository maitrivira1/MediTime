//
//  UserController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class UserController: UIViewController {

    @IBOutlet weak var btnSimpan: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI(){
        navigationItem.title = "Isi Data Pengguna"
        navigationItem.largeTitleDisplayMode = .never
        
        btnSimpan.layer.cornerRadius = 12
    }

    
}
