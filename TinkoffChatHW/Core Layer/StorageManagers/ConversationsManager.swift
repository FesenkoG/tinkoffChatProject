//
//  ConversationsManager.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 01.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationsManager {
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?)
    func saveNewMessageInConversation(conversationId: String, text:String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?)
    func userBecameInactive(userId: String)
    func setAllConversationsOffline()
}

class ConversationsManager: IConversationsManager {
    
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
}
