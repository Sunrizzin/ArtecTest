//
//  NewWorkerViewController.swift
//  UsanovArtecTest
//
//  Created by Алексей Усанов on 23/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import RealmSwift

class NewWorkerViewController: UIViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ibSecondNameTextField: UITextField!
    @IBOutlet weak var ibFirstNameTextField: UITextField!
    @IBOutlet weak var ibSalaryTextField: UITextField!
    @IBOutlet weak var ibAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewWorkerViewController.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        ibSalaryTextField.delegate = self
        ibFirstNameTextField.delegate = self
        ibSecondNameTextField.delegate = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = 0
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func addData() {
        let worker = WorkerRLM()
        worker.name = self.ibFirstNameTextField.text!
        worker.secondName = self.ibSecondNameTextField.text!
        worker.salary = Int(self.ibSalaryTextField.text!)!
        
        try! realm.write {
            realm.add(worker)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showAlert(text: String, tf: UITextField) {
        let alert = UIAlertController(title: "Внимание", message: "Не заполнено поле \(text)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            tf.resignFirstResponder()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        if ibFirstNameTextField.text!.count < 1 {
            self.showAlert(text: "\"Имя\"", tf: ibFirstNameTextField)
        } else if ibSecondNameTextField.text!.count < 1 {
            self.showAlert(text: "\"Фамилия\"", tf: ibSecondNameTextField)
        } else if ibSalaryTextField.text!.count < 1 {
            self.showAlert(text: "\"Зарплата\"", tf: ibSalaryTextField)
        } else if ibSalaryTextField.text!.first == "0" {
            let alert = UIAlertController(title: "Внимание", message: "Поле \"Зарплата\" не может начинаться с \"0\"", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.ibSalaryTextField.resignFirstResponder()
            }
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            self.addData()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NewWorkerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 10 {
            return false
        }
        switch textField {
        case self.ibSalaryTextField:
            let number = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: number)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case ibSecondNameTextField:
            ibFirstNameTextField.becomeFirstResponder()
            return true
        case ibFirstNameTextField:
            ibSalaryTextField.becomeFirstResponder()
            return true
        default:
            self.view.endEditing(true)
        }
        return true
    }
}
