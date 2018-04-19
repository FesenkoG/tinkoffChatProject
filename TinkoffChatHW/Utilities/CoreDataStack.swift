//
//  CoreDataStack.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    lazy var storeUrl: URL = {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentUrl.appendingPathComponent("MyStore.sqllite")
    }()
    
    let dataModelName = "CoreDataModel"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
            
        } catch {
            assert(false, error.localizedDescription)
        }
        
        return coordinator
    }()
    
//    lazy var masterContext: NSManagedObjectContext = {
//        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
//        masterContext.mergePolicy = NSOverwriteMergePolicy
//        return masterContext
//    }()
//
//    lazy var mainContext: NSManagedObjectContext = {
//        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        mainContext.parent = self.masterContext
//        mainContext.mergePolicy = NSOverwriteMergePolicy
//        return mainContext
//    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        let saveContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        saveContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    
    public func performSave(context: NSManagedObjectContext, completionHandler: ((Bool) -> Void)?) {
        if context.hasChanges {
            context.perform {
                [weak self] in
                do {
                    try context.save()
                } catch {
                    print(error)
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    DispatchQueue.main.async {
                        completionHandler?(true)
                    }
                }
                
            }
        } else {
            DispatchQueue.main.async {
                completionHandler?(false)
            }
            
        }
    }
    
    public func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser?{
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print(error)
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
        
    }
    
}

extension AppUser {
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            return nil
        }
        
        return fetchRequest
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            return appUser
        }
        
        return nil
    }
}
