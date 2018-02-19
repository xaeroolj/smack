//
//  MessageService.swift
//  Smack
//
//  Created by Roman Trekhlebov on 28.01.2018.
//  Copyright © 2018 Roman Trekhlebov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel: Channel?
    
    

    func findAllChannel(compleation: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else {return}
                
                if let json = JSON(data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    compleation(true)
                }
                
            } else {
                compleation(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessagesForChannel(channelId: String, compleation: @escaping CompletionHandler) {
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else {return}
                if let json = JSON(data).array {
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["messageBody"].stringValue
                        let id = item["messageBody"].stringValue
                        let userName = item["messageBody"].stringValue
                        let userAvatar = item["messageBody"].stringValue
                        let userAvatarColor = item["messageBody"].stringValue
                        let timeStamp = item["messageBody"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    print(self.messages)
                    compleation(true)
                }
            } else {
                debugPrint(response.result.error as Any)
                compleation(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    func clearChannels() {
        channels.removeAll()
    }
}
