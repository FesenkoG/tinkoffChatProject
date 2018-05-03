//
//  ProfileManager.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 01.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol IProfileManager {
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?)
    func retrieveData(completionHandler: @escaping (Result<UserInApp>) -> Void)
}

class ProfileManager: IProfileManager {
    
    private let coreDataStack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.coreDataStack = stack
    }
    
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?) {
        guard let appUser = coreDataStack.findOrInsertAppUser(in: coreDataStack.saveContext) else { return }
        appUser.descr = user.descr
        appUser.name = user.name
        appUser.image = UIImageJPEGRepresentation(user.image, 1.0)
        
        coreDataStack.performSave(context: coreDataStack.saveContext) { (success) in
            completionHandler?(success)
        }
    }
    
    func retrieveData(completionHandler: @escaping (Result<UserInApp>) -> Void) {
        if let appUser = coreDataStack.findOrInsertAppUser(in: coreDataStack.saveContext) {
            if let imageData = appUser.image, let name = appUser.name, let descr = appUser.descr {
                let image = UIImage(data: imageData)!
                completionHandler(Result.Success(UserInApp(name: name, descr: descr, image: image)))
            } else {
                completionHandler(Result.Success(UserInApp(name: "Insert a name here", descr: "Here is a place for user information", image: UIImage(named: "placeholder-user")!)))
            }
        } else {
            completionHandler(Result.Failure("Something went wrong"))
            
        }
        
    }
}

enum Result<T> {
    case Success(T)
    case Failure(String)
}
