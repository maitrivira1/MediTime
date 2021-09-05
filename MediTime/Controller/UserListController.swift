//
//  UserListController.swift
//  MediTime
//
//  Created by Maitri Vira on 22/07/21.
//

import UIKit
import CoreData

class UserListController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userListTableView: UITableView!
    
    var usersFalse = [User]()
    var usersTrue = [User]()
    var userSelected: User?
    let ext = Extension()
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let context = appDelegate?.persistentContainer.viewContext{
            manageObjectContext = context
        }else{
            ext.showCrash(on: self)
        }
        
        loadUserFinishFalse()
        loadUserFinishTrue()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
    }
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        loadUserFinishFalse()
        loadUserFinishTrue()
        userListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int ?? 0
        if segue.identifier == "UserController" {
            
            guard let destinationVC = segue.destination as? UserController else{
                ext.showCrash(on: self)
                return
            }
            
            destinationVC.userSelected = usersFalse[index]
            destinationVC.status = "edit"
        }
    }
    
}

extension UserListController: Setup{
    
    func setupUI(){
        navigationItem.title = "Daftar Pengguna"
        navigationItem.largeTitleDisplayMode = .never
        
        self.userListTableView.register(UINib(nibName: "UserListTVC", bundle: nil), forCellReuseIdentifier: "cell")
        self.userListTableView.register(UINib(nibName: "UserStoryTVC", bundle: nil), forCellReuseIdentifier: "cell2")
        
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        
        userListTableView.tableFooterView = UIView()
    }
    
}

extension UserListController: SetupData{
    func loadUserFinishFalse(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        let sort = [NSSortDescriptor(key: "id", ascending: false)]
        userRequest.sortDescriptors = sort
        
        do {
            try usersFalse = manageObjectContext.fetch(userRequest)
            
            usersFalse = usersFalse.filter{$0.isFinish == false}
        } catch {
            print("error")
        }
        
        userListTableView.reloadData()
    }
    
    func loadUserFinishTrue(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        let sort = [NSSortDescriptor(key: "id", ascending: false)]
        userRequest.sortDescriptors = sort
        
        do {
            try usersTrue = manageObjectContext.fetch(userRequest)
            
            usersTrue = usersTrue.filter{$0.isFinish == true}
            print("user true", usersTrue)
        } catch {
            print("error")
        }
        
        userListTableView.reloadData()
    }
    
    func deleteDataUser(id: Int, with request: NSFetchRequest<User> = User.fetchRequest(), predicate: NSPredicate? = nil){
        
        let userPredicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, addtionalPredicate])
        } else {
            request.predicate = userPredicate
        }
        
        do {
            let object = try manageObjectContext.fetch(request)
            let objectToDelete = object[0] as NSManagedObject
            manageObjectContext.delete(objectToDelete)
            
            do {
                try manageObjectContext.save()
            } catch {
                print("error save")
            }
           
        } catch {
            print("Error fetching data from context \(error)")
        }
        loadUserFinishTrue()
        userListTableView.reloadData()
    }
    
    func saveData(){
        do{
            try manageObjectContext.save()
        } catch{
            print(error)
        }

        self.userListTableView.reloadData()
    }
}

extension UserListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userFalseCount = usersFalse.count
        let userTrueCount = usersTrue.count
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if userFalseCount == 0{
                tableView.separatorStyle  = .none
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: tableView.bounds.size.height))
                noDataLabel.text          = "Belum Ada Data"
                noDataLabel.textColor     = UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)
                noDataLabel.numberOfLines = 2
                noDataLabel.textAlignment = .center
                noDataLabel.font          = UIFont(name: "Poppins-Regular", size: 16)
                tableView.backgroundView  = noDataLabel
            }else{
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                return userFalseCount
            }
            return userFalseCount
        case 1:
            if userTrueCount == 0{
                tableView.separatorStyle  = .none
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: tableView.bounds.size.height))
                noDataLabel.text          = "Belum Ada Data"
                noDataLabel.textColor     = UIColor(red: 0.64, green: 0.64, blue: 0.64, alpha: 1.00)
                noDataLabel.numberOfLines = 2
                noDataLabel.textAlignment = .center
                noDataLabel.font          = UIFont(name: "Poppins-Regular", size: 16)
                tableView.backgroundView  = noDataLabel
            }else{
                tableView.separatorStyle = .singleLine
                tableView.backgroundView = nil
                return userTrueCount
            }
            return userTrueCount
        default:
            return userFalseCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let userIndex = usersFalse[indexPath.row]
            
            guard let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserListTVC else{
                fatalError("DequeueReusableCell failed while casting")
            }
            
            cell.userData(data: userIndex)
            return cell
        case 1:
            let userIndex = usersTrue[indexPath.row]
            
            guard let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserListTVC else{
                fatalError("DequeueReusableCell failed while casting")
            }
            
            cell.userData(data: userIndex)
            return cell
        
        default:
            let userIndex = usersFalse[indexPath.row]
            
            guard let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UserListTVC else{
                fatalError("DequeueReusableCell failed while casting")
            }
            
            cell.userData(data: userIndex)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let delete = UIContextualAction(style: .normal, title: "Selesai") { (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Pengobatan Selesai", message: "Data pengobatan anda akan tersimpan di Riwayat Pengguna", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                    
                    self.usersFalse[indexPath.row].setValue(true, forKey: "isFinish")
                    self.saveData()
                    self.loadUserFinishFalse()
                    self.userListTableView.reloadData()
                    completionHandler(true)
                    
                }))
                
                self.present(alert, animated: true)
                
            }
            delete.backgroundColor = UIColor(red: 0.99, green: 0.26, blue: 0.38, alpha: 1.00)
            
            let change = UIContextualAction(style: .normal, title: "Ubah") { (action, view, completionHandler) in
                
                self.performSegue(withIdentifier: "UserController", sender: indexPath.row)
                
                completionHandler(true)
                
            }
            change.backgroundColor = UIColor(red: 0.18, green: 0.76, blue: 0.67, alpha: 1.00)
            let swipe = UISwipeActionsConfiguration(actions: [delete, change])
            return swipe
        case 1:
            let delete = UIContextualAction(style: .normal, title: "Hapus") { (action, view, completionHandler) in
                
                let alert = UIAlertController(title: "Hapus Riwayat", message: "Apakah anda yakin ingin menghapus riwayat ini?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Tidak", style: .default, handler: { action in
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Yakin", style: .default, handler: { [self] action in
                    
                    deleteDataUser(id: Int(self.usersTrue[indexPath.row].id))
                    
                }))
                
                self.present(alert, animated: true)
                
                completionHandler(true)
            }
            delete.backgroundColor = .red
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            return swipe
        default:
            let delete = UIContextualAction(style: .normal, title: "Selesai") { (action, view, completionHandler) in
                print("Selesai")
                completionHandler(true)
            }
            delete.backgroundColor = .red
            
            let change = UIContextualAction(style: .normal, title: "Ubah") { (action, view, completionHandler) in
                print("Ubah")
                completionHandler(true)
            }
            change.backgroundColor = .green
            let swipe = UISwipeActionsConfiguration(actions: [delete, change])
            return swipe
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rencana = UIStoryboard(name: "UserMedicine", bundle: nil)
        
        guard let vc = rencana.instantiateViewController(identifier: "UserMedicine") as? UserMedicine else{
            fatalError("DequeueReusableCell failed while casting")
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            vc.userSelected = usersFalse[indexPath.row]
        case 1:
            vc.userSelected = usersTrue[indexPath.row]
        default:
            vc.userSelected = usersFalse[indexPath.row]
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
