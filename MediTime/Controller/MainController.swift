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
    @IBOutlet weak var userCollectionView: UICollectionView!
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var todayLabel: UILabel!
    
    var userSelected = ""
    var index = IndexPath(item: 0, section: 0)
    var clicked = false
    
    var users = [User]()
    var medicines = [Medicine]()
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        loadDataUser()
        loadDataMedicine()
        
        setupUI()
        permission()
        
        collectionView(userCollectionView, didSelectItemAt: index)
        print("set did select did load")
        userCollectionView?.selectItem(at: index, animated: false, scrollPosition: .top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDataUser()
        loadDataMedicine()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
        collectionView(userCollectionView, didSelectItemAt: index)
        print("set did select did view")
        userCollectionView?.selectItem(at: index, animated: false, scrollPosition:.top)
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
        
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        
        let nib = UINib(nibName: "MedicineTVC", bundle: nil)
        medicineTableView.register(nib, forCellReuseIdentifier: "MedicineTVC")
        medicineTableView.separatorStyle = .none
        medicineTableView.backgroundColor = .white
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
    func loadDataUser(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        let sort = [NSSortDescriptor(key: "id", ascending: false)]
        userRequest.sortDescriptors = sort
        
        do {
            try users = manageObjectContext.fetch(userRequest)
        } catch {
            print("error")
        }
        
        userCollectionView.reloadData()
    }
    
    func loadDataMedicine(with request: NSFetchRequest<Medicine> = Medicine.fetchRequest(), predicate: NSPredicate? = nil) {
        let medicinePredicate = NSPredicate(format: "users.name = %@", userSelected)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [medicinePredicate, addtionalPredicate])
        } else {
            request.predicate = medicinePredicate
        }
        
        do {
            try medicines = manageObjectContext.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        medicineTableView.reloadData()
    }
}

extension MainController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let medicineCount = medicines.count
        let userCount = users.count
        
        if medicineCount == 0 && userCount == 0{
            tableView.separatorStyle  = .none
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: tableView.bounds.size.height))
            noDataLabel.text          = "Tambah pengguna, lalu tambahkan obat yang ingin diingatkan"
            noDataLabel.textColor     = UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment = .center
            noDataLabel.font          = UIFont(name: "Poppins-Regular", size: 16)
            tableView.backgroundView  = noDataLabel
        }else if medicineCount == 0 {
            tableView.separatorStyle  = .none
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: tableView.bounds.size.height))
            noDataLabel.text          = "Tambahkan obat yang ingin diingatkan"
            noDataLabel.textColor     = UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment = .center
            noDataLabel.font          = UIFont(name: "Poppins-Regular", size: 16)
            tableView.backgroundView  = noDataLabel
        }else{
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return medicineCount
        }
        
        return medicineCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userIndex = medicines[indexPath.row]
        let tableCell = medicineTableView.dequeueReusableCell(withIdentifier: "MedicineTVC", for: indexPath) as! MedicineTVC
        
        tableCell.selectionStyle = .none
        tableCell.userData(with: userIndex)
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return users.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = indexPath.section == 0 ? "UserNone" : "UserCVC"

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
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCVC {
            cell.changeBackgroundSelected()
            print("change color")
            cell.layer.cornerRadius = 15.0
            cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
        }
        
        if indexPath.row == users.count{
            return
        }else{
            userSelected = "\(users[indexPath.row].name!)"
            todayLabel.text = "Obat \(userSelected) hari ini"
            index = IndexPath(row: indexPath.row, section: indexPath.section)
            loadDataMedicine()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCVC {
            cell.changeBackgrounUnselected()
            
            cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 0.0
            cell.layer.shadowOpacity = 0
            cell.layer.masksToBounds = false
        }
    }
    
}
