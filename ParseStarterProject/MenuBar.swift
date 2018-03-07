//
//  MenuBar.swift
//  What's The Tea?
//
//  Created by Lynx on 2/6/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse
import NotificationCenter


class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //setup my collectionview for the navigation buttons must be lazy var to get data source and delegate as self
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Constants.Colors.NOIR_NAV_BAR
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellID = "cellId"
    
    //array for icons
    let imageNames = ["earth-america-7", "local_dart_icon", "favorites_fire_icon","flirts_icon", "chat_icon"]
    
    var mainViewController: MainViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //register the cell
        collectionView.register(MenuCell.self,forCellWithReuseIdentifier: cellID)
        
        //add collection view to subviews
        addSubview(collectionView)
        
        //place collection view
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        //set the initial selected menu ite,
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: [])
        
        setupHorizontalBar()
        
        
        
    }
    
    
    
    
    var horizontalBarLeftanchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar(){
        
        let horizontalBarView = UIView()
        
        horizontalBarView.backgroundColor = Constants.Colors.NOIR_HIGHLIGHT
        
        addSubview(horizontalBarView)
        
        horizontalBarLeftanchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftanchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/6).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: IndexPath(item: 5, section: 0)) as! MenuCell
        mainViewController?.scrollToMenuIndex(menuIndex: indexPath.item)
        if imageNames[indexPath.item] == "chat_icon" {
            DispatchQueue.main.async {
                let currentInstallation = PFInstallation.current()
                currentInstallation?.badge = 0
                currentInstallation?.saveInBackground()
                cell.imageView.badge = String(describing: currentInstallation?.badge)
                collectionView.layoutIfNeeded()
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        
        cell.imageView.setImage(UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.tintColor = Constants.Colors.NOIR_HIGHLIGHT
        if imageNames[indexPath.item] == "chat_icon" {
            DispatchQueue.main.async {
                let currentInstallation = PFInstallation.current()
                if let currentBadgeCount = currentInstallation?.badge{
                    cell.imageView.badge = String(currentBadgeCount)
                }
            }
            
        }
        
        
        //        cell.backgroundColor = UIColor.blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / CGFloat(imageNames.count), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    let imageView: SSBadgeButton = {
        let button = SSBadgeButton()
        button.setImage(UIImage(named: "home-7")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = Constants.Colors.NOIR_MENU_TINT
        button.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: -25)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
//    let imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.image = UIImage(named: "home-7")?.withRenderingMode(.alwaysTemplate)
//        iv.tintColor = Constants.Colors.NOIR_MENU_TINT
//        return iv
//    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? Constants.Colors.NOIR_HIGHLIGHT : Constants.Colors.NOIR_MENU_TINT
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? Constants.Colors.NOIR_HIGHLIGHT : Constants.Colors.NOIR_MENU_TINT
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(28)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

