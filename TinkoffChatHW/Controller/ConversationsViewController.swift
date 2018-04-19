//
//  ChannelsVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit
import CoreData

class ConversationsViewController: UITableViewController {
    
    
    let communicator = MultipeerCommunicator()
    let storageManager = StorageManager()
    var conversationsController: NSFetchedResultsController<Conversation>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communicator.delegate = self
        conversationsController = storageManager.createFRCForConversations()
        conversationsController.delegate = self

        
        do {
            try conversationsController.performFetch()
        } catch {
            print(error)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: Notification.Name(rawValue: didEnterBackgroundNotif), object: nil)
        
        
    }
    
    @objc func didEnterBackground(_ notif: Notification) {
        storageManager.setAllConversationsOffline()
        communicator.sessions.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func themesBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "toThemes", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = conversationsController.sections else {
            return 0
        }
        
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = conversationsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as? ConversationCell else { return UITableViewCell() }
        let conversation = conversationsController.object(at: indexPath)
        var dateOfLastMessage: Date?
        var lastMessage: String?
        if let numberOfMessages = conversation.messages?.count, numberOfMessages > 0 {
            lastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).text
            dateOfLastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).date
        }
        let name = conversation.sender?.name
        let online = (conversation.isOnline)
        let channel = ConversationInApp(name: name, message: lastMessage, date: dateOfLastMessage, online: online, hasUnreadMessages: false, userId: nil)
        cell.configureCell(channel: channel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = conversationsController.sections?[section]
        if let name = sectionInfo?.name, name == "0" {
            return "History"
        } else {
            return "Online"
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = conversationsController.object(at: indexPath).sender?.name else { return }
        guard let userId = conversationsController.object(at: indexPath).sender?.userId else {
            return
        }
        let channel = ConversationInApp(name: name, message: nil, date: nil, online: false, hasUnreadMessages: false, userId: userId)
        performSegue(withIdentifier: "ToChat", sender: channel)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let conversation = conversationsController.object(at: indexPath)
            if let id = conversation.sender?.userId {
                communicator.sessions.removeValue(forKey: id)
                if let messages = conversation.messages {
                    conversation.removeFromMessages(messages)
                }
                storageManager.userBecameInactive(userId: id)
            }
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let convVC = segue.destination as? ConversationViewController {
            convVC.initView(channel: sender as! ConversationInApp)
            convVC.manager = communicator
            convVC.storageManager = storageManager
        } else if let themesVC = segue.destination as? ThemesViewController {
            themesVC.delegate = self
        } else if let themesVC = segue.destination as? ThemesViewControllerSwift {
            themesVC.closure = { themeChanged }()
        } else if let profileVC = segue.destination as? ProfileViewController {
            profileVC.storageManager = storageManager
        }
    }
    func logThemeChanging(selectedTheme: UIColor) {
        print(selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        UserDefaults.standard.setColor(color: selectedTheme, forKey: "Theme")
    }
    
    func themeChanged(selectedTheme: ThemesSwift.Theme) -> Void {
        print(selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme.barColor
        UINavigationBar.appearance().tintColor = selectedTheme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: selectedTheme.tintColor]
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.setColor(color: selectedTheme.barColor, forKey: "Theme")
            UserDefaults.standard.setColor(color: selectedTheme.tintColor, forKey: "ThemeTint")
        }
    }
    
}
extension ConversationsViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

extension ConversationsViewController: CommunicatorDelegate {
    func didFoundUser(userID: String, userName: String?) {
        
        storageManager.insertOrUpdateConversationWithUser(userId: userID, userName: userName!) { (success) in
            if success {
                print("good")
            }
        }
    }
    
    func didLostUser(userID: String) {
        communicator.sessions.removeValue(forKey: userID)
        storageManager.userBecameInactive(userId: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        
        storageManager.saveNewMessageInConversation(conversationId: generateConversationId(fromUserId: fromUser), text: text, isIncoming: true) { (success) in
            if success {
                print("Good")
            }
        }
    }
    
    
}

extension ConversationsViewController: NSFetchedResultsControllerDelegate {
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
                guard let cell = self.tableView.cellForRow(at: indexPath!) as? ConversationCell else { return }
                let conversation = self.conversationsController.object(at: indexPath!)
                var dateOfLastMessage: Date?
                var lastMessage: String?
                if let numberOfMessages = conversation.messages?.count, numberOfMessages > 0 {
                    lastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).text
                    dateOfLastMessage = (conversation.messages?[numberOfMessages - 1] as! Message).date
                }
                let name = conversation.sender?.name
                let online = conversation.isOnline
                let channel = ConversationInApp(name: name, message: lastMessage, date: dateOfLastMessage, online: online, hasUnreadMessages: false, userId: nil)
                cell.configureCell(channel: channel)
                
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
        }
    }
    
    
}
