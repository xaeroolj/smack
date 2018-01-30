//
//  ChannelVC.swift
//  Smack
//
//  Created by Roman Trekhlebov on 29.11.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChanged(_:)), name: NOTIF_USER_DID_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelsLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    
    @IBAction func addChannelPressed(_ sender: Any) {
        if AuthService.instance.isLoggedin {
            let addCHannel = AddChannelVC()
            addCHannel.modalPresentationStyle = .custom
            present(addCHannel, animated: true, completion: nil)
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.instance.isLoggedin {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @objc func userDataDidChanged(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func channelsLoaded(_ notif: Notification) {
        tableView.reloadData()
    }
    
    func  setupUserInfo() {
        if AuthService.instance.isLoggedin {
            loginBtn.setTitle(UserDataServices.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataServices.instance.avatarName)
            userImg.backgroundColor = UserDataServices.instance.returnUIColor(components: UserDataServices.instance.avatarColor)
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNELS_SELECTED, object: nil)
        
        self.revealViewController().revealToggle(animated: true)
    }
}
