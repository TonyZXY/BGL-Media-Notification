//
//  MenuBar.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 29/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class DetailMenuBar:UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var factor:CGFloat?{
        didSet{
            setupView()
        }
    }
    
    var color = ThemeColor()
    var menuitems = [String]()
    
    var detailController:CoinDetailController?
    
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
    }
    
    func setupView(){
        menuitems.append(textValue(name: "general_detail"))
        menuitems.append(textValue(name: "transaction_detail"))
        menuitems.append(textValue(name: "alerts_detail"))
        collectionView.register(MenuCells.self, forCellWithReuseIdentifier: "cellId")
        
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
        horizontalBarView.backgroundColor = ThemeColor().blueColor()
        addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier:1/3).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3*factor!).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailController?.scrollToMenuIndex(menuIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MenuCells
        cell.menuLabel.text = menuitems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:frame.width / 3,height:frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCells: UICollectionViewCell{
    
    var color = ThemeColor()
    lazy var menuLabel:UILabel = {
        let factor = frame.width/125 //  iPhone X frame.width / 3
        let menuLabel = UILabel()
        menuLabel.font = UIFont.regularFont(16*factor)
        menuLabel.textColor = ThemeColor().textGreycolor()
        return menuLabel
    }()
    
    override var isHighlighted: Bool {
        didSet {
            menuLabel.textColor = isHighlighted ? ThemeColor().blueColor() : ThemeColor().textGreycolor()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? ThemeColor().blueColor() : ThemeColor().textGreycolor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        backgroundColor = ThemeColor().darkBlackColor()
        addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
