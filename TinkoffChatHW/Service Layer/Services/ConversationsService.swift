//
//  ConversationsService.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 01.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
protocol IConversationsService {
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?)
    func saveNewMessageInConversation(conversationId: String, text:String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?)
    func userBecameInactive(userId: String)
    func setAllConversationsOffline()
}

class ConversationsService: IConversationsService {
    
    let conversationsManager: IConversationsManager
    init(conversationsManager: IConversationsManager) {
        self.conversationsManager = conversationsManager
    }
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?) {
        conversationsManager.insertOrUpdateConversationWithUser(userId: userId, userName: userName, completionHandler: completionHandler)
    }
    
    func saveNewMessageInConversation(conversationId: String, text: String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?) {
        conversationsManager.saveNewMessageInConversation(conversationId: conversationId, text: text, isIncoming: isIncoming, completionHandler: completionHandler)
    }
    
    func userBecameInactive(userId: String) {
        conversationsManager.userBecameInactive(userId: userId)
    }
    
    func setAllConversationsOffline() {
        conversationsManager.setAllConversationsOffline()
    }
}
