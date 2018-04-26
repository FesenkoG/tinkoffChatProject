//
//  ThemesViewControllerSwift.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 19.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ThemesViewControllerSwift: UIViewController {
    
    var closure: GetTheme?
    var themes = ThemesSwift(theme1: ThemesSwift.Theme.init(barColor: #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1), tintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), theme2: ThemesSwift.Theme.init(barColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), tintColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)), theme3: ThemesSwift.Theme.init(barColor: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = UserDefaults.standard.colorForKey(key: "Theme") {
            view.backgroundColor = color
        }
    }
    
    @IBAction func changeThemeBtnWasPressed(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            switch title {
            case "Theme 1":
                let theme = themes.theme1
                view.backgroundColor = theme.barColor
                closure?(theme)
            case "Theme 2":
                let theme = themes.theme2
                view.backgroundColor = theme.barColor
                closure?(theme)
            case "Theme 3":
                let theme = themes.theme3
                view.backgroundColor = theme.barColor
                closure?(theme)
            default:
                print("Exception")
            }
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
