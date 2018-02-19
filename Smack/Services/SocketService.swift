//
//  SocketService.swift
//  Smack
//
//  Created by Roman Trekhlebov on 30.01.2018.
//  Copyright © 2018 Roman Trekhlebov. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    
    override init() {
        super.init()
    }

    var manager: SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!)
//    var manager: SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
    func establishConnection() {
        manager.defaultSocket.connect()
    }
    
    func closeConnection() {
        manager.defaultSocket.disconnect()
    }
    
    func addChannel(channelname: String, channelDescription: String, compleation: @escaping CompletionHandler) {
        manager.defaultSocket.emit("newChannel", channelname, channelDescription)
        compleation(true)
    }
    
    func getChannel(compleation: @escaping CompletionHandler) {
        manager.defaultSocket.on("channelCreated") { (dataArray, ack) in
            guard let channelname = dataArray[0] as? String else {return}
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            let newChannel = Channel(channelTitle: channelname, channelDescription: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
            compleation(true)
         }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, compleation: @escaping CompletionHandler) {
        let user = UserDataServices.instance
        manager.defaultSocket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        compleation(true)
        
    }
    
    func getChatMessage(compleation: @escaping CompletionHandler) {
        manager.defaultSocket.on("messageCreated") { (dataArray, ack) in
            guard let msgBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            if channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedin {
                let newMessage = Message(message: msgBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                MessageService.instance.messages.append(newMessage)
                compleation(true)
            } else {
                compleation(false)
            }
        }
    }
}


