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
    
    weak var communicatorModel: ICommunicatorModel?
    var storageManager: IStorageModel!
    var rootAssembly: RootAssembly!
    var messagesControllerModel: IFRCMessagesModel!
    
    var userId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        setupTableView()
        modelSetup()
        sendBtn.isEnabled = true
    }
    
    func initView(channel: ConversationInApp) {
        navigationItem.title = channel.name
        self.userId = channel.userId!
        
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
    
    @objc func handleKeyboadNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                let number = self.messagesControllerModel.numberOfMessages()
                if number > 0 {
                    let indexPath = IndexPath(row: number - 1 , section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        if let text = inputTextField.text, text != "" {
            communicatorModel?.sendMessage(string: text, to: userId, completionHandler: { (success, error) in
                if success {
                    self.storageManager.saveNewMessageInConversation(conversationId: generateConversationId(fromUserId: self.userId), text: text, isIncoming: false, completionHandler: { (success) in
                        if success {
                            print("Good")
                        }
                    })
                    
                }
            })
        }
        inputTextField.text = ""
        
    }
    //MARK: - TableViewDelegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesControllerModel.numberOfMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messagesControllerModel.getMessage(by: indexPath)
        if message.isIncoming {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingCell") as? IncomingCell else { return UITableViewCell() }
            cell.setTextAndImage(message.text!, image: UIImage(named: "incoming-message-bubble")!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutcomingCell") as? OutgoingCell else { return UITableViewCell() }
            cell.setTextAndImage(message.text!, image: UIImage(named: "outgoing-message-bubble")!)
            return cell
        }
    }
    
    //MARK: - InitialSetups
    func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboadNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockSend(_:)), name: NSNotification.Name.init(didLostUserNotif), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unblockSend), name: NSNotification.Name.init(didFoundUserNotif), object: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 40
    }
    
    func modelSetup() {
        messagesControllerModel = rootAssembly.presentationAssembly.getFRCMessagesModel()
        
        messagesControllerModel.initFRC(convId: generateConversationId(fromUserId: userId))
        messagesControllerModel.performFetch()
        messagesControllerModel.delegate = self
    }

}

//MARK: - FRCModelDelegate

extension ConversationViewController: FRCMessagesModelDelegate {
    func willChangeContent() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }
    
    func changingContent(indexPath: IndexPath?, typeOfChanging: ChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            switch typeOfChanging {
            case .insert:
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                let message = self.messagesControllerModel.getMessage(by: indexPath!)
                if message.isIncoming {
                    guard let cell = self.tableView.cellForRow(at: indexPath!) as? IncomingCell else { return }
                    cell.setTextAndImage(message.text!, image: UIImage(named: "incoming-message-bubble")!)
                } else {
                    guard let cell = self.tableView.cellForRow(at: indexPath!) as? OutgoingCell else { return  }
                    cell.setTextAndImage(message.text!, image: UIImage(named: "outgoing-message-bubble")!)
                }
                
            case .move:
                self.tableView.deleteRows(at: [indexPath!], with: .automatic)
                self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
            }
        }
    }
    
    func changingContentInSection(indexSet: IndexSet, typeOfChanging: ChangeType) {
        DispatchQueue.main.async {
            switch typeOfChanging {
            case .insert:
                self.tableView.insertSections(indexSet, with: .automatic)
            case .delete:
                self.tableView.deleteSections(indexSet, with: .automatic)
            default: break
            }
        }
    }
    
    func didChangeContent() {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
            let number = self.messagesControllerModel.numberOfMessages()
            if number > 0 {
                let indexPath = IndexPath(row: number - 1 , section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    
}
