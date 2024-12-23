//
//  localization.swift
//  MediTime
//
//  Created by MACBOOK M1 PRO on 23/12/24.
//

import UIKit

extension String {
    //MARK: - Localizable
    func localized() -> String {
        return NSLocalizedString(
            self,
            tableName: "Main",
            bundle: .main,
            value: self,
            comment: self
        )
    }
}
