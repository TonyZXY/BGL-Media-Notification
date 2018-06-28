//
//  MarketsCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 30/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class MarketsCell: UICollectionViewCell {
    
    var color = ThemeColor()
    var sortItems = [String]()
    var filterDateitems = ["1W","1D","1H"]
    let general = generalDetail()
    //排序窗口 sort window
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //总额view
    lazy var totalCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectview = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectview.backgroundColor = color.themeColor()
        return collectview
    }()
    
    //排序按钮
    let sortCoin:UITextField={
        var sort = UITextField()
        sort.tintColor = .clear
        sort.layer.borderColor = UIColor.white.cgColor
        sort.textColor = UIColor.white
        return sort
    }()
    
    //时间分类
    lazy var filterDate:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collect = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collect.backgroundColor = color.themeColor()
        return collect
    }()
    
    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.barTintColor = color.themeColor()
        searchBar.tintColor = color.themeColor()
        searchBar.backgroundColor = color.themeColor()
        searchBar.returnKeyType = .done
        return searchBar
    }()
    
    lazy var coinList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = color.themeColor()
        collectionView.register(MarketCollectionViewCell.self, forCellWithReuseIdentifier: "MarketCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupView(){
        addSubview(totalCollectionView)
        addSubview(sortCoin)
        addSubview(filterDate)
        addSubview(searchBar)
        addSubview(coinList)
        
        
        
        //总额View
        totalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        totalCollectionView.register(MarketsTotalView.self, forCellWithReuseIdentifier: "CellId")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalCollectionView]))
        
        //排序按钮
        sortCoin.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":totalCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":totalCollectionView]))
        
        //时间分类 Constraints
        filterDate.translatesAutoresizingMaskIntoConstraints = false
        filterDate.register(MarketFilterCollectionView.self, forCellWithReuseIdentifier: "SortDate")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(200)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":filterDate,"v1":sortCoin]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":filterDate,"v1":totalCollectionView]))
        
        //搜索栏
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":sortCoin]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":sortCoin]))
        
        //币种列表
        coinList.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

