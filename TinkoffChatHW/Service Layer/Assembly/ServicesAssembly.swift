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
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var communicationService: ICommunicationService = CommunicationService(communicator: self.coreAssembly.multipeerCommunicator)
    lazy var frcConversationsService: IFRCConversationsService = FRCConversationsService(frcCommunicator: self.coreAssembly.frcCommunicatorConversations)
    lazy var frcMessagesService: IFRCMessagesService = FRCMessagesService(frcCommunicator: self.coreAssembly.frcCommunicatorMessages)
    //
    lazy var profileService: IProfileService = ProfileService(profileManager: self.coreAssembly.profileManager)
    lazy var conversationsService: IConversationsService = ConversationsService(conversationsManager: self.coreAssembly.conversationsManager)
    //
    lazy var requestService: IRequestService = RequestService(requestSender: self.coreAssembly.requestSender)
    
    
    
    
}

protocol IServicesAssembly {
    var communicationService: ICommunicationService { get }
    var frcConversationsService: IFRCConversationsService { get }
    var frcMessagesService: IFRCMessagesService { get }
    var requestService: IRequestService { get }
    var profileService: IProfileService { get }
    var conversationsService: IConversationsService { get }
}
