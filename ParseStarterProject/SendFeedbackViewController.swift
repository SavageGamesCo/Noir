//
//  SendFeedbackViewController.swift
//  Noir
//
//  Created by Lynx on 3/23/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SendFeedbackViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = .init(top: 5, left: 5, bottom: 10, right: 5)
        layout.scrollDirection = .vertical
        
        self.collectionView!.setCollectionViewLayout(layout, animated: true)
        self.collectionView!.register(FeedbackCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedbackCell
        
        // Configure the cell
        let savageCodeLogo: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(named: "savage_code_logo")
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        let feedbackStatement: UILabel = {
            let label = UILabel()
            label.text = "The creator of Noir is glad to receive your feedback, feature requests and questions regarding Noir. Please use the button below to contact Noir. \n\nVisit the Noir site where you can sign up for the mailing list and to be a beta tester for future versions or visit the site of the company that created Noir, Savage Code, LLC."
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = Constants.Colors.NOIR_WHITE
            label.numberOfLines = 0
            label.sizeToFit()
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
            
        }()
        let emailButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isUserInteractionEnabled = true
            button.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
            button.setTitle("Email Noir", for: .normal)
            button.setTitleColor(Constants.Colors.NOIR_BUTTON_TEXT, for: .normal)
            button.setTitleColor(Constants.Colors.NOIR_WHITE, for: .highlighted)
            button.tintColor = Constants.Colors.NOIR_BUTTON
            button.backgroundColor = Constants.Colors.NOIR_BUTTON
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(emailNoirAdmin), for: .touchUpInside)
            button.isEnabled = true
            return button
        }()
        let noirSiteButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isUserInteractionEnabled = true
            button.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
            button.setTitle("Visit Noir", for: .normal)
            button.setTitleColor(Constants.Colors.NOIR_BUTTON_TEXT, for: .normal)
            button.setTitleColor(Constants.Colors.NOIR_WHITE, for: .highlighted)
            button.backgroundColor = Constants.Colors.NOIR_BUTTON
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(goToNoirSite), for: .touchUpInside)
            button.isEnabled = true
            return button
        }()
        
        let savageCodeButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.isUserInteractionEnabled = true
            button.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
            button.setTitle("Visit Savage Code", for: .normal)
            button.setTitleColor(Constants.Colors.NOIR_BUTTON_TEXT, for: .normal)
            button.setTitleColor(Constants.Colors.NOIR_WHITE, for: .highlighted)
            button.backgroundColor = Constants.Colors.NOIR_BUTTON
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(goToSavageCodeSite), for: .touchUpInside)
            button.isEnabled = true
            button.backgroundColor = Constants.Colors.NOIR_BUTTON
            return button
        }()
        
        cell.addSubview(savageCodeLogo)
        cell.addSubview(feedbackStatement)
        cell.addSubview(emailButton)
        cell.addSubview(noirSiteButton)
        cell.addSubview(savageCodeButton)
        
        cell.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: savageCodeLogo)
        cell.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: feedbackStatement)
        cell.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: emailButton)
        cell.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: noirSiteButton)
        cell.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: savageCodeButton)
        cell.addConstraintsWithFormat(format: "V:|-10-[v0(100)]-5-[v1]-10-[v2(50)]-5-[v3(50)]-5-[v4(50)]", views: savageCodeLogo, feedbackStatement, emailButton, noirSiteButton, savageCodeButton)
    
        return cell
    }
    
    func goToNoirSite(){
        let targetURL = "http://noir.savage-code.com"
        if let url = URL(string: targetURL) {
            UIApplication.shared.open(url)
        }
        
    }
    
    func goToSavageCodeSite(){
        let targetURL = "http://savage-code.com"
        if let url = URL(string: targetURL) {
            UIApplication.shared.open(url)
        }
      
    }
    
    func emailNoirAdmin(){
        let email = "noir@savage-code.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
       
    }

    

}

class FeedbackCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        
        
        
    }
    
    
    
}






