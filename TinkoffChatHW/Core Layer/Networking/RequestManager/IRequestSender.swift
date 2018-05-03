//
//  IRequestSender.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 29.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation


protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
