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
    
    override func prepareForReuse() {
        nameLbl.text = ""
        lastMessageLbl.text = ""
        dateOfLastMessageLbl.text = ""
        dateOfLastMessageLbl.isHidden = false
        lastMessageLbl.adjustsFontForContentSizeCategory = false
        lastMessageLbl.font = UIFont.systemFont(ofSize: 17)
    }
    
    func configureCell(channel: ConversationInApp) {
        nameLbl.text = channel.name
        
        if let lastMessage = channel.message {
            lastMessageLbl.text = lastMessage
            
            if channel.hasUnreadMessages {
                lastMessageLbl.adjustsFontForContentSizeCategory = false
                lastMessageLbl.font = UIFont.boldSystemFont(ofSize: 17)
            }
            
            if let date = channel.date {
                dateOfLastMessageLbl.isHidden = false
                let currentDate = Date()
                let calendar = Calendar.current
                
                let currentYear = calendar.component(.year, from: currentDate)
                let currentMonth = calendar.component(.month, from: currentDate)
                let currentDay = calendar.component(.day, from: currentDate)
                
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                
                
                let getDate = DateFormatter()
                let getTime = DateFormatter()
                getDate.dateFormat = "dd MMM"
                getTime.dateFormat = "HH:mm"
                let datee = getDate.string(from: date)
                let time = getTime.string(from: date)
                
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
