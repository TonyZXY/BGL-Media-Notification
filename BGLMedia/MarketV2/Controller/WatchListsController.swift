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
//        setUpView()

        
        DispatchQueue.main.async(execute: {
            self.coinList.beginHeaderRefreshing()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(updateWatchList), name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshWatchList), name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if watchListObjects.count == 0{
            //            coinList.removeFromSuperview()
            setUpHintView()
        } else{
            //            hintView.removeFromSuperview()
            setUpView()
        }
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
    }
    
    @objc func updateWatchList(){
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
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
            return watchListObjects.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let factor = view.frame.width/414
        if collectionView == coinList{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchListCell", for: indexPath) as! WatchListCell
            cell.factor = factor
            let object = watchListObjects[indexPath.row]
            cell.object = object
            checkDataRiseFallColor(risefallnumber: object.profitChange, label: cell.coinChange, type: "PercentDown")
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let factor = view.frame.width/414
        if collectionView == coinList{
            return CGSize(width:view.frame.width-10*factor, height: 70*factor)
        } else{
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coinList{
            return 10 * view.frame.width/414
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
        
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        coinList.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(self.coinList)
        })
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList]))
    }
    
    func setUpHintView(){
        view.addSubview(hintView)
        hintView.addSubview(hintLabel)
        hintView.addSubview(starLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView]))
        
        
        let settingString = textValue(name: "hintLabel_watchlist")
        let myAttribute = [NSAttributedStringKey.font: UIFont.MediumFont(15), NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()]
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
        let myAttributes = [NSAttributedStringKey.font: UIFont.boldFont(30), NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()]
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
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
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
}
