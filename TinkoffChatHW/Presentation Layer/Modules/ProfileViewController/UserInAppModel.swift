//
//  User.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 10.04.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//
//
import Foundation
protocol IProfileModel {
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?)
    func retrieveData(completionHandler: @escaping (Result<UserInApp>) -> Void)
    func deleteUserData(completionHandler: @escaping (Bool) -> Void)
}

struct UserInApp {
    var name: String
    var descr: String
    var image: UIImage
}

class ProfileModel: IProfileModel {
    let profileService: IProfileService
    init(profileService: IProfileService) {
        self.profileService = profileService
    }
    
    func saveData(user: UserInApp, completionHandler: ((Bool) -> Void)?) {
        profileService.saveData(user: user, completionHandler: completionHandler)
    }
    
    func retrieveData(completionHandler: @escaping (Result<UserInApp>) -> Void) {
        profileService.retrieveData(completionHandler: completionHandler)
    }
    
    func deleteUserData(completionHandler: @escaping (Bool) -> Void) {
        profileService.deleteUserData(completionHandler: completionHandler)
    }
    
    
}
