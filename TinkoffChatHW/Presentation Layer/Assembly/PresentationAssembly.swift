//
//  PresentationAssembly.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class PresentationAssembly: IPresentationAssembly {
    
    let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func getCommunicatorModel() -> ICommunicatorModel {
        return CommunicatorModel(communicationService: serviceAssembly.communicationService)
    }
    
    func getFRCConversationsModel() -> IFRCConversationsModel {
        return FRCConversationsModel(frcConversationsService: serviceAssembly.frcConversationsService)
    }
    
    func getFRCMessagesModel() -> IFRCMessagesModel {
        return FRCMessagesModel(frcMessagesService: serviceAssembly.frcMessagesService)
    }
    
    func getStorageModel() -> IStorageModel {
        return StorageModel(service: serviceAssembly.storageService)
    }
    
    
}

protocol IPresentationAssembly {
    func getStorageModel() -> IStorageModel
    func getCommunicatorModel() -> ICommunicatorModel
    func getFRCConversationsModel() -> IFRCConversationsModel
    func getFRCMessagesModel() -> IFRCMessagesModel
}
