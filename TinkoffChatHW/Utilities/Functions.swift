//
//  Functions.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.02.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

func convertState(state: UIApplicationState) -> String {
    switch state {
    case .active:
        return "active"
    case .inactive:
        return "inactive"
    case .background:
        return "background"
    }
}
