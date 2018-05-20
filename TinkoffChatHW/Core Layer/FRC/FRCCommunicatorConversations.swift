//
//  File.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 23.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import CoreData


class FRCCommunicatorConversations: NSObject, NSFetchedResultsControllerDelegate, IFRCCommunicatorConversations {
    
    private let coreDataStack: CoreDataStack
    internal var conversationsController: NSFetchedResultsController<Conversation>!
    weak var delegate: FRCConversationsDelegate?
    
    init(stack: CoreDataStack) {
        self.coreDataStack = stack
    }
    
    
    func initFRC() {
        conversationsController = createFRCForConversations()
        conversationsController.delegate = self
    }
    
    func performFetch() {
        do {
            try conversationsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    private func createFRCForConversations() -> NSFetchedResultsController<Conversation> {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        let sortDesctiptorIsOnline = NSSortDescriptor(key: #keyPath(Conversation.isOnline), ascending: false)
        request.sortDescriptors = [sortDesctiptorIsOnline]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.saveContext, sectionNameKeyPath: #keyPath(Conversation.isOnline), cacheName: nil)
        return frc
    }
    

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        var newType: ChangeType = .insert
        var channel: ConversationInApp?
        switch type {
        case .insert:
            newType = .insert
        case .delete:
            newType = .delete
        case .move:
            newType = .move
        case .update:
            newType = .update
            guard let numberOfSections = self.conversationsController.sections?.count else { return }
            guard let sec = indexPath?.section else { return }
            guard numberOfSections > sec else { return }
            guard let conversation = self.conversationsController?.object(at: indexPath!) else { return }
            var dateOfLastMessage: Date?
            var lastMessage: String?
            if let numberOfMessages = conversation.messages?.count, numberOfMessages > 0 {
                lastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).text
                dateOfLastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).date
            }
            let name = conversation.sender?.name
            let online = conversation.isOnline
            channel = ConversationInApp(name: name, message: lastMessage, date: dateOfLastMessage, online: online, hasUnreadMessages: false, userId: nil)
        }
        delegate?.changingContent(indexPath: indexPath, typeOfChanging: newType, newIndexPath: newIndexPath, channel: channel)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet.init(integer: sectionIndex)
        var newType = ChangeType.insert
        switch type {
        case .insert:
            newType = .insert
        case .delete:
            newType = .delete
        default:
            break
        }
        
        delegate?.changingContentInSection(indexSet: indexSet, typeOfChanging: newType)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChangeContent()
    }
    
    
    func getChannel(for indexPath: IndexPath) -> ConversationInApp? {
        
        let conversation = conversationsController.object(at: indexPath)
        var dateOfLastMessage: Date?
        var lastMessage: String?
        if let numberOfMessages = conversation.messages?.count, numberOfMessages > 0 {
            lastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).text
            dateOfLastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).date
        }
        let name = conversation.sender?.name
        let online = (conversation.isOnline)
        
        let userId = conversation.sender?.userId
        let channel = ConversationInApp(name: name, message: lastMessage, date: dateOfLastMessage, online: online, hasUnreadMessages: false, userId: userId)
        
        return channel
    }
    
    func getNumberOfSections() -> Int {
        guard let sections = conversationsController.sections else {
            return 0
        }
        
        return sections.count
    }
    func getNumberOfRows(inSection section: Int) -> Int {
        guard let sectionInfo = conversationsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    func getHeaderForSection(section: Int) -> String {
        let sectionInfo = conversationsController.sections?[section]
        if let name = sectionInfo?.name, name == "0" {
            return "History"
        } else {
            return "Online"
        }
    }
}

protocol FRCConversationsDelegate:class {
    func willChangeContent()
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?, channel: ConversationInApp?)
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType)
    func didChangeContent()
}

protocol IFRCCommunicatorConversations: class {
    var delegate: FRCConversationsDelegate? { get set }
    func initFRC()
    func performFetch()
    func getChannel(for indexPath: IndexPath) -> ConversationInApp?
    func getNumberOfSections() -> Int
    func getNumberOfRows(inSection section: Int) -> Int
    func getHeaderForSection(section: Int) -> String
}

enum ChangeType {
    case insert
    case update
    case delete
    case move
}
