//
//  RankMenuView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

protocol RankMenuViewDelegate {
    /**
     customize what to do when menu is selected
     */
    func rankMenuView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

// Tab menu class
class RankMenuView : UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var customDelegate : RankMenuViewDelegate?
    
    var cellLabels : [String] = [""]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: RankMenuViewCell.registerID, for: indexPath) as! RankMenuViewCell
        cell.setContent(menuText: cellLabels[indexPath.row])
        if indexPath.row == 0 {
            cell.backgroundColor = .red
        }else{
            cell.backgroundColor = .blue
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/CGFloat(cellLabels.count), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        customDelegate?.rankMenuView(collectionView: collectionView, didSelectItemAt: indexPath)
    }
    
    func initSetup(){
        self.delegate = self
        self.dataSource = self
        self.register(RankMenuViewCell.self, forCellWithReuseIdentifier: RankMenuViewCell.registerID)
        self.isScrollEnabled = false
        self.bounces = false
        self.alwaysBounceHorizontal = false
        self.showsHorizontalScrollIndicator = false
    }
    
    /**
     create the collectionview with default .zero frame and flowlayout
     */
    convenience init(menuLabels:[String]){
        let layout = UICollectionViewFlowLayout()
        //            // to prevent cell to exceed the bound
        //            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.init(frame: .zero,collectionViewLayout: layout)
        initSetup()
        self.cellLabels = menuLabels
    }
}



class RankMenuViewCell: UICollectionViewCell{
    public static let registerID = "rankMenuCell"
    
    var menuLabel : UILabel = {
        let lb = UILabel()
        lb.text = "default"
        lb.backgroundColor = .white
        return lb
    }()
    
    /**
     responsible for setting any changeable content in cell
     */
    func setContent(menuText: String){
        self.menuLabel.text = menuText
    }
    
    func setupView(){
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
