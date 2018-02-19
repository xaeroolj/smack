//
//  ChatVC.swift
//  Smack
//
//  Created by Roman Trekhlebov on 29.11.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    
    
    //Outlets
    @IBOutlet weak var tabbleView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    @IBOutlet weak var messageTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        tabbleView.delegate = self
        tabbleView.dataSource = self
        tabbleView.estimatedRowHeight = 80
        tabbleView.rowHeight = UITableViewAutomaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        NotificationCenter.default
            .addObserver(self, selector: #selector(ChatVC.userDataDidChanged(_:)), name: NOTIF_USER_DID_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedin {
            AuthService.instance.findUserByEmail(completion: { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGED, object: nil)
            })
        }
    }
    
    @objc func userDataDidChanged(_ notif: Notification) {
        if AuthService.instance.isLoggedin {
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }

    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func sendMsgPressed(_ sender: Any) {
        if AuthService.instance.isLoggedin {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTextBox.text else {return}
            SocketService.instance.addMessage(messageBody: message, userId: UserDataServices.instance.id, channelId: channelId, compleation: { (success) in
                if success {
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                }
            })
        }
    }
    
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (seccess) in
            if seccess {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No Channels yet!"
                }
                
            }
        }
    }

    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tabbleView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tabbleView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
        
    }

}
