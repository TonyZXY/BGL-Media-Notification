
//  WalletController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 3/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift



class WalletController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var color = ThemeColor()
    var image = AppImage()
    let realm = try! Realm()
    var allResult = try! Realm().objects(AllTransactions.self)
    var all = try! Realm().objects(MarketTradingPairs.self)
    let cryptoCompareClient = CryptoCompareClient()
    var walletResults = [MarketTradingPairs]()
    var displayType:String = "Percent"
//    let priceType:[String] = ["AUD"]
    var refreshTimer: Timer!
    var coinDetail = SelectCoin()
    var profit:Double = 0
    var loading:Int = 0
    var profitPrecent:Double = 0
    var totalProfit:Double = 0
    var totalAssets:Double = 0
    //    var walletResults = [MarketTradingPairs]()
    
    
    var allTransactions: Results<MarketTradingPairs> {
        get {
            return try! Realm().objects(MarketTradingPairs.self)
        }
    }
    
//    var priceType:String {
//        get{
//            var curreny:String = ""
//            if let defaultCurrency = UserDefaults.standard.value(forKey: "defaultCurrency") as? String{
//                curreny = defaultCurrency
//                return curreny
//            } else {
//                return curreny
//            }
//        }
//    }
    
    
    //The First Time load the Page
    override func viewDidLoad() {
        super.viewDidLoad()
        setWalletData()
        setUpBasicView()
        SetDataResult().writeJsonExchange()
        SetDataResult().writeMarketCapCoinList()
        GetDataResult().getCoinList()
        print(allResult)
        print(all)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        if let defaultCurrency = UserDefaults.standard.value(forKey: "defaultCurrency") as? String{
            print(defaultCurrency)
        }
    }
    
    //Every Time the Page appear will active this method
    override func viewWillAppear(_ animated: Bool) {
        if allResult.count == 0{
            setUpInitialView()
        } else {
            setupView()
        }
        setWalletData()
        reloadData()
        tabBarController?.tabBar.isHidden = false
    }
    
    // Refresh Table View Data
    
    
    
    
    //TableView Cell Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTransactions.count
    }
    
    //Each Table View Cell Create
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletsCell
        let assets = allTransactions[indexPath.row]
        cell.coinName.text = assets.coinName
        cell.coinAmount.text = String(assets.coinAmount) + assets.coinAbbName
        checkDataRiseFallColor(risefallnumber: assets.singlePrice, label: cell.coinSinglePrice, type: "Default")
        checkDataRiseFallColor(risefallnumber: assets.totalPrice, label:  cell.coinTotalPrice, type: "Default")
        cell.coinTotalPrice.text = "(" + cell.coinTotalPrice.text! + ")"
        if displayType == "Percent"{
             self.checkDataRiseFallColor(risefallnumber: assets.totalRiseFallPercent, label: cell.profitChange, type: "Percent")
        } else if displayType == "Number"{
            self.checkDataRiseFallColor(risefallnumber: assets.totalRiseFall, label: cell.profitChange, type: "Number")
        }
        cell.selectCoin.selectCoinAbbName = assets.coinAbbName
        cell.selectCoin.selectCoinName = assets.coinName
        cell.coinImage.coinImageSetter(coinName: assets.coinAbbName, width: 30, height: 30, fontSize: 5)
        return cell
    }
    
    //Combine all transacitons which have same coins
    func setWalletData(){
        walletResults = [MarketTradingPairs]()
        var list = [String]()
        let coinSelected = realm.objects(MarketTradingPairs.self)
        for value in allResult{
            let currencyResult = value.currency.filter{name in return name.name.contains(self.priceType)}
            if list.contains(value.coinName){
                let indexs = walletResults.index(where: { (item) -> Bool in
                    item.coinName == value.coinName
                })
                let filterName = "coinAbbName = '" + value.coinAbbName + "' "
                let coinSelected = coinSelected.filter(filterName)
                if coinSelected.count == 0{
                    walletResults[indexs!].tradingPairsName = value.tradingPairsName
                    walletResults[indexs!].exchangeName = value.exchangName
                } else {
                    for result in coinSelected{
                        walletResults[indexs!].exchangeName = result.exchangeName
                        walletResults[indexs!].tradingPairsName = result.tradingPairsName
                    }
                }
                if value.status == "Buy"{
                    walletResults[indexs!].coinAmount += value.amount
                    walletResults[indexs!].transactionPrice += (currencyResult.first?.price)! * value.amount
                }else if value.status == "Sell"{
                    walletResults[indexs!].coinAmount -= value.amount
                    walletResults[indexs!].transactionPrice -= (currencyResult.first?.price)! * value.amount
                }
            } else{
                let newWallet = MarketTradingPairs()
                newWallet.coinName = value.coinName
                newWallet.exchangeName = value.exchangName
                newWallet.coinAbbName = value.coinAbbName
                if value.status == "Buy"{
                    newWallet.coinAmount += value.amount
                    newWallet.transactionPrice += (currencyResult.first?.price)! * value.amount
                }else if value.status == "Sell"{
                    newWallet.coinAmount -= value.amount
                    newWallet.transactionPrice -= (currencyResult.first?.price)! * value.amount
                }
                newWallet.tradingPairsName = value.tradingPairsName
                walletResults.append(newWallet)
                list.append(value.coinName)
            }
        }
        walletList.reloadData()
    }
    
    @objc func refreshData(){
        setWalletData()
        reloadData()
    }
    
    func reloadData(){
        let dispatchGroup = DispatchGroup()
        self.totalAssets = 0
        self.totalProfit = 0
        for asset in walletResults{
            dispatchGroup.enter()
            CryptoCompareClient().getTradePrice(from: asset.coinAbbName, to: asset.tradingPairsName, exchange: asset.exchangeName){ result in
                switch result{
                case .success(let resultData):
                    for results in resultData!{
                        let single = Double(results.value)
                        GetDataResult().getCryptoCurrencyApi(from: asset.tradingPairsName, to: [self.priceType], price: single, completion: { (success, jsonResult) in
                            var pricess:Double = 0
                            for currency in jsonResult{
                                pricess = currency.value * single
                            }
                            asset.singlePrice = pricess
                            asset.totalPrice = pricess * asset.coinAmount
                            asset.totalRiseFall = asset.totalPrice - asset.transactionPrice
                            asset.totalRiseFallPercent = (asset.totalRiseFall / asset.transactionPrice) * 100
                            self.totalAssets += asset.totalPrice
                            self.totalProfit += asset.totalRiseFall
                            DispatchQueue.main.async {
                                self.realm.beginWrite()
                                let realmData:[Any] = [asset.coinName,asset.coinAbbName,asset.exchangeName,asset.tradingPairsName,asset.coinAmount,asset.totalRiseFall,asset.singlePrice,asset.totalPrice,asset.totalRiseFallPercent,asset.transactionPrice,"AUD"]
                                if self.realm.object(ofType: MarketTradingPairs.self, forPrimaryKey: asset.coinAbbName) == nil {
                                    self.realm.create(MarketTradingPairs.self, value: realmData)
                                } else {
                                    self.realm.create(MarketTradingPairs.self, value: realmData, update: true)
                                }
                                try! self.realm.commitWrite()
                            }
                            dispatchGroup.leave()
                        })
                    }
                case .failure(let error):
                    print("the error \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue:.main){
            self.caculateTotal()
            self.walletList.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    
    func caculateTotal(){
        totalNumber.text = currencyName[priceType]! + self.scientificMethod(number: totalAssets)
        self.checkDataRiseFallColor(risefallnumber: totalProfit, label: totalChange, type: "Number")
    }
    
    //Click Add Transaction Button Method
    @objc func changetotransaction(){
        let transaction = TransactionsController()
        self.navigationController?.pushViewController(transaction, animated: true)
    }
    
    //Refresh Method
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let cell:WalletsCell = walletList.cellForRow(at: indexPath) as! WalletsCell
            let filterName = "coinName = '" + cell.coinName.text! + "' "
            
            let statusItem = realm.objects(AllTransactions.self).filter(filterName)
            let marketResult = realm.objects(MarketTradingPairs.self).filter(filterName)
            try! realm.write {
                realm.delete(statusItem)
                realm.delete(marketResult)
            }
            refreshData()
        }
    }
    
    
    //Select specific coins and change to detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailPage = DetailController()
        let cell = self.walletList.cellForRow(at: indexPath) as! WalletsCell
        
        // Pass coin detail to detail page (etc, coin name)
        coinDetail = cell.selectCoin
        detailPage.coinDetails = coinDetail
        navigationController?.pushViewController(detailPage, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    

    
    //TableView Refresh Spinnner
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    func setUpBasicView(){
        view.backgroundColor = color.themeColor()
        
        //NavigationBar
        navigationController?.navigationBar.barTintColor =  color.themeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        let titilebarlogo = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        titilebarlogo.image = image.logoImage()
        titilebarlogo.contentMode = .scaleAspectFit
        navigationItem.titleView = titilebarlogo
        
    }
    
    
    func setUpInitialView(){
        view.addSubview(invisibleView)
        invisibleView.addSubview(buttonView)
        invisibleView.addSubview(hintMainView)
        invisibleView.addSubview(hintView)
        buttonView.addSubview(addTransactionButton)
        hintView.addSubview(hintLabel)
        hintMainView.addSubview(hintMainLabel)
        
        //View No transactions
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        
        
        //Main Hint View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainView,"v1":buttonView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(80)]-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainView,"v1":buttonView]))
        
        NSLayoutConstraint(item: hintMainLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: hintMainView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintMainLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: hintMainView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        hintMainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainLabel]))
        hintMainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainLabel]))
        
        
        //Button View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonView,"v1":hintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(60)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonView,"v1":hintView]))
        NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: invisibleView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -80).isActive = true
        NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: invisibleView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v5(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        
        //Hint Label View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView,"v1":buttonView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-5-[v0(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView,"v1":buttonView]))
        
        NSLayoutConstraint(item: hintLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: hintView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: hintView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
    }
    
    //Set Up View Layout
    func setupView(){
        //Add Subview
        view.addSubview(existTransactionView)
        existTransactionView.addSubview(totalProfitView)
        existTransactionView.addSubview(buttonView)
        existTransactionView.addSubview(filterButtonNumber)
        existTransactionView.addSubview(filterButtonPercent)
        existTransactionView.addSubview(walletList)
        walletList.addSubview(self.refresher)
        
        totalProfitView.addSubview(totalLabel)
        totalProfitView.addSubview(totalNumber)
        totalProfitView.addSubview(totalChange)
        buttonView.addSubview(addTransactionButton)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":existTransactionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":existTransactionView]))
        
        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        
        //        Total Profit View Constraints(总资产)
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView]))
        
        NSLayoutConstraint(item: totalLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalChange, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        totalProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":totalLabel,"v2":totalNumber,"v3":totalChange]))
        totalProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-10-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":totalLabel,"v2":totalNumber,"v3":totalChange]))
        
        //Add Transaction Button Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v4]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView,"v4":buttonView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-[v4(60)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView,"v4":buttonView]))
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v5(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        
        //Add filter Button Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v7(100)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v4":buttonView,"v7":filterButtonNumber]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v4]-10-[v7(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v4":buttonView,"v7":filterButtonNumber]))
        
        //Add filter Button Constraints
        NSLayoutConstraint(item: filterButtonNumber, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: filterButtonPercent, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v8(100)]-10-[v7]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v8":filterButtonPercent,"v7":filterButtonNumber]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v8(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v8":filterButtonPercent,"v7":filterButtonNumber]))
        
        
        //Wallet List Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v6]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":filterButtonNumber,"v6":walletList]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v7]-10-[v6]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":filterButtonNumber,"v6":walletList]))
        
    }
    
    var hintMainLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your portfolio starts here!"
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
        label.text = "We just need one or more transactions.Add your first transaction via the + button below"
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
        view.backgroundColor = color.walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalLabel:UILabel = {
        var label = UILabel()
        label.text = "总资产"
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalChange:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonView:UIView = {
        var view = UIView()
        view.backgroundColor = color.themeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var filterButtonNumber:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("总数", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
        button.titleLabel?.font = button.titleLabel?.font.withSize(15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().walletCellcolor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(setUpNumber), for: .touchUpInside)
        return button
    }()
    
    var filterButtonPercent:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("涨幅", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(15)
        button.setTitleColor(ThemeColor().themeColor(), for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(setUpPercent), for: .touchUpInside)
        return button
    }()
    
    @objc func setUpNumber(){
        displayType = "Number"
        filterButtonNumber.setTitleColor(ThemeColor().themeColor(), for: .normal)
        filterButtonNumber.backgroundColor = UIColor.white
        filterButtonPercent.setTitleColor(UIColor.white, for: .normal)
        filterButtonPercent.backgroundColor = ThemeColor().walletCellcolor()
        walletList.reloadData()
    }
    
    @objc func setUpPercent(){
        displayType = "Percent"
        filterButtonPercent.setTitleColor(ThemeColor().themeColor(), for: .normal)
        filterButtonPercent.backgroundColor = UIColor.white
        filterButtonNumber.setTitleColor(UIColor.white, for: .normal)
        filterButtonNumber.backgroundColor = ThemeColor().walletCellcolor()
        walletList.reloadData()
    }
    
    var spinner:UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView()
        spinner.tintColor = UIColor.white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    var addTransactionButton:UIButton = {
        var button = UIButton()
        button.setTitle("➕", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(25)
        button.tintColor = UIColor.black
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changetotransaction), for: .touchUpInside)
        return button
    }()
    
    lazy var walletList:UITableView = {
        var collectionView = UITableView()
        collectionView.separatorStyle = .none
        collectionView.backgroundColor = color.themeColor()
        collectionView.register(WalletsCell.self, forCellReuseIdentifier: "WalletCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



