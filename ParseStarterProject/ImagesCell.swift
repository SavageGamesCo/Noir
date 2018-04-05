//
//  ImagesCell.swift
//  Noir
//
//  Created by Lynx on 3/16/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import Parse

class imagesCell: BaseCell {
    
    let tapOne = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    let tapTwo = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    let tapThree = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    let tapFour = UIGestureRecognizer(target: self, action: #selector(handleImageUpload))
    
    
    
    let imageOne: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageTwo: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageThree: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    let imageFour: UIImageView = {
        let member = PFUser.current()
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func setupViews() {
        backgroundColor = Constants.Colors.NOIR_RED_MEDIUM
        
        scrollView.addSubview(imageOne)
        scrollView.addSubview(imageTwo)
        scrollView.addSubview(imageThree)
        scrollView.addSubview(imageFour)
        
        let imageSizeSquared = self.frame.height - 10
        
        scrollView.addConstraintsWithFormat(format: "H:|-5-[v0(\(imageSizeSquared))]-5-[v1(\(imageSizeSquared))]-5-[v2(\(imageSizeSquared))]-5-[v3(\(imageSizeSquared))]-5-|", views: imageOne, imageTwo, imageThree, imageFour)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageOne)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageTwo)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageThree)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(\(imageSizeSquared))]-5-|", views: imageFour)
        
        addSubview(scrollView)
        
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
        
        
    }
    
    @objc func handleImageUpload() {
        
    }
}
