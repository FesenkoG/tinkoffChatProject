//
//  ConversationVC.swift
//  TinkoffChatHW
//
//  Created by Георгий Фесенко on 11.03.2018.
//  Copyright © 2018 Georgy. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var messages = [Message]()
    weak var manager: MultipeerCommunicator?
    var userId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
        
        sendBtn.isEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageHaveArrived(notification:)), name: .init(rawValue: messageHaveArrivedNotif), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(blockSend(_:)), name: NSNotification.Name.init(didLostUserNotif), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unblockSend), name: NSNotification.Name.init(didFoundUserNotif), object: nil)
        
    }
    
    @objc func blockSend(_ notif: Notification) {
        if let userID = notif.object as? String {
            if userID == userId {
                sendBtn.isEnabled = false
            }
        }
    }
    
    @objc func unblockSend(_ notif: Notification) {
        if let userID = notif.object as? String {
            if userID == userId {
                sendBtn.isEnabled = true
            }
        }
    }
    
    @objc func messageHaveArrived(notification: NSNotification) {
        if let data = notification.object as? [String: String] {
            if let fromUser = data["fromUser"], fromUser == userId, let toUser = data["toUser"], toUser == self.manager?.myPeerId.displayName {
                self.messages.append(Message(text: data["text"], isIncoming: true))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    
    }
    
    @objc func handleKeyboadNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if self.messages.count > 0 {
                    let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        if let text = inputTextField.text, text != "" {
            manager?.sendMessage(string: text, to: userId, completionHandler: { (success, error) in
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name.init(didSendMessageNotif), object: text)
                    self.messages.append(Message(text: text, isIncoming: false))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1 , section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
        }
        inputTextField.text = ""
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    func initView(channel: Channel) {
        navigationItem.title = channel.name
        self.userId = channel.userId
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].isIncoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.setTextAndImage(messages[indexPath.row].text!, image: UIImage(named: "incoming-message-bubble")!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.setTextAndImage(messages[indexPath.row].text!, image: UIImage(named: "outgoing-message-bubble")!)
            return cell
        }
    }

}
