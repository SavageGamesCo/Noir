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

var newMainProfileImage: UIImageView?
var newAdditionalImageOne: UIImageView?
var newAdditionalImageTwo: UIImageView?
var newAdditionalImageThree: UIImageView?
var newAdditionalImageFour: UIImageView?
var newMemberAge: String?
var newMemberWeight: String?
var newMemberHeight: String?
var newMemberGender: String?
var newMemberRace: String?
var newMemberBody: String?
var newMemberHIV: String?
var newMemberMarital: String?
var newMemberAbout: String?

var activityIndicater = UIActivityIndicatorView()

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
    let saveCellID = "saveCellID"
    let logoutCellID = "logoutCellID"
    let deleteCellID = "celeteCellID"
    let optionsCellID = "optionsCellID"
    
    
    
    let member = PFUser.current()!
    
    var origin: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        registerForKeyboardNotifications()
        
        collectionView?.allowsSelection = true
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.register(profImageCell.self, forCellWithReuseIdentifier: profImgCellID)
        collectionView?.register(imagesCell.self, forCellWithReuseIdentifier: imgCellID)
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
        collectionView?.register(saveCell.self, forCellWithReuseIdentifier: saveCellID)
        collectionView?.register(logoutCell.self, forCellWithReuseIdentifier: logoutCellID)
        collectionView?.register(deleteCell.self, forCellWithReuseIdentifier: deleteCellID)
        collectionView?.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileSettingsViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        origin = self.view.frame.origin
        
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
                self.view.frame.origin.y = (origin?.y)!
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width, height: 300)
        }
        if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width, height: 150)
        }
        
        if indexPath.item == 2 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        
        if indexPath.item == 3 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 4 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 5 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 6 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 7 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 8 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 9 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 10 {
            return CGSize(width: collectionView.frame.width, height: 200)
        }
        if indexPath.item == 11 {
            return CGSize(width: collectionView.frame.width, height: 55)
        }
        if indexPath.item == 12 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 13 {
            return CGSize(width: collectionView.frame.width, height: 35)
        }
        if indexPath.item == 14 {
            return CGSize(width: collectionView.frame.width, height: 35)
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
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: raceCellID, for: indexPath) as! raceCell
            
        }
        if indexPath.item == 6 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: genderCellID, for: indexPath) as! GenderCell
            
        }
        if indexPath.item == 7 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: bodyCellID, for: indexPath) as! bodyCell
            
        }
        
        if indexPath.item == 8 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: maritalCellID, for: indexPath) as! maritalCell
            
        }
        if indexPath.item == 9 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: hivCellID, for: indexPath) as! hivCell
            
        }
        
        if indexPath.item == 10 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: aboutCellID, for: indexPath) as! aboutCell
            
        }
        
        if indexPath.item == 11 {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath) as! echoCell
            
        }
        
        if indexPath.item == 12 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: saveCellID, for: indexPath) as! saveCell
            
            
            
            return cell
            
        }
        
        if indexPath.item == 13 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: logoutCellID, for: indexPath) as! logoutCell
            
            
            return cell
            
        }
        
        if indexPath.item == 14 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: deleteCellID, for: indexPath) as! deleteCell
            
            
            return cell
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profImgCellID, for: indexPath) as! profImageCell
            
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imgCellID, for: indexPath) as! imagesCell
            
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
        }
        if indexPath.item == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ageCellID, for: indexPath) as! ageCell
            
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weightCellID, for: indexPath) as! weightCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 4 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: heightCellID, for: indexPath) as! heightCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 5 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: raceCellID, for: indexPath) as! raceCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 6 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genderCellID, for: indexPath) as! GenderCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 7 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bodyCellID, for: indexPath) as! bodyCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 8 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: maritalCellID, for: indexPath) as! maritalCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        if indexPath.item == 9 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hivCellID, for: indexPath) as! hivCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 10 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: aboutCellID, for: indexPath) as! aboutCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 11 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: echoCellID, for: indexPath) as! echoCell
            if cell.isSelected {
                cell.backgroundColor = .clear
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 12 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: saveCellID, for: indexPath) as! saveCell
            
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
                cell.save()
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 13 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: logoutCellID, for: indexPath) as! logoutCell
            
            if cell.isSelected {
                cell.backgroundColor = Constants.Colors.NOIR_RED_LIGHT
             
                
            } else {
                cell.backgroundColor = .clear
                
            }
            
        }
        
        if indexPath.item == 14 {
            
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
        
        newMainProfileImage = mainProfileImage
        
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
            
            newMainProfileImage = mainProfileImage
            
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
        
        newAdditionalImageOne = imageOne
        newAdditionalImageTwo = imageTwo
        newAdditionalImageThree = imageThree
        newAdditionalImageFour = imageFour
        
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
            newTapped = self.tapped
            picker.dismiss(animated: true, completion: nil)
            
            
        } else {
            print("There was a problem getting your image")
            picker.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    var newTapped: UIImageView?
    
    @objc func handleImageOneUpload() {
        selectNewImage(self)
        tapped = imageOne
        newTapped = newAdditionalImageOne
    }
    
    @objc func handleImageTwoUpload() {
        selectNewImage(self)
        tapped = imageTwo
        newTapped = newAdditionalImageTwo
        
    }
    
    @objc func handleImageThreeUpload() {
        selectNewImage(self)
        tapped = imageThree
        newTapped = newAdditionalImageThree
        
    }
    
    @objc func handleImageFourUpload() {
        selectNewImage(self)
        tapped = imageFour
        newTapped = newAdditionalImageFour
        
    }
    
    
}

class ageCell: BaseCell {
    
    let agePicker = UIPickerView()
    let aPickerData = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    
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
        newMemberAge = ageField.text
        
        
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return aPickerData.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
            return aPickerData[component].count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return aPickerData[component][row]
        
    }
    var firstDigit: String?
    var secondDigit: String?
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        switch (component) {
            
        case 0:
          firstDigit = aPickerData[component][row] as String
        case 1:
           secondDigit = aPickerData[component][row] as String
        default: break
        
        }
        
        if firstDigit != nil && secondDigit != nil {
            ageField.text = "\(firstDigit!)\(secondDigit!)"
            newMemberAge = ageField.text
        }
        
    }
    
}

class weightCell: BaseCell {
    var firstDigit: String?
    var secondDigit: String?
    var thirdDigit: String?
    
    let weightPicker = UIPickerView()
    let wPickerData = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]

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
        newMemberWeight = weightField.text
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return wPickerData.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return wPickerData[component].count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return wPickerData[component][row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        switch (component) {
            
        case 0:
            firstDigit = wPickerData[component][row] as String
        case 1:
            secondDigit = wPickerData[component][row] as String
        case 2:
            thirdDigit = wPickerData[component][row] as String
        default: break
            
        }
        
        if firstDigit != nil {
            weightField.text = "\(firstDigit!)"
            newMemberWeight = weightField.text
            
            if secondDigit != nil {
                weightField.text = "\(firstDigit!)\(secondDigit!)"
                newMemberWeight = weightField.text
                
                if thirdDigit != nil{
                    weightField.text = "\(firstDigit!)\(secondDigit!)\(thirdDigit!)"
                    newMemberWeight = weightField.text
                }
            }
        }
        
        
        
        
    }
}

class heightCell: BaseCell {
    var firstDigit: String?
    var secondDigit: String?
    
    let heightPicker = UIPickerView()
    let hPickerData = [["1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'", "9'"], ["1\"", "2\"", "3\"", "4\"", "5\"", "6\"", "7\"", "8\"", "9\"", "0\""]]
    
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
        newMemberHeight = heightField.text
        
    }
    
    override func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return hPickerData.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return hPickerData[component].count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return hPickerData[component][row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        switch (component) {
            
        case 0:
            firstDigit = hPickerData[component][row] as String
        case 1:
            secondDigit = hPickerData[component][row] as String
        default: break
            
        }
        
        if firstDigit != nil {
            heightField.text = "\(firstDigit!)"
            newMemberHeight = heightField.text
            
            if secondDigit != nil {
                heightField.text = "\(firstDigit!)\(secondDigit!)"
                newMemberHeight = heightField.text
                
            }
        }
        
    }
    
    
}

class bodyCell: BaseCell {
    
    let bodyPicker = UIPickerView()
    let bodyData = ["Average", "Slim", "Stocky", "Athletic", "Jock", "Muscular", "Chub", "Bear", "Muscle Bear", "Cub", "Otter", "Big Boy", "Thick"]
    
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
        newMemberBody = bodyField.text
        
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
        newMemberBody = bodyField.text
        
    }
    
}

class raceCell: BaseCell {
    
    let ethnicityPicker = UIPickerView()
    let ethnicityData = ["Black American", "Black African", "Black European", "Black Hispanic", "Black Asian", "Indigenous", "Aboriginal", "Hispanic", "Caribbean", "West Indian", "Puerto Rican", "Arabic", "Central American", "South American", "Native American", "Asian American", "East Asian", "South Asian", "South East Asian", "West Asian", "Pacific Islander", "White American", "White European", "White Hispanic"]
    
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
        if let text = PFUser.current()?["ethnicity"] as? String {
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
        newMemberRace = raceField.text
        
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
        newMemberRace = raceField.text
        
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
        newMemberMarital = maritalField.text
        
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
        newMemberMarital = maritalField.text
        
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
        if let text = PFUser.current()?["hivStatus"] as? String {
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
        
        newMemberHIV = hivField.text
        
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
        newMemberHIV = hivField.text
        
    }
}

class GenderCell: BaseCell {
    
    let genderPicker = UIPickerView()
    let genderData = ["Male", "MTF Transgender", "FTM Transgender", "Gender Queer", "Questioning"]
    
    let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender:"
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
        newMemberGender = genderField.text
        
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
        newMemberGender = genderField.text
        
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
        textField.editingRect(forBounds: textField.bounds)
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
        
        newMemberAbout = aboutField.text
        
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
        
        if PFUser.current()?["echo"] != nil {
            echoButton.setOn(true, animated: true)
        } else {
            echoButton.setOn(false, animated: true)
        }
        
        if echoButton.isOn {
            PFUser.current()?["echo"] = true
            PFUser.current()?.saveInBackground()
                    } else {
            PFUser.current()?["echo"] = false
            PFUser.current()?.saveInBackground()
        }
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: echoStack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: echoStack)
        
        
    }
}

class saveCell: BaseCell {
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                saveLabel.backgroundColor = .green
            } else {
                saveLabel.backgroundColor = .clear
            }
        }
    }
    
    let saveLabel: UILabel = {
        let label = UILabel()
        label.text = "Save Profile Changes"
        label.textAlignment = .center
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Constants.Colors.NOIR_YELLOW
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        
        return label
    }()
    
    
    override func setupViews() {
        
        isUserInteractionEnabled = true
        addSubview(saveLabel)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(save))
        
        saveLabel.isUserInteractionEnabled = true
        saveLabel.addGestureRecognizer(tapImage)
        
        
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: saveLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0(30)]-10-|", views: saveLabel)
        
    }
    
    @objc func save() {
        
        activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicater.center = self.center
        activityIndicater.hidesWhenStopped = true
        activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        addSubview(activityIndicater)
        activityIndicater.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let imageData = UIImageJPEGRepresentation((newMainProfileImage?.image)!, 0.5)
        
        let imageDataOne = UIImageJPEGRepresentation((newAdditionalImageOne?.image)!, 0.5)
        let imageDataTwo = UIImageJPEGRepresentation((newAdditionalImageTwo?.image)!, 0.5)
        let imageDataThree = UIImageJPEGRepresentation((newAdditionalImageThree?.image)!, 0.5)
        let imageDataFour = UIImageJPEGRepresentation((newAdditionalImageFour?.image)!, 0.5)
        
        PFUser.current()?["mainPhoto"] = PFFile(name: "mainProfilePhoto.jpg", data: imageData!)
        PFUser.current()?["memberImageOne"] = PFFile(name: "memberImageOne.jpg", data: imageDataOne!)
        PFUser.current()?["memberImageTwo"] = PFFile(name: "memberImageTwo.jpg", data: imageDataTwo!)
        PFUser.current()?["memberImageThree"] = PFFile(name: "memberImageThree.jpg", data: imageDataThree!)
        PFUser.current()?["memberImageFour"] = PFFile(name: "memberImageFour.jpg", data: imageDataFour!)
        PFUser.current()?["age"] = newMemberAge
        PFUser.current()?["height"] = newMemberHeight
        PFUser.current()?["weight"] = newMemberWeight
        PFUser.current()?["marital"] = newMemberMarital
        PFUser.current()?["about"] = newMemberAbout
        PFUser.current()?["ethnicity"] = newMemberRace
        PFUser.current()?["body"] = newMemberBody
        PFUser.current()?["gender"] = newMemberGender
        PFUser.current()?["hivStatus"] = newMemberHIV
        
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                var displayErrorMessage = "Something went wrong while saving your profile. Please try again."
                
                if let errorMessage = error?.localizedDescription {
                    displayErrorMessage = errorMessage
                }
                
                self.window?.rootViewController?.dialogueBox(title: "Profile Error", messageText: displayErrorMessage)
            } else {
                self.window?.rootViewController?.dialogueBox(title: "Profile Saved", messageText: "User Profile Changes Have Successfully been saved!")

                
            }
            
        })


    }
    
    
}

class logoutCell: BaseCell {
    override var isSelected: Bool {
        didSet{
            isSelected ? logoutClicked() : nil
            
        }
    }
    
    let logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Logout"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Constants.Colors.NOIR_YELLOW
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        
        return label
    }()
    
    
    override func setupViews() {
        
        addSubview(logoutLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: logoutLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0(30)]-10-|", views: logoutLabel)
        
    }
    
    func logoutClicked() {
        
        if PFUser.current()?["online"] as! Bool == true {
            
            PFUser.current()?["online"] = false
            
            PFUser.current()?.saveInBackground(block: {(success, error) in
                if error != nil {
                    print(error!)
                } else {
                    PFUser.logOut()
                    
                    let loginController = LoginController()
                    self.window?.rootViewController?.present(loginController, animated: true, completion: nil)
                }
            })
        }
    }
    
}
class deleteCell: BaseCell {
    override var isSelected: Bool {
        didSet{
            isSelected ? deleteUserCurrent() : nil
            
        }
    }
    
    let deleteLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Delete Account"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Constants.Colors.NOIR_WHITE
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = Constants.Colors.NOIR_ORANGE
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        
        
        return label
    }()
    
    
    override func setupViews() {
        
        addSubview(deleteLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: deleteLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0(30)]-10-|", views: deleteLabel)
        
    }
    
    @objc func deleteUserCurrent() {
        
        if PFUser.current() != nil {
            PFUser.current()?.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                print("success = \(deleteSuccessful)")
                PFUser.logOut()
                let loginController = LoginController()
                self.window?.rootViewController?.present(loginController, animated: true, completion: nil)
            })
            
        }
        
    }
}
class optionsCell: BaseCell {
    override func setupViews() {
        backgroundColor = .yellow
        
    }
}
