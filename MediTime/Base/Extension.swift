//
//  Extension.swift
//  MediTime
//
//  Created by Maitri Vira on 02/08/21.
//

import UIKit

class Extension: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //alert
    func showAlertConfirmation(on vc: UIViewController, title: String, message: String, status: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if status == "berhasil"{
                vc.navigationController?.popToRootViewController(animated: true)
            }
            
        }))
        
        vc.present(alert, animated: true)
        
    }
    
    func showCrash(on vc: UIViewController){
        let alert = UIAlertController(title: "title", message: "Terjadi Kesalahan Sistem", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        vc.present(alert, animated: true)
    }
    
}

extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}

extension UIButton {
    func underline() {
        if let textString = self.titleLabel?.text {

            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: textString.count))
            self.setAttributedTitle(attributedString, for: .normal)
        }

    }
}
