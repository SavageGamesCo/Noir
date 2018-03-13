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
    let aboutCellID = "aboutCellID"
    let echoCellID = "echoCellID"
    let optionsCellID = "optionsCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .red
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.register(profImageCell.self, forCellWithReuseIdentifier: profImgCellID)
        collectionView?.register(imagesCell.self, forCellWithReuseIdentifier: imgCellID)
        collectionView?.register(statsCell.self, forCellWithReuseIdentifier: statsCellID)
        collectionView?.register(aboutCell.self, forCellWithReuseIdentifier: aboutCellID)
        collectionView?.register(echoCell.self, forCellWithReuseIdentifier: echoCellID)
        collectionView?.register(optionsCell.self, forCellWithReuseIdentifier: optionsCellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
          return CGSize(width: collectionView.frame.width, height: 300)
        }
        if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width, height: 150)
        }
        
        if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        
        if indexPath.item == 3 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        if indexPath.item == 4 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 5 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: profImgCellID, for: indexPath) as! profImageCell
            
        }
        if indexPath.item == 1 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: imgCellID, for: indexPath) as! imagesCell
            
        }
        if indexPath.item == 2 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: statsCellID, for: indexPath) as! statsCell
            
        }
        
        if indexPath.item == 3 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: aboutCellID, for: indexPath) as! aboutCell
            
        }
        
        if indexPath.item == 4 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath) as! echoCell
            
        }
        
        if indexPath.item == 5 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: optionsCellID, for: indexPath) as! optionsCell
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)

    }
    
    
    
    
}

class profImageCell: BaseCell {
    
    let mainProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_image")
        imageView.contentMode = .scaleAspectFill
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
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageTwo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageThree: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_image")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        
        return imageView
    }()
    let imageFour: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default_user_image")
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
        backgroundColor = .white
        
        scrollView.addSubview(imageOne)
        scrollView.addSubview(imageTwo)
        scrollView.addSubview(imageThree)
        scrollView.addSubview(imageFour)
        
        scrollView.addConstraintsWithFormat(format: "H:|-5-[v0][v1][v2][v3]-5-|", views: imageOne, imageTwo, imageThree, imageFour)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: imageOne)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: imageTwo)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: imageThree)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: imageFour)
        
        addSubview(scrollView)
        
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
    }
    
    @objc func handleImageUpload() {
        
    }
}

class statsCell: BaseCell {
    var currentAgeText = String()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age:"
        return label
    }()
    
    let ageField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["age"] as? String {
           textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let ageStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "Weight:"
        return label
    }()
    
    let weightField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["weight"] as? String {
            textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let weightStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "Height:"
        return label
    }()
    
    let heightField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["height"] as? String {
            textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let heightStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Body Type:"
        return label
    }()
    
    let bodyField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["body"] as? String {
            textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let bodyStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    let raceLabel: UILabel = {
        let label = UILabel()
        label.text = "Race/Ethnicity:"
        return label
    }()
    
    let raceField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["race"] as? String {
            textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let raceStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    let maritalLabel: UILabel = {
        let label = UILabel()
        label.text = "Marital Status:"
        return label
    }()
    
    let maritalField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["marital"] as? String {
            textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let maritalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    let hivLabel: UILabel = {
        let label = UILabel()
        label.text = "HIV Status:"
        return label
    }()
    
    let hivField: UITextField = {
        let textField = UITextField()
        
        if let text = PFUser.current()?["status"] as? String {
            textField.text = text
        } else {
            textField.text = "Unaswered"
        }
        
        return textField
    }()
    
    let hivStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        
        return stack
    }()
    
    
    
    override func setupViews() {
        backgroundColor = .black
        
        
        
    }
}

class aboutCell: BaseCell {
    override func setupViews() {
        backgroundColor = .purple
        
    }
}

class echoCell: BaseCell {
    override func setupViews() {
        backgroundColor = .green
        
    }
}

class optionsCell: BaseCell {
    override func setupViews() {
        backgroundColor = .yellow
        
    }
}
