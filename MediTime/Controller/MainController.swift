//
//  ViewController.swift
//  MediTime
//
//  Created by Maitri Vira on 13/07/21.
//

import UIKit
import CoreData

class MainController: UIViewController {
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var addMedicineButton: UIButton!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var todayLabel: UILabel!
    
    var userSelected = ""
    var index:IndexPath = IndexPath(row: 0, section: 0)
    
    var users = [User]()
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        permission()
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
//        collectionView(userCollectionView, didSelectItemAt: index)
//        userCollectionView?.selectItem(at: index, animated: false, scrollPosition: .top)
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
        collectionView(userCollectionView, didSelectItemAt: index)
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "medicineController" {
            let destinationVC = segue.destination as! MedicineController
            destinationVC.userSelected = users[index.row]
        }
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
        
        todayLabel.text = "Obat \(userSelected) hari ini"
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

extension MainController: SetupData{
    func loadData(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        let sort = [NSSortDescriptor(key: "id", ascending: false)]
        userRequest.sortDescriptors = sort
        
        do {
            try users = manageObjectContext.fetch(userRequest)
            userCollectionView?.reloadData()
        } catch {
            print("error")
        }
        
        userCollectionView.reloadData()
    }
}

extension MainController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userIndex = users[indexPath.row]
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
        return users.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = indexPath.row < users.count ? "UserCVC" : "UserNone"
//        let cellID = indexPath.row == 0 ? "UserCVC" : "UserNone"
        
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
        let userIndex = users[indexPath.row]
        cell.userData(data: userIndex)
    }

    func setupNoneCell(cell: NoneCVC, indexPath: IndexPath) {
        cell.setup()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == users.count{
//            performSegue(withIdentifier: "UserController", sender: indexPath.row)
        }else{
            userSelected = "\(users[indexPath.row].name!) "
            todayLabel.text = "Obat \(userSelected)hari ini"
            index = IndexPath(row: indexPath.row, section: indexPath.section)
            print("index", index)
            print("user", userSelected)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCVC {
            cell.changeBackgroundSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCVC {
            cell.changeBackgrounUnselected()
        }
    }
    
}
