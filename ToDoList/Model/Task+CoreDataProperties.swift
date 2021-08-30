//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Олег Дементьев on 26.08.2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var date: Date?
    @NSManaged public var marked: Bool

}

extension Task : Identifiable {

}
