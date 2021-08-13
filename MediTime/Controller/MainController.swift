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
    var index = IndexPath(item: 0, section: 1)
    var clicked = false
    
    var users = [User]()
    var medicines = [Medicine]()
    let ext = Extension()
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
        
        if let context = appDelegate?.persistentContainer.viewContext{
            manageObjectContext = context
        }else{
            ext.showCrash(on: self)
        }
        
        loadDataUser()
        loadDataMedicine()
        
        setupUI()
        permission()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDataUser()
        loadDataMedicine()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
    
        if users.count == 0{
            addMedicineButton.isEnabled = false
            addMedicineButton.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00)
        }else{
            addMedicineButton.isEnabled = true
            addMedicineButton.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.56, alpha: 1.00)
        }
        
        self.userCollectionView.selectItem(at: index, animated: true, scrollPosition: [])
        collectionView(userCollectionView, didSelectItemAt: index)
        
        userCollectionView.reloadData()
        medicineTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "medicineController" {
            
            if let destinationVC = segue.destination as? MedicineController{
                destinationVC.userSelected = users[index.row]
                destinationVC.status = "create"
            }
            
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
        
        medicineTableView.delegate = self
        medicineTableView.dataSource = self
        
        let nib = UINib(nibName: "MedicineTVC", bundle: nil)
        medicineTableView.register(nib, forCellReuseIdentifier: "MedicineTVC")
        medicineTableView.separatorStyle = .none
        medicineTableView.backgroundColor = .white
        medicineTableView.tableFooterView = UIView()
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
            
            users = users.filter{$0.isFinish == false}
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
            
            let date = Date()
            let timeFormat = DateFormatter()
            timeFormat.dateFormat = "yyyy-MM-dd"
            let current = timeFormat.string(from: date)
            
            medicines = medicines.filter{$0.date == current}
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        medicineTableView.reloadData()
    }
    
    func saveData(){
        do{
            try manageObjectContext.save()
        } catch{
            print(error)
        }

        self.medicineTableView.reloadData()
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
        
        guard let cell = medicineTableView.dequeueReusableCell(withIdentifier: "MedicineTVC", for: indexPath) as? MedicineTVC else{
            fatalError("DequeueReusableCell failed while casting")
        }
        
        cell.selectionStyle = .none
        cell.userData(with: userIndex)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        medicines[indexPath.row].setValue(true, forKey: "isFinish")
        saveData()
        
        medicineTableView.reloadData()
    }
    
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate{
    
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
                
                guard let userCell = cell as? UserCVC else{
                    ext.showCrash(on: self)
                    return
                }
                
                setupUserCell(cell: userCell, indexPath: index)
            case "UserNone":
                
                guard let noneCell = cell as? NoneCVC else{
                    ext.showCrash(on: self)
                    return
                }
                
                setupNoneCell(cell: noneCell, indexPath: index)
            default:
                break
        }
    }
    
    func setupUserCell(cell: UserCVC, indexPath: IndexPath) {
        let userIndex = users[indexPath.row]
        cell.userData(data: userIndex)
        if index == indexPath {
            cell.changeBackgroundSelected()
            cell.layer.cornerRadius = 15.0
            cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
        }else{
            cell.changeBackgrounUnselected()
            cell.layer.borderWidth = 0.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 0.0
            cell.layer.shadowOpacity = 0
            cell.layer.masksToBounds = false
        }
    }

    func setupNoneCell(cell: NoneCVC, indexPath: IndexPath) {
        cell.setup()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.index = indexPath
        self.userCollectionView.reloadData()
        
        if indexPath.row == users.count{
            return
        }else{
            userSelected = "\(users[indexPath.row].name ?? "")"
            todayLabel.text = "Obat \(userSelected) hari ini"
            index = IndexPath(row: indexPath.row, section: indexPath.section)
            loadDataMedicine()
        }
    }
    
}
