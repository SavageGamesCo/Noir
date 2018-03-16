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

    let profImgCellID = "profImgCellID"
    let imgCellID = "imgCellID"
    let statsCellID = "statsCellID"
    let ageCellID = "ageCellID"
    let weightCellID = "weightCellID"
    let heightCellID = "heightCellID"
    let raceCellID = "raceCellID"
    let bodyCellID = "bodyCellID"
    let maritalCellID = "maritalCellID"
    let hivCellID = "hivCellID"
    let aboutCellID = "aboutCellID"
    let echoCellID = "echoCellID"
    let logoutCellID = "logoutCellID"
    let deleteCellID = "celeteCellID"
    let optionsCellID = "optionsCellID"
    
    let member = PFUser.current()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.allowsSelection = true
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.register(profImageCell.self, forCellWithReuseIdentifier: profImgCellID)
        collectionView?.register(imagesCell.self, forCellWithReuseIdentifier: imgCellID)
//        collectionView?.register(statsCell.self, forCellWithReuseIdentifier: statsCellID)
        
        collectionView?.register(ageCell.self, forCellWithReuseIdentifier: ageCellID)
        collectionView?.register(weightCell.self, forCellWithReuseIdentifier: weightCellID)
        collectionView?.register(heightCell.self, forCellWithReuseIdentifier: heightCellID)
        collectionView?.register(raceCell.self, forCellWithReuseIdentifier: raceCellID)
        collectionView?.register(bodyCell.self, forCellWithReuseIdentifier: bodyCellID)
        collectionView?.register(maritalCell.self, forCellWithReuseIdentifier: maritalCellID)
        collectionView?.register(hivCell.self, forCellWithReuseIdentifier: hivCellID)
        
        collectionView?.register(aboutCell.self, forCellWithReuseIdentifier: aboutCellID)
        collectionView?.register(echoCell.self, forCellWithReuseIdentifier: echoCellID)
        collectionView?.register(logoutCell.self, forCellWithReuseIdentifier: logoutCellID)
        collectionView?.register(deleteCell.self, forCellWithReuseIdentifier: deleteCellID)
//        collectionView?.register(optionsCell.self, forCellWithReuseIdentifier: optionsCellID)
        
        collectionView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
          return CGSize(width: collectionView.frame.width, height: 300)
        }
        if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width, height: 150)
        }
        
        if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        
        if indexPath.item == 3 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 4 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 5 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 6 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 7 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 8 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        if indexPath.item == 9 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 10 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 11 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let user = PFUser.query()
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profImgCellID, for: indexPath) as! profImageCell
            
            user?.getObjectInBackground(withId: member.objectId!, block: { (gMember, error) in
                if let user = gMember as? PFUser {
                
                    if user["mainPhoto"] != nil {
                        let imageFile5 = user["mainPhoto"] as! PFFile
                        imageFile5.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                let image = UIImage(data: imageData)!
                                cell.mainProfileImage.image = image
                                
                            }
                        })
                    } else {
                        cell.mainProfileImage.image = UIImage(named: "default_user_image")
                    }
                    
                }
                
            })
            
            return cell
            
        }
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imgCellID, for: indexPath) as! imagesCell
            
            user?.getObjectInBackground(withId: member.objectId!, block: { (gMember, error) in
                if let user = gMember as? PFUser {
                    if user["memberImageOne"] != nil {
                        let imageFile5 = user["memberImageOne"] as! PFFile
                        imageFile5.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                let image = UIImage(data: imageData)!
                                cell.imageOne.image = image
                                
                            }
                        })
                        
                    } else {
                        cell.imageOne.image = UIImage(named: "default_user_image")
                    }
                    
                    if user["memberImageTwo"] != nil {
                        let imageFile5 = user["memberImageTwo"] as! PFFile
                        imageFile5.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                let image = UIImage(data: imageData)!
                                cell.imageTwo.image = image
                                
                            }
                        })
                        
                    } else {
                        cell.imageTwo.image = UIImage(named: "default_user_image")
                    }
                    
                    if user["memberImageThree"] != nil {
                        let imageFile5 = user["memberImageThree"] as! PFFile
                        imageFile5.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                let image = UIImage(data: imageData)!
                                cell.imageThree.image = image
                                
                            }
                        })
                        
                    } else {
                        cell.imageThree.image = UIImage(named: "default_user_image")
                    }
                    
                    if user["memberImageFour"] != nil {
                        let imageFile5 = user["memberImageFour"] as! PFFile
                        imageFile5.getDataInBackground(block: { (data, error) in
                            if let imageData = data {
                                let image = UIImage(data: imageData)!
                                cell.imageFour.image = image
                                
                            }
                        })
                        
                    } else {
                        cell.imageFour.image = UIImage(named: "default_user_image")
                    }
                }
                
            })
            
            
            
            return cell
            
        }
        if indexPath.item == 2 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: ageCellID, for: indexPath) as! ageCell
            
        }
        if indexPath.item == 3 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: weightCellID, for: indexPath) as! weightCell
            
        }
        if indexPath.item == 4 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: heightCellID, for: indexPath) as! heightCell
            
        }
        if indexPath.item == 5 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: bodyCellID, for: indexPath) as! bodyCell
            
        }
        
        if indexPath.item == 6 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: maritalCellID, for: indexPath) as! maritalCell
            
        }
        if indexPath.item == 7 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: hivCellID, for: indexPath) as! hivCell
            
        }
        
        if indexPath.item == 8 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: aboutCellID, for: indexPath) as! aboutCell
            
        }
        
        if indexPath.item == 9 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath) as! echoCell
            
        }
        
        if indexPath.item == 10 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: logoutCellID, for: indexPath) as! logoutCell
            
        }
        
        if indexPath.item == 11 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: deleteCellID, for: indexPath) as! deleteCell
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)

    }
    
    
    
    
}

class profImageCell: BaseCell {
    
    let mainProfileImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func setupViews() {
        backgroundColor = .blue
        
        addSubview(mainProfileImage)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainProfileImage)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainProfileImage)
        
    }
    
}

class imagesCell: BaseCell {
    
    let tapOne = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    let tapTwo = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    let tapThree = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    let tapFour = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    
    
    
    let imageOne: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageTwo: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageThree: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        
        return imageView
    }()
    let imageFour: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
       
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func setupViews() {
        backgroundColor = Constants.Colors.NOIR_RED_MEDIUM
        
        scrollView.addSubview(imageOne)
        scrollView.addSubview(imageTwo)
        scrollView.addSubview(imageThree)
        scrollView.addSubview(imageFour)
        
        let imageSizeSquared = self.frame.height - 10
        
        scrollView.addConstraintsWithFormat(format: "H:|-5-[v0(\(imageSizeSquared))]-5-[v1(\(imageSizeSquared))]-5-[v2(\(imageSizeSquared))]-5-[v3(\(imageSizeSquared))]-5-|", views: imageOne, imageTwo, imageThree, imageFour)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageOne)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageTwo)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageThree)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageFour)
        
        addSubview(scrollView)
        
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        
    }
    
    @objc func handleImageUpload() {
        
    }
}

class ageCell: BaseCell {
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ageField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["age"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let ageStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: ageStack, statLabel: ageLabel, statField: ageField)
        
        
        
    }
    
}

class weightCell: BaseCell {
   
    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["weight"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let weightStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: weightStack, statLabel: weightLabel, statField: weightField)
        
    }
}

class heightCell: BaseCell {
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heightField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["height"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let heightStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: heightStack, statLabel: heightLabel, statField: heightField)
        
    }
    
    
}

class bodyCell: BaseCell {
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Body Type:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["body"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let bodyStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {

        setupStats(stack: bodyStack, statLabel: bodyLabel, statField: bodyField)
        
    }
    
}

class raceCell: BaseCell {
    
    let raceLabel: UILabel = {
        let label = UILabel()
        label.text = "Race/Ethnicity:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let raceField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["race"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let raceStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
       
        setupStats(stack: raceStack, statLabel: raceLabel, statField: raceField)
        
    }
    
}

class maritalCell: BaseCell {
    
    let maritalLabel: UILabel = {
        let label = UILabel()
        label.text = "Marital Status:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maritalField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["marital"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let maritalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
       
        setupStats(stack: maritalStack, statLabel: maritalLabel, statField: maritalField)
        
    }
    
}

class hivCell: BaseCell {
    
    let hivLabel: UILabel = {
        let label = UILabel()
        label.text = "HIV Status:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hivField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["status"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let hivStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
       
        setupStats(stack: hivStack, statLabel: hivLabel, statField: hivField)
        
    }
}

class statsCell: BaseCell {

}

class aboutCell: BaseCell {
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.sizeToFit()
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutField: UITextField = {
        let textField = UITextField()
//        textField.backgroundColor = Constants.Colors.NOIR_RED_MEDIUM
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["about"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let aboutStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        setupStats(stack: aboutStack, statLabel: aboutLabel, statField: aboutField)
        addConstraintsWithFormat(format: "H:|[v0]|", views: aboutStack)
        aboutStack.addConstraintsWithFormat(format: "V:|[v0(35)]", views: aboutLabel)
        aboutStack.addConstraintsWithFormat(format: "H:|-10-[v0]-5-[v1(330)]-10-|", views: aboutLabel, aboutField)
        aboutField.textAlignment = .left
        aboutField.contentVerticalAlignment = .top
        
    }
}

class echoCell: BaseCell {
    
    let echoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Echo:"
        label.textColor = Constants.Colors.NOIR_WHITE
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let echoInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Turn on Echo to let members know you are looking to meet!"
        label.textColor = Constants.Colors.NOIR_WHITE
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let echoButton: UISwitch = {
        
        let button = UISwitch()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if button.isOn {
            PFUser.current()?["echo"] = true
        } else {
            PFUser.current()?["echo"] = false
        }
        
        return button
        
    }()
    
    let echoStack: UIStackView = {
        
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
        
    }()
    
    override func setupViews() {
        
        echoStack.addSubview(echoLabel)
        echoStack.addSubview(echoInfoLabel)
        echoStack.addSubview(echoButton)
        echoStack.addConstraintsWithFormat(format: "H:|-10-[v0]-5-[v1]-10-|", views: echoLabel,echoButton )
        echoStack.addConstraintsWithFormat(format: "H:|[v0]|", views: echoInfoLabel)
        echoStack.addConstraintsWithFormat(format: "V:|[v0]-5-[v1]|", views: echoLabel, echoInfoLabel)
        echoStack.addConstraintsWithFormat(format: "V:|[v0]", views: echoButton)
        addSubview(echoStack)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: echoStack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: echoStack)
        
        
    }
}

class logoutCell: BaseCell {
    
    let logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Logout"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func setupViews() {
        
        addSubview(logoutLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: logoutLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: logoutLabel)
        
    }
}
class deleteCell: BaseCell {
    
    let deleteLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Delete Account"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    override func setupViews() {
        
        addSubview(deleteLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: deleteLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: deleteLabel)
        
    }
}
class optionsCell: BaseCell {
    override func setupViews() {
        backgroundColor = .yellow
        
    }
}
