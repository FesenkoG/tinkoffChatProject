//
//  ServicesAssembly.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    lazy var communicationService: ICommunicationService = CommunicationService(communicator: self.coreAssembly.multipeerCommunicator)
    lazy var frcConversationsService: IFRCConversationsService = FRCConversationsService(frcCommunicator: self.coreAssembly.frcCommunicatorConversations)
    lazy var frcMessagesService: IFRCMessagesService = FRCMessagesService(frcCommunicator: self.coreAssembly.frcCommunicatorMessages)
    lazy var storageService: IStorageService = StorageService(storageManager: self.coreAssembly.storageManager)
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    
    
}

protocol IServicesAssembly {
    var communicationService: ICommunicationService { get }
    var frcConversationsService: IFRCConversationsService { get }
    var frcMessagesService: IFRCMessagesService { get }
    var storageService: IStorageService { get }
}
