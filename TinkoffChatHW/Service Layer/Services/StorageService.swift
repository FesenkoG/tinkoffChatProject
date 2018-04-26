//
//  StorageService.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol IStorageService {
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?)
    func saveNewMessageInConversation(conversationId: String, text:String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?)
    func userBecameInactive(userId: String)
    func setAllConversationsOffline()
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?)
    func retrieveData(completionHandler: @escaping (Result) -> Void)
    
}

class StorageService: IStorageService {
    
    let storageManager: IStorageManager
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?) {
        storageManager.insertOrUpdateConversationWithUser(userId: userId, userName: userName, completionHandler: completionHandler)
    }
    
    func saveNewMessageInConversation(conversationId: String, text: String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?) {
        storageManager.saveNewMessageInConversation(conversationId: conversationId, text: text, isIncoming: isIncoming, completionHandler: completionHandler)
    }
    
    func userBecameInactive(userId: String) {
        storageManager.userBecameInactive(userId: userId)
    }
    
    func setAllConversationsOffline() {
        storageManager.setAllConversationsOffline()
    }
    
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?) {
        storageManager.saveData(user: user, completionHandler: completionHandler)
    }
    
    func retrieveData(completionHandler: @escaping (Result) -> Void) {
        storageManager.retrieveData(completionHandler: completionHandler)
    }
    
    
}
