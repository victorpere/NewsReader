//
//  Cache.swift
//  NewsReader
//
//  Created by Victor on 2019-04-28.
//  Copyright © 2019 Victorius Software Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class Cache : NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer
    
    init(completionClosure: @escaping () -> ()) {
        self.persistentContainer = NSPersistentContainer(name: "NewsReader")
        self.persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure()
        }
        self.managedObjectContext = self.persistentContainer.viewContext
    }
    
    // MARK: - Public methods
    
    func save(entity entityName: String, keyName: String, keyValue: Any, values: Dictionary<String,Any?>) {
        var object = self.fetch(entity: entityName, keyName: keyName, keyValue: keyValue)
        if object == nil {
            // no match
            // new record
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
            object = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
            object!.setValue(keyValue, forKey: keyName)
        }
        
        if self.save(object!, with: values) {
            print("saving succeeded")
        } else {
            print("saving failed")
        }
    }
    
    func fetch(entity entityName: String, keyName: String, keyValue: Any) -> NSManagedObject? {
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "%K == %@", keyName, keyValue as! String)
            let fetchedResults = try self.managedObjectContext.fetch(fetchRequest)
            if let object = fetchedResults.first {
                // found match
                return object
            }
        } catch {
            print("fetching failed")
        }
        
        return nil
    }
    
    func deleteAll(entity entityName: String) {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try self.managedObjectContext.execute(deleteRequest)
        } catch {
            print("deleting failed")
        }
    }
    
    // MARK: - Private methods
    
    private func save(_ object: NSManagedObject, with values: Dictionary<String, Any?>) -> Bool {
        do {
            for value in values {
                object.setValue(value.value, forKey: value.key)
            }
            try self.managedObjectContext.save()
            return true
        } catch {
            return false
        }
    }
}
