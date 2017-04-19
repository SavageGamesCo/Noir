//
//  ProfileInitViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileInitViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var currentImageView: UIImageView!
    
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
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            if error != nil {
                
                var displayErrorMessage = "Something went wrong"
                
                if let errorMessage = error?.localizedDescription {
                    displayErrorMessage = errorMessage
                }
                
                self.dialogueBox(title: "Error", messageText: displayErrorMessage)
            } else {
                print("user profile updated")
                
                //self.performSegue(withIdentifier: "ShowUserTable", sender: self)
            }
            
        })
        
    }
    
    @IBOutlet var userAgeTextField: UITextField!
    
    @IBOutlet var userEthnicityTextField: UITextField!
    
    @IBOutlet var userHeightField: UITextField!
    
    @IBOutlet var userWeightField: UITextField!
    
    @IBOutlet var userMaritalStatusTextField: UITextField!
    
    @IBOutlet var userAboutTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //downloadImages()

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
        
        
        if let photo = PFUser.current()?["mainPhoto"] as? PFFile {
            
            photo.getDataInBackground(block: {(data, error) in
            
                if let imageData = data{
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        self.currentImageView.image = downloadedImage
                    }
                }
            
                
            })
        }
        
        
        
       
    }
    
    func downloadImages() {
        var urls = ["https://s-media-cache-ak0.pinimg.com/originals/e2/58/29/e25829f574827842dc7f54f32a984b91.jpg", "https://s-media-cache-ak0.pinimg.com/236x/71/db/ab/71dbab74727f3dcceb20f340e51edbc3.jpg", "https://ldawkins.files.wordpress.com/2016/01/portrait-by-maryland-portrait-photographer-l-dawkins.jpg", "https://ldawkins.files.wordpress.com/2012/06/black-male-with-tattoos-and-cap-in-park.jpg"]
        
        var counter = 0
        
        for urlString in urls {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do{
            
            let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.jpg", data: data)
                
                let user = PFUser()
                
                user["mainPhoto"] = imageFile
                
                user.username = String(counter)
                
                user.password = "nopassword"
                
                user["age"] = String(20 + counter)
                
                user["ethnicity"] = "Black"
                
                user["height"] = "6'"
                
                user["weight"] = "210"
                
                user["marital"] = "Single"
                
//                let acl = PFACL()
//                
//                acl.getPublicWriteAccess = true
//                
//                user.acl = acl
                
                user.signUpInBackground(block: {(success, error) in
                    if success {
                        print("User created")
                    
                    }
                })
                
            } catch {
                print("Could not get datae")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage]  as? UIImage {
            
            currentImageView.image = image
        } else {
            print("There was a problem getting your image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }

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
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
