//
//  AppDelegate.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.02.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var prevState = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let color = UserDefaults.standard.colorForKey(key: "Theme") {
            UINavigationBar.appearance().barTintColor = color
        }
        if let tintColor = UserDefaults.standard.colorForKey(key: "ThemeTint") {
            UINavigationBar.appearance().tintColor = tintColor
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: tintColor]
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
}


