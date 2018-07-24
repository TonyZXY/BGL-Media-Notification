//
//  WatchListsController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 11/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift

class WatchListsController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    let realm = try! Realm()
    
    var watchListObjects:Results<WatchListRealm>{
        get{
            return realm.objects(WatchListRealm.self)
        }
    }
    
    var realmObject:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getCoinData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateWatchList), name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshWatchList), name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(realm.objects(WatchListRealm.self))
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
    }
    
    @objc func updateWatchList(){
        self.coinList.reloadData()
    }
    
//    @objc func refreshWatchList(){
//        self.coinList.reloadData()
//    }
    
    lazy var coinList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = ThemeColor().themeColor()
        collectionView.register(WatchListCell.self, forCellWithReuseIdentifier: "WatchListCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical  = true
        return collectionView
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getCoinData()
    }
    
    func getCoinData(){
        URLServices.fetchInstance.getGlobalAverageCoinList(){ success in
            if success{
                let dispatchGroup = DispatchGroup()
                for result in self.watchListObjects{
                    if result.isGlobalAverage{
                        let coinObject = self.realmObject.filter("coinAbbName = %@", result.coinAbbName)
                        let watchListCoinObject = self.watchListObjects.filter("coinAbbName = %@", result.coinAbbName)
                        try! self.realm.write {
                            watchListCoinObject[0].price = coinObject[0].price
                            watchListCoinObject[0].profitChange = coinObject[0].percent24h
                        }
                    } else{
                        dispatchGroup.enter()
                        APIServices.fetchInstance.getExchangePriceData(from: result.coinAbbName, to: result.tradingPairsName, market: result.market) { (response,success) in
                            if success{
                                let watchListCoinObject = self.watchListObjects.filter("coinAbbName = %@", result.coinAbbName)
                                try! self.realm.write {
                                    watchListCoinObject[0].price = response["RAW"]["PRICE"].double ?? 0
                                    watchListCoinObject[0].profitChange = response["RAW"]["CHANGEPCT24HOUR"].double ?? 0
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue:.main){
                    self.coinList.reloadData()
                    self.refresher.endRefreshing()
                }
            } else{
                print("Fail to get Global Average CoinList")
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == coinList{
            return watchListObjects.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == coinList{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchListCell", for: indexPath) as! WatchListCell
            let object = watchListObjects[indexPath.row]
            cell.object = object
            checkDataRiseFallColor(risefallnumber: object.profitChange, label: cell.coinChange, type: "PercentDown")
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coinList{
            return CGSize(width:view.frame.width-10, height: 70)
        } else{
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coinList{
            return 10
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == coinList{
            return CGSize(width:view.frame.width, height: 10)
        } else{
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coinList{
            let cell = coinList.cellForItem(at: indexPath) as! WatchListCell
            let global = GloabalController()
            global.hidesBottomBarWhenPushed = true
            global.pageStatus = "WatchList"
            global.coinDetail.coinName = cell.coinLabel.text!
            navigationController?.pushViewController(global, animated: true)
        }
    }
    
    
    func setUpView(){
        view.addSubview(coinList)
        coinList.addSubview(refresher)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList]))
    }
}
