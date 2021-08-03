//
//  ViewController.swift
//  MediTime
//
//  Created by Maitri Vira on 13/07/21.
//

import UIKit

class MainController: UIViewController {
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var addMedicineButton: UIButton!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userTableView: UITableView!
    
    var userSelected = ""
    var selected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        permission()
        
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        userCollectionView?.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
        collectionView(userCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
    }
}

extension MainController: Setup{
    
    func setupUI() {
        navigationItem.title = "MediTime"
        navigationItem.largeTitleDisplayMode = .never
        
        roundedView.layer.cornerRadius = 15
        roundedView.layer.shadowColor = UIColor.black.cgColor
        roundedView.layer.shadowOpacity = 0.3
        roundedView.layer.shadowOffset = .zero
        roundedView.layer.shadowRadius = 3
        
        addMedicineButton.layer.cornerRadius = 10
        medicineTableView.tableFooterView = UIView()
        
        userTableView.delegate = self
        userTableView.dataSource = self
        
        let nib = UINib(nibName: "MedicineTVC", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: "MedicineTVC")
        userTableView.separatorStyle = .none
        userTableView.backgroundColor = .white
    }
    
    func permission(){
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("User has declined notifications")
            }else{
                print("success permission")
            }
        }
    }
    
}

extension MainController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userIndex = userData[indexPath.row]
        let tableCell = userTableView.dequeueReusableCell(withIdentifier: "MedicineTVC", for: indexPath) as! MedicineTVC
        
        tableCell.selectionStyle = .none
        tableCell.userData(with: userIndex)
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

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
        cell.userData(data: userIndex)
    }

    func setupNoneCell(cell: NoneCVC, indexPath: IndexPath) {
        cell.setup()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == userData.count{
            performSegue(withIdentifier: "UserController", sender: indexPath.row)
        }else{
            print(userData[indexPath.row].name)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCVC {
            selected = true
            cell.changeBackgroundSelected()
        }
        
        if selected == false {
            collectionView.cellForItem(at: [0, 0])?.backgroundColor = UIColor(red: 0.02, green: 0.33, blue: 0.28, alpha: 1.00)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCVC {
            cell.changeBackgrounUnselected()
        }
    }
    
}
