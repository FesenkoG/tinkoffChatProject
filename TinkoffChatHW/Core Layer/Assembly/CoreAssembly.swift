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
    var storageManager: StorageManager { get }
    
}

class CoreAssembly: ICoreAssembly {
    
    lazy var multipeerCommunicator: ICommunicator = MultipeerCommunicator()
    lazy var frcCommunicatorMessages: IFRCCommunicatorMessages = FRCCommunicatorMessages(stack: self.coreDataStack)
    lazy var frcCommunicatorConversations: IFRCCommunicatorConversations = FRCCommunicatorConversations(stack: self.coreDataStack)
    lazy var storageManager = StorageManager(stack: self.coreDataStack)
    lazy var coreDataStack: CoreDataStack = CoreDataStack()
    
}
