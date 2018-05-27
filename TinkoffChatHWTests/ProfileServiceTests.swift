//
//  TinkoffChatHWTests.swift
//  TinkoffChatHWTests
//
//  Created by Георгий Фесенко on 27.05.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import XCTest
@testable import TinkoffChatHW

class ProfileServiceTests: XCTestCase {
    
    var profileService: IProfileService!
    var controllerUnderTest: ProfileViewController!
    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let profileManager: IProfileManager = ProfileManager(stack: stack)
        profileService = ProfileService(profileManager: profileManager)
        controllerUnderTest = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        controllerUnderTest.profileModel = ProfileModel(profileService: profileService)
        //Just to make view controller initialize its buttons
        controllerUnderTest.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    override func tearDown() {
        profileService = nil
        controllerUnderTest = nil
        super.tearDown()
    }
    
    
    func testSaving() {
        //given
        let userInApp = UserInApp(name: "Ivan", descr: "Very good person", image: UIImage(named: "placeholder-user")!)
        var name: String?
        var descr: String?
        let expectation = self.expectation(description: "Waiting for retrieve")
        profileService.saveData(user: userInApp) { (success) in
            //when
            self.profileService.retrieveData(completionHandler: { (result) in
                switch result {
                    
                case .Failure(let error):
                    print(error)
                case .Success(let user):
                    name = user.name
                    descr = user.descr
                    expectation.fulfill()
                }
                
            })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        //then
        XCTAssertEqual(name!, "Ivan")
        XCTAssertEqual(descr!, "Very good person")
    }
    
    func testSavingInProfileViewController() {
        //given
        controllerUnderTest.usernameTxtField.text = "Vasya"
        controllerUnderTest.userDescriptionTxtField.text = "Another good person"
        
        var name: String?
        var description: String?
        let expectation = self.expectation(description: "Waiting")
        
        //when
        controllerUnderTest.saveData()
        
        //then
        controllerUnderTest.profileModel.retrieveData { (result) in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let user):
                name = user.name
                description = user.descr
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(name!, "Vasya")
        XCTAssertEqual(description!, "Another good person")
        
    }
    
    func testDeleteMethodInService() {
        
        //given
        let userInApp = UserInApp(name: "Ivan", descr: "Very good person", image: UIImage(named: "placeholder-user")!)
        var name: String?
        var descr: String?
        let expectation = self.expectation(description: "Waiting for retrieve")
        profileService.saveData(user: userInApp) { (success) in
            //when
            self.profileService.deleteUserData(completionHandler: { (success) in
                if success {
                    self.profileService.retrieveData(completionHandler: { (result) in
                        switch result {
                        case .Failure(let error):
                            print(error)
                        case .Success(let user):
                            name = user.name
                            descr = user.descr
                        }
                        expectation.fulfill()
                        
                    })
                }
            })
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        //then
        XCTAssertEqual(name!, "")
        XCTAssertEqual(descr!, "")
    }
    
    func testDeleteMethodInViewController() {
        controllerUnderTest.usernameTxtField.text = "Vasya"
        controllerUnderTest.userDescriptionTxtField.text = "Another good person"
        controllerUnderTest.saveData()
        
        var name: String?
        var description: String?
        let expectation = self.expectation(description: "Waiting")
        
        //when
        controllerUnderTest.deleteData()
        controllerUnderTest.profileModel.retrieveData { (result) in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let user):
                name = user.name
                description = user.descr
                expectation.fulfill()
            }
            
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        //then
        XCTAssertEqual(controllerUnderTest.usernameTxtField.text, "")
        XCTAssertEqual(controllerUnderTest.userDescriptionTxtField.text, "")
        XCTAssertEqual(name!, "")
        XCTAssertEqual(descr!, "")
    }
    
}
