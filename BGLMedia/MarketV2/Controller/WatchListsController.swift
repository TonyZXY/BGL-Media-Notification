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

    var index = 0
    var changeLaugageStatus:Bool = false
    var watchListObjects:Results<WatchListRealm>{
        get{
            return try! Realm().objects(WatchListRealm.self).sorted(byKeyPath: "date", ascending: false)
        }
    }
    
    var realmObject:Results<GlobalAverageObject>{
        get{
            return try! Realm().objects(GlobalAverageObject.self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinList.delegate = self
        coinList.dataSource = self
//        setUpView()

        DispatchQueue.main.async(execute: {
            self.coinList.beginHeaderRefreshing()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(updateWatchList), name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeMarketData), name: NSNotification.Name(rawValue: "reloadGlobalNewMarketData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency), name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshWatchList), name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
    }
    
    @objc func changeMarketData(){
        coinList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if watchListObjects.count == 0{
            //            coinList.removeFromSuperview()
            setUpHintView()
        } else{
            //            hintView.removeFromSuperview()
            setUpView()
        }
        
//        if changeLaugageStatus{
//            coinList.switchRefreshHeader(to: .removed)
//            coinList.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
//                self.handleRefresh(self.coinList)
//                self.changeLaugageStatus = false
//            })
//            coinList.switchRefreshHeader(to: .refreshing)
//        }
    }
    
    @objc func changeLanguage(){
//        changeLaugageStatus = true
        coinList.switchRefreshHeader(to: .removed)
        coinList.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
            self.handleRefresh(self.coinList)
            self.changeLaugageStatus = false
        })
        DispatchQueue.main.async(execute: {
            self.coinList.switchRefreshHeader(to: .refreshing)
        })
    }
    
    @objc func changeCurrency(){
        DispatchQueue.main.async(execute: {
            self.coinList.reloadData()
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadGlobalNewMarketData"), object: nil)
    }
    
    @objc func updateWatchList(){
        print(watchListObjects.count)
        if watchListObjects.count == 0{
            //            coinList.removeFromSuperview()
            setUpHintView()
        } else{
            //            hintView.removeFromSuperview()
            setUpView()
        }
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
        collectionView.register(ListViewCell.self, forCellWithReuseIdentifier: "ListViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        collectionView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(collectionView)
        })
        collectionView.alwaysBounceVertical  = true
        return collectionView
    }()
    

    
    @objc func handleRefresh(_ collectionView: UICollectionView) {
        getCoinData(){success in
            if success{
                self.coinList.reloadData()
                self.coinList.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                self.coinList.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    func getCoinData(completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        URLServices.fetchInstance.getGlobalAverageCoinList(){ success in
            if success{
                let objectResult = try! Realm().objects(WatchListRealm.self)
                let dispatchGroup = DispatchGroup()
                for result in objectResult{
                    if result.isGlobalAverage{
                        let coinObject = self.realmObject.filter("coinAbbName = %@", result.coinAbbName)
                        let watchListCoinObject = objectResult.filter("coinAbbName = %@", result.coinAbbName)
                        try! realm.write {
                            watchListCoinObject[0].price = coinObject[0].price
                            watchListCoinObject[0].profitChange = coinObject[0].percent24h
                        }
                    } else{
                        dispatchGroup.enter()
                        APIServices.fetchInstance.getExchangePriceData(from: result.coinAbbName, to: result.tradingPairsName, market: result.market) { (success,response) in
                            if success{
                                let watchListCoinObject = objectResult.filter("coinAbbName = %@", result.coinAbbName)
                                try! realm.write {
                                    watchListCoinObject[0].price = response["RAW"]["PRICE"].double ?? 0
                                    watchListCoinObject[0].profitChange = response["RAW"]["CHANGEPCT24HOUR"].double ?? 0
                                }
                                dispatchGroup.leave()
                            } else{
                                dispatchGroup.leave()
                            }
                        }
                    }
                }
                
                dispatchGroup.notify(queue:.main){
                    completion(true)
                }
            } else{
                completion(false)
                print("Fail to get Global Average CoinList")
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == coinList{
            return watchListObjects.count+1
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let factor = view.frame.width/414
        if collectionView == coinList{
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
                cell.factor = factor
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchListCell", for: indexPath) as! WatchListCell
                cell.factor = factor
                let object = watchListObjects[indexPath.row-1]
                cell.object = object
                cell.addWish.addTarget(self, action: #selector(deleteitem), for: .touchUpInside)
                checkDataRiseFallColor(risefallnumber: object.profitChange, label: cell.coinChange, type: "PercentDown")
                return cell
            }
        }else{
            return UICollectionViewCell()
        }
    }
    
    @objc func deleteitem(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 0, y: 0), to:coinList)
        let indexPath = coinList.indexPathForItem(at: buttonPosition)
        let cell = coinList.cellForItem(at: indexPath!) as! WatchListCell
        deleteCoinRealm(coin:cell.coinLabel.text!){
            success in
            if success{
                self.coinList.deleteItems(at: [indexPath!])
                if self.watchListObjects.count == 0{
                    self.coinList.removeFromSuperview()
                    self.setUpHintView()
                }
            }
        }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
        
        
        
//        let realm = try! Realm()
        
//        let watchList = try! Realm().objects(WatchListRealm.self).filter("coinAbbName = %@", cell.coinLabel.text)
//        realm.beginWrite()
//        if watchList.count == 1 {
//            cell.addWish.setTitleColor(ThemeColor().darkGreyColor(), for: .normal)
//            //            addWish.setClicked(false, animated: true)
//            realm.delete(watchList[0])
//        } else {
//            cell.addWish.setTitleColor(ThemeColor().blueColor(), for: .normal)
//        }
//        try! realm.commitWrite()
//
//        coinList.deleteItems(at: [indexPath!])
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
    }
    
    func deleteCoinRealm(coin:String,completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        let watchList = try! Realm().objects(WatchListRealm.self).filter("coinAbbName = %@", coin)
        realm.beginWrite()
//        if watchList.count == 1 {
//            addWish.setTitleColor(ThemeColor().darkGreyColor(), for: .normal)
            realm.delete(watchList[0])
//        } else {
//            addWish.setTitleColor(ThemeColor().blueColor(), for: .normal)
//        }
        try! realm.commitWrite()
        completion(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let factor = view.frame.width/414
        if collectionView == coinList{
            if indexPath.row == 0{
                return CGSize(width:view.frame.width, height: 30*factor)
            } else{
                return CGSize(width:view.frame.width-10*factor, height: 70*factor)
            }
        } else{
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coinList{
            if section == 0{
                 return 5 * view.frame.width/414
            } else{
                 return 5 * view.frame.width/414
            }
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == coinList{
            return CGSize(width:view.frame.width, height: 10*view.frame.width/414)
        } else{
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coinList{
            if indexPath.row != 0{
                let cell = coinList.cellForItem(at: indexPath) as! WatchListCell
                let global = GloabalController()
                global.hidesBottomBarWhenPushed = true
                global.pageStatus = "WatchList"
                global.coinDetailController.alertControllers.status = "detailPage"
                global.coinDetail.coinName = cell.coinLabel.text!
                navigationController?.pushViewController(global, animated: true)
            }
        }
    }
    
    
    func setUpView(){
        view.addSubview(coinList)
        view.addSubview(listView)
//        listView.addSubview(coinNameLabel)
//        listView.addSubview(volumeLabel)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":listView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":listView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":listView]))
        
//        coinNameLabel.centerYAnchor.constraint(equalTo: listView.centerYAnchor).isActive = true
//        coinNameLabel.topAnchor.constraint(equalTo: listView.topAnchor).isActive = true
//        coinNameLabel.bottomAnchor.constraint(equalTo: listView.bottomAnchor).isActive = true
//        coinNameLabel.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 10).isActive = true
//        volumeLabel.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -10).isActive = true
//        volumeLabel.centerYAnchor.constraint(equalTo: listView.centerYAnchor).isActive = true
//        volumeLabel.topAnchor.constraint(equalTo: listView.topAnchor).isActive = true
//        volumeLabel.bottomAnchor.constraint(equalTo: listView.bottomAnchor).isActive = true
        
    }
    
    func setUpHintView(){
        let factor = view.frame.width/375
        view.addSubview(hintView)
        hintView.addSubview(hintLabel)
        hintView.addSubview(starLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView]))
        
        
        let settingString = textValue(name: "hintLabel_watchlist")
        let myAttribute = [NSAttributedStringKey.font: UIFont.MediumFont(15*factor), NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()]
        let myString = NSMutableAttributedString(string: settingString, attributes: myAttribute )
        var greyStarRange = NSRange(location: 0, length: 0)
        var blueStarRange = NSRange(location: 0, length: 0)
        if defaultLanguage == "EN"{
            greyStarRange = NSRange(location: 53, length: 1)
            blueStarRange = NSRange(location: 65, length: 1)
        } else if defaultLanguage == "CN"{
            greyStarRange = NSRange(location: 24, length: 1)
            blueStarRange = NSRange(location: 33, length: 1)
        }
        myString.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeColor().textGreycolor(), range: greyStarRange)
        myString.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeColor().blueColor(), range: blueStarRange)
        hintLabel.attributedText = myString
        
        let settingStrings = "★ ⇥ ★"
        let myAttributes = [NSAttributedStringKey.font: UIFont.boldFont(30*factor), NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()]
        let myStrings = NSMutableAttributedString(string: settingStrings, attributes: myAttributes )
        let myRange1 = NSRange(location: 0, length: 1)
        let myRange2 = NSRange(location: 4, length: 1)
        myStrings.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeColor().textGreycolor(), range: myRange1)
        myStrings.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeColor().blueColor(), range: myRange2)
        starLabel.attributedText = myStrings
        
        NSLayoutConstraint(item: starLabel, attribute: .bottom, relatedBy: .equal, toItem: hintLabel, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: starLabel, attribute: .centerX, relatedBy: .equal, toItem: hintView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintLabel, attribute: .centerX, relatedBy: .equal, toItem: hintView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintLabel, attribute: .centerY, relatedBy: .equal, toItem: hintView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(20*factor)-[v0]-\(20*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
    }
    
    var hintView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var starLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        //        label.font = label.font.withSize(30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var hintLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var listView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var coinNameLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15)
        label.text = "Name"
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var volumeLabel:UILabel = {
        var label = UILabel()
        label.text = "24 Hour"
        label.font = UIFont.semiBoldFont(15)
         label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
