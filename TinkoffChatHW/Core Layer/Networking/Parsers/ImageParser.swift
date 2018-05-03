//
//  ImageParser.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 30.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

class ImageParser: IParser {
    typealias Model = UIImage
    
    func parse(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    
}
