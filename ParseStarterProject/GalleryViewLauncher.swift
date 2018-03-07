//
//  GalleryViewLauncher.swift
//  Noir
//
//  Created by Lynx on 2/28/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class GalleryImage: NSObject {
    let name: String
    let image: UIImage
    
    init(name: String, galleryImage: UIImage) {
        self.name = name
        self.image = galleryImage
    }
}

class GalleryViewLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    let blackView = UIView()
    
    let galleryCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.backgroundColor = Constants.Colors.NOIR_WHITE
        
        return collection
    }()
    
    let cellID = "cellID"
    let cellHeight: CGFloat = 50
    
    var images = [GalleryImage]()
    lazy var mainViewController: MainViewController = {
        let mainvc = MainViewController()
        
        return mainvc
    }()
    
    func showSettings(member: Member) {
        images.removeAll()
        
        let user = PFUser.query()
        
        user?.getObjectInBackground(withId: member.memberID!, block: { (gMember, error) in
            if let user = gMember as? PFUser {
                
                if user["mainPhoto"] != nil {
                    let imageFile = user["mainPhoto"] as! PFFile
                    imageFile.getDataInBackground(block: { (data, error) in
                        if let imageData = data {
                            
                            let image = GalleryImage(name: user.username!, galleryImage: UIImage(data: imageData)! )
                            self.images.append(image)
                            self.galleryCollectionView.reloadData()
                        }
                    })
                }
                
                
                if user["memberImageOne"] != nil {
                    let imageFile2 = user["memberImageOne"] as! PFFile
                    imageFile2.getDataInBackground(block: { (data, error) in
                        if let imageData = data {
                            
                            let image = GalleryImage(name: user.username!, galleryImage: UIImage(data: imageData)! )
                            self.images.append(image)
                            self.galleryCollectionView.reloadData()
                        }
                    })
                }
                
                
                
                if user["memberImageTwo"] != nil {
                    let imageFile3 = user["memberImageTwo"] as! PFFile
                    imageFile3.getDataInBackground(block: { (data, error) in
                        if let imageData = data {
                            
                            let image = GalleryImage(name: user.username!, galleryImage: UIImage(data: imageData)! )
                            self.images.append(image)
                            self.galleryCollectionView.reloadData()
                        }
                    })
                }
                
                
                if user["memberImageThree"] != nil {
                    let imageFile4 = user["memberImageThree"] as! PFFile
                    imageFile4.getDataInBackground(block: { (data, error) in
                        if let imageData = data {
                            
                            let image = GalleryImage(name: user.username!, galleryImage: UIImage(data: imageData)! )
                            self.images.append(image)
                            self.galleryCollectionView.reloadData()
                        }
                    })
                }
                
                
                if user["memberImageFour"] != nil {
                    let imageFile5 = user["memberImageFour"] as! PFFile
                    imageFile5.getDataInBackground(block: { (data, error) in
                        if let imageData = data {
                            
                            let image = GalleryImage(name: user.username!, galleryImage: UIImage(data: imageData)! )
                            self.images.append(image)
                            self.galleryCollectionView.reloadData()
                        }
                    })
                }
                
                
                
                
            }
            
            
        })
        
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blackViewDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(galleryCollectionView)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            if let flowLayout = galleryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                flowLayout.scrollDirection = .horizontal
                flowLayout.minimumLineSpacing = 0
//                flowLayout.minimumInteritemSpacing = 10
                flowLayout.itemSize = CGSize(width: window.frame.width, height: window.frame.height)
                
            }
            galleryCollectionView.frame = blackView.frame
            galleryCollectionView.isPagingEnabled = true
//            galleryCollectionView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.galleryCollectionView.alpha = 1
                
            }, completion: nil)
            
            
        }
        
    }
    
    @objc func blackViewDismiss(){
        handleDismiss()
    }
    
    func handleDismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.galleryCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.galleryCollectionView.frame.width, height: self.galleryCollectionView.frame.height)
            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath as IndexPath) as! GalleryCell
        
        let uImage = self.images[indexPath.item]
        cell.iconImageView.image = uImage.image
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: blackView.frame.width, height: blackView.frame.height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        handleDismiss()
        
    }
    
    
    
    override init() {
        super.init()
        
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        
        galleryCollectionView.register(GalleryCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
