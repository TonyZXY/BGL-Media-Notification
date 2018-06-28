//
//  WatchListController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 4/6/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class WatchListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SortPickerViewDelegate {
    let watchList = WatchListView()
    
    
    var marketSortPickerView = MarketSortPickerView()
    var sortitems = [String]()
    var sortdate = ["1W","1D","1H"]
    let pickerview = UIPickerView()
    let general = generalDetail()
    var color = ThemeColor()
    
    var coinSymbolInWatchListRealm = try! Realm().objects(CoinsInWatchListRealm.self)
    var tickerDataRealmObjects = try! Realm().objects(TickerDataRealm.self)
    
    var filterDateSelection: Int?
    
    var sortOption: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getCoinWatchList()
        watchList.marketSortPickerView.sortPickerViewDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataAfterUpdateWatchList), name: NSNotification.Name(rawValue: "updateWatchInWatchList"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == watchList.sortDate{
            return watchList.sortdate.count
        } else if collectionView == watchList.coinList{
            return coinSymbolInWatchListRealm.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == watchList.sortDate{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortDate", for: indexPath) as! MarketFilterCollectionView
            cell.label.text = watchList.sortdate[indexPath.row]
            return cell
        } else if collectionView == watchList.coinList{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCells", for: indexPath) as! MarketCollectionViewCell
            cell.backgroundColor = color.themeColor()
            let object = tickerDataRealmObjects[indexPath.row]
            checkDataRiseFallColor(risefallnumber: [object.percent_change_7d, object.percent_change_24h, object.percent_change_1h][filterDateSelection ?? 0] ?? 0.0, label: cell.coinChange, type: "Percent")
//            cell.priceChange = [object.percent_change_7d, object.percent_change_24h, object.percent_change_1h][filterDateSelection ?? 0]
            cell.object = object
            cell.backgroundColor = ThemeColor().walletCellcolor()
            return cell
        } else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == watchList.sortDate{
            return CGSize(width:watchList.sortDate.frame.width / 3, height: watchList.sortDate.frame.height)
        } else if collectionView == watchList.coinList{
            return CGSize(width:watchList.frame.width-10, height: 70)
        } else{
            return CGSize()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == watchList.sortDate{
            return 0
        } else {
            return CGFloat()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == watchList.coinList{
            return 10
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == watchList.coinList{
            return CGSize(width:watchList.frame.width, height: 10)
        } else{
            return CGSize()
        }
    }
    
    func getCoinWatchList() {
        let allCoinsSymbol = coinSymbolInWatchListRealm.map {$0.symbol}
        tickerDataRealmObjects = try! Realm().objects(TickerDataRealm.self).filter("symbol in %@", Array(allCoinsSymbol))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == watchList.sortDate {
            filterDateSelection = indexPath.row
            watchList.coinList.reloadData()
        } else if collectionView == watchList.coinList{
            let cell = watchList.coinList.cellForItem(at: indexPath) as! MarketCollectionViewCell
            let global = GloabalController()
            global.coinDetail.coinName = cell.coinLabel.text!
            navigationController?.pushViewController(global, animated: true)
        }
    }
    
    func reloadDataSortedByName() {
        tickerDataRealmObjects = tickerDataRealmObjects.sorted(byKeyPath: "symbol", ascending: true)
        watchList.coinList.reloadData()
    }
    
    func reloadDataSortedByPrice() {
        tickerDataRealmObjects = tickerDataRealmObjects.sorted(byKeyPath: "price", ascending: false)
        watchList.coinList.reloadData()
    }
    
    @objc func reloadDataAfterUpdateWatchList() {
        getCoinWatchList()
        if let sortOption = sortOption {
            if sortOption == 0 {
                reloadDataSortedByName()
            } else {
                reloadDataSortedByPrice()
            }
        } else {
            watchList.coinList.reloadData()
        }
    }
    
    func setSortOption(option: Int) {
        sortOption = option
    }
    
    func setUpView(){
        view.addSubview(watchList)
        watchList.coinList.backgroundColor = ThemeColor().themeColor()
        watchList.sortDate.delegate = self
        watchList.sortDate.dataSource = self
        watchList.coinList.delegate = self
        watchList.coinList.dataSource = self
        watchList.backgroundColor = ThemeColor().themeColor()
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":watchList]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":watchList]))
    }
}
