//
//  CoreAssembly.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var multipeerCommunicator: ICommunicator { get }
    var coreDataStack: CoreDataStack { get }
    var frcCommunicatorConversations: IFRCCommunicatorConversations { get }
    var frcCommunicatorMessages: IFRCCommunicatorMessages { get }    
    //
    var conversationsManager: IConversationsManager { get }
    var profileManager: IProfileManager { get }
    //
    var requestSender: IRequestSender { get }
    
    
}

class CoreAssembly: ICoreAssembly {
    
    lazy var multipeerCommunicator: ICommunicator = MultipeerCommunicator()
    lazy var frcCommunicatorMessages: IFRCCommunicatorMessages = FRCCommunicatorMessages(stack: self.coreDataStack)
    lazy var frcCommunicatorConversations: IFRCCommunicatorConversations = FRCCommunicatorConversations(stack: self.coreDataStack)
    //
    lazy var conversationsManager: IConversationsManager = ConversationsManager(stack: self.coreDataStack)
    lazy var profileManager: IProfileManager = ProfileManager(stack: self.coreDataStack)
    //
    lazy var coreDataStack: CoreDataStack = CoreDataStack()
    lazy var requestSender: IRequestSender = RequestSender()
    
    
}
