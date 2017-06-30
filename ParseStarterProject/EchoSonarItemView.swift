//
//  SonarItemView.swift
//  Noir
//
//  Created by Lynx on 6/29/17.
//  Copyright © 2017 Savage Code. All rights reserved.
//

import Foundation
import Sonar

class EchoSonarItemView: SonarItemView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.clipsToBounds = true
    }
    
}
