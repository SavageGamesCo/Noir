//
//  FavoritesCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class FavoritesCell: GlobalCell {

    override func fetchMembers(){
        APIService.sharedInstance.fetchFavorites() { (fetchMembers: [Member]) in
            self.members = fetchMembers
            DispatchQueue.main.async {
                self.memberCollectionView.reloadData()
            }
        }
    }
    
    
    
}
