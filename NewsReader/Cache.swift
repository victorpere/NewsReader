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
    
    /* Saves the object in data store. Either creates a new record, or updates existing one
     depending on whether an object with the same keyValue exists
     returns true if save succeeds
    */
    func save(entity entityName: String, keyName: String, keyValue: Any, values: Dictionary<String,Any?>) -> Bool {
        var object = self.fetch(entity: entityName, keyName: keyName, keyValue: keyValue)
        if object == nil {
            // no match
            // new record
            object = self.createNewObject(for: entityName)
            object!.setValue(keyValue, forKey: keyName)
        }
        
        return self.save(object!, with: values)
    }
    
    /* Saves the object as an existing record with the provided objectID, or new record if no match
     returns true if save succeeds
    */
    func save(entity entityName: String, objectID: NSManagedObjectID?, values: Dictionary<String,Any?>) -> Bool {
        var object: NSManagedObject?
        if objectID != nil {
            object = self.fetch(with: objectID)
        }
        if object == nil {
            // no match
            // new record
            object = self.createNewObject(for: entityName)
        }
        return self.save(object!, with: values)
    }
    
    /* Fetches an object matching the provided keyValue
    */
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
    
    /* Fetches the object with the provided objectID
    */
    func fetch(with objectID: NSManagedObjectID?) -> NSManagedObject? {
        if objectID != nil {
            do {
                let object = try self.managedObjectContext.existingObject(with: objectID!)
                return object
            } catch {
                print("fetching with ID failed")
            }
        }
        
        return nil
    }
    
    /* Fetches all the records for the specified entity
    */
    func fetchAll(entity entityName: String) -> [NSManagedObject]? {
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            // TODO: predicate
            let fetchedResults = try self.managedObjectContext.fetch(fetchRequest)
            return fetchedResults
        } catch {
            print("fetching all failed")
        }
        
        return nil
    }
    
    /* Deletes all the records for the specified entity
    */
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
    
    private func createNewObject(for entityName: String) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: self.managedObjectContext)!
        let object = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
        return object
    }
}
