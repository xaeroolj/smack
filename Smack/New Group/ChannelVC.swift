//
//  ChannelVC.swift
//  Smack
//
//  Created by Roman Trekhlebov on 29.11.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }


}
