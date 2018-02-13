//
//  SettingsLauncher.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let blackView = UIView()
    
    let settingCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.backgroundColor = Constants.Colors.NOIR_WHITE
        
        return collection
    }()
    
    let cellID = "cellID"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
        return [Setting(name: "Settings", imageName: "settings"), Setting(name: "Terms & privacy policy", imageName: "privacy"), Setting(name: "Send Feedback", imageName: "feedback"), Setting(name: "Help", imageName: "help"), Setting(name: "Switch Account", imageName: "switch_account"), Setting(name: "Cancel", imageName: "cancel")]
    }()
    
    
    func showSettings() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(settingCollectionView)
            
//            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let height = CGFloat(200)
            let y = window.frame.height - height
            settingCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.settingCollectionView.frame = CGRect(x: 0, y: y, width: self.settingCollectionView.frame.width, height: self.settingCollectionView.frame.height)
                
            }, completion: nil)
        }
        print("finished showing blackview")
        
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 1
            if let window = UIApplication.shared.keyWindow{
                self.settingCollectionView.frame = CGRect(x: 0, y: window.frame.width, width: self.settingCollectionView.frame.width, height: self.settingCollectionView.frame.height)
            }
            
            
        })
        self.blackView.removeFromSuperview()
        self.settingCollectionView.removeFromSuperview()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = settingCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath as IndexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: settingCollectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init() {
        super.init()
        
        settingCollectionView.dataSource = self
        settingCollectionView.delegate = self
        
        settingCollectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
