//
//  ProfileInitViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

var activeField: UITextField?

class ProfileInitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let agePicker = UIPickerView()
    let agePickerData = ["18", "19", "20", "21","22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40",]
    
    let heightPicker = UIPickerView()
    let heightDataFeet = ["1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'",]
    let heightDataInches = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",]
    
    let maritalPicker = UIPickerView()
    let maritalData = ["Single", "Married", "Divorced", "Open", "Poly"]
    
    let ethnicityPicker = UIPickerView()
    let ethnicityData = ["Black American", "African", "West Indian", "Central American", "South American", "Puerto Rican", "Native American", "East Asian", "South Asian", "West Asian", "Pacific Islander", "White"]
    
    let bodyPicker = UIPickerView()
    let bodyData = ["Chub", "Bear", "Muscle Bear", "Stocky", "Jock", "Muscular", "Athletic", "Average", "Slim"]
    

    @IBOutlet var currentImageView: UIImageView!
    
    @IBOutlet var ScrollView: UIScrollView!
    
    
    @IBOutlet var userAgeTextField: UITextField!
    
    @IBOutlet var userEthnicityTextField: UITextField!
    
    @IBOutlet var userHeightField: UITextField!
    
    @IBOutlet var userWeightField: UITextField!
    
    @IBOutlet var userMaritalStatusTextField: UITextField!
    
    @IBOutlet var userAboutTextField: UITextView!
    
    @IBOutlet var userBodyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agePicker.dataSource = self
        agePicker.delegate = self
        
        heightPicker.dataSource = self
        heightPicker.delegate = self
        
        maritalPicker.dataSource = self
        maritalPicker.delegate = self
        
        bodyPicker.dataSource = self
        bodyPicker.delegate = self
        
        ethnicityPicker.dataSource = self
        ethnicityPicker.delegate = self
        
        //binding textfield to picker
        userAgeTextField.inputView = agePicker
        userHeightField.inputView = heightPicker
        userEthnicityTextField.inputView = ethnicityPicker
        userMaritalStatusTextField.inputView = maritalPicker
        userBodyTextField.inputView = bodyPicker
        
        //downloadImages()
        //createAgePicker()

        // Do any additional setup after loading the view.
        if let age = PFUser.current()?["age"] as? String {
            userAgeTextField.text = age
        }
        if let height = PFUser.current()?["height"] as? String {
            userHeightField.text = height
        }
        if let weight = PFUser.current()?["weight"] as? String {
            userWeightField.text = weight
        }
        if let marital = PFUser.current()?["marital"] as? String {
            userMaritalStatusTextField.text = marital
        }
        if let about = PFUser.current()?["about"] as? String {
            userAboutTextField.text = about
        }
        if let ethnicity = PFUser.current()?["ethnicity"] as? String {
            userEthnicityTextField.text = ethnicity
        }
        
        if let body = PFUser.current()?["body"] as? String {
            userBodyTextField.text = body
        }
        
        
        if let photo = PFUser.current()?["mainPhoto"] as? PFFile {
            
            photo.getDataInBackground(block: {(data, error) in
            
                if let imageData = data{
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        self.currentImageView.image = downloadedImage
                    }
                }
            
                
            })
        }
        
        registerForKeyboardNotifications()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileInitViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
       
    }
    
    @IBAction func selectNewImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let imageData = UIImageJPEGRepresentation(currentImageView.image!, 0.5)
        
        PFUser.current()?["mainPhoto"] = PFFile(name: "mainProfile.jpg", data: imageData!)
        PFUser.current()?["age"] = userAgeTextField.text
        PFUser.current()?["height"] = userHeightField.text
        PFUser.current()?["weight"] = userWeightField.text
        PFUser.current()?["marital"] = userMaritalStatusTextField.text
        PFUser.current()?["about"] = userAboutTextField.text
        PFUser.current()?["ethnicity"] = userEthnicityTextField.text
        PFUser.current()?["body"] = userBodyTextField.text
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                
                var displayErrorMessage = "Something went wrong"
                
                if let errorMessage = error?.localizedDescription {
                    displayErrorMessage = errorMessage
                }
                
                self.dialogueBox(title: "Error", messageText: displayErrorMessage)
            } else {
                print("user profile updated")
                
                self.performSegue(withIdentifier: "toUserTable", sender: self)
            }
            
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true);
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func downloadImages() {
//        let urls = ["https://s-media-cache-ak0.pinimg.com/originals/e2/58/29/e25829f574827842dc7f54f32a984b91.jpg", "https://s-media-cache-ak0.pinimg.com/236x/71/db/ab/71dbab74727f3dcceb20f340e51edbc3.jpg", "https://ldawkins.files.wordpress.com/2016/01/portrait-by-maryland-portrait-photographer-l-dawkins.jpg", "https://ldawkins.files.wordpress.com/2012/06/black-male-with-tattoos-and-cap-in-park.jpg"]
//        
//        var counter = 0
//        
//        for urlString in urls {
//            
//            counter += 1
//            
//            let url = URL(string: urlString)!
//            
//            do{
//                
//                let data = try Data(contentsOf: url)
//                
//                let imageFile = PFFile(name: "photo" + counter.description + ".jpg", data: data)
//                
//                let user = PFUser()
//                
//                user["mainPhoto"] = imageFile
//                
//                user.username = String(counter)
//                
//                user.password = "nopassword"
//                
//                user["age"] = String(20 + counter)
//                
//                user["ethnicity"] = "Black"
//                
//                user["height"] = "6'"
//                
//                user["weight"] = "210"
//                
//                user["marital"] = "Single"
//                
//                let acl = PFACL()
//                
//                acl.getPublicWriteAccess = true
//                
//                user.acl = acl
//                
//                user.signUpInBackground(block: {(success, error) in
//                    if success {
//                        print("User created")
//                        
//                    }
//                })
//                
//            } catch {
//                print("Could not get datae")
//            }
//        }
//    }

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage {
            
            currentImageView.image = image
        } else {
            print("There was a problem getting your image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //Keyboard Methods

    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.ScrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.userAboutTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.ScrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.ScrollView.contentInset = contentInsets
        self.ScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.ScrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Picker Methods
    
    func numberOfComponents(in pickerView : UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == agePicker {
            
            return agePickerData.count
            
        } else if pickerView == heightPicker {
            
            return heightDataFeet.count
            
        } else if pickerView == ethnicityPicker {
            
            return ethnicityData.count
            
        } else if pickerView == maritalPicker {
            
            return maritalData.count
            
        } else if pickerView == bodyPicker {
            
            return bodyData.count
            
        }

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if pickerView == agePicker {
            
            return agePickerData[row]
            
        } else if pickerView == heightPicker {
            
            return heightDataFeet[row]
            
        } else if pickerView == ethnicityPicker {
            
            return ethnicityData[row]
            
        } else if pickerView == maritalPicker {
            
            return maritalData[row]
            
        } else if pickerView == bodyPicker {
            
            return bodyData[row]
            
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == agePicker {
            
            userAgeTextField.text = agePickerData[row]
            
            view.endEditing(false)
            
        } else if pickerView == heightPicker {
            
            userHeightField.text = heightDataFeet[row]
            
            view.endEditing(false)
        } else if pickerView == ethnicityPicker {
            
            userEthnicityTextField.text = ethnicityData[row]
            
            view.endEditing(false)
            
        } else if pickerView == maritalPicker {
            
            userMaritalStatusTextField.text = maritalData[row]
            
            view.endEditing(false)
            
        } else if pickerView == bodyPicker {
            
            userBodyTextField.text = bodyData[row]
            
            view.endEditing(false)
            
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: My utilities
    
    func dialogueBox(title:String, messageText:String ){
        let dialog = UIAlertController(title: title,
                                       message: messageText,
                                       preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        dialog.addAction(defaultAction)
        // Present the dialog.
        
        self.present(dialog,
                     animated: true,
                     completion: nil)
    }


}
