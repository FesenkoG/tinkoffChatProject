//
//  File.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class DataService {
    static let instance = DataService()
    
    private let data = [Channel(name: "Vasya", message: "Online and unread", date: Date.init(timeIntervalSince1970: 60*6000), online: true, hasUnreadMessages: true), Channel(name: "George", message: "Offline and unread", date: Date.init(timeIntervalSince1970: 60*12000), online: false, hasUnreadMessages: true), Channel(name: "Polinom", message: "Online and read", date: Date.init(timeIntervalSince1970: 60*6000222), online: true, hasUnreadMessages: false), Channel(name: "Ivan4", message: "online and read with time", date: Date.init(timeIntervalSinceNow: 0), online: true, hasUnreadMessages: false), Channel(name: "Ivan13", message: "online and read with time", date: Date.init(timeIntervalSinceNow: 380), online: true, hasUnreadMessages: false), Channel(name: "Igor", message: nil, date: nil, online: true, hasUnreadMessages: false), Channel(name: "Ivan2", message: "Offline and read from distinct future", date: Date.init(timeIntervalSince1970: 60*60*1200*7666), online: false, hasUnreadMessages: false), Channel(name: "Ivan3", message: "Offline and read with time", date: Date.init(timeIntervalSinceNow: 0), online: false, hasUnreadMessages: false), Channel(name: "Ivan5", message: "Offline and read with time", date: Date.init(timeIntervalSinceNow: 120), online: false, hasUnreadMessages: false), Channel(name: "Ivan98", message: "online and unread", date: Date.init(timeIntervalSinceNow: 189), online: true, hasUnreadMessages: true), Channel(name: "Ivan0", message: "Offline and unread with time", date: Date.init(timeIntervalSinceNow: 111), online: false, hasUnreadMessages: true), Channel(name: "Ivan101", message: "Offline and unread with time", date: Date.init(timeIntervalSinceNow: 1000), online: false, hasUnreadMessages: true), Channel(name: "Ivan5", message: "Offline and read with time", date: Date.init(timeIntervalSinceNow: 120), online: false, hasUnreadMessages: false), Channel(name: "Ivan5", message: "Online and read with time", date: Date.init(timeIntervalSinceNow: 289), online: true, hasUnreadMessages: false), Channel(name: "igor1", message: nil, date: nil, online: true, hasUnreadMessages: false), Channel(name: "Egor23", message: "Hello, my friend! Offline, Unread.", date: Date.init(timeIntervalSinceNow: 29), online: false, hasUnreadMessages: true), Channel(name: "Egor3", message: "offline, read", date: Date.init(timeIntervalSince1970: 27), online: false, hasUnreadMessages: false), Channel(name: "george", message: "online, read", date: Date.init(timeIntervalSinceNow: 206), online: true, hasUnreadMessages: false), Channel(name: "ray", message: nil, date: nil, online: true, hasUnreadMessages: false), Channel(name: "leo", message: "Well, I'm offline and unread", date: Date.init(timeIntervalSinceNow: 26), online: false, hasUnreadMessages: true)]
    
    private let messagesForUsers = [[Message(text: "?", isIncoming: true), Message(text: "!", isIncoming: false), Message(text: "Do you like George Orwell?", isIncoming: true), Message(text: "No, I have no idea who he is.", isIncoming: false), Message(text: "Nineteen Eighty-Four, often published as 1984, is a dystopian novel published in 1949 by English author George Orwell. The novel is set in Airstrip One, formerly Great Britain, a province of the superstate Oceania, whose residents are victims of perpetual war, omnipresent government surveillance and public manipulation.", isIncoming: true), Message(text: "As literary political fiction and dystopian science-fiction, Nineteen Eighty-Four is a classic novel in content, plot, and style. Many of its terms and concepts, such as Big Brother, doublethink, thoughtcrime, Newspeak, Room 101, telescreen, 2 + 2 = 5, and memory hole, have entered into common use since its publication in 1949.", isIncoming: false)]]
    
    func getData() -> [Channel] {
        return data
    }
    func getMessages() -> [[Message]] {
        return messagesForUsers
    }
}
