//
//  ProfileInitViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 4/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseLiveQuery
import UserNotifications

var activeField: UITextField?

class ProfileInitViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let liveQueryClient: Client = ParseLiveQuery.Client(server: "wss://noir.back4app.io")
    
    private var subscription: Subscription<PFObject>!
    
    @IBOutlet var currentImageView: UIImageView!
    @IBOutlet var ScrollView: UIScrollView!
    @IBOutlet var userAgeTextField: UITextField!
    @IBOutlet var userEthnicityTextField: UITextField!
    @IBOutlet var userHeightField: UITextField!
    @IBOutlet var userWeightField: UITextField!
    @IBOutlet var userMaritalStatusTextField: UITextField!
    @IBOutlet var userAboutTextField: UITextView!
    @IBOutlet var userBodyTextField: UITextField!
    
    @IBAction func deleteAccountButton(_ sender: Any) {
        
        commonActionSheet(title: "Delete Account", message: "Are you certain you wish you to delete your account?", whatCase: "delUser")
        
    }
    
    @IBAction func TermsOfUseButton(_ sender: Any) {
        
        commonActionSheet(title: "Terms of User / End User License Agreement", message: EULAText, whatCase: "normal")
        
    }
    
    @IBAction func privacyPolicyButton(_ sender: Any) {
        
        commonActionSheet(title: "Privacy Policy", message: PrivacyPolicyText, whatCase: "normal")
        
    }
    
    @IBAction func aboutNoir(_ sender: Any) {
        
        commonActionSheet(title: "About Noir", message: AboutNoir, whatCase: "normal")
        
    }
    
    
    let agePicker = UIPickerView()
    let aPickerData = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    let agePickerData = ["18", "19", "20", "21","22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65", "66", "67", "68", "69", "70", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100"]
    
    let heightPicker = UIPickerView()
    let hPickerData = [["1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'", "9'"], ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    let heightDataFeet = ["4'0", "4'1", "4'2", "4'3", "4'4", "4'5", "4'6", "4'7", "4'8", "4'9", "4'10", "4'11", "5'0", "5'1", "5'2", "5'3", "5'4", "5'5", "5'6", "5'7", "5'8", "5'9", "5'10", "5'11", "6'0", "6'1", "6'2", "6'3", "6'4", "6'5", "6'6", "6'7", "6'8", "6'9", "6'10", "6'11", "7'0"]
    
    let weightPicker = UIPickerView()
    let wPickerData = [["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]]
    var weightPickerData = ["100",
                            "101",
                            "102",
                            "103",
                            "104",
                            "105",
                            "106",
                            "107",
                            "108",
                            "109",
                            "110",
                            "111",
                            "112",
                            "113",
                            "114",
                            "115",
                            "116",
                            "117",
                            "118",
                            "119",
                            "120",
                            "121",
                            "122",
                            "123",
                            "124",
                            "125",
                            "126",
                            "127",
                            "128",
                            "129",
                            "130",
                            "131",
                            "132",
                            "133",
                            "134",
                            "135",
                            "136",
                            "137",
                            "138",
                            "139",
                            "140",
                            "141",
                            "142",
                            "143",
                            "144",
                            "145",
                            "146",
                            "147",
                            "148",
                            "149",
                            "150",
                            "151",
                            "152",
                            "153",
                            "154",
                            "155",
                            "156",
                            "157",
                            "158",
                            "159",
                            "160",
                            "161",
                            "162",
                            "163",
                            "164",
                            "165",
                            "166",
                            "167",
                            "168",
                            "169",
                            "170",
                            "171",
                            "172",
                            "173",
                            "174",
                            "175",
                            "176",
                            "177",
                            "178",
                            "179",
                            "180",
                            "181",
                            "182",
                            "183",
                            "184",
                            "185",
                            "186",
                            "187",
                            "188",
                            "189",
                            "190", 
                            "191", 
                            "192", 
                            "193", 
                            "194", 
                            "195", 
                            "196", 
                            "197", 
                            "198", 
                            "199", 
                            "200", 
                            "201", 
                            "202", 
                            "203", 
                            "204", 
                            "205", 
                            "206", 
                            "207", 
                            "208", 
                            "209", 
                            "210", 
                            "211", 
                            "212", 
                            "213", 
                            "214", 
                            "215", 
                            "216", 
                            "217", 
                            "218", 
                            "219", 
                            "220", 
                            "221", 
                            "222", 
                            "223", 
                            "224", 
                            "225", 
                            "226", 
                            "227", 
                            "228", 
                            "229", 
                            "230", 
                            "231", 
                            "232", 
                            "233", 
                            "234", 
                            "235", 
                            "236", 
                            "237", 
                            "238", 
                            "239", 
                            "240", 
                            "241", 
                            "242", 
                            "243", 
                            "244", 
                            "245", 
                            "246", 
                            "247", 
                            "248", 
                            "249", 
                            "250", 
                            "251", 
                            "252", 
                            "253", 
                            "254", 
                            "255", 
                            "256", 
                            "257", 
                            "258", 
                            "259", 
                            "260", 
                            "261", 
                            "262", 
                            "263", 
                            "264", 
                            "265", 
                            "266", 
                            "267", 
                            "268", 
                            "269", 
                            "270", 
                            "271", 
                            "272", 
                            "273", 
                            "274", 
                            "275", 
                            "276", 
                            "277", 
                            "278", 
                            "279", 
                            "280", 
                            "281", 
                            "282", 
                            "283", 
                            "284", 
                            "285", 
                            "286", 
                            "287", 
                            "288", 
                            "289", 
                            "290", 
                            "291", 
                            "292", 
                            "293", 
                            "294", 
                            "295", 
                            "296", 
                            "297", 
                            "298", 
                            "299", 
                            "300", 
                            "301", 
                            "302", 
                            "303", 
                            "304", 
                            "305", 
                            "306", 
                            "307", 
                            "308", 
                            "309", 
                            "310", 
                            "311", 
                            "312", 
                            "313", 
                            "314", 
                            "315", 
                            "316", 
                            "317", 
                            "318", 
                            "319", 
                            "320", 
                            "321", 
                            "322", 
                            "323", 
                            "324", 
                            "325", 
                            "326", 
                            "327", 
                            "328", 
                            "329", 
                            "330", 
                            "331", 
                            "332", 
                            "333", 
                            "334", 
                            "335", 
                            "336", 
                            "337", 
                            "338", 
                            "339", 
                            "340", 
                            "341", 
                            "342", 
                            "343", 
                            "344", 
                            "345", 
                            "346", 
                            "347", 
                            "348", 
                            "349", 
                            "350", 
                            "351", 
                            "352", 
                            "353", 
                            "354", 
                            "355", 
                            "356", 
                            "357", 
                            "358", 
                            "359", 
                            "360", 
                            "361", 
                            "362", 
                            "363", 
                            "364", 
                            "365", 
                            "366", 
                            "367", 
                            "368", 
                            "369", 
                            "370", 
                            "371", 
                            "372", 
                            "373", 
                            "374", 
                            "375", 
                            "376", 
                            "377", 
                            "378", 
                            "379", 
                            "380", 
                            "381", 
                            "382", 
                            "383", 
                            "384", 
                            "385", 
                            "386", 
                            "387", 
                            "388", 
                            "389", 
                            "390", 
                            "391", 
                            "392", 
                            "393", 
                            "394", 
                            "395", 
                            "396", 
                            "397", 
                            "398", 
                            "399", 
                            "400", 
                            "401", 
                            "402", 
                            "403", 
                            "404", 
                            "405", 
                            "406", 
                            "407", 
                            "408", 
                            "409", 
                            "410", 
                            "411", 
                            "412", 
                            "413", 
                            "414", 
                            "415", 
                            "416", 
                            "417", 
                            "418", 
                            "419", 
                            "420", 
                            "421", 
                            "422", 
                            "423", 
                            "424", 
                            "425", 
                            "426", 
                            "427", 
                            "428", 
                            "429", 
                            "430", 
                            "431", 
                            "432", 
                            "433", 
                            "434", 
                            "435", 
                            "436", 
                            "437", 
                            "438", 
                            "439", 
                            "440", 
                            "441", 
                            "442", 
                            "443", 
                            "444", 
                            "445", 
                            "446", 
                            "447", 
                            "448", 
                            "449", 
                            "450", 
                            "451", 
                            "452", 
                            "453", 
                            "454", 
                            "455", 
                            "456", 
                            "457", 
                            "458", 
                            "459", 
                            "460", 
                            "461", 
                            "462", 
                            "463", 
                            "464", 
                            "465", 
                            "466", 
                            "467", 
                            "468", 
                            "469", 
                            "470", 
                            "471", 
                            "472", 
                            "473", 
                            "474", 
                            "475", 
                            "476", 
                            "477", 
                            "478", 
                            "479", 
                            "480", 
                            "481", 
                            "482", 
                            "483", 
                            "484", 
                            "485", 
                            "486", 
                            "487", 
                            "488", 
                            "489", 
                            "490", 
                            "491", 
                            "492", 
                            "493", 
                            "494", 
                            "495", 
                            "496", 
                            "497", 
                            "498", 
                            "499", 
                            "500"]
    
    let maritalPicker = UIPickerView()
    let maritalData = ["Single", "Married", "Divorced", "Open", "Poly", "Triad", "No Idea"]
    
    let ethnicityPicker = UIPickerView()
    let ethnicityData = ["Black American", "Black African", "Black European", "Black Hispanic", "Hispanic", "Caribbean", "West Indian", "Puerto Rican", "Arabic", "Central American", "South American", "Native American", "East Asian", "South Asian", "West Asian", "Pacific Islander", "White American", "White European", "White Hispanic"]
    
    let bodyPicker = UIPickerView()
    let bodyData = ["Chub", "Bear", "Muscle Bear", "Stocky", "Jock", "Muscular", "Athletic", "Average", "Slim"]
    
    var PrivacyPolicyText = String()
    var EULAText = String()
    var AboutNoir = String()
    
    @IBAction func logoutClicked(_ sender: Any) {

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
    
    var activityIndicater = UIActivityIndicatorView()
    
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
        
        
        badge = 0
        UIApplication.shared.applicationIconBadgeNumber = badge
        
        let msgQuery = PFQuery(className: "Chat").whereKey("app", equalTo: APPLICATION).whereKey("toUser", contains: CURRENT_USER!)
        
        subscription = liveQueryClient.subscribe(msgQuery).handle(Event.created) { _, message in
            // This is where we handle the event
 
            if Thread.current != Thread.main {
                return DispatchQueue.main.async {
                    
                    badge += 1
                    self.notification(displayName: message["senderName"] as! String)
                    print("Got new message")
                    
                }
            } else {
                
                badge += 1
                self.notification(displayName: message["senderName"] as! String)
                print("Got new message")
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        registerForKeyboardNotifications()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(colorLiteralRed: 0.988, green: 0.685, blue: 0.000, alpha: 1.0)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        agePicker.dataSource = self
        agePicker.delegate = self
        
        heightPicker.dataSource = self
        heightPicker.delegate = self
        
        weightPicker.dataSource = self
        weightPicker.delegate = self
        
        maritalPicker.dataSource = self
        maritalPicker.delegate = self
        
        bodyPicker.dataSource = self
        bodyPicker.delegate = self
        
        ethnicityPicker.dataSource = self
        ethnicityPicker.delegate = self

        
        //binding textfield to picker
        userAgeTextField.inputView = agePicker
        userAgeTextField.inputAccessoryView = toolBar
        userHeightField.inputView = heightPicker
        userHeightField.inputAccessoryView = toolBar
        userWeightField.inputView = weightPicker
        userWeightField.inputAccessoryView = toolBar
        userEthnicityTextField.inputView = ethnicityPicker
        userEthnicityTextField.inputAccessoryView = toolBar
        userMaritalStatusTextField.inputView = maritalPicker
        userMaritalStatusTextField.inputAccessoryView = toolBar
        userBodyTextField.inputView = bodyPicker
        userBodyTextField.inputAccessoryView = toolBar


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
        
        if let about = PFUser.current()?["about"] as? String {
            userAboutTextField.text = about
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
        
        activityIndicater = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicater.center = self.view.center
        activityIndicater.hidesWhenStopped = true
        activityIndicater.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicater)
        activityIndicater.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let imageData = UIImageJPEGRepresentation(currentImageView.image!, 0.3)
        
        PFUser.current()?["mainPhoto"] = PFFile(name: "mainProfile.jpg", data: imageData!)
        PFUser.current()?["age"] = userAgeTextField.text
        PFUser.current()?["height"] = userHeightField.text
        PFUser.current()?["weight"] = userWeightField.text
        PFUser.current()?["marital"] = userMaritalStatusTextField.text
        PFUser.current()?["about"] = userAboutTextField.text
        PFUser.current()?["ethnicity"] = userEthnicityTextField.text
        PFUser.current()?["body"] = userBodyTextField.text
        
        PFUser.current()?.saveInBackground(block: {(success, error) in
            
            self.deregisterFromKeyboardNotifications()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                var displayErrorMessage = "Something went wrong while saving your profile. Please try again."
                
                if let errorMessage = error?.localizedDescription {
                    displayErrorMessage = errorMessage
                }
                
                self.dialogueBox(title: "Profile Error", messageText: displayErrorMessage)
            } else {
                
                self.performSegue(withIdentifier: "toUserTable", sender: self)
            }
            
        })
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true);
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        badge = 0
        UIApplication.shared.applicationIconBadgeNumber = badge

        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func donePicker(){
        
        self.view.endEditing(true)
    }
    
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
            
        } else if pickerView == weightPicker {
            return weightPickerData.count
        }

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
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
            
        } else if pickerView == weightPicker {
            return weightPickerData[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerView == agePicker {
            
            userAgeTextField.text = agePickerData[row]
            
            
        } else if pickerView == heightPicker {
            
            userHeightField.text = heightDataFeet[row]
            

        } else if pickerView == ethnicityPicker {
            
            userEthnicityTextField.text = ethnicityData[row]
            
            
        } else if pickerView == maritalPicker {
            
            userMaritalStatusTextField.text = maritalData[row]
            
            
        } else if pickerView == bodyPicker {
            
            userBodyTextField.text = bodyData[row]
            
            
        } else if pickerView == weightPicker {
            
            userWeightField.text = weightPickerData[row]
        }
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
    
    func notification(displayName: String){
        
        let chatNotification = UNMutableNotificationContent()
        chatNotification.title = "Noir Chat Notification"
        chatNotification.subtitle = "You Have a New Chat message from " + displayName
        chatNotification.badge = badge as NSNumber
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier:APPLICATION, content: chatNotification, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func commonActionSheet(title: String, message: String, whatCase: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        
        switch whatCase {
        case "delUser":
            let delete = UIAlertAction(title: "Delete", style: .default, handler: {(alert: UIAlertAction!) in self.deleteUserCurrent()})
            let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            break
        case "normal":
            let cancel = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(cancel)
            break
        default:
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            break
        }
        
        
        
        alert.popoverPresentationController?.sourceView = view
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteUserCurrent() {
        
        if PFUser.current() != nil {
            PFUser.current()?.deleteInBackground(block: { (deleteSuccessful, error) -> Void in
                print("success = \(deleteSuccessful)")
                PFUser.logOut()
            })
        }
        
    }


}
