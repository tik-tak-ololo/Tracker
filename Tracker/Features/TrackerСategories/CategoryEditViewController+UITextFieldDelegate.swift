//
//  CategoryEditViewController+UITextFieldDelegate.swift
//  Tracker
//
//  Created by Сергей Хмелёв on 07.06.2026.
//

import UIKit

extension CategoryEditViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
