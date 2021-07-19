//
//  MedicineController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class MedicineController: UIViewController {
    @IBOutlet weak var btnSimpan: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI(){
        navigationItem.title = "Keterangan Obat"
        navigationItem.largeTitleDisplayMode = .never
        
        btnSimpan.layer.cornerRadius = 12
    }
}
