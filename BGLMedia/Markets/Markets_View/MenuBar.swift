//
//  MenuBar.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 29/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class MenuBar:UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var color = ThemeColor()
    var menuitems = ["市场行情","收藏列表"]
    
    var marketController:MarketController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout:layout)
        cv.backgroundColor = color.themeColor()
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cellId")
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionView]))
        
        let selectindexpath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectindexpath as IndexPath, animated: false, scrollPosition:.left)
        
        setHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint:NSLayoutConstraint?
    func setHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.white
        addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier:1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        marketController?.scrollToMenuIndex(menuIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MenuCell
        cell.menuLabel.text = menuitems[indexPath.row]
        //        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width / 2,height:frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: UICollectionViewCell{
    var color = ThemeColor()
    let menuLabel:UILabel = {
        let menuLabel = UILabel()
        menuLabel.textColor = UIColor.gray
        return menuLabel
    }()
    
    override var isHighlighted: Bool {
        didSet {
            menuLabel.textColor = isHighlighted ? UIColor.white : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? UIColor.white : UIColor.gray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = color.themeColor()
        setupView()
    }
    
    func setupView(){
        addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
