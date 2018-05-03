//
//  IParser.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 29.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}


