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
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        loadUserFinishFalse()
        loadUserFinishTrue()
        setupUI()
    }
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        userListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int ?? 0
        if segue.identifier == "UserController" {
            let destinationVC = segue.destination as! UserController
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
        } catch {
            print("error")
        }
        
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
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return usersFalse.count
        case 1:
            return usersTrue.count
        default:
            return usersFalse.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let userIndex = usersFalse[indexPath.row]
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
            cell.userData(data: userIndex)
            return cell
        case 1:
            let userIndex = usersTrue[indexPath.row]
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
            cell.userData(data: userIndex)
            return cell
            
//            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! UserStoryTVC
//            cell.userStoryImg.image = UIImage(named: userStoryImages[indexPath.row])
//            cell.userStoryMed.text = userStoryMedNames[indexPath.row]
//            cell.userStoryUnit.text = userStoryUnits[indexPath.row]
//            cell.userStoryDosis.text = userStoryDosiss[indexPath.row]
//            return cell
        
        default:
            let userIndex = usersFalse[indexPath.row]
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
            cell.userData(data: userIndex)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let delete = UIContextualAction(style: .normal, title: "Selesai") { (action, view, completionHandler) in
                
                self.ext.showAlertConfirmation(on: self, title: "Pengobatan Selesai", message: "Data pengobatan anda akan tersimpan di Riwayat Pengguna", status: "selsai")
                
                self.usersFalse[indexPath.row].setValue(true, forKey: "isFinish")
                self.saveData()
                self.userListTableView.reloadData()
                completionHandler(true)
                
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
                
                alert.addAction(UIAlertAction(title: "Tidak", style: .destructive, handler: { action in
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Yakin", style: .destructive, handler: { action in
                    
                    print("hapus")
                    
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
    
}
