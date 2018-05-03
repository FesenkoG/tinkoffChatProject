//
//  ProfileService.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 01.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import Foundation

protocol IProfileService {
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?)
    func retrieveData(completionHandler: @escaping (Result<UserInApp>) -> Void)
}

class ProfileService: IProfileService {
    let profileManager: IProfileManager
    
    init(profileManager: IProfileManager) {
        self.profileManager = profileManager
    }
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?) {
        profileManager.saveData(user: user, completionHandler: completionHandler)
    }
    
    func retrieveData(completionHandler: @escaping (Result<UserInApp>) -> Void) {
        profileManager.retrieveData(completionHandler: completionHandler)
    }
}
