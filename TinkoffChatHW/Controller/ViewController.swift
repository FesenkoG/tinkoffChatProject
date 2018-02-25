//
//  ViewController.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.02.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var prevState = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let state = convertState(state: UIApplication.shared.applicationState)
        if state != prevState {
            print("Application moved from \(prevState) to \(state): \(#function)")
        } else {
            print("Application is still in \(state): \(#function)")
        }
        prevState = state
    }
}

