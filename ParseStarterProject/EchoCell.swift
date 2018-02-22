//
//  EchoCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import CoreLocation
import Sonar
import MapKit

class EchoCell: BaseCell {
    
    
    
    lazy var echoView: UIView = {
        
        let cv = UIView()
        cv.backgroundColor = Constants.Colors.NOIR_GREY_LIGHT
        
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .brown
        
        addSubview(echoView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: echoView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: echoView)
        
    }
    
    func setupEcho(){
        
    }
   
}
