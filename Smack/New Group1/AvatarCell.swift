//
//  AvatarCell.swift
//  Smack
//
//  Created by Roman Trekhlebov on 05.12.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpFiew()
    }
    
    func setUpFiew() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
}
