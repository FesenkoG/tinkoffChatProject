//
//  Channel.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

struct ConversationInApp {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    var userId: String?
}

//MARK: - CommunicatorModel
class CommunicatorModel: CommunicatorServiceDelegate, ICommunicatorModel {
    let communicationService: ICommunicationService
    weak var delegate: CommunicatorModelDelegate?
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
        self.communicationService.delegate = self
    }
    
    func removeAllSessions() {
        communicationService.removeAllSessions()
    }
    
    func didLostUser(userID: String) {
        delegate?.didLostUser(userID: userID)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        communicationService.sendMessage(string: string, to: userID, completionHandler: completionHandler)
    }
    
}
//MARK: - FRCConversationsModel
class FRCConversationsModel: IFRCConversationsModel, FRCConversationsServiceDelegate {
    
    let conversationsService: IFRCConversationsService
    weak var delegate: FRCConversationsModelDelegate?
    
    init(frcConversationsService: IFRCConversationsService) {
        self.conversationsService = frcConversationsService
        self.conversationsService.delegate = self
    }
    
    func initFRC() {
        conversationsService.initFRC()
    }
    
    func performFetch() {
        conversationsService.performFetch()
    }
    func willChangeContent() {
        delegate?.willChangeContent()
    }
    
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?, channel: ConversationInApp?) {
        delegate?.changingContent(indexPath: indexPath, typeOfChanging: typeOfChanging, newIndexPath: newIndexPath, channel: channel)
    }
    
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType) {
        delegate?.changingContentInSection(indexSet: indexSet, typeOfChanging: typeOfChanging)
    }
    
    func didChangeContent() {
        delegate?.didChangeContent()
    }
    
    func getChannel(for indexPath: IndexPath) -> ConversationInApp? {
        return conversationsService.getChannel(for: indexPath)
    }
    
    func getNumberOfSections() -> Int {
        return conversationsService.getNumberOfSections()
    }
    func getNumberOfRows(inSection section: Int) -> Int {
        return conversationsService.getNumberOfRows(inSection: section)
    }
    func getHeaderForSection(section: Int) -> String {
        return conversationsService.getHeaderForSection(section: section)
    }
    
}
//MARK: - FRCStorageModel
class StorageModel: IStorageModel {
    let storageService: IStorageService
    
    init(service: IStorageService) {
        self.storageService = service
    }
    
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?) {
        storageService.insertOrUpdateConversationWithUser(userId: userId, userName: userName, completionHandler: completionHandler)
    }
    
    func saveNewMessageInConversation(conversationId: String, text: String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?) {
        storageService.saveNewMessageInConversation(conversationId: conversationId, text: text, isIncoming: isIncoming, completionHandler: completionHandler)
    }
    
    func userBecameInactive(userId: String) {
        storageService.userBecameInactive(userId: userId)
    }
    
    func setAllConversationsOffline() {
        storageService.setAllConversationsOffline()
    }
    
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?) {
        storageService.saveData(user: user, completionHandler: completionHandler)
    }
    
    func retrieveData(completionHandler: @escaping (Result) -> Void) {
        storageService.retrieveData(completionHandler: completionHandler)
    }
}
//MARK: - Storage Protocol
protocol IStorageModel {
    func insertOrUpdateConversationWithUser(userId: String, userName: String, completionHandler: ((Bool) -> Void)?)
    func saveNewMessageInConversation(conversationId: String, text:String, isIncoming: Bool, completionHandler: ((Bool) -> Void)?)
    func userBecameInactive(userId: String)
    func setAllConversationsOffline()
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?)
    func retrieveData(completionHandler: @escaping (Result) -> Void)
    
    
}
//MARK: - Communicator Protocols
protocol CommunicatorModelDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

protocol ICommunicatorModel: class {
    var delegate: CommunicatorModelDelegate? { get set }
    func removeAllSessions()
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}
//MARK: - FRCConversations Protocols
protocol  FRCConversationsModelDelegate: class{
    func willChangeContent()
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?, channel: ConversationInApp?)
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType)
    func didChangeContent()
}

protocol IFRCConversationsModel: class {
    var delegate: FRCConversationsModelDelegate? { get set }
    func initFRC()
    func performFetch()
    func getChannel(for indexPath: IndexPath) -> ConversationInApp?
    func getNumberOfSections() -> Int
    func getNumberOfRows(inSection section: Int) -> Int
    func getHeaderForSection(section: Int) -> String
}
