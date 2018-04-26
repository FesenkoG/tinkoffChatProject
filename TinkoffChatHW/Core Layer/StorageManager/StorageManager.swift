//
//  StorageManager.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import CoreData

protocol IStorageManager {
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?)
    func saveNewMessageInConversation(conversationId: String, text:String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?)
    func userBecameInactive(userId: String)
    func setAllConversationsOffline()
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?)
    func retrieveData(completionHandler: @escaping (Result) -> Void)
    
}

class StorageManager: IStorageManager {
    
    private let coreDataStack: CoreDataStack
    
    init(stack: CoreDataStack) {
        self.coreDataStack = stack
    }
    
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?) {
        //Проверить наличие такой беседы в бд
        //Вынести создание реквеста и его выполнение в CoreDataStack
        var conversation = [Conversation]()
        let conversationId = generateConversationId(fromUserId: userId)
        guard let fetchRequestConversation = coreDataStack.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationWithID", substitutionVariables: ["conversationId": conversationId]) as? NSFetchRequest<Conversation> else { return }
        do {
            conversation = try coreDataStack.saveContext.fetch(fetchRequestConversation)
        } catch {
            print(error.localizedDescription)
        }
        
        if conversation.count > 0 {
            
            let conv = conversation.first!
            conv.isOnline = true
            coreDataStack.performSave(context: coreDataStack.saveContext) { (success) in
                completionHandler?(success)
            }
            
        } else {
            
            //Создать беседу и юзера в контексте
            //Вынести создание беседы и юзера в CoreDataStack, а тут только сохранять
            guard let conv = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: coreDataStack.saveContext) as? Conversation else { return }
            guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: coreDataStack.saveContext) as? User else { return }
            
            user.userId = userId
            user.name = userName
            
            conv.sender = user
            conv.isOnline = true
            conv.conversationId = generateConversationId(fromUserId: userId)
            //Сохранить
            coreDataStack.performSave(context: coreDataStack.saveContext) { (success) in
                completionHandler?(success)
            }
        }
    }
    
    func saveNewMessageInConversation(conversationId: String, text:String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?) {
        //Находим в бд беседу
        guard let fetchRequestConversation = coreDataStack.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationWithID", substitutionVariables: ["conversationId": conversationId]) as? NSFetchRequest<Conversation> else { return }
        
        //Добавляем в конец новое сообщение
        do {
            let conv = try coreDataStack.saveContext.fetch(fetchRequestConversation).first!
            guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: coreDataStack.saveContext) as? Message else { return }
            message.text = text
            message.isIncoming = isIncoming
            message.date = Date()
            conv.addToMessages(message)
        } catch {
            print(error.localizedDescription)
        }
        //Сохранить
        coreDataStack.performSave(context: coreDataStack.saveContext) { (success) in
            completionHandler?(success)
        }
        
    }
    
    func userBecameInactive(userId: String) {
        //Сменить индикатор isOnline
        var conversations = [Conversation]()
        let conversationId = generateConversationId(fromUserId: userId)
        guard let fetchRequestConversation = coreDataStack.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationWithID", substitutionVariables: ["conversationId": conversationId]) as? NSFetchRequest<Conversation> else { return }
        do {
            conversations = try coreDataStack.saveContext.fetch(fetchRequestConversation)
        } catch {
            print(error.localizedDescription)
        }
        
        let conv = conversations.first!
        if let numOfMessages = conv.messages?.count, numOfMessages > 0 {
            conv.isOnline = false
        } else {
            coreDataStack.saveContext.delete(conv)
        }
        coreDataStack.performSave(context: coreDataStack.saveContext) { (success) in
            if success {
                print("Good")
            }
        }
    }
    
    func setAllConversationsOffline() {
        var conversations = [Conversation]()
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        
        do {
            conversations = try coreDataStack.saveContext.fetch(request)
        } catch {
            print(error)
        }
        
        for conversation in conversations {
            conversation.isOnline = false
        }
        
        coreDataStack.performSave(context: coreDataStack.saveContext, completionHandler: nil)
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
    
    func retrieveData(completionHandler: @escaping (Result) -> Void) {
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
    
    func createFRCForConversations() -> NSFetchedResultsController<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let sortDesctiptorIsOnline = NSSortDescriptor(key: #keyPath(Conversation.isOnline), ascending: false)
        request.sortDescriptors = [sortDesctiptorIsOnline]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.saveContext, sectionNameKeyPath: #keyPath(Conversation.isOnline), cacheName: nil)
        return frc
    }
    
    func createFRCForMessages(withConvID convID: String) -> NSFetchedResultsController<Message>? {
        
        if let request = coreDataStack.managedObjectModel.fetchRequestFromTemplate(withName: "MessagesFromConvID", substitutionVariables: ["convId": convID]) as? NSFetchRequest<Message> {
            let sortDescriptor = NSSortDescriptor(key: #keyPath(Message.date), ascending: true)
            request.sortDescriptors = [sortDescriptor]
            let frc =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.saveContext, sectionNameKeyPath: nil, cacheName: nil)
            
            return frc
        }
        
        return nil
    }
    
    func deleteObject(object: NSManagedObject) {
        coreDataStack.saveContext.delete(object)
        
        coreDataStack.performSave(context: coreDataStack.saveContext, completionHandler: nil)
    }
    
}

enum Result {
    case Success(UserInApp)
    case Failure(String)
}
