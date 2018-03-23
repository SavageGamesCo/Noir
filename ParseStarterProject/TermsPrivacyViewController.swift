//
//  TermsPrivacyViewController.swift
//  Noir
//
//  Created by Lynx on 3/23/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

private let privacyPolicyCellID = "privacyPolicyCellID"
private let eulaCellID = "EULACellID"
private let aboutNoirCellID = "AboutNoirCellID"

class TermsPrivacyViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var PrivacyPolicyText = String()
    var EULAText = String()
    var AboutNoir = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle.main
        let PrivacyPath = bundle.path(forResource: "privacy_policy_sclcm", ofType: "txt")
        let EULAPath = bundle.path(forResource: "eula_noir", ofType: "txt")
        let AboutPath = bundle.path(forResource: "about_noir", ofType: "txt")
        
        do{
            try PrivacyPolicyText = String(contentsOfFile: PrivacyPath!)
            try EULAText = String(contentsOfFile: EULAPath!)
            try AboutNoir = String(contentsOfFile: AboutPath!)
        }catch{
            print("Unable to load privacy policy")
        }
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = .init(top: 5, left: 5, bottom: 10, right: 5)
        layout.scrollDirection = .vertical
        
        self.collectionView?.setCollectionViewLayout(layout, animated: true)

        self.collectionView!.register(AboutNoirCell.self, forCellWithReuseIdentifier: aboutNoirCellID)
        self.collectionView!.register(PrivacyPolicyCell.self, forCellWithReuseIdentifier: privacyPolicyCellID)
        self.collectionView!.register(EULACell.self, forCellWithReuseIdentifier: eulaCellID)
        
        self.collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        self.collectionView?.alwaysBounceVertical = true
        
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            let approximateWidthOfContent = self.view.frame.width
            
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            //1000 is the large arbitrary values which should be taken in case of very high amount of content
            
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
            let estimatedFrame = NSString(string: AboutNoir ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
        }
        
        if indexPath.item == 1 {
            let approximateWidthOfContent = self.view.frame.width
            
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            //1000 is the large arbitrary values which should be taken in case of very high amount of content
            
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
            let estimatedFrame = NSString(string: PrivacyPolicyText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
        }
        
        if indexPath.item == 2 {
            let approximateWidthOfContent = self.view.frame.width
            
            let size = CGSize(width: approximateWidthOfContent, height: 1000)
            
            //1000 is the large arbitrary values which should be taken in case of very high amount of content
            
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 12)]
            let estimatedFrame = NSString(string: EULAText ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            return CGSize(width: approximateWidthOfContent, height: estimatedFrame.height + 8)
        }
        return CGSize(width: collectionView.frame.width, height: 25)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: aboutNoirCellID, for: indexPath) as! AboutNoirCell
            
            cell.aboutPolicy.text = AboutNoir
          
            return cell
        }
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: privacyPolicyCellID, for: indexPath) as! PrivacyPolicyCell
            
            cell.privacyPolicy.text = PrivacyPolicyText
            
            return cell
        }
        
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eulaCellID, for: indexPath) as! EULACell
            
            cell.eulaPolicy.text = EULAText
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
    
        // Configure the cell
    
        return cell
    }



}

class PrivacyPolicyCell: BaseCell {
    
    var privacyTitleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Privacy Policy"
        label.textColor = Constants.Colors.NOIR_ORANGE
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    var privacyPolicy: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.NOIR_ORANGE
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 8)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(privacyTitleLabel)
        addSubview(privacyPolicy)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: privacyTitleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: privacyPolicy)
        addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-10-|", views: privacyTitleLabel, privacyPolicy)
        
    }
}

class EULACell: BaseCell {
    
    var eulaTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "End User License Agreement"
        label.textColor = Constants.Colors.NOIR_ORANGE
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var eulaPolicy: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.NOIR_ORANGE
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 8)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(eulaTitleLabel)
        addSubview(eulaPolicy)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: eulaTitleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: eulaPolicy)
        addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-10-|", views: eulaTitleLabel, eulaPolicy)
        
    }
}

class AboutNoirCell: BaseCell {
    
    var aboutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "About Noir"
        label.textColor = Constants.Colors.NOIR_ORANGE
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    var aboutPolicy: UILabel = {
        let label = UILabel()
        label.textColor = Constants.Colors.NOIR_ORANGE
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    override func setupViews() {
        super.setupViews()
        
        addSubview(aboutTitleLabel)
        addSubview(aboutPolicy)
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: aboutTitleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: aboutPolicy)
        addConstraintsWithFormat(format: "V:|[v0]-5-[v1]-10-|", views: aboutTitleLabel, aboutPolicy)
        
    }
}
