//
//  ProfileSettingsViewController.swift
//  Noir
//
//  Created by Lynx on 3/7/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import UserNotifications

var currentActiveField: UITextField?

class ProfileSettingsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    let profImgCellID = "profImgCellID"
    let imgCellID = "imgCellID"
    let statsCellID = "statsCellID"
    let ageCellID = "ageCellID"
    let weightCellID = "weightCellID"
    let heightCellID = "heightCellID"
    let raceCellID = "raceCellID"
    let bodyCellID = "bodyCellID"
    let genderCellID = "genderCellID"
    let maritalCellID = "maritalCellID"
    let hivCellID = "hivCellID"
    let aboutCellID = "aboutCellID"
    let echoCellID = "echoCellID"
    let logoutCellID = "logoutCellID"
    let deleteCellID = "celeteCellID"
    let optionsCellID = "optionsCellID"
    
    var PrivacyPolicyText = String()
    var EULAText = String()
    var AboutNoir = String()
    
    let member = PFUser.current()!
    
    
    
    var activityIndicater = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        registerForKeyboardNotifications()
        
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
        collectionView?.register(GenderCell.self, forCellWithReuseIdentifier: genderCellID)
        collectionView?.register(bodyCell.self, forCellWithReuseIdentifier: bodyCellID)
        collectionView?.register(maritalCell.self, forCellWithReuseIdentifier: maritalCellID)
        collectionView?.register(hivCell.self, forCellWithReuseIdentifier: hivCellID)
        
        collectionView?.register(aboutCell.self, forCellWithReuseIdentifier: aboutCellID)
        collectionView?.register(echoCell.self, forCellWithReuseIdentifier: echoCellID)
        collectionView?.register(logoutCell.self, forCellWithReuseIdentifier: logoutCellID)
        collectionView?.register(deleteCell.self, forCellWithReuseIdentifier: deleteCellID)
        //        collectionView?.register(optionsCell.self, forCellWithReuseIdentifier: optionsCellID)
        
        collectionView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileInitViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    //    @objc func saveButton() {
    //
    //        activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    //
    //        activityIndicater.center = self.view.center
    //        activityIndicater.hidesWhenStopped = true
    //        activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    //
    //        view.addSubview(activityIndicater)
    //        activityIndicater.startAnimating()
    //        UIApplication.shared.beginIgnoringInteractionEvents()
    //
    //        let imageData = UIImageJPEGRepresentation(currentImageView.image!, 0.3)
    //
    //        PFUser.current()?["mainPhoto"] = PFFile(name: "mainProfile.jpg", data: imageData!)
    //        PFUser.current()?["age"] = userAgeTextField.text
    //        PFUser.current()?["height"] = userHeightField.text
    //        PFUser.current()?["weight"] = userWeightField.text
    //        PFUser.current()?["marital"] = userMaritalStatusTextField.text
    //        PFUser.current()?["about"] = userAboutTextField.text
    //        PFUser.current()?["ethnicity"] = userEthnicityTextField.text
    //        PFUser.current()?["body"] = userBodyTextField.text
    //        PFUser.current()?["echo"] = Echo
    //
    //        PFUser.current()?.saveInBackground(block: {(success, error) in
    //
    //            self.deregisterFromKeyboardNotifications()
    //
    //            UIApplication.shared.endIgnoringInteractionEvents()
    //
    //            if error != nil {
    //
    //                var displayErrorMessage = "Something went wrong while saving your profile. Please try again."
    //
    //                if let errorMessage = error?.localizedDescription {
    //                    displayErrorMessage = errorMessage
    //                }
    //
    //                self.dialogueBox(title: "Profile Error", messageText: displayErrorMessage)
    //            } else {
    //
    //                self.performSegue(withIdentifier: "toUserTable", sender: self)
    //            }
    //
    //        })
    //
    //    }
    
    func logoutClicked() {
        
        if PFUser.current()?["online"] as! Bool == true {
            
            PFUser.current()?["online"] = false
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                if error != nil {
                    print(error!)
                } else {
                    PFUser.logOut()
                    
                    self.performSegue(withIdentifier: "toLogin", sender: self)
                }
            })
        }
    }
    
    @objc func deleteUserCurrent() {
        
        if PFUser.current() != nil {
            PFUser.current()?.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                print("success = \(deleteSuccessful)")
                PFUser.logOut()
                self.performSegue(withIdentifier: "toLogin", sender: self)
            })
            
        }
        
    }
    
    //Keyboard Methods
    
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 9 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        if indexPath.item == 10 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 11 {
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        if indexPath.item == 12 {
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
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: genderCellID, for: indexPath) as! GenderCell
            
        }
        if indexPath.item == 6 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: bodyCellID, for: indexPath) as! bodyCell
            
        }
        
        if indexPath.item == 7 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: maritalCellID, for: indexPath) as! maritalCell
            
        }
        if indexPath.item == 8 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: hivCellID, for: indexPath) as! hivCell
            
        }
        
        if indexPath.item == 9 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: aboutCellID, for: indexPath) as! aboutCell
            
        }
        
        if indexPath.item == 10 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath) as! echoCell
            
        }
        
        if indexPath.item == 11 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: logoutCellID, for: indexPath) as! logoutCell
            
        }
        
        if indexPath.item == 12 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: deleteCellID, for: indexPath) as! deleteCell
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profImgCellID, for: indexPath) as! profImageCell
            
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imgCellID, for: indexPath) as! imagesCell
            
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
        }
        if indexPath.item == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ageCellID, for: indexPath) as! ageCell
            
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weightCellID, for: indexPath) as! weightCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 4 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: heightCellID, for: indexPath) as! heightCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 5 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genderCellID, for: indexPath) as! GenderCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 6 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bodyCellID, for: indexPath) as! bodyCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 7 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: maritalCellID, for: indexPath) as! maritalCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 8 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hivCellID, for: indexPath) as! hivCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 9 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: aboutCellID, for: indexPath) as! aboutCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 10 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath) as! echoCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 11 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: logoutCellID, for: indexPath) as! logoutCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 12 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deleteCellID, for: indexPath) as! deleteCell
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
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
        addSubview(mainProfileImage)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(handleImageUpload))
        
        mainProfileImage.isUserInteractionEnabled = true
        mainProfileImage.addGestureRecognizer(tapImage)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainProfileImage)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainProfileImage)
        
    }
    
    func selectNewImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePickerController.allowsEditing = false
        
        self.window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage {
            
            mainProfileImage.image = image
            print("main image chosen")
            picker.dismiss(animated: true, completion: nil)
        } else {
            print("There was a problem getting your image")
            picker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @objc func handleImageUpload(){
        selectNewImage(self)
        print("Showing profile image selector")
    }
    
}

class imagesCell: BaseCell {
    
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
    
    var tapped: UIImageView?
    
    
    override func setupViews() {
        backgroundColor = Constants.Colors.NOIR_RED_MEDIUM
        
        scrollView.addSubview(imageOne)
        scrollView.addSubview(imageTwo)
        scrollView.addSubview(imageThree)
        scrollView.addSubview(imageFour)
        
        let tapImage1 = UITapGestureRecognizer(target: self, action: #selector(handleImageOneUpload))
        let tapImage2 = UITapGestureRecognizer(target: self, action: #selector(handleImageTwoUpload))
        let tapImage3 = UITapGestureRecognizer(target: self, action: #selector(handleImageThreeUpload))
        let tapImage4 = UITapGestureRecognizer(target: self, action: #selector(handleImageFourUpload))
        
        imageOne.isUserInteractionEnabled = true
        imageOne.addGestureRecognizer(tapImage1)
        
        imageTwo.isUserInteractionEnabled = true
        imageTwo.addGestureRecognizer(tapImage2)
        
        imageThree.isUserInteractionEnabled = true
        imageThree.addGestureRecognizer(tapImage3)
        
        imageFour.isUserInteractionEnabled = true
        imageFour.addGestureRecognizer(tapImage4)
        
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
    
    func selectNewImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePickerController.allowsEditing = false
        
        self.window?.rootViewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage {
            
            self.tapped?.image = image
            print("image one set")
            picker.dismiss(animated: true, completion: nil)
            
            
        } else {
            print("There was a problem getting your image")
            picker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @objc func handleImageOneUpload() {
        selectNewImage(self)
        tapped = imageOne
    }
    
    @objc func handleImageTwoUpload() {
        selectNewImage(self)
        tapped = imageTwo
        
    }
    
    @objc func handleImageThreeUpload() {
        selectNewImage(self)
        tapped = imageThree
        
    }
    
    @objc func handleImageFourUpload() {
        selectNewImage(self)
        tapped = imageFour
        
    }
    
    
}

class ageCell: BaseCell {
    
    let agePicker = UIPickerView()
    let aPickerData = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    let agePickerData = ["18", "19", "20", "21","22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100"]
    
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
        
        agePicker.dataSource = self
        agePicker.delegate = self
        
        ageField.inputView = agePicker
        ageField.inputAccessoryView = toolBar
        
        
        setupStats(stack: ageStack, statLabel: ageLabel, statField: ageField)
        
        
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
            return agePickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return agePickerData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
            ageField.text = agePickerData[row]
        
    }
    
}

class weightCell: BaseCell {
    
    let weightPicker = UIPickerView()
    let wPickerData = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    var weightPickerData = ["100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","119", "120","121","122","123","124","125","126","127","128","129", "130", "131", "132", "133", "134","135", "136", "137", "138", "139", "140", "141","142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162","163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200", "201","202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "220", "221", "222", "223", "224", "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235", "236", "237", "238", "239", "240", "241", "242", "243", "244", "245", "246", "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257", "258", "259", "260", "261", "262",  "263", "264", "265", "266", "267", "268", "269", "270", "271", "272", "273", "274", "275", "276", "277", "278", "279", "280", "281", "282", "283", "284", "285", "286", "287", "288", "289", "290", "291", "292", "293", "294", "295", "296", "297", "298", "299", "300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312", "313", "314", "315", "316", "317", "318", "319", "320", "321", "322", "323", "324", "325", "326", "327", "328", "329", "330", "331", "332", "333", "334", "335", "336", "337", "338", "339", "340", "341", "342", "343", "344", "345", "346", "347", "348", "349", "350", "351", "352", "353", "354", "355", "356", "357", "358", "359", "360", "361", "362", "363", "364", "365", "366", "367", "368", "369", "370", "371", "372", "373", "374", "375", "376", "377", "378", "379", "380", "381", "382", "383", "384", "385", "386", "387", "388", "389", "390", "391", "392", "393", "394", "395", "396", "397", "398", "399", "400", "401", "402", "403", "404", "405", "406", "407", "408", "409", "410", "411", "412", "413", "414", "415", "416", "417", "418", "419", "420", "421", "422", "423", "424", "425", "426", "427", "428", "429", "430", "431", "432", "433", "434", "435", "436", "437", "438", "439", "440", "441", "442", "443", "444", "445", "446", "447", "448", "449", "450", "451", "452", "453", "454", "455", "456", "457", "458", "459", "460", "461", "462", "463", "464", "465", "466", "467", "468", "469", "470", "471", "472", "473", "474", "475", "476", "477", "478", "479", "480", "481", "482", "483", "484", "485", "486", "487", "488", "489", "490", "491", "492", "493", "494", "495", "496", "497", "498", "499", "500"]
    
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
        weightPicker.dataSource = self
        weightPicker.delegate = self
        weightField.inputView = weightPicker
        weightField.inputAccessoryView = toolBar
        

        setupStats(stack: weightStack, statLabel: weightLabel, statField: weightField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return weightPickerData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return weightPickerData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        weightField.text = weightPickerData[row]
        
    }
}

class heightCell: BaseCell {
    
    let heightPicker = UIPickerView()
    let hPickerData = [["1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'", "9'"], ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    let heightDataFeet = ["4'0", "4'1", "4'2", "4'3", "4'4", "4'5", "4'6", "4'7", "4'8", "4'9", "4'10", "4'11", "5'0", "5'1", "5'2", "5'3", "5'4", "5'5", "5'6", "5'7", "5'8", "5'9", "5'10", "5'11", "6'0", "6'1", "6'2", "6'3", "6'4", "6'5", "6'6", "6'7", "6'8", "6'9", "6'10", "6'11", "7'0"]
    
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
        
        heightPicker.dataSource = self
        heightPicker.delegate = self
        
        heightField.inputView = heightPicker
        heightField.inputAccessoryView = toolBar
        
        setupStats(stack: heightStack, statLabel: heightLabel, statField: heightField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return heightDataFeet.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return heightDataFeet[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        heightField.text = heightDataFeet[row]
        
    }
    
    
}

class bodyCell: BaseCell {
    
    let bodyPicker = UIPickerView()
    let bodyData = ["Chub", "Bear", "Muscle Bear", "Stocky", "Jock", "Muscular", "Athletic", "Average", "Slim"]
    
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
        
        bodyPicker.dataSource = self
        bodyPicker.delegate = self
        
        bodyField.inputView = bodyPicker
        bodyField.inputAccessoryView = toolBar
        
        setupStats(stack: bodyStack, statLabel: bodyLabel, statField: bodyField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return bodyData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return bodyData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        bodyField.text = bodyData[row]
        
    }
    
}

class raceCell: BaseCell {
    
    let ethnicityPicker = UIPickerView()
    let ethnicityData = ["Indigenous", "Black American", "Black African", "Black European", "Black Hispanic", "Black Asian", "Hispanic", "Caribbean", "West Indian", "Puerto Rican", "Arabic", "Central American", "South American", "Native American", "Asian American", "East Asian", "South Asian", "South East Asian", "West Asian", "Pacific Islander", "White American", "White European", "White Hispanic"]
    
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
        
        ethnicityPicker.dataSource = self
        ethnicityPicker.delegate = self
        
        raceField.inputView = ethnicityPicker
        raceField.inputAccessoryView = toolBar
        
        
        setupStats(stack: raceStack, statLabel: raceLabel, statField: raceField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return ethnicityData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ethnicityData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        raceField.text = ethnicityData[row]
        
    }
    
}

class maritalCell: BaseCell {
    
    let maritalPicker = UIPickerView()
    let maritalData = ["Single", "Married", "Divorced", "Open", "Poly", "Triad", "No Idea"]
    
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
        
        maritalPicker.dataSource = self
        maritalPicker.delegate = self
        
        maritalField.inputView = maritalPicker
        maritalField.inputAccessoryView = toolBar
        
        setupStats(stack: maritalStack, statLabel: maritalLabel, statField: maritalField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return maritalData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return maritalData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        maritalField.text = maritalData[row]
        
    }
    
}

class hivCell: BaseCell {
    
    let hivPicker = UIPickerView()
    let hivData = ["Negative", "Positive", "Undetectable", "Unknown", "Neg-on PreP"]
    
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
        
        hivPicker.dataSource = self
        hivPicker.delegate = self
        
        hivField.inputView = hivPicker
        hivField.inputAccessoryView = toolBar
        
        setupStats(stack: hivStack, statLabel: hivLabel, statField: hivField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return hivData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return hivData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        hivField.text = hivData[row]
        
    }
}

class GenderCell: BaseCell {
    
    let genderPicker = UIPickerView()
    let genderData = ["Male", "MTF Transgender", "FTM Transgender", "Gender Queer", "Questioning"]
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Race/Ethnicity:"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genderField: UITextField = {
        
        let textField = UITextField()
        //        textField.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = Constants.Colors.NOIR_WHITE
        if let text = PFUser.current()?["gender"] as? String {
            textField.text = text
        } else {
            textField.text = "Unanswered"
        }
        
        return textField
    }()
    
    let genderStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    override func setupViews() {
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        
        genderField.inputView = genderPicker
        genderField.inputAccessoryView = toolBar
        
        setupStats(stack: genderStack, statLabel: genderLabel, statField: genderField)
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return genderData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return genderData[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        genderField.text = genderData[row]
        
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
