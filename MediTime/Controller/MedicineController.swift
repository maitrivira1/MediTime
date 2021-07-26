//
//  MedicineController.swift
//  MediTime
//
//  Created by Maitri Vira on 14/07/21.
//

import UIKit

class MedicineController: UIViewController {
    
    @IBOutlet weak var saveButton: UIView!
    @IBOutlet weak var dosisTextField: UITextField!
    @IBOutlet weak var eatingTextField: UITextField!
    
    let dosisPicker = UIPickerView()
    let eatPicker = UIPickerView()
    
    let dosis = ["1 x sehari", "2 x sehari", "3 x sehari", "4 x sehari"]
    let eat = ["Sebelum Makan", "Sesudah Makan"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

extension MedicineController: Setup{
    
    func setupUI(){
        navigationItem.title = "Keterangan Obat"
        navigationItem.largeTitleDisplayMode = .never
        
        dosisPicker.delegate = self
        dosisPicker.dataSource = self
        
        eatPicker.delegate = self
        eatPicker.dataSource = self
        
        dosisTextField.inputView = dosisPicker
        eatingTextField.inputView = eatPicker
        
        saveButton.layer.cornerRadius = 12
    }
    
}

// MARK: - Picker View
extension MedicineController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dosisPicker {
            return dosis.count
        } else if pickerView == eatPicker{
             return eat.count
        }

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dosisPicker  {
            return dosis[row]
        }else if pickerView == eatPicker {
            return eat[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dosisPicker {
            dosisTextField.text = dosis[row]
        }else if pickerView == eatPicker {
            eatingTextField.text = eat[row]
        }
    }
    
}
