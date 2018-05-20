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
    

    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
    
    weak var communicatorModel: ICommunicatorModel?
    var conversationsModel: IConversationsModel!
    var rootAssembly: RootAssembly!
    var messagesControllerModel: IFRCMessagesModel!
    
    var userId = ""
    private var channel: ConversationInApp?
    var isTextFieldEmpty = true
    var isUserOnline = true {
        willSet(value) {
            if value == true {
                UIView.animate(withDuration: 1.0, animations: {
                    self.label.textColor = UIColor.green
                    self.label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                })
                
            } else {
                UIView.animate(withDuration: 1.0) {
                   self.label.textColor = UIColor.black
                    self.label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    
                }
                
            }
        }
    }
    
    var isSendBlocked = false {
        willSet(value) {
            if value == true {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.sendBtn.setTitleColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), for: .normal)
                    self.sendBtn.isEnabled = false
                    self.sendBtn.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                    
                }) { _ in
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.sendBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                }
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.sendBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                    self.sendBtn.isEnabled = true
                    self.sendBtn.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }) { _ in
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.sendBtn.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSendBlocked = true
        setupLabel()
        setupObservers()
        setupTableView()
        modelSetup()
        inputTextField.delegate = self
        sendBtn.isEnabled = true
        
        self.view.createTinkoffLogoAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let isOnline = channel?.online {
            if isOnline {
                isUserOnline = true
            }
        }
    }
    
    func setupLabel() {
        
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.textColor = UIColor.black
        self.navigationItem.titleView = label
        //label.sizeToFit()
        if let isOnline = channel?.online {
            label.textColor = isOnline ? .green : .black
        }
        
    }
    
    func initView(channel: ConversationInApp) {
        label.text = channel.name
        self.userId = channel.userId!
        self.channel = channel
        
    }
    
    @objc func blockSend(_ notif: Notification) {
        if let userID = notif.object as? String {
            if userID == userId {
                isUserOnline = false
                isSendBlocked = true
            }
        }
    }
    
    @objc func unblockSend(_ notif: Notification) {
        if let userID = notif.object as? String {
            if userID == userId {
                isUserOnline = true
                if !isTextFieldEmpty {
                    isSendBlocked = false
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
                    self.conversationsModel.saveNewMessageInConversation(conversationId: generateConversationId(fromUserId: self.userId), text: text, isIncoming: false, completionHandler: { (success) in
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

extension ConversationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" && range.location == 0 {
            isTextFieldEmpty = true
        }
        
        if isUserOnline {
            if string == "" && range.location == 0 {
                isSendBlocked = true
                isTextFieldEmpty = true
            } else {
                isTextFieldEmpty = false
                if isSendBlocked {
                    isSendBlocked = false
                }
            }
        }
//        if let text = textField.text {
//            if text == ""{
//                NotificationCenter.default.post(name: NSNotification.Name.init(didLostUserNotif), object: userId)
//            } else {
//                NotificationCenter.default.post(name: NSNotification.Name.init(didFoundUserNotif), object: userId)
//            }
//        } else {
//            NotificationCenter.default.post(name: NSNotification.Name.init(didLostUserNotif), object: userId)
//        }
        return true
    }
}
