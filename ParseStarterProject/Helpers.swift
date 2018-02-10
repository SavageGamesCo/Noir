//
//  Helpers.swift
//  Noir
//
//  Created by Lynx on 2/9/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIViewController {
    
    //Custom Dialogue Box
    func dialogueBox(title:String, messageText:String ){
        let dialog = UIAlertController(title: title, message: messageText, preferredStyle: .actionSheet)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        dialog.addAction(defaultAction)
        
        self.present(dialog, animated: true)
    }
}

