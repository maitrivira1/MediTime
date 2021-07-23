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
    
    override func viewDidAppear(_ animated: Bool) {
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
        userTableView.backgroundColor = .white
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
        return userData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellID = indexPath.row < userData.count ? "UserCVC" : "UserNone"
        
        let collectionCell = userCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)

        setupCell(cell: collectionCell, index: indexPath, type: cellID)

        return collectionCell
    }
    
    func setupCell(cell: UICollectionViewCell, index: IndexPath, type: String) {
        switch(type) {
            case "UserCVC":
                setupUserCell(cell: cell as! UserCVC, indexPath: index)
            case "UserNone":
                setupNoneCell(cell: cell as! NoneCVC, indexPath: index)
            default:
                break
        }
    }
    
    func setupUserCell(cell: UserCVC, indexPath: IndexPath) {
        let userIndex = userData[indexPath.row]
        cell.setup(with: userIndex)
    }

    func setupNoneCell(cell: NoneCVC, indexPath: IndexPath) {
        cell.setup()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == userData.count{
//            let storyboardRestaurant = UIStoryboard(name: "User", bundle: .main)
//            let vc = storyboardRestaurant.instantiateViewController(identifier: "UserController") as! UserController
//            self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
            performSegue(withIdentifier: "UserController", sender: indexPath.row)
        }else{
            print(userData[indexPath.row].name)
        }
                
    }
}
