//
//  FRCMessagesService.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class FRCMessagesService: IFRCMessagesService, FRCMessagesDelegate {
    
    private var frcCommunicator: IFRCCommunicatorMessages
    weak var delegate: FRCMessagesServiceDelegate?
    init(frcCommunicator: IFRCCommunicatorMessages) {
        self.frcCommunicator = frcCommunicator
        self.frcCommunicator.delegate = self
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
    
    func initFRC(convId: String) {
        frcCommunicator.initFRC(convId: convId)
    }
    
    func performFetch() {
        frcCommunicator.performFetch()
    }
    
    func numberOfMessages() -> Int {
        return frcCommunicator.numberOfMessages()
    }
    func getMessage(by indexPath: IndexPath) -> MessageInApp {
        return frcCommunicator.getMessage(by:indexPath)
    }
    
}

protocol IFRCMessagesService: class {
    var delegate: FRCMessagesServiceDelegate? { get set }
    func initFRC(convId: String)
    func performFetch()
    func numberOfMessages() -> Int
    func getMessage(by indexPath: IndexPath) -> MessageInApp
}

protocol  FRCMessagesServiceDelegate: class{
    func willChangeContent()
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?)
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType)
    func didChangeContent()
}
