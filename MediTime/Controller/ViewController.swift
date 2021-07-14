//
//  ViewController.swift
//  MediTime
//
//  Created by Maitri Vira on 13/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var RoundedView: UIView!
    @IBOutlet weak var addMedicineBtn: UIButton!
    @IBOutlet weak var medicineTV: UITableView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIU()
        
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        userTableView.delegate = self
        userTableView.dataSource = self
    }

    func setupIU(){
        navigationItem.title = "MediTime"
        navigationItem.largeTitleDisplayMode = .never
        
        RoundedView.layer.cornerRadius = 15
        addMedicineBtn.layer.cornerRadius = 10
        medicineTV.tableFooterView = UIView()
        
        let nib = UINib(nibName: "MedicineTVC", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: "MedicineTVC")
    }
    
    @IBAction func addedMedicineBtn(_ sender: UIButton) {
        print("add")
    }
}

//Mark - table view
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userIndex = userData[indexPath.row]
        let tableCell = userTableView.dequeueReusableCell(withIdentifier: "MedicineTVC", for: indexPath) as! MedicineTVC
        
        tableCell.userIndex = userIndex
        tableCell.updateUI()
        
        return tableCell
    }
}


//Mark - collection view
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userIndex = userData[indexPath.row]
        let CollectionCell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCVC", for: indexPath) as! UserCVC
        
        CollectionCell.setup(with: userIndex)
        
        return CollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(userData[indexPath.row].name)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 180, height: 180)
    }
}
