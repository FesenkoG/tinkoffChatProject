//
//  ICommunicator.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol ICommunicator: class {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
    func removeAllSessions()
}
