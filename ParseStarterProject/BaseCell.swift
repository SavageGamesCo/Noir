//
//  BaseCell.swift
//  What's The Tea?
//
//  Created by Lynx on 2/6/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let toolBar = UIToolbar()
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        DispatchQueue.main.async {
            self.setupViews()
            self.setupToolbar()
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
    
    func setupToolbar() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = Constants.Colors.NOIR_BLACK
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    @objc func donePicker(){
        
        endEditing(true)
    }
    
    func setupViews() {
        
    }
}


