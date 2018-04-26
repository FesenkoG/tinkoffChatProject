//
//  FRCCommunicatorConversation.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation
import CoreData

class FRCCommunicatorMessages: NSObject, NSFetchedResultsControllerDelegate, IFRCCommunicatorMessages {
    
    private let coreDataStack: CoreDataStack
    
    private var messagesController: NSFetchedResultsController<Message>!
    weak var delegate: FRCMessagesDelegate?
    
    
    init(stack: CoreDataStack) {
        coreDataStack = stack
    }
    
    func initFRC(convId: String) {
        messagesController = createFRCForMessages(withConvID: convId)
        messagesController.delegate = self
    }
    func createFRCForMessages(withConvID convID: String) -> NSFetchedResultsController<Message>? {

        if let request = coreDataStack.managedObjectModel.fetchRequestFromTemplate(withName: "MessagesFromConvID", substitutionVariables: ["convId": convID]) as? NSFetchRequest<Message> {
            let sortDescriptor = NSSortDescriptor(key: #keyPath(Message.date), ascending: true)
            request.sortDescriptors = [sortDescriptor]
            let frc =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDataStack.saveContext, sectionNameKeyPath: nil, cacheName: nil)

            return frc
        }

        return nil
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChangeContent()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        var newType: ChangeType = .insert
        
        switch type {
        case .insert:
            newType = .insert
        case .delete:
            newType = .delete
        case .move:
            newType = .move
        case .update:
            newType = .update
        }
        delegate?.changingContent(indexPath: indexPath, typeOfChanging: newType, newIndexPath: newIndexPath)
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
    
    func performFetch() {
        do {
            try messagesController.performFetch()
        } catch {
            print(error)
        }
    }
    func numberOfMessages() -> Int {
        guard let msg = messagesController.fetchedObjects else { return 0 }
        return msg.count
    }
    func getMessage(by indexPath: IndexPath) -> MessageInApp {
        let message = messagesController.object(at: indexPath)
        let returnValue = MessageInApp(text: message.text, isIncoming: message.isIncoming)
        return returnValue
    }
    
    
}

protocol FRCMessagesDelegate: class {
    func willChangeContent()
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?)
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType)
    func didChangeContent()
}

protocol IFRCCommunicatorMessages: class {
    var delegate: FRCMessagesDelegate? { get set }
    func initFRC(convId: String)
    func performFetch()
    func numberOfMessages() -> Int
    func getMessage(by indexPath: IndexPath) -> MessageInApp
}
