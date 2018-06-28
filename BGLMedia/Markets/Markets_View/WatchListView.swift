//
//  WatchlistCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 1/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class WatchListView: UIView{
    
    var marketSortPickerView = MarketSortPickerView()
    var sortitems:[String]{
        get{
            return [textValue(name: "sortByLetter_market"),textValue(name: "sortByHighestPrice_market")]
        }
    }
    
    var sortdate:[String]{
        get{
            return [textValue(name: "filterByWeek_market"),textValue(name: "filterByDay_market"),textValue(name: "filterByHour_market")]
        }
    }
    let pickerview = UIPickerView()
    let general = generalDetail()
    var color = ThemeColor()
    
    
    
    var coinSymbolInWatchListRealm = try! Realm().objects(CoinsInWatchListRealm.self)
    var tickerDataRealmObjects = try! Realm().objects(TickerDataRealm.self)
    
    var filterDateSelection: Int?
    
    var sortOption: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //排序按钮
    let sortCoin:UITextField={
        var sort = UITextField()
        sort.tintColor = .clear
        sort.layer.borderColor = UIColor.white.cgColor
        sort.textColor = UIColor.white
        return sort
    }()
    
    //时间分类
    lazy var sortDate:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collect = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collect.backgroundColor = color.themeColor()
        return collect
    }()
    
//    //币种列表
//    lazy var coinList:UITableView = {
//        var coinlist=UITableView()
////        coinlist.backgroundColor = color.themeColor()
//        coinlist.backgroundColor = UIColor.red
//        coinlist.separatorStyle = .none
//        coinlist.rowHeight = 100
//        return coinlist
//    }()
    
    lazy var coinList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = color.themeColor()
        collectionView.register(MarketCollectionViewCell.self, forCellWithReuseIdentifier: "MarketCollectionViewCells")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //筛选日期
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortdate.count
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(marketSortPickerView)
        addSubview(sortDate)
        addSubview(coinList)
        
        
        //排序按钮
        marketSortPickerView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketSortPickerView,"v1":self]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketSortPickerView,"v1":self]))
        
        //时间分类 Constraints
        sortDate.translatesAutoresizingMaskIntoConstraints = false
        sortDate.register(MarketFilterCollectionView.self, forCellWithReuseIdentifier: "SortDate")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(200)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortDate,"v1":marketSortPickerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortDate,"v1":self,"v2":marketSortPickerView]))
        
        
        
        //币种列表
        coinList.translatesAutoresizingMaskIntoConstraints = false
//        coinList.register(MarketsCoinTableViewCell.self, forCellReuseIdentifier: "cellid")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":marketSortPickerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":marketSortPickerView]))
    }
}
