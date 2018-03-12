//
//  IncomeCell.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class IncomingCell: UITableViewCell {
    
    @IBOutlet weak var messageTextLbl: UILabel!
    @IBOutlet weak var bubbleImage: UIImageView!
    
    func setTextAndImage(_ text: String, image: UIImage) {
        messageTextLbl.translatesAutoresizingMaskIntoConstraints = false
        bubbleImage.translatesAutoresizingMaskIntoConstraints = false
        
        let screenwidth = UIScreen.main.bounds.width
        
        messageTextLbl.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12.0).isActive = true
        messageTextLbl.widthAnchor.constraint(equalToConstant: 3 * screenwidth / 4 - 26).isActive = true
        messageTextLbl.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16.0).isActive = true
        messageTextLbl.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.0).isActive = true
        
        bubbleImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 6).isActive = true
        bubbleImage.widthAnchor.constraint(equalToConstant: 3 * screenwidth / 4 - 2).isActive = true
        bubbleImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 2).isActive = true
        bubbleImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -6).isActive = true
        
        messageTextLbl.text = text
        bubbleImage.image = image.resizableImage(withCapInsets: UIEdgeInsetsMake(17, 21, 17, 21), resizingMode: .stretch).withRenderingMode(.alwaysOriginal)
        
    }
    
    
    
}
