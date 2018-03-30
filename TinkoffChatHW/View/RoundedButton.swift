//
//  EditButton.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.black.cgColor
    }
}
