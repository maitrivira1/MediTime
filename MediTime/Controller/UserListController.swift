//
//  UserListController.swift
//  MediTime
//
//  Created by Maitri Vira on 22/07/21.
//

import UIKit

class UserListController: UIViewController {
    
    var userNames: [String] = ["User1", "User2", "User3", "User4"]
    var userNames2: [String] = ["User5", "User6", "User7", "User8"]
    var userImages: [String] = ["user1", "user2", "user3", "user4"]
    var userImages2: [String] = ["user5", "user6", "user7", "user8"]
    var userMedicines: [String] = ["Med1", "Med2", "Med3", "Med4"]
    var userMedicines2: [String] = ["Med5", "Med6", "Med7", "Med8"]

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var userListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userListTableView.register(UINib(nibName: "UserListTVC", bundle: nil), forCellReuseIdentifier: "cell")
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
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserListTVC
        cell.userImage.image = UIImage(named: userImages[indexPath.row])
        cell.userName.text = userNames[indexPath.row]
        cell.userMedicine.text = userMedicines[indexPath.row]
        return cell
    }
    
    
}
