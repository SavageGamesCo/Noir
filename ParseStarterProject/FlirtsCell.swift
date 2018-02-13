//
//  FlirtsCell.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class FlirtsCell: FavoritesCell {
    override lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.Colors.NOIR_GREY_DARK
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
}
