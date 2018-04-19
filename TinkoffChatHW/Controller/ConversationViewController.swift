//
//  ConversationVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    weak var manager: MultipeerCommunicator?
    var storageManager: StorageManager!
    var userId = ""
    var messagesController: NSFetchedResultsController<Message>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        
        sendBtn.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(blockSend(_:)), name: NSNotification.Name.init(didLostUserNotif), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(unblockSend), name: NSNotification.Name.init(didFoundUserNotif), object: nil)
        messagesController = storageManager.createFRCForMessages(withConvID: generateConversationId(fromUserId: userId))
        messagesController.delegate = self

        do {
            try messagesController.performFetch()
            
        } catch {
            print(error)
        }
        
    }
    
    @objc func blockSend(_ notif: Notification) {
        if let userID = notif.object as? String {
            if userID == userId {
                sendBtn.isEnabled = false
            }
        }
    }
    
    @objc func unblockSend(_ notif: Notification) {
        if let userID = notif.object as? String {
            if userID == userId {
                sendBtn.isEnabled = true
            }
        }
    }
    
    @objc func handleKeyboadNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if let number = self.messagesController.fetchedObjects?.count, number > 0 {
                    let indexPath = IndexPath(row: number - 1 , section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        if let text = inputTextField.text, text != "" {
            manager?.sendMessage(string: text, to: userId, completionHandler: { (success, error) in
                if success {
                    self.storageManager.saveNewMessageInConversation(conversationId: generateConversationId(fromUserId: self.userId), text: text, isIncoming: false, completionHandler: { (success) in
                        if success {
                            print("Good")
                        }
                    })
                    
                }
            })
        }
        inputTextField.text = ""
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    func initView(channel: ConversationInApp) {
        navigationItem.title = channel.name
        self.userId = channel.userId!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let msg = messagesController.fetchedObjects else { return 0}
        return msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesController.object(at: indexPath)
        if message.isIncoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.setTextAndImage(message.text!, image: UIImage(named: "incoming-message-bubble")!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.setTextAndImage(message.text!, image: UIImage(named: "outgoing-message-bubble")!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let message = messagesController.object(at: indexPath)
            storageManager.deleteObject(object: message)
        }
    }

}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch type {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                let message = self.messagesController.object(at: indexPath!)
                if message.isIncoming {
                    guard let cell = self.tableView.cellForRow(at: indexPath!) as? IncomingCell else { return }
                    cell.setTextAndImage(message.text!, image: UIImage(named: "incoming-message-bubble")!)
                } else {
                    guard let cell = self.tableView.cellForRow(at: indexPath!) as? OutgoingCell else { return  }
                    cell.setTextAndImage(message.text!, image: UIImage(named: "outgoing-message-bubble")!)
                }
                
            case .move:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            }
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async {
            let indexSet = IndexSet(integer: sectionIndex)
            switch type {
            case .insert:
                self.tableView.insertSections(indexSet, with: .automatic)
            case .delete:
                self.tableView.deleteSections(indexSet, with: .automatic)
            default: break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
            if let number = self.messagesController.fetchedObjects?.count, number > 0 {
                let indexPath = IndexPath(row: number - 1 , section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}
