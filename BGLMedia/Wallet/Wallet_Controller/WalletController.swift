
//  WalletController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 3/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift



class WalletController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    var image = AppImage()
//    let realm = try! Realm()
    //    var all = try! Realm().objects(MarketTradingPairs.self)
    let cryptoCompareClient = CryptoCompareClient()
    //    var walletResults = [MarketTradingPairs]()
    var coinDetail = SelectCoin()
    var totalProfit:Double = 0
    var totalAssets:Double = 0
    var changeLaugageStatus:Bool = false
    var changeCurrencyStatus:Bool = false
    var countField:String = ""
    //    var walletResults = [MarketTradingPairs]()
    
    var assetss: Results<Transactions>{
        get{
            return try! Realm().objects(Transactions.self).sorted(byKeyPath: "publishDate")
        }
    }
    
    //The First Time load the Page
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBasicView()
        checkTransaction()
        
//        print(realm.objects(EachTransactions.self))
//        print(realm.objects(Transactions.self))
//        print(realm.objects(EachCurrency.self))
        DispatchQueue.main.async(execute: {
            //                    self.newsTableView.beginHeaderRefreshing()
            self.walletList.switchRefreshHeader(to: .refreshing)
        })
//        walletList.switchRefreshHeader(to: .refreshing)

        NotificationCenter.default.addObserver(self, selector: #selector(updateTransaction), name: NSNotification.Name(rawValue: "updateTransaction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTransaction), name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency), name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewMarketData), name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTransaction"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
    }
    
    @objc func reloadNewMarketData(){
        walletList.reloadData()
        caculateTotal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if changeLaugageStatus || changeCurrencyStatus{
//            if changeLaugageStatus{
//                walletList.switchRefreshHeader(to: .removed)
//                walletList.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
//                    self.handleRefresh(self.walletList)
//                })
//            }
//            self.changeLaugageStatus = false
//            self.changeCurrencyStatus = false
//            DispatchQueue.main.async(execute: {
//            self.walletList.switchRefreshHeader(to: .refreshing)
//            })
//        }
    }
    
    func checkTransaction(){
        if assetss.count == 0{
            setUpInitialView()
        } else {
            setupView()
        }
    }
    
    @objc func changeLanguage(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        checkTransaction()
        walletList.switchRefreshHeader(to: .removed)
        walletList.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
            self.handleRefresh(self.walletList)
        })
        DispatchQueue.main.async(execute: {
            self.walletList.switchRefreshHeader(to: .refreshing)
        })
    }
    
    @objc func changeCurrency(){
//        changeCurrencyStatus = true
        DispatchQueue.main.async(execute: {
            self.walletList.switchRefreshHeader(to: .refreshing)
        })
    }
    
    //TableView Cell Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetss.count
    }
    
    //Each Table View Cell Create
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletsCell
        cell.factor = factor
        let assets = assetss[indexPath.row]
        cell.coinName.text = assets.coinName
        cell.coinAmount.text = Extension.method.scientificMethod(number: assets.totalAmount) + " " + assets.coinAbbName
            
//            String(assets.totalAmount) + assets.coinAbbName
        checkDataRiseFallColor(risefallnumber: assets.defaultCurrencyPrice, label: cell.coinSinglePrice,currency:priceType, type: "Default")
        checkDataRiseFallColor(risefallnumber: assets.defaultTotalPrice, label: cell.coinTotalPrice,currency:priceType, type: "Default")
        cell.coinTotalPrice.text = "(" + cell.coinTotalPrice.text! + ")"
        cell.coinTotalPrice.textColor = ThemeColor().textGreycolor()
        checkDataRiseFallColor(risefallnumber: assets.totalRiseFallPercent, label: cell.profitChange,currency:priceType, type: "Percent")
        cell.profitChange.text = "(" + cell.profitChange.text! + ")"
        checkDataRiseFallColor(risefallnumber: assets.totalRiseFallNumber, label: cell.profitChangeNumber,currency:priceType, type: "Number")
        cell.selectCoin.selectCoinAbbName = assets.coinAbbName
        cell.selectCoin.selectCoinName = assets.coinName
        cell.coinImage.coinImageSetter(coinName: assets.coinAbbName, width: 30, height: 30, fontSize: 5)
        return cell
    }
    
    func loadData(completion:@escaping (Bool)->Void){
        let dispatchGroup = DispatchGroup()
        self.totalAssets = 0
        self.totalProfit = 0
        for result in assetss{
            var amount:Double = 0
            var transactionPrice:Double = 0
            var singlePrice:Double = 0
            var currency:Double = 0
            
            for each in result.everyTransactions{
                let currencyResult = each.currency.filter{name in return name.name.contains(priceType)}
                if each.status == "Buy"{
                    amount += each.amount
                    transactionPrice += ((each.amount) * (currencyResult.first?.price)!)
                } else if each.status == "Sell"{
                    amount -= each.amount
                    transactionPrice -= ((each.amount) * (currencyResult.first?.price)!)
                }
            }
            
            dispatchGroup.enter()
            if result.exchangeName == "Global Average"{
                URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + result.coinAbbName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
                    if success{
                        if let responseResult = response["quotes"].array{
                            for results in responseResult{
                                if results["currency"].string ?? "" == priceType{
                                    singlePrice = results["data"]["price"].double ?? 0
                                    APIServices.fetchInstance.getCryptoCurrencyApis(from: result.tradingPairsName, to: [priceType]) { (success, response) in
                                        if success{
                                            for result in response{
                                                currency = (result.1.double) ?? 0
                                            }
                                            let tran = Transactions()
                                            tran.coinAbbName = result.coinAbbName
                                            tran.transactionPrice = transactionPrice
                                            tran.defaultCurrencyPrice = singlePrice * currency
                                            tran.defaultTotalPrice = tran.defaultCurrencyPrice * amount
                                            tran.totalAmount = amount
                                            tran.totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                            tran.totalRiseFallPercent = (tran.totalRiseFallNumber / tran.transactionPrice) * 100
                                            
                                            self.totalAssets += tran.defaultTotalPrice
                                            self.totalProfit += tran.totalRiseFallNumber
                                            
                                            let object = try! Realm().objects(Transactions.self).filter("coinAbbName == %@",result.coinAbbName)
                                            try! Realm().write {
                                                if object.count != 0{
                                                    object[0].currentSinglePrice = singlePrice
                                                    object[0].currentTotalPrice = singlePrice * amount
                                                    object[0].currentNetValue = transactionPrice * (1/currency)
                                                    object[0].currentRiseFall = (singlePrice * amount) - (transactionPrice * (1/currency))
                                                    object[0].transactionPrice = transactionPrice
                                                    object[0].defaultCurrencyPrice = singlePrice * currency
                                                    object[0].defaultTotalPrice = (singlePrice * currency) * amount
                                                    object[0].totalAmount = amount
                                                    object[0].totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                                    object[0].totalRiseFallPercent =  tran.totalRiseFallPercent
                                                }
                                            }
                                            dispatchGroup.leave()
                                        } else{
                                            dispatchGroup.leave()
                                        }
                                    }
                                }
                            }
                        } else{
                            dispatchGroup.leave()
                        }
                    } else{
                        completion(false)
                        dispatchGroup.leave()
                    }
                }
            } else{
                APIServices.fetchInstance.getExchangePriceData(from: result.coinAbbName, to: result.tradingPairsName, market: result.exchangeName) { (success, response) in
                    if success{
                        singlePrice = response["RAW"]["PRICE"].double ?? 0
                        APIServices.fetchInstance.getCryptoCurrencyApis(from: result.tradingPairsName, to: [priceType]) { (success, response) in
                            if success{
                                for result in response{
                                    currency = (result.1.double) ?? 0
                                }
                                let tran = Transactions()
                                tran.coinAbbName = result.coinAbbName
                                tran.transactionPrice = transactionPrice
                                tran.defaultCurrencyPrice = singlePrice * currency
                                tran.defaultTotalPrice = tran.defaultCurrencyPrice * amount
                                tran.totalAmount = amount
                                tran.totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                tran.totalRiseFallPercent = (tran.totalRiseFallNumber / tran.transactionPrice) * 100
                                
                                self.totalAssets += tran.defaultTotalPrice
                                self.totalProfit += tran.totalRiseFallNumber
                                
                                let object = try! Realm().objects(Transactions.self).filter("coinAbbName == %@",result.coinAbbName)
                                try! Realm().write {
                                    if object.count != 0{
                                        object[0].currentSinglePrice = singlePrice
                                        object[0].currentTotalPrice = singlePrice * amount
                                        object[0].currentNetValue = transactionPrice * (1/currency)
                                        object[0].currentRiseFall = (singlePrice * amount) - (transactionPrice * (1/currency))                  
                                        object[0].transactionPrice = transactionPrice
                                        object[0].defaultCurrencyPrice = singlePrice * currency
                                        object[0].defaultTotalPrice = (singlePrice * currency) * amount
                                        object[0].totalAmount = amount
                                        object[0].totalRiseFallNumber = tran.defaultTotalPrice - tran.transactionPrice
                                        object[0].totalRiseFallPercent =  tran.totalRiseFallPercent
                                    }
                                }
                                dispatchGroup.leave()
                            } else{
                                completion(false)
                                dispatchGroup.leave()
                            }
                        }
                    } else{
                        completion(false)
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue:.main){
            completion(true)
        }
    }
    
    
    @objc func updateTransaction(){
        checkTransaction()
        loadData(){success in
            if success{
                self.caculateTotal()
                self.walletList.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
            }
        }
    }
    
    @objc func refreshData(){
        checkTransaction()
        self.walletList.beginHeaderRefreshing()
    }
    
    func caculateTotal(){
//        totalNumber.text = currencyName[priceType]! + " " + Extension.method.scientificMethod(number: totalAssets)
        var totalNumbers:Double = 0
        var totalChanges:Double = 0
        for result in assetss{
            totalNumbers += result.defaultTotalPrice
            totalChanges += result.totalRiseFallNumber
        }
        checkDataRiseFallColor(risefallnumber: totalNumbers, label: totalNumber,currency:priceType, type: "Default")
        checkDataRiseFallColor(risefallnumber: totalChanges, label: totalChange,currency:priceType, type: "Number")
    }
    
    //Click Add Transaction Button Method
    @objc func changetotransaction(){
        let transaction = TransactionsController()
        transaction.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(transaction, animated: true)
        
        //        let vc = CustomAlertController()
        //        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        //        self.addChildViewController(vc)
        //        view.addSubview(vc.view)
    }
    
    
    //Refresh Method
    @objc func handleRefresh(_ tableView:UITableView) {
        loadData(){success in
            if success{
                self.caculateTotal()
                self.walletList.reloadData()
                self.walletList.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                self.walletList.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let item = assetss[indexPath.row]
            let eachTransaction = item.everyTransactions
            try! Realm().write {
                try! Realm().delete(eachTransaction)
                try! Realm().delete(item)
            }
            checkTransaction()
            caculateTotal()
            self.walletList.reloadData()
          
//            refreshData()
        }
    }
    
    
    //Select specific coins and change to detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPage = DetailController()
        detailPage.hidesBottomBarWhenPushed = true
        let cell = self.walletList.cellForRow(at: indexPath) as! WalletsCell
        coinDetail = cell.selectCoin
        detailPage.coinDetails = coinDetail
        detailPage.coinDetailController.alertControllers.status = "detailPage"
        navigationController?.pushViewController(detailPage, animated: true)
    }
    
    //TableView Refresh Spinnner
    //    lazy var refresher: UIRefreshControl = {
    //        let refreshControl = UIRefreshControl()
    //        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
    //        refreshControl.tintColor = UIColor.white
    //        return refreshControl
    //    }()
    
    func setUpBasicView(){
        view.backgroundColor = ThemeColor().navigationBarColor()
        //NavigationBar
        let titilebarlogo = UIImageView()
        titilebarlogo.image = UIImage(named: "cryptogeek_icon_")
        titilebarlogo.contentMode = .scaleAspectFit
        titilebarlogo.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        titilebarlogo.clipsToBounds = true
        navigationItem.titleView = titilebarlogo
    }
    
    
    func setUpInitialView(){
        let factor = view.frame.width/375
        existTransactionView.removeFromSuperview()
        view.addSubview(invisibleView)
        invisibleView.addSubview(buttonView)
        invisibleView.addSubview(hintMainView)
        invisibleView.addSubview(hintView)
        buttonView.addSubview(addTransactionButton)
        hintView.addSubview(hintLabel)
        hintMainView.addSubview(hintMainLabel)
        
        
        hintMainLabel.text = textValue(name: "mainHint")
        hintMainLabel.font = UIFont.regularFont(23*factor)
        hintLabel.text = textValue(name: "hintLabel")
        hintLabel.font = UIFont.regularFont(13*factor)
        
        //View No transactions
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        
        
        //Main Hint View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainView,"v1":buttonView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(80*factor))]-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainView,"v1":buttonView]))
        
        NSLayoutConstraint(item: hintMainLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: hintMainView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintMainLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: hintMainView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        hintMainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainLabel]))
        hintMainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainLabel]))
        
        
        //Button View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonView,"v1":hintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(60*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonView,"v1":hintView]))
        NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: invisibleView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -80*factor).isActive = true
        NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: invisibleView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v5(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        
        //Hint Label View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView,"v1":buttonView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(5*factor)-[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView,"v1":buttonView]))
        
        NSLayoutConstraint(item: hintLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: hintView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: hintView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
    }
    
    //Set Up View Layout
    func setupView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        let factor = view.frame.width/375
        totalLabel.text = textValue(name:"mainBalance")
        totalLabel.font = UIFont.regularFont(20*factor)
        totalNumber.font = UIFont.boldFont(30*factor)
        totalChange.font = UIFont.regularFont(20*factor)
        addTransactionButton.layer.cornerRadius = 25*factor
        
        //Add Subview
        invisibleView.removeFromSuperview()
        view.addSubview(existTransactionView)
        existTransactionView.addSubview(totalProfitView)
        existTransactionView.addSubview(buttonView)
        existTransactionView.addSubview(walletList)
        totalProfitView.addSubview(totalLabel)
        totalProfitView.addSubview(totalNumber)
        totalProfitView.addSubview(totalChange)
        buttonView.addSubview(addTransactionButton)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":existTransactionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":existTransactionView]))
        
        //        Total Profit View Constraints(总资产)
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(\(150*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView]))
        
        NSLayoutConstraint(item: totalLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalChange, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        totalNumber.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
        totalNumber.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10).isActive = true
        totalChange.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
        totalChange.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10).isActive = true
        
        totalProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(10*factor)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":totalLabel,"v2":totalNumber,"v3":totalChange]))
        totalProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-\(10*factor)-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":totalLabel,"v2":totalNumber,"v3":totalChange]))
        
        //Add Transaction Button Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v4]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView,"v4":buttonView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-[v4(\(60*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView,"v4":buttonView]))
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v5(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        
        //Wallet List Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v6]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":buttonView,"v6":walletList]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v7]-\(10*factor)-[v6]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":buttonView,"v6":walletList]))
        
    }
    
    
    var hintMainLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = label.font.withSize(23)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var hintMainView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var hintLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.text = "We just need one or more transactions.Add your first transaction via the + button below"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var hintView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var existTransactionView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var invisibleView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    lazy var totalProfitView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalLabel:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalNumber:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.font = label.font.withSize(30)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalChange:UILabel = {
        var label = UILabel()
//        label.text = "--"
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var spinner:UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView()
        spinner.tintColor = UIColor.white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    var addTransactionButton:UIButton = {
        var button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "AddButton.png"), for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changetotransaction), for: .touchUpInside)
        return button
    }()
    
    lazy var walletList:UITableView = {
        let factor = view.frame.width/375
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(WalletsCell.self, forCellReuseIdentifier: "WalletCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12*factor)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        tableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(tableView)
        })
        tableView.rowHeight = 70*factor
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}


class newAlert:SCLAlertView{
    
}




