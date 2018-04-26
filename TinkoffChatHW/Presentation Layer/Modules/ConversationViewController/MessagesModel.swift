//
//  MessagesModel.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

struct MessageInApp {
    
    var text: String?
    var isIncoming: Bool
}

class FRCMessagesModel: IFRCMessagesModel, FRCMessagesServiceDelegate {

    let messagesService: IFRCMessagesService
    weak var delegate: FRCMessagesModelDelegate?
    
    init(frcMessagesService: IFRCMessagesService) {
        self.messagesService = frcMessagesService
        self.messagesService.delegate = self
        
    }
    
    func initFRC(convId: String) {
        messagesService.initFRC(convId: convId)
    }
    
    func performFetch() {
        messagesService.performFetch()
    }
    func willChangeContent() {
        delegate?.willChangeContent()
    }
    
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?) {
        delegate?.changingContent(indexPath: indexPath, typeOfChanging: typeOfChanging, newIndexPath: newIndexPath)
    }
    
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType) {
        delegate?.changingContentInSection(indexSet: indexSet, typeOfChanging: typeOfChanging)
    }
    
    func didChangeContent() {
        delegate?.didChangeContent()
    }
    
    func numberOfMessages() -> Int {
        return messagesService.numberOfMessages()
    }
    
    func getMessage(by indexPath: IndexPath) -> MessageInApp {
        return messagesService.getMessage(by: indexPath)
    }
    
}

protocol IFRCMessagesModel: class {
    var delegate: FRCMessagesModelDelegate? { get set }
    func initFRC(convId: String)
    func performFetch()
    func numberOfMessages() -> Int
    func getMessage(by indexPath: IndexPath) -> MessageInApp
}

protocol  FRCMessagesModelDelegate: class{
    func willChangeContent()
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?)
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType)
    func didChangeContent()
}
