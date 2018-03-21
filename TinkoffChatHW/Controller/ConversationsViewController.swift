//
//  ChannelsVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationsViewController: UITableViewController {
    
    var sortedData = [Int: [Channel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Получаем данные из источника и делим их по секциям: 0 - online, 1 - history.
        sortedData[0] = DataService.instance.getData().filter({$0.online == true})
        sortedData[1] = DataService.instance.getData().filter({$0.online == false && $0.message != nil})
        //Сортируем диалоги в хронологическим порядке по дате последнего сообщения.
        sortedData[0]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
        sortedData[1]?.sort(by: { (first, second) -> Bool in
            if first.date == nil {
                return false
            }
            if let date1 = first.date, let date2 = second.date {
                return date1 > date2
            }
            return true
        })
    }
    
    @IBAction func themesBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "toThemes", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = sortedData[section] {
            return data.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as? ConversationCell else { return UITableViewCell() }
        guard let channel = sortedData[indexPath.section]?[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(channel: channel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = sortedData[indexPath.section]?[indexPath.row] else { return }
        performSegue(withIdentifier: "ToChat", sender: channel)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let convVC = segue.destination as? ConversationViewController {
            convVC.initView(channel: sender as! Channel)
        } else if let themesVC = segue.destination as? ThemesViewController {
            themesVC.delegate = self
        } else if let themesVC = segue.destination as? ThemesViewControllerSwift {
            themesVC.closure = { themeChanged }()
        }
    }
    func logThemeChanging(selectedTheme: UIColor) {
        print(selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme
        UserDefaults.standard.setColor(color: selectedTheme, forKey: "Theme")
    }
    
    func themeChanged(selectedTheme: ThemesSwift.Theme) -> Void {
        print(selectedTheme)
        UINavigationBar.appearance().barTintColor = selectedTheme.barColor
        UINavigationBar.appearance().tintColor = selectedTheme.tintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: selectedTheme.tintColor]
        
        UserDefaults.standard.setColor(color: selectedTheme.barColor, forKey: "Theme")
        UserDefaults.standard.setColor(color: selectedTheme.tintColor, forKey: "ThemeTint")
    }
    
}
extension ConversationsViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController!, didSelectTheme selectedTheme: UIColor!) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

extension UserDefaults {
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
        }
        set(colorData, forKey: key)
    }
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
}
