//
//  DetailController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 18/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class generalDetail{
    var coinName:String = ""
    var coinAbbName:String = ""
    var totalNumber:Double = 0
    var exchangeName:String = ""
    var tradingPairs:String = ""
}

class DetailController: UIViewController{
    var menuitems = ["General","Transactions","Alerts"]
    let cryptoCompareClient = CryptoCompareClient()
    var coinDetail = CoinDetailData()
    var observer:NSObjectProtocol?
    var coinDetails = SelectCoin()
    let mainView = MainView()
    let allLossView = AllLossView()
    let realm = try! Realm()
    let coinDetailController = CoinDetailController()
    let general = generalDetail()
    var marketSelectedData = MarketTradingPairs()
    var globalMarketData = GlobalMarket.init()
    var refreshTimer: Timer!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        refreshTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setPriceChange), name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPage()
        refreshData()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadDetail"), object: nil)
    }
    
    //Remove the refresh notification (From market and tradingpairs change)
    deinit { 
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
    }
    
    //Load page data
    @objc func refreshPage(){
        let generalPage = coinDetailController.gerneralController
        let filterName = "coinAbbName = '" + coinDetails.selectCoinAbbName + "' "
        let selectItem = realm.objects(MarketTradingPairs.self).filter(filterName)
        generalPage.coinSymbol = coinDetails.selectCoinAbbName
        for value in selectItem{
            checkDataRiseFallColor(risefallnumber: value.totalRiseFall, label: allLossView.profitLoss,type:"Number")
            mainView.portfolioResult.text = scientificMethod(number:value.coinAmount) + " " + value.coinAbbName            
            checkDataRiseFallColor(risefallnumber: value.totalPrice, label: mainView.marketValueRsult, type: "Default")
            checkDataRiseFallColor(risefallnumber: value.transactionPrice, label: mainView.netCostResult, type: "Default")
            checkDataRiseFallColor(risefallnumber: value.singlePrice, label:  generalPage.totalNumber, type: "Default")
            generalPage.totalNumber.text = currencyName[priceType]! + generalPage.totalNumber.text!
            generalPage.tradingPairs.text = value.tradingPairsName
            generalPage.market.text = value.exchangeName
            general.coinAbbName = value.coinAbbName
            general.coinName = value.coinName
            general.exchangeName = value.exchangeName
            general.tradingPairs = value.tradingPairsName
            marketSelectedData.coinAbbName = value.coinAbbName
            marketSelectedData.coinName = value.coinName
            marketSelectedData.exchangeName = value.exchangeName
            marketSelectedData.tradingPairsName = value.tradingPairsName
            marketSelectedData.transactionPrice = value.transactionPrice
            marketSelectedData.coinAmount = value.coinAmount
            coinDetailController.transactionHistoryController.generalData = general
            generalPage.marketCapResult.text = String(globalMarketData.market_cap ?? 0.0)
            generalPage.volumeResult.text = String(globalMarketData.volume_24h ?? 0.0)
            generalPage.circulatingSupplyResult.text = String(globalMarketData.circulating_supply ?? 0.0)
        }
    }
    
    //refresh coin detail
    @objc func refreshData(){
        loadCoinPrice { (success) in
            if success{
                let coinNameId = self.getCoinName(coinAbbName: self.coinDetails.selectCoinAbbName)
                if coinNameId != 0 {
                    
                    //Get coin Market Data (Market Cap, Volume, Supply)
                    GetDataResult().getMarketCapCoinDetail(coinId: coinNameId, priceType: self.priceType){(globalMarket,bool) in
                        if bool {
                            DispatchQueue.main.async {
                                self.globalMarketData = globalMarket!
                                self.refreshPage()
                                self.coinDetailController.gerneralController.spinner.stopAnimating()
                            }
                        } else {
                            self.coinDetailController.gerneralController.spinner.stopAnimating()
                        }
                    }
                }
            } else{
                self.coinDetailController.gerneralController.spinner.stopAnimating()
            }
        }
    }
    
    //Re load the coin trading price
    func loadCoinPrice(completion:@escaping (Bool)->Void){
        coinDetailController.gerneralController.spinner.startAnimating()
        let filterName = "coinAbbName = '" + coinDetails.selectCoinAbbName + "' "
        let selectItem = realm.objects(MarketTradingPairs.self).filter(filterName)
        var tradingPairs:String = ""
        var exchangeName:String = ""
        
        for value in selectItem{
            exchangeName = value.exchangeName
            tradingPairs = value.tradingPairsName
        }
        
        marketSelectedData.exchangeName = exchangeName
        marketSelectedData.tradingPairsName = tradingPairs

        cryptoCompareClient.getTradePrice(from: marketSelectedData.coinAbbName, to: tradingPairs, exchange: exchangeName){ result in
            switch result{
            case .success(let resultData):
                for results in resultData!{
                    let single = Double(results.value)
                    
                    
                    self.transferPriceType(priceType: [self.priceType], walletData:self.marketSelectedData, single: single, eachCell: WalletsCell(), transactionPrice: self.marketSelectedData.transactionPrice)
                    completion(true)
                }
            case .failure(let error):
                print("the error \(error.localizedDescription)")
            }
        }
    }
    
    //Get currency rate and transfer trading price to specific currency
    func transferPriceType(priceType:[String],walletData:MarketTradingPairs,single:Double,eachCell:WalletsCell,transactionPrice:Double){
        GetDataResult().getCryptoCurrencyApi(from: walletData.tradingPairsName, to: priceType, price: single){success,jsonResult in
            if success{
                DispatchQueue.main.async {
                    var pricess:Double = 0
                    for result in jsonResult{
                        pricess = Double(result.value) * single
                    }
                    walletData.singlePrice = pricess
                    walletData.totalPrice = Double(pricess) * Double(walletData.coinAmount)
                    walletData.totalRiseFallPercent = ((walletData.totalPrice - transactionPrice) / transactionPrice) * 100
                    walletData.totalRiseFall = walletData.totalPrice - transactionPrice
                    self.realm.beginWrite()
                    
                    if self.realm.object(ofType: MarketTradingPairs.self, forPrimaryKey: walletData.coinAbbName) == nil {
                        self.realm.create(MarketTradingPairs.self,value:[walletData.coinName,walletData.coinAbbName,walletData.exchangeName,walletData.tradingPairsName,walletData.coinAmount,walletData.totalRiseFall,walletData.singlePrice,walletData.totalPrice,walletData.totalRiseFallPercent,walletData.transactionPrice,walletData.priceType])
                    } else {
                        self.realm.create(MarketTradingPairs.self,value:[walletData.coinName,walletData.coinAbbName,walletData.exchangeName,walletData.tradingPairsName,walletData.coinAmount,walletData.totalRiseFall,walletData.singlePrice,walletData.totalPrice,walletData.totalRiseFallPercent,walletData.transactionPrice,walletData.priceType],update:true)
                    }
                    try! self.realm.commitWrite()
                    self.refreshPage()
                }
            } else{
                    self.coinDetailController.gerneralController.spinner.stopAnimating()
                print("fail")
            }
        }
    }
    
    //Get coin Id
    func getCoinName(coinAbbName:String)->Int{
        let data = GetDataResult().getMarketCapCoinList()
        var coinId:Int = 0
        
        for value in data {
            if value.symbol == coinAbbName{
                coinId = value.id!
            }
        }
        if coinId == 0{
            self.coinDetailController.gerneralController.spinner.stopAnimating()
            let generalPage = coinDetailController.gerneralController
            generalPage.marketCapResult.text = "--"
            generalPage.volumeResult.text = "--"
            generalPage.circulatingSupplyResult.text = "--"
        }
        return coinId
    }
    
    //Get coin global price
    @objc func setPriceChange() {
        let candleData = coinDetailController.gerneralController.vc
        if let priceChange = candleData.priceChange, let priceChangeRatio = candleData.priceChangeRatio {
            checkDataRiseFallColor(risefallnumber: priceChange, label: coinDetailController.gerneralController.totalRiseFall,type: "number")
            checkDataRiseFallColor(risefallnumber: priceChangeRatio, label: coinDetailController.gerneralController.totalRiseFallPercent,type: "Percent")
            coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
        }
    }
    
    //Click edit button and pass data to the market reselect page
    @objc func edit(){
        let market = MarketSelectController()
        market.newTransaction.coinAbbName = general.coinAbbName
        market.newTransaction.coinName = general.coinName
        market.newTransaction.exchangName = general.exchangeName
        market.newTransaction.tradingPairsName = general.tradingPairs
        navigationController?.pushViewController(market, animated: true)
    }
    
    //Add child controller (coin details)
    func addChildViewControllers(childViewControllers:UIViewController,views:UIView){
        addChildViewController(childViewControllers)
        views.addSubview(childViewControllers.view)
        childViewControllers.view.frame = views.bounds
        childViewControllers.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewControllers.didMove(toParentViewController: self)
        
        //Constraints
        childViewControllers.view.translatesAutoresizingMaskIntoConstraints = false
        childViewControllers.view.topAnchor.constraint(equalTo: views.topAnchor).isActive = true
        childViewControllers.view.leftAnchor.constraint(equalTo: views.leftAnchor).isActive = true
        childViewControllers.view.widthAnchor.constraint(equalTo: views.widthAnchor).isActive = true
        childViewControllers.view.heightAnchor.constraint(equalTo: views.heightAnchor).isActive = true
    }
    
    //Set up layout constraints
    func setUpView(){
        coinDetailController.gerneralController.edit.addTarget(self, action: #selector(edit), for: .touchUpInside)
        view.backgroundColor = ThemeColor().themeColor()
        let titleLabel = UILabel()
        titleLabel.text = coinDetails.selectCoinName
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        view.addSubview(allLossView)
        view.addSubview(mainView)
        
        //AllLossView Constraint
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView]))
        
        //MainView Constraint
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView,"v1":mainView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-0-[v1(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView,"v1":mainView]))
        
        view.addSubview(coinDetailView)
        //coinDetailPage
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailView,"v1":mainView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailView,"v1":mainView]))
        addChildViewControllers(childViewControllers: coinDetailController, views: coinDetailView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var spinner:UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }
    
    var coinDetailView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
