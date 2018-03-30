//
//  Protocols.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 26.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol DataManipulationProtocol {
    func saveData(name: String, descr: String, imageData: Data, handler: @escaping (Bool) -> Void)
    func retrieveData(handler: @escaping (Bool, [String: Any]?) -> Void)
}
