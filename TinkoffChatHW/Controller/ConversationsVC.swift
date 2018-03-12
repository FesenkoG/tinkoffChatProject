//
//  ChannelsVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationsVC: UITableViewController {
    
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
        if let convVC = segue.destination as? ConversationVC {
            convVC.initView(channel: sender as! Channel)
        }
    }
    
}
