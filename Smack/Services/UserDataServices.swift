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
    
    func returnUIColor(components: String) -> UIColor {
//        "[0.164705882352941, 0.749019607843137, 0.772549019607843, 1]"
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defoultColor = UIColor.lightGray
        guard let rUnwrapped = r else { return defoultColor }
        guard let gUnwrapped = g else { return defoultColor }
        guard let bUnwrapped = b else { return defoultColor }
        guard let aUnwrapped = a else { return defoultColor }
        
        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        return newUIColor
    }
    
    func logoutUser() {
        id = ""
        avatarColor = ""
        avatarName = ""
        name = ""
        email = ""
        AuthService.instance.isLoggedin = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToke = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    
    
    
    
    
}
