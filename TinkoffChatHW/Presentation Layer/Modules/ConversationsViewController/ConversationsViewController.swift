//
//  ChannelsVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController {
    
    let rootAssembly = RootAssembly()
    
    lazy var conversationsModel = self.rootAssembly.presentationAssembly.getConversationsModel()
    lazy var communicatorModel = rootAssembly.presentationAssembly.getCommunicatorModel()
    lazy var conversationsControllerModel = rootAssembly.presentationAssembly.getFRCConversationsModel()
    
    var timer: Timer?
    var location: CGPoint?
    var imgSize: CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupModels()
        self.view.createTinkoffLogoAnimation()
        
    }
    
    @objc func didEnterBackground(_ notif: Notification) {
        conversationsModel.setAllConversationsOffline()
        communicatorModel.removeAllSessions()
        //tableView.reloadData()
    }
    
    
    //MARK: - TableViewDelegates
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return conversationsControllerModel.getNumberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsControllerModel.getNumberOfRows(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as? ConversationCell else { return UITableViewCell() }
        if let channel = conversationsControllerModel.getChannel(for: indexPath) {
            cell.configureCell(channel: channel)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return conversationsControllerModel.getHeaderForSection(section: section)
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = conversationsControllerModel.getChannel(for: indexPath) else { return }
        performSegue(withIdentifier: "ToChat", sender: channel)
    }
    
    //MARK: - Themes Seque
    @IBAction func themesBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "toThemes", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let convVC = segue.destination as? ConversationViewController {
            convVC.initView(channel: sender as! ConversationInApp)
            convVC.communicatorModel = communicatorModel
            convVC.rootAssembly = rootAssembly
            convVC.conversationsModel = conversationsModel
        } else if let themesVC = segue.destination as? ThemesViewController {
            themesVC.delegate = self
        } else if let themesVC = segue.destination as? ThemesViewControllerSwift {
            themesVC.closure = { themeChanged }()
        } else if let profileVC = segue.destination as? ProfileViewController {
            profileVC.profileModel = rootAssembly.presentationAssembly.getProfileModel()
            profileVC.rootAssembly = rootAssembly
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
    
    //MARK: - Initial Setups
    func setupModels() {
        communicatorModel.delegate = self
        
        conversationsControllerModel.initFRC()
        conversationsControllerModel.performFetch()
        conversationsControllerModel.delegate = self
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: Notification.Name(rawValue: didEnterBackgroundNotif), object: nil)
    }
    
}

//MARK: - ThemesDelegate
extension ConversationsViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}
// MARK: - CommunicatorModelDelegate
extension ConversationsViewController: CommunicatorModelDelegate {
    func didFoundUser(userID: String, userName: String?) {
        NotificationCenter.default.post(name: .init(didFoundUserNotif), object: userID)
        conversationsModel.insertOrUpdateConversationWithUser(userId: userID, userName: userName!) { (success) in
            if success {
                print("good")
            }
        }
    }
    
    func didLostUser(userID: String) {
        conversationsModel.userBecameInactive(userId: userID)
        NotificationCenter.default.post(name: NSNotification.Name.init(didLostUserNotif), object: userID)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        
        conversationsModel.saveNewMessageInConversation(conversationId: generateConversationId(fromUserId: fromUser), text: text, isIncoming: true) { (success) in
            if success {
                print("Good")
            }
        }
        
    }
    
    
}

//MARK: - FRCModelDelegate
extension ConversationsViewController: FRCConversationsModelDelegate {
    
    func willChangeContent() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }
    
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?, channel: ConversationInApp?) {
        DispatchQueue.main.async {
            switch typeOfChanging {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                guard let cell = self.tableView.cellForRow(at: indexPath!) as? ConversationCell else { return }
                if let channel = channel {
                    cell.configureCell(channel: channel)
                }
            case .move:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            }
        }
    }
    
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType) {
        DispatchQueue.main.async {
            switch typeOfChanging {
            case .insert:
                self.tableView.insertSections(indexSet, with: .automatic)
            case .delete:
                self.tableView.deleteSections(indexSet, with: .automatic)
            default: break
            }
        }
    }
    
    func didChangeContent() {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
        }
    }
    
    
}
