//
//  ProfileVC.swift
//  Smack
//
//  Created by Roman Trekhlebov on 07.12.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    
    //Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataServices.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGED, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        userName.text = UserDataServices.instance.name
        userEmail.text = UserDataServices.instance.email
        profileImg.image = UIImage(named: UserDataServices.instance.avatarName)
        profileImg.backgroundColor = UserDataServices.instance.returnUIColor(components: UserDataServices.instance.avatarColor)
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    


}
