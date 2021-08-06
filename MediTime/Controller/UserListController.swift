//
//  UserListController.swift
//  MediTime
//
//  Created by Maitri Vira on 22/07/21.
//

import UIKit

class UserListController: UIViewController {
    
    var userImages: [String] = ["user1", "user2", "user3", "user4", "user5", "user6", "user7", "user8"]
    var userNames: [String] = ["User1", "User2", "User3", "User4", "User5", "User6", "User7", "User8"]
    var userMedicines: [String] = ["Med1", "Med2", "Med3", "Med4", "Med5", "Med6", "Med7", "Med8"]
    
    var userStoryImages: [String] = ["obat1", "obat2", "obat3", "obat4", "obat5", "obat6"]
    var userStoryMedNames: [String] = ["Obat1", "Obat2", "Obat3", "Obat4", "Obat5", "Obat6"]
    var userStoryUnits: [String] = ["100 mg", "200 mg", "300 mg", "400 mg", "500 mg", "600 mg"]
    var userStoryDosiss: [String] = ["2x1 hari", "3x1 hari", "4x1 hari", "5x1 hari", "6x1 hari", "7x1 hari"]
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userListTableView.register(UINib(nibName: "UserListTVC", bundle: nil), forCellReuseIdentifier: "cell")
        self.userListTableView.register(UINib(nibName: "UserStoryTVC", bundle: nil), forCellReuseIdentifier: "cell2")
        
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self

        setupUI()
    }
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        userListTableView.reloadData()
    }
    
}

extension UserListController: Setup{
    
    func setupUI(){
        navigationItem.title = "Daftar Pengguna"
        navigationItem.largeTitleDisplayMode = .never
    }
    
}

extension UserListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return userNames.count
        case 1:
            return userStoryMedNames.count
        default:
            return userNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
            cell.userImage.image = UIImage(named: userImages[indexPath.row])
            cell.userName.text = userNames[indexPath.row]
            cell.userMedicine.text = userMedicines[indexPath.row]
            return cell
        case 1:
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! UserStoryTVC
            cell.userStoryImg.image = UIImage(named: userStoryImages[indexPath.row])
            cell.userStoryMed.text = userStoryMedNames[indexPath.row]
            cell.userStoryUnit.text = userStoryUnits[indexPath.row]
            cell.userStoryDosis.text = userStoryDosiss[indexPath.row]
            return cell
        default:
            let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
            cell.userImage.image = UIImage(named: userImages[indexPath.row])
            cell.userName.text = userNames[indexPath.row]
            cell.userMedicine.text = userMedicines[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
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
        case 1:
            let delete = UIContextualAction(style: .normal, title: "Hapus") { (action, view, completionHandler) in
                print("Hapus")
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
