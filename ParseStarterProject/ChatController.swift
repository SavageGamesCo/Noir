//
//  ChatController.swift
//  Noir
//
//  Created by Lynx on 2/21/18.
//  Copyright © 2018 Savage Code. All rights reserved.
//

import UIKit

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var sender: Sender? {
        didSet{
            
            let navbar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: 50))
            view.addSubview(navbar)
            let navTitle = UINavigationItem()
            navTitle.title = sender?.name
            let dismissButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: nil, action: #selector(handleDismiss))
            navTitle.rightBarButtonItem = dismissButton
            navbar.setItems([navTitle], animated: true)
            
        }
    }
    
    var messages: [Message]?
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = Constants.Colors.NOIR_BACKGROUND
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .init(top: 35, left: 0, bottom: 0, right: 0)
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let counter = messages?.count {
            return counter
        }
        
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    

}

class ChatMessageCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .blue
        
    }
    
    
    
    
}
