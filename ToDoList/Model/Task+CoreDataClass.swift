//
//  Task+CoreDataClass.swift
//  ToDoList
//
//  Created by Олег Дементьев on 26.08.2021.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

    convenience init() {
        self.init(entity: CoreDataManager.instance.entityDescription(forEntity: "Task"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
