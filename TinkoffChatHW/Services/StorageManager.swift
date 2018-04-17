//
//  StorageManager.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class StorageManager {
    
    static private let coreDataStack = CoreDataStack()
    
    static func saveData(user: User, completionHandler: ((Bool) -> Void)?) {
        guard let appUser = coreDataStack.findOrInsertAppUser(in: coreDataStack.saveContext) else { return }
        appUser.descr = user.descr
        appUser.name = user.name
        appUser.image = UIImageJPEGRepresentation(user.image, 1.0)
        
        coreDataStack.performSave(context: coreDataStack.saveContext) { (success) in
            completionHandler?(success)
        }
    }
    
    static func retrieveData(completionHandler: @escaping (Result) -> Void) {
        if let appUser = coreDataStack.findOrInsertAppUser(in: coreDataStack.saveContext) {
            if let imageData = appUser.image, let name = appUser.name, let descr = appUser.descr {
                let image = UIImage(data: imageData)!
                completionHandler(Result.Success(User(name: name, descr: descr, image: image)))
            } else {
                completionHandler(Result.Success(User(name: "Insert a name here", descr: "Here is a place for user information", image: UIImage(named: "placeholder-user")!)))
            }
        } else {
            completionHandler(Result.Failure("Something went wrong"))
            
        }
        
    }
}

enum Result {
    case Success(User)
    case Failure(String)
}
