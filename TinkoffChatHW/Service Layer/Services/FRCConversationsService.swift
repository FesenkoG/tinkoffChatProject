//
//  FRCConversationsService.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class FRCConversationsService: IFRCConversationsService, FRCConversationsDelegate {
    
    var frcCommunicator: IFRCCommunicatorConversations
    weak var delegate: FRCConversationsServiceDelegate?
    init(frcCommunicator: IFRCCommunicatorConversations) {
        self.frcCommunicator = frcCommunicator
        self.frcCommunicator.delegate = self
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
    
    func initFRC() {
        frcCommunicator.initFRC()
    }
    
    func performFetch() {
        frcCommunicator.performFetch()
    }
    
    func getChannel(for indexPath: IndexPath) -> ConversationInApp? {
        return frcCommunicator.getChannel(for: indexPath)
    }
    func getNumberOfSections() -> Int {
        return frcCommunicator.getNumberOfSections()
    }
    func getNumberOfRows(inSection section: Int) -> Int {
        return frcCommunicator.getNumberOfRows(inSection: section)
    }
    func getHeaderForSection(section: Int) -> String {
        return frcCommunicator.getHeaderForSection(section: section)
    }
    
}

protocol IFRCConversationsService: class {
    var delegate: FRCConversationsServiceDelegate? { get set }
    func initFRC()
    func performFetch()
    func getChannel(for indexPath: IndexPath) -> ConversationInApp?
    func getNumberOfSections() -> Int
    func getNumberOfRows(inSection section: Int) -> Int
    func getHeaderForSection(section: Int) -> String
}

protocol  FRCConversationsServiceDelegate: class{
    func willChangeContent()
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?, channel: ConversationInApp?)
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType)
    func didChangeContent()
}
