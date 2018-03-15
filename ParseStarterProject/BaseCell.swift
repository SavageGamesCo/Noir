//
//  BaseCell.swift
//  What's The Tea?
//
//  Created by Lynx on 2/6/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        DispatchQueue.main.async {
            self.setupViews()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStats(stack: UIStackView, statLabel: UILabel, statField: UITextField ) {
        stack.addSubview(statLabel)
        stack.addSubview(statField)
        stack.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: statLabel)
        stack.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: statField)
        stack.addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1]", views: statLabel, statField)
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: stack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: stack)
    }
    
    func setupViews() {
        
    }
}


