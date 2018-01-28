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
                    print(self.channels)
                    compleation(true)
                }
                
            } else {
                compleation(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
}
