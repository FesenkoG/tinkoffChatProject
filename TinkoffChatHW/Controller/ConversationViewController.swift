//
//  ConversationVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [[Message]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        messages = DataService.instance.getMessages()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        
    }
    
    func initView(channel: Channel) {
        navigationItem.title = channel.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[0][indexPath.row].isIncoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.setTextAndImage(messages[0][indexPath.row].text!, image: UIImage(named: "incoming-message-bubble")!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.setTextAndImage(messages[0][indexPath.row].text!, image: UIImage(named: "outgoing-message-bubble")!)
            return cell
        }
    }
    
    
    
    

}
