//
//  UserDetailsLauncher.swift
//  Noir
//
//  Created by Lynx on 2/12/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit
import MapKit

class Detail: NSObject {
    let label: String
    let detail: String
    
    init(label: String, detail: String) {
        self.label = label
        self.detail = detail
    }
}

class UserDetailsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let detailsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.backgroundColor = Constants.Colors.NOIR_RED_DARK
        collection.layer.cornerRadius = 5
        collection.layer.masksToBounds = true
        collection.layer.borderColor = Constants.Colors.NOIR_CG_ORANGE
        collection.layer.borderWidth = 2
        
        return collection
    }()
    
    let cellID = "cellID"
    let cellHeight: CGFloat = 27.5
    
    
    var details = [Detail]()
    
    lazy var mainViewController: MainViewController = {
        let mainvc = MainViewController()
        
        return mainvc
    }()
    
    func showDetails(member: Member?) {
        details.removeAll()
        if let window = UIApplication.shared.keyWindow {
            var age = String()
            var mHeight = String()
            var mWeight = String()
            var body = String()
            var race = String()
            var marital = String()
            var status = String()
            var about = String()
            var location = String()
            
            if let ageText = member?.age {
                age = ageText
            } else {
                age = "Unanswered"
            }
            if let heightText = member?.height {
                mHeight = heightText
            } else {
                mHeight = "Unanswered"
            }
            if let weightText = member?.weight {
                mWeight = weightText
            } else {
                mWeight = "Unanswered"
            }
            
            if let bodyText = member?.body {
                body = bodyText
            } else {
                body = "Unanswered"
            }
            
            if let raceText = member?.race {
                race = raceText
            } else {
                race = "Unanswered"
            }
            
            if let maritalText = member?.maritalStatus {
                marital = maritalText
            } else {
                marital = "Unanswered"
            }
            
            if let statusText = member?.status {
                status = statusText
            } else {
                status = "Unanswered"
            }
            
            if let aboutText = member?.about {
                about = aboutText
            } else {
                about = ""
            }
            if let locationText = member?.location {
                location = locationText
            } else {
                location = "Member Location Unavailable"
            }
            
            details = [Detail(label: "Location:", detail: location),Detail(label: "Age:", detail: age), Detail(label: "Height:", detail: mHeight), Detail(label: "Weight:", detail: mWeight), Detail(label: "Body Type:", detail: body), Detail(label: "Ethnicity:", detail: race), Detail(label: "Marital Status:", detail: marital), Detail(label: "HIV Status:", detail: status), Detail(label: "About:", detail: about), Detail(label: "Report", detail: "")]
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.7)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blackViewDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(detailsCollectionView)
            
            let height: CGFloat = CGFloat(details.count) * cellHeight
            let y = window.center.y - (height / 2)
            detailsCollectionView.frame = CGRect(x: window.center.x - (self.detailsCollectionView.frame.width / 2), y: window.frame.height, width: window.frame.width - 20, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            detailsCollectionView.alpha = 0
            
            detailsCollectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8)
            
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.detailsCollectionView.frame = CGRect(x: window.center.x - (self.detailsCollectionView.frame.width / 2), y: y, width: self.detailsCollectionView.frame.width, height: self.detailsCollectionView.frame.height)
                
                self.detailsCollectionView.alpha = 1
                
                
                
            }, completion: nil)
            
        }
        detailsCollectionView.reloadData()
    }
    
    @objc func blackViewDismiss(){
        let detail = Detail(label: "Cancel", detail: "none")
        handleDismiss(detail: detail)
    }
    
    func handleDismiss(detail: Detail){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.detailsCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.detailsCollectionView.frame.width, height: self.detailsCollectionView.frame.height)
            }
        }) { (completed: Bool) in
            
            if detail.label != "Report" {
                
            } else {
                //Report user code
            }
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath as IndexPath) as! DetailCell
        
        let detail = details[indexPath.item]
        cell.detail = detail
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let approximateWidthOfContent = detailsCollectionView.frame.width
        // x is the width of the logo in the left
        
        let size = CGSize(width: approximateWidthOfContent, height: 1000)
        
        //1000 is the large arbitrary values which should be taken in case of very high amount of content
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let estimatedFrame = NSString(string: details[indexPath.item].detail).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return CGSize(width: detailsCollectionView.frame.width, height: estimatedFrame.height + 8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detail = self.details[indexPath.item]
        handleDismiss(detail: detail)
        
    }
    
    
    
    override init() {
        super.init()
        
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        
        detailsCollectionView.register(DetailCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

