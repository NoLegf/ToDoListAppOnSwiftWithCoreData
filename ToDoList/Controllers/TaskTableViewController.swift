//
//  ViewController.swift
//  ToDoList
//
//  Created by Олег Дементьев on 10.08.2021.
//

import CoreData
import UIKit

class TaskTableViewController: UIViewController {
    
    var nameDescriptor: NSSortDescriptor?
    var nameAscending = false
    var dateDescriptor: NSSortDescriptor?
    var dateAscending = false
    var markedDescriptor: NSSortDescriptor?
    var markedAscending = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Live Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateFetchedResultsController(descriptors: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        navigationItem.backButtonTitle = "Cancel"
        title = "My Tasks"
    }
    // MARK: - IBActions
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(identifier: "addNewTaskVC") {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func nameSortButton(_ sender: UIButton) {
        nameAscending = !nameAscending
        nameDescriptor = NSSortDescriptor(key: "name", ascending: nameAscending)
        
        updateFetchedResultsController(descriptors: [nameDescriptor!])
        tableView.reloadData()
    }
    @IBAction func dateSortButton(_ sender: UIButton) {
        dateAscending = !dateAscending
        dateDescriptor = NSSortDescriptor(key: "date", ascending: dateAscending)
        
        updateFetchedResultsController(descriptors: [dateDescriptor!])
        tableView.reloadData()
    }
    @IBAction func markedSortButton(_ sender: UIButton) {
        markedAscending = !markedAscending
        markedDescriptor = NSSortDescriptor(key: "marked", ascending: markedAscending)
        
        updateFetchedResultsController(descriptors: [markedDescriptor!])
        tableView.reloadData()
    }
    
    // MARK: - Func

    private func string(from date: Date?, style: DateFormatter.Style) -> String {
        guard let date = date else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: date)
    }
    
    func updateFetchedResultsController(descriptors: [NSSortDescriptor]?) {
        CoreDataManager.instance.fetchedResultsController = CoreDataManager.getFetchedResultsController(forFetchRequest:
            CoreDataManager.getFetchRequest(forEntity: "Task", descriptors: descriptors)
        )
        CoreDataManager.instance.tryPerformFetch()
    }
}

// MARK: - UITableView
extension TaskTableViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.instance.fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath) as! TaskRowTableViewCell
        
        let fetchObj = CoreDataManager.instance.fetchedResultsController?.object(at: indexPath) as! Task
        cell.task.text = fetchObj.name
        cell.timeDate.text = string(from: fetchObj.date, style: .medium)
        
        if fetchObj.marked {
            cell.star.image = UIImage.init(systemName: "star.fill")
        } else {
            cell.star.image = UIImage.init(systemName: "star")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailTaskVC") as? DetailTaskViewController {
            let selectObj = CoreDataManager.instance.fetchedResultsController?.object(at: indexPath) as! Task
            
            vc.taskName = selectObj.name
            vc.taskDescription = selectObj.taskDescription
            vc.date = selectObj.date
            vc.indexPathRow = indexPath
            
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
