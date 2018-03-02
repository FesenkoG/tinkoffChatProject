//
//  TopAllignmentLabel.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 02.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit
@IBDesignable
class TopAllignmentLabel: UILabel {

    override func draw(_ rect: CGRect) {
        guard text != nil else {
            return super.drawText(in: rect)
        }
        
        let height = self.sizeThatFits(rect.size).height
        super.drawText(in: CGRect(x: 0, y: 0, width: rect.width, height: height))
    }

}
