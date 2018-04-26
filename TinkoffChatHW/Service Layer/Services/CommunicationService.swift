//
//  CommunicationManager.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 23.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class CommunicationService: CommunicatorDelegate, ICommunicationService {
    
    var communicator: ICommunicator
    weak var delegate: CommunicatorServiceDelegate?
    
    init(communicator: ICommunicator) {
        self.communicator = communicator
        self.communicator.delegate = self
    }
    
    func didFoundUser(userID: String, userName: String?) {
        delegate?.didFoundUser(userID: userID, userName: userName)
    }
    
    func didLostUser(userID: String) {
        delegate?.didLostUser(userID: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
    
    func sendMessage(string: String, to: String, completionHandler : ((Bool, Error?) -> ())?) {
        communicator.sendMessage(string: string, to: to, completionHandler: completionHandler)
    }
    
    func removeAllSessions() {
        communicator.removeAllSessions()
    }
    
    
    
}

protocol CommunicatorServiceDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

protocol ICommunicationService: class {
    var delegate: CommunicatorServiceDelegate? { get set }
    func sendMessage(string: String, to: String, completionHandler : ((Bool, Error?) -> ())?)
    func removeAllSessions()
}
