//
//  ChannelsVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController {
    
    
    let communicator = MultipeerCommunicator()
    var data = [Conversation]()
    var sortedData = [Int: [Conversation]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        communicator.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: Notification.Name(rawValue: didEnterBackgroundNotif), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLastMessage), name: NSNotification.Name.init(didSendMessageNotif), object: nil)
        
    }
    
    @objc func didEnterBackground(_ notif: Notification) {
        data.removeAll()
        sortedData.removeAll()
        communicator.sessions.removeAll()
        tableView.reloadData()
    }
    
    @objc func changeLastMessage(_ notif: Notification) {
        guard let text = notif.object as? String else { return }
        for index in 0..<data.count {
            data[index].message = text
            data[index].date = Date()
        }
        sortData()
        self.tableView.reloadData()
    }
    @IBAction func themesBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "toThemes", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = sortedData[section] {
            return data.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as? ConversationCell else { return UITableViewCell() }
        guard let channel = sortedData[indexPath.section]?[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(channel: channel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = sortedData[indexPath.section]?[indexPath.row] else { return }
        performSegue(withIdentifier: "ToChat", sender: channel)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let convVC = segue.destination as? ConversationViewController {
            convVC.initView(channel: sender as! Conversation)
            convVC.manager = communicator
        } else if let themesVC = segue.destination as? ThemesViewController {
            themesVC.delegate = self
        } else if let themesVC = segue.destination as? ThemesViewControllerSwift {
            themesVC.closure = { themeChanged }()
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
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: didFoundUserNotif), object: userID)
        let channel = Conversation(name: userName, message: nil, date: nil, online: true, hasUnreadMessages: false, userId: userID)
        data.append(channel)
        sortData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didLostUser(userID: String) {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: didLostUserNotif), object: userID)
        communicator.sessions.removeValue(forKey: userID)
        var i = -1
        for index in 0..<data.count {
            if data[index].userId == userID {
                i = index
            }
        }
        if i != -1 {
            data.remove(at: i)
        }
        
        sortData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        let dataToSend = ["text": text, "fromUser": fromUser, "toUser": toUser]
        NotificationCenter.default.post(name: .init(rawValue: messageHaveArrivedNotif), object: dataToSend)
        
        for index in 0..<data.count {
            if data[index].userId == fromUser {
                data[index].message = text
                data[index].date = Date()
            }
        }
        sortData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        
    }
    
    func sortData() {
        
        sortedData[0] = data.filter({$0.online == true && $0.date != nil})
        sortedData[1] = data.filter({$0.online == false && $0.message != nil})
        //Сортируем диалоги в хронологическим порядке по дате последнего сообщения.
        var dataWithoutTime = data.filter({$0.online == true && $0.date == nil})
        sortedData[0]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
        sortedData[1]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
        //Сортируем те диалоги, у которых нет сообщений
        dataWithoutTime.sort { (first, second) -> Bool in
            guard let leftName = first.name, let rightName = second.name else { return false}
            if leftName > rightName {
                return true
            }
            return false
        }
        //Добавляем их в конец
        sortedData[0]?.append(contentsOf: dataWithoutTime)
    }
    
}
