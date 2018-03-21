//
//  OutcomeCell.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class OutgoingCell: UITableViewCell {
    
    @IBOutlet weak var messageTextLbl: UILabel!
    @IBOutlet weak var bubbleImage: UIImageView!
    
    func setTextAndImage(_ text: String, image: UIImage) {
        messageTextLbl.translatesAutoresizingMaskIntoConstraints = false
        bubbleImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        messageTextLbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12.0).isActive = true
        messageTextLbl.widthAnchor.constraint(equalToConstant: bubbleWidth - 28).isActive = true
        messageTextLbl.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16).isActive = true
        messageTextLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.0).isActive = true
        
        bubbleImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6).isActive = true
        bubbleImage.widthAnchor.constraint(equalToConstant: bubbleWidth - 2).isActive = true
        bubbleImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -2).isActive = true
        bubbleImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
        
        messageTextLbl.text = text
        bubbleImage.image = image.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 21, 17, 21), resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        bubbleImage.tintColor = #colorLiteral(red: 0.05684914692, green: 0.5671757187, blue: 1, alpha: 1)
    }
}
