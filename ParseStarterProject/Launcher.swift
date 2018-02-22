//
//  Launcher.swift
//  Noir
//
//  Created by Lynx on 2/14/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class Launcher: UIViewController {
    
    override func viewDidLoad() {
        if PFUser.current() != nil {
            let layout = UICollectionViewFlowLayout()
            let mainViewController = MainViewController(collectionViewLayout: layout)
            
            self.navigationController?.popViewController(animated: true)
            self.navigationController?.pushViewController(mainViewController, animated: true)
            
        } else {
            
            let loginController = LoginController()
            self.navigationController?.present(loginController, animated: true, completion: nil)
            
        }
    }
}
