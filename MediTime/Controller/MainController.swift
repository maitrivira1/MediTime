//
//  ViewController.swift
//  MediTime
//
//  Created by Maitri Vira on 13/07/21.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var RoundedView: UIView!
    @IBOutlet weak var addMedicineBtn: UIButton!
    @IBOutlet weak var medicineTV: UITableView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIU()
        setupItem()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
    }
    
    func setupItem(){
        userTableView.delegate = self
        userTableView.dataSource = self
    }

    func setupIU(){
        navigationItem.title = "MediTime"
        navigationItem.largeTitleDisplayMode = .never
        
        RoundedView.layer.cornerRadius = 15
        RoundedView.layer.shadowColor = UIColor.black.cgColor
        RoundedView.layer.shadowOpacity = 0.3
        RoundedView.layer.shadowOffset = .zero
        RoundedView.layer.shadowRadius = 3
        
        addMedicineBtn.layer.cornerRadius = 10
        medicineTV.tableFooterView = UIView()
        
        let nib = UINib(nibName: "MedicineTVC", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: "MedicineTVC")
        userTableView.separatorStyle = .none
    }
    
    @IBAction func addedMedicineBtn(_ sender: UIButton) {
        print("add")
    }
}

//Mark - table view
extension MainController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userIndex = userData[indexPath.row]
        let tableCell = userTableView.dequeueReusableCell(withIdentifier: "MedicineTVC", for: indexPath) as! MedicineTVC
        
        tableCell.selectionStyle = .none
        tableCell.setup(with: userIndex)
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//Mark - collection view
extension MainController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell = userCollectionView.dequeueReusableCell(withReuseIdentifier: "UserCVC", for: indexPath) as! UserCVC

        let userIndex = userData[indexPath.row]
        collectionCell.setup(with: userIndex)

        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(userData[indexPath.row].name)
    }
}
