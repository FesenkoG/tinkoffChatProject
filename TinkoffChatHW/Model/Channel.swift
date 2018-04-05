//
//  Channel.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

struct Channel: ConversationCellConfiguration {
    
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    var userId: String
}

protocol ConversationCellConfiguration {
    
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
