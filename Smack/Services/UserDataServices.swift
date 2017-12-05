//
//  UserDataServices.swift
//  Smack
//
//  Created by Roman Trekhlebov on 05.12.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import Foundation

class UserDataServices {
    
    static let instance = UserDataServices()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
}
