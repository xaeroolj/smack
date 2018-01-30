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

//    var manager: SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!)
    var manager: SocketManager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
    
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
}


