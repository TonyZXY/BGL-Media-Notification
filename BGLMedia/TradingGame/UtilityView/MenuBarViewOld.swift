//
//  RankMenuView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

protocol MenuBarViewDelegate {
    /**
     customize what to do when menu is selected
     */
    func menuBarView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

/**
    to use the class
    instatiate it with [String] parameter and assign delegate to controller
 */
class MenuBarViewOld : UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var customDelegate : MenuBarViewDelegate?
    let factor = UIScreen.main.bounds.width/375
    
    var cellLabels : [String] = [""]
    var textFont :UIFont?{
        didSet{
            menuViewCollection.reloadData()
            let selectindexpath = NSIndexPath(item: 0, section: 0)
            menuViewCollection.selectItem(at: selectindexpath as IndexPath, animated: false, scrollPosition:.left)
        }
    }
    
    lazy var menuViewCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout:layout)
        cv.backgroundColor = ThemeColor().themeColor()
        cv.delegate = self
        cv.dataSource = self
        cv.register(MenuViewCell.self, forCellWithReuseIdentifier: MenuViewCell.registerID)
//        cv.isScrollEnabled = false
        cv.bounces = false
        cv.alwaysBounceHorizontal = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var horizontalBarLeftAnchorConstraint:NSLayoutConstraint?
    func setHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = ThemeColor().themeWidgetColor()
        addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        let multiplier : CGFloat = CGFloat(1 / Float(self.cellLabels.count))
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3*factor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = menuViewCollection.dequeueReusableCell(withReuseIdentifier: MenuViewCell.registerID, for: indexPath) as! MenuViewCell
        cell.setContent(menuText: cellLabels[indexPath.row])
        cell.menuLabel.font = textFont ?? cell.menuLabel.font
//        if indexPath.row == 0 {
//            cell.backgroundColor = .red
//        }else{
//            cell.backgroundColor = .blue
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/CGFloat(cellLabels.count), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.menuBarView(collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    func initSetup(){
        addSubview(menuViewCollection)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuViewCollection)
        addConstraintsWithFormat(format: "V:|[v0]|", views: menuViewCollection)
        
        let selectindexpath = NSIndexPath(item: 0, section: 0)
        menuViewCollection.selectItem(at: selectindexpath as IndexPath, animated: false, scrollPosition:.left)
        
        setHorizontalBar()
    }
    
    /**
     create the collectionview with default .zero frame and flowlayout
     */
    convenience init(menuLabels:[String]){
        self.init()
        self.cellLabels = menuLabels
        initSetup()
    }
}



class MenuViewCell: UICollectionViewCell{
    let factor = UIScreen.main.bounds.width/375
    
    public static let registerID = "rankMenuCell"
    var color = ThemeColor()
    lazy var menuLabel : UILabel = {
        let menuLabel = UILabel()
        menuLabel.font = UIFont.regularFont(20*factor)
        menuLabel.textColor = ThemeColor().textGreycolor()
        return menuLabel
    }()
    
    override var isHighlighted: Bool {
        didSet {
            menuLabel.textColor = isHighlighted ? ThemeColor().themeWidgetColor() : ThemeColor().textGreycolor()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            menuLabel.textColor = isSelected ? ThemeColor().themeWidgetColor() : ThemeColor().textGreycolor()
        }
    }
    
    /**
     responsible for setting any changeable content in cell
     */
    func setContent(menuText: String){
        self.menuLabel.text = menuText
    }
    
    func setupView(){
        backgroundColor = color.themeColor()
        addSubview(menuLabel)
        menuLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: menuLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
