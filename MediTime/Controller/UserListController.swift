//
//  UserListController.swift
//  MediTime
//
//  Created by Maitri Vira on 22/07/21.
//

import UIKit

class UserListController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension UserListController: Setup{
    
    func setupUI(){
        navigationItem.title = "Daftar Pengguna"
        navigationItem.largeTitleDisplayMode = .never
    }
    
}
