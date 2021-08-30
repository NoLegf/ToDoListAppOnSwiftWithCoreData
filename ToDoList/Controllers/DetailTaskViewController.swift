//
//  DetailTaskViewController.swift
//  ToDoList
//
//  Created by Олег Дементьев on 27.08.2021.
//

import UIKit

class DetailTaskViewController: UIViewController {

// MARK: - Variables
    
    var taskName: String?
    var taskDescription: String?
    var date: Date?
    
    var indexPathRow: IndexPath?
    
// MARK: - IBOutlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionText: UITextView!

// MARK: - @IBAction
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) {
        callAlertController()
    }
    
// MARK: - View Live Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.date = date!
        descriptionText.text = taskDescription
        self.title = taskName
    }
    
    // MARK: - Func
    
    private func callAlertController() {
        let alertController = UIAlertController(title: "Are you sure?", message: "Did you really complete this task?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            
            CoreDataManager.instance.managedObjectContext.delete(
                CoreDataManager.instance.fetchedResultsController?.object(at: self!.indexPathRow!) as! Task
            )
            CoreDataManager.instance.saveContext()
            
            CoreDataManager.instance.tryPerformFetch()
            
            self?.navigationController?.popViewController(animated: true)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
