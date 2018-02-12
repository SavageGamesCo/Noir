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
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}


