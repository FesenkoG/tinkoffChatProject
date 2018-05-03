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
    
    func getConversationsModel() -> IConversationsModel {
        return ConversationsModel(service: serviceAssembly.conversationsService)
    }
    
    func getProfileModel() -> IProfileModel {
        return ProfileModel(profileService: serviceAssembly.profileService)
    }
    func getChoosePhotoModel() -> IChoosePhotoModel {
        return ChoosePhotoModel(requestService: serviceAssembly.requestService)
    }
    
    
}

protocol IPresentationAssembly {
    func getCommunicatorModel() -> ICommunicatorModel
    func getFRCConversationsModel() -> IFRCConversationsModel
    func getFRCMessagesModel() -> IFRCMessagesModel
    func getChoosePhotoModel() -> IChoosePhotoModel
    func getConversationsModel() -> IConversationsModel
    func getProfileModel() -> IProfileModel
}
