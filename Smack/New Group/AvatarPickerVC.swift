//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Roman Trekhlebov on 05.12.2017.
//  Copyright © 2017 Roman Trekhlebov. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Outlets
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    var avatarType = AvatarType.dark
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColumns: CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDemension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns
        return CGSize(width: cellDemension, height: cellDemension)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataServices.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataServices.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            avatarType = .dark
        } else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
