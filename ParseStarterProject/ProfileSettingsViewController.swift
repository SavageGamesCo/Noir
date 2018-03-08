//
//  ProfileSettingsViewController.swift
//  Noir
//
//  Created by Lynx on 3/7/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class ProfileSettingsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(profImageCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
//        if indexPath.item == 0 {
//
//            return collectionView.dequeueReusableCell(withReuseIdentifier: globalCellID, for: indexPath)
//        }
//
//        if indexPath.item == 1 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: localCellID, for: indexPath)
//        }
//
//        if indexPath.item == 2 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: favoritesCellID, for: indexPath)
//        }
//
//        if indexPath.item == 3 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: flirtsCellID, for: indexPath)
//        }
//
//        if indexPath.item == 4 {
//            return collectionView.dequeueReusableCell(withReuseIdentifier: messagesCellID, for: indexPath)
//        }
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath)


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: view.frame.height / 2)
    }
    
}

class profImageCell: BaseCell {
    override func setupViews() {
        backgroundColor = .blue
        
    }
}
