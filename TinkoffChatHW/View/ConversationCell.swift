//
//  ChannelCell.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lastMessageLbl: UILabel!
    @IBOutlet weak var dateOfLastMessageLbl: UILabel!
    
    
    
    func configureCell(channel: Channel) {
        nameLbl.text = channel.name
        dateOfLastMessageLbl.isHidden = false
        
        lastMessageLbl.adjustsFontForContentSizeCategory = false
        lastMessageLbl.font = UIFont.systemFont(ofSize: 17)
        if let lastMessage = channel.message {
            lastMessageLbl.text = lastMessage
            
            if channel.hasUnreadMessages {
                lastMessageLbl.adjustsFontForContentSizeCategory = false
                lastMessageLbl.font = UIFont.boldSystemFont(ofSize: 17)
            }
            
            if let date = channel.date {
                let currentDate = Date()
                let calendar = Calendar.current
                
                let currentYear = calendar.component(.year, from: currentDate)
                let currentMonth = calendar.component(.month, from: currentDate)
                let currentDay = calendar.component(.day, from: currentDate)
                
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM HH:mm"
                
                let stringGivenDate = dateFormatter.string(from: date)
                let datee = stringGivenDate[..<stringGivenDate.index(stringGivenDate.startIndex, offsetBy: 6)]
                let time = stringGivenDate[stringGivenDate.index(stringGivenDate.endIndex, offsetBy: -5)...]
                
                if year == currentYear, month == currentMonth, day == currentDay {
                    dateOfLastMessageLbl.text = "\(time)"
                } else {
                    dateOfLastMessageLbl.text = "\(datee)"
                }
            }
        } else {
            lastMessageLbl.adjustsFontForContentSizeCategory = false
            lastMessageLbl.font = UIFont.italicSystemFont(ofSize: 17)
            lastMessageLbl.text = "No messages yet."
            dateOfLastMessageLbl.isHidden = true
            
        }
        
        if channel.online {
            self.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        } else {
            self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
    }
}
