//
//  SecondView.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 25.02.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class SecondView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
