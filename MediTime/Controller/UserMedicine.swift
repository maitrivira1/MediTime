//
//  UserMedicine.swift
//  MediTime
//
//  Created by Maitri Vira on 09/08/21.
//

import UIKit
import CoreData

class UserMedicine: UIViewController {

    @IBOutlet weak var userMedtableView: UITableView!
    var userSelected: User?
    var medicines = [Medicine]()
    var filterMedicine = [Medicine]()
    
    var manageObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageObjectContext = appDelegate?.persistentContainer.viewContext as! NSManagedObjectContext
        
        loadDataMedicine()
        
        setupUI()
    }
}

extension UserMedicine: Setup{
    
    func setupUI() {
        navigationItem.title = "User"
        userMedtableView.register(UINib(nibName: "UserStoryTVC", bundle: nil), forCellReuseIdentifier: "cell2")
        userMedtableView.delegate = self
        userMedtableView.dataSource = self
        userMedtableView.tableFooterView = UIView()
        userMedtableView.separatorStyle = .none
    }
    
}

extension UserMedicine: SetupData{
    
    func loadDataMedicine(with request: NSFetchRequest<Medicine> = Medicine.fetchRequest(), predicate: NSPredicate? = nil) {
        let medicinePredicate = NSPredicate(format: "users.id = %@", NSNumber(value: userSelected?.id ?? 0))
        
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
        
        userMedtableView.reloadData()
    }
    
}

extension UserMedicine: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let medicineCount = medicines.count
        
        if medicineCount == 0{
            tableView.separatorStyle  = .none
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: tableView.bounds.size.height))
            noDataLabel.text          = "Belum ada data"
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
        let medicineIndex = medicines[indexPath.row]
        let cell = userMedtableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! UserStoryTVC
        cell.userData(data: medicineIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
