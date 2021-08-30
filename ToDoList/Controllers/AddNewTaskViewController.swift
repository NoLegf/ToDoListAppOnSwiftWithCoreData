//
//  AddNewTaskViewController.swift
//  ToDoList
//
//  Created by Олег Дементьев on 11.08.2021.
//

import CoreData
import UIKit

class AddNewTaskViewController: UIViewController {
    
    // MARK: - Variables
    
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var taskTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var importantSwitch: UISwitch!
    
    
    // MARK: - View Live Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        taskTF.delegate = self
        datePicker.minimumDate = Date() // Создает значение даты, инициализированное текущими датой и временем.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    // MARK: - IBActions
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let task = taskTF.text, task != "" else {
            showAlertController(text: "Please, enter the taskfield.")
            return
        }
        let managedObject = Task()
        managedObject.name = taskTF.text
        managedObject.taskDescription = descriptionTF.text
        managedObject.date = datePicker.date
        managedObject.marked = importantSwitch.isOn
        
        CoreDataManager.instance.saveContext()
        
        CoreDataManager.instance.tryPerformFetch()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Func
    
    private func showAlertController(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Keyboard
extension AddNewTaskViewController: UITextFieldDelegate {
    
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contetnInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbFrameSize.height, right: 0.0)
        scrollView.contentInset = contetnInsets
        scrollView.scrollIndicatorInsets = contetnInsets
        
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    @objc func kbWillHide() {
        scrollView.contentInset = UIEdgeInsets.zero
        
        if keyboardDismissTapGesture != nil {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
