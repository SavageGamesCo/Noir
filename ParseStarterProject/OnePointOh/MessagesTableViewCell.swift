//
//  MessagesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Lynx on 5/3/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var senderPic: UIImageView!
    
    @IBOutlet weak var senderName: UILabel!
    
    var userID = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
