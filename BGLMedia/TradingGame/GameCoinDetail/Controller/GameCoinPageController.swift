//
//  GameCoinPageController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 9/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit
import RealmSwift

//class generalDetail{
//    var coinName:String = ""
//    var coinAbbName:String = ""
//    var totalNumber:Double = 0
//    var exchangeName:String = ""
//    var tradingPairs:String = ""
//}

/**
    mostly copied form DetailController
 */
class GameCoinPageController: UIViewController{
    let cryptoCompareClient = CryptoCompareClient()
//    var coinDetail = CoinDetailData()
    var observer:NSObjectProtocol?
    // views
    let mainView = MainView()
    let allLossView = AllLossView()
    let coinDetailController = GameCoinDetailController()
    
    var coinDetailView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let realm = try! Realm()
    let general = generalDetail()
    var globalMarketData = GlobalMarket.init()
    var refreshTimer: Timer!
    
    var gameBalanceController: GameBalanceController? {
        didSet {
            coinDetailController.gameBalanceController = gameBalanceController
        }
    }
    var coinDetail : GameCoin? {
        didSet {
            coinDetailController.coinDetail = coinDetail
        }
    }
    
    var GlobalData:Results<GlobalAverageObject>{
        get{
            let abbrName = coinDetail?.abbrName ?? ""
            let filterName = "coinAbbName = '" + abbrName + "' "
            let objects = realm.objects(GlobalAverageObject.self).filter(filterName)
            return objects
        }
    }

//    var assetsData:Results<Transactions>{
//        get{
//            let filterName = "coinAbbName = '" + (coinDetails?.abbrName ?? "") + "' "
//            let objects = realm.objects(Transactions.self).filter(filterName)
//            return objects
//        }
//    }
    
    var chartPeriod:String{
        get{
            return UserDefaults.standard.string(forKey: "chartPeriod") ?? "Minute"
        }
    }
    
//    var assetss: Results<Transactions>{
//        get{
//            return try! Realm().objects(Transactions.self).filter("coinAbbName = %@", coinDetails?.abbrName ?? "")
//        }
//    }
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        refreshPage()
        setPriceChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPriceChange), name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateMarketData), name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadMarketData), name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
    }
    
    
    //Remove the refresh notification (From market and tradingpairs change)
    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
    }
    
//    @objc func updateMarketData(){
//        if loginStatus{
//            RefreshDataService.refresh.caculateAssetsData(coinAbbName: self.coinDetails.selectCoinAbbName){success in
//                if success{
//                    self.refreshPage()
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAssetsTableView"), object: nil)
//                }
//            }
//            self.coinDetailController.transactionHistoryController.historyTableView.switchRefreshHeader(to: .refreshing)
//        }else{
//            RefreshDataService.refresh.caculateAssetsData(coinAbbName: coinDetails.selectCoinAbbName){success in
//                if success{
//                    self.refreshPage()
//                    self.coinDetailController.transactionHistoryController.historyTableView.switchRefreshHeader(to: .refreshing)
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAssetsTableView"), object: nil)
//                }
//            }
//        }
//    }

//    @objc func reloadMarketData(){
//        RefreshDataService.refresh.caculateAssetsData(coinAbbName: coinDetail?.abbrName ?? ""){success in
//            if success{
//                self.refreshPage()
//                //                    self.coinDetailController.transactionHistoryController.historyTableView.switchRefreshHeader(to: .refreshing)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAssetsTableView"), object: nil)
//            }
//        }
//    }
    
    
    //Load page data
    @objc func refreshPage(){
        let generalPage = coinDetailController.gerneralController
        let candleChartDatas = candleChartData()
        
        if coinDetail != nil{
            let detail = coinDetail!
            candleChartDatas.coinSymbol = detail.abbrName
            candleChartDatas.coinExchangeName = detail.exchangeName
            candleChartDatas.coinTradingPairsName = detail.tradingPairName
            generalPage.candleChartDatas = candleChartDatas

            checkDataRiseFallColor(risefallnumber: detail.profitNumber, label: allLossView.profitLoss,currency:detail.tradingPairName, type:"Number")
            mainView.portfolioResult.text = Extension.method.scientificMethod(number:detail.amount) + " " + detail.abbrName
            checkDataRiseFallColor(risefallnumber: detail.totalValue, label: mainView.marketValueRsult,currency:detail.tradingPairName, type: "Default")
            checkDataRiseFallColor(risefallnumber: detail.netValue, label: mainView.netCostResult,currency:detail.tradingPairName, type: "Default")
            checkDataRiseFallColor(risefallnumber: detail.price, label:  generalPage.totalNumber,currency:detail.tradingPairName, type: "Default")
            
            generalPage.exchangeButton.setTitle(detail.exchangeName, for: .normal)
            generalPage.tradingPairButton.setTitle(detail.abbrName + "/" +  detail.tradingPairName, for: .normal)
            general.coinAbbName = detail.abbrName
            general.coinName = detail.name
            general.exchangeName = detail.exchangeName
            general.tradingPairs = detail.tradingPairName
            coinDetailController.alertControllers.coinName.coinAbbName = general.coinAbbName
            coinDetailController.alertControllers.coinName.status = true
            coinDetailController.alertControllers.coinAbbName = general.coinAbbName
            coinDetailController.alertControllers.coinName.coinName = general.coinName
            generalPage.marketCapResult.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number: GlobalData[0].marketCap )
            generalPage.volumeResult.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number: GlobalData[0].volume24 )
            generalPage.circulatingSupplyResult.text = Extension.method.scientificMethod(number: GlobalData[0].circulatingSupply )
        }

        

        
    }
    
    //refresh coin detail
    @objc func refreshData(){
        loadData(){success in
            if success{
                self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .normal(.success, 0.5))
                self.refreshPage()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
            } else{
                self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }

    
    func loadData(completion:@escaping (Bool)->Void){
//        let dispatchGroup = DispatchGroup()
//        var currency:Double = 0
//        var singlePrice:Double = 0
        
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getCoinData"], httpMethod: "GET", parameters: [:]) { (response, success) in
            
            if success {
                let dataArray = response["data"].array
                
                for data in dataArray ?? []{
                    if data["coin_name"].stringValue == self.coinDetail?.abbrName.lowercased(){
                        self.coinDetail?.price = data["current_price"].doubleValue
                        print(self.coinDetail?.price ?? -11111)
                    }
                }
            }
        }
        
//        if let assets = assetsData.first {
//            dispatchGroup.enter()
        
//        // read current single price from markek
//        if coinDetail == nil {return}
//        if coinDetail!.exchangeName == "Global Average"{
//            URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + coinDetail!.abbrName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
//                if success{
//                    if let responseResult = response["quotes"].array{
//                        for results in responseResult{
//                            if results["currency"].string ?? "" == priceType{
//                                singlePrice = results["data"]["price"].double ?? 0
//                            }
//                        }
//                    }
//                }
//            }
//        }else if coinDetail?.exchangeName == "Huobi Australia"{
//            APIServices.fetchInstance.getHuobiAuCoinPrice(coinAbbName: coinDetail!.abbrName, tradingPairName: coinDetail!.tradingPairName, exchangeName: coinDetail!.exchangeName) { (response, success) in
//                if success{
//                    singlePrice = Double(response["tick"]["close"].string ?? "0") ?? 0
//                }
//            }
//        } else{
//            APIServices.fetchInstance.getExchangePriceData(from: coinDetail!.abbrName, to: coinDetail!.tradingPairName, market: coinDetail!.exchangeName) { (success, response) in
//                if success{
//                    singlePrice = response["RAW"]["PRICE"].double ?? 0
//                }
//            }
//        }
//
//        APIServices.fetchInstance.getCryptoCurrencyApis(from: coinDetail!.tradingPairName, to: [priceType]){ (success, response) in
//            if success{
//                for result in response{
//                    currency = (result.1.double) ?? 0
//                }
//            }
//        }
        
        getRiseFallData(){success in
            if success{
            }
        }
//        dispatchGroup.notify(queue:.main){
//            if let assets = self.assetsData.first{
//                try! self.realm.write {
//                    assets.currentSinglePrice = singlePrice
//                    assets.currentTotalPrice = assets.currentSinglePrice * assets.totalAmount
//                    assets.currentNetValue = assets.transactionPrice * (1/currency)
//                    assets.currentRiseFall = (assets.currentSinglePrice * assets.totalAmount) - (assets.transactionPrice * (1/currency))
//                    assets.defaultCurrencyPrice = singlePrice * currency
//                    assets.defaultTotalPrice = assets.defaultCurrencyPrice * assets.totalAmount
//                    assets.totalRiseFallNumber = assets.defaultTotalPrice - assets.transactionPrice
//                    assets.totalRiseFallPercent = ((assets.defaultTotalPrice - assets.transactionPrice) / assets.transactionPrice) * 100
//                }
//            }
//            completion(true)
//        }
        

        completion(true)
    }
    
    //Get coin global price
    @objc func setPriceChange() {
        getRiseFallData(){_ in}
    }
    
//    func getRiseFallData(completion:@escaping (Bool)->Void){
//        let realmCoinAbbName = coinDetail?.abbrName ?? ""
//        let realmTradingPairsName = coinDetail?.tradingPairName ?? ""
//        let realmMarket = coinDetail?.exchangeName ?? ""
////        if let assets = assetsData.first {
////            realmCoinAbbName = assets.coinAbbName
////            realmTradingPairsName = assets.exchangeName == "Global Average" ? priceType : assets.tradingPairsName
////            realmMarket = assets.exchangeName
////        }
//
//        if realmCoinAbbName != "" && realmTradingPairsName != "" && realmMarket != ""{
//            APIServices.fetchInstance.getRiseFallPeriod(period: chartPeriod, from: realmCoinAbbName, to: realmTradingPairsName, market: realmMarket) { (success, response) in
//                if success{
//                    if response["Response"].string ?? "" == "Success"{
//                        if let periodData = response["Data"].array{
//                            if periodData != []{
//                                let price = periodData.last!["close"].double! - periodData.first!["open"].double!
//                                let change = (price /  periodData.first!["open"].double!) * 100
//                                checkDataRiseFallColor(risefallnumber: price, label: self.coinDetailController.gerneralController.totalRiseFall,currency:realmTradingPairsName,type: "Number")
//                                checkDataRiseFallColor(risefallnumber: change, label: self.coinDetailController.gerneralController.totalRiseFallPercent,currency:realmTradingPairsName,type: "Percent")
//                                self.coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + self.coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
//                            }
//                        }
//                        completion(true)
//                    }else{
//                        completion(false)
//                    }
//                } else{
//                    completion(false)
//                }
//            }
//        } else{
//            completion(false)
//        }
//    }
    
    func getRiseFallData(completion:@escaping (Bool)->Void){
        let realmCoinAbbName = coinDetail?.abbrName ?? ""
        let realmTradingPairsName = coinDetail?.tradingPairName ?? ""
        let realmMarket = coinDetail?.exchangeName ?? ""
//        if let assets = assetsData.first {
//            realmCoinAbbName = assets.coinAbbName
//            realmTradingPairsName = assets.exchangeName == "Global Average" ? priceType : assets.tradingPairsName
//            realmMarket = assets.exchangeName
//        }
        
        if realmCoinAbbName != "" && realmTradingPairsName != "" && realmMarket != ""{
            if realmMarket == "Huobi Australia"{
                self.getHuobiAuRiseFallData(chartPeriod: chartPeriod, realmCoinAbbName: realmCoinAbbName, realmTradingPairsName: realmTradingPairsName, realmMarket: realmMarket){
                    success in
                    completion(true)
                }
            }else{
                self.getCryptoCompareData(chartPeriod: chartPeriod, realmCoinAbbName: realmCoinAbbName, realmTradingPairsName: realmTradingPairsName, realmMarket: realmMarket){
                    success in
                    completion(true)
                }
            }
        } else{
            completion(false)
        }
    }
    
    func getHuobiAuRiseFallData(chartPeriod: String, realmCoinAbbName: String, realmTradingPairsName: String, realmMarket: String,completion:@escaping (Bool)->Void){
        APIServices.fetchInstance.getHuobiAuRiseFallPeriod(period: chartPeriod, from: realmCoinAbbName, to: realmTradingPairsName, market: realmMarket){ (success, response) in
            if success{
                if response["status"].string ?? "" == "ok"{
                    if let periodData = response["data"].array{
                        if periodData != []{
                            let price = periodData.last!["close"].double! - periodData.first!["open"].double!
                            let change = (price /  periodData.first!["open"].double!) * 100
                            checkDataRiseFallColor(risefallnumber: price, label: self.coinDetailController.gerneralController.totalRiseFall,currency:realmTradingPairsName,type: "Number")
                            checkDataRiseFallColor(risefallnumber: change, label: self.coinDetailController.gerneralController.totalRiseFallPercent,currency:realmTradingPairsName,type: "Percent")
                            self.coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + self.coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
                        }
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
    }
    
    func getCryptoCompareData(chartPeriod: String, realmCoinAbbName: String, realmTradingPairsName: String, realmMarket: String,completion:@escaping (Bool)->Void){
        APIServices.fetchInstance.getRiseFallPeriod(period: chartPeriod, from: realmCoinAbbName, to: realmTradingPairsName, market: realmMarket) { (success, response) in
            if success{
                if response["Response"].string ?? "" == "Success"{
                    if let periodData = response["Data"].array{
                        if periodData != []{
                            let price = periodData.last!["close"].double! - periodData.first!["open"].double!
                            let change = (price / periodData.first!["open"].double!) * 100
                            checkDataRiseFallColor(risefallnumber: price, label: self.coinDetailController.gerneralController.totalRiseFall,currency:realmTradingPairsName,type: "Number")
                            checkDataRiseFallColor(risefallnumber: change, label: self.coinDetailController.gerneralController.totalRiseFallPercent,currency:realmTradingPairsName,type: "Percent")
                            self.coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + self.coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
                        }
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            } else{
                completion(false)
            }
        }
    }
    
    //Set up layout constraints
    func setUpView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        let factor = view.frame.width/375
        coinDetailController.gerneralController.factor = factor
        coinDetailController.transactionHistoryController.generalData = general
        allLossView.factor = factor
        mainView.factor = factor
//        coinDetailController.gerneralController.exchangeButton.addTarget(self, action: #selector(editMarket), for: .touchUpInside)
//        coinDetailController.gerneralController.tradingPairButton.addTarget(self, action: #selector(editTradingPairs), for: .touchUpInside)
        view.backgroundColor = ThemeColor().blueColor()
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldFont(17*factor)
        titleLabel.text = coinDetail?.name ?? ""
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        view.addSubview(allLossView)
        view.addSubview(mainView)
        
        //AllLossView Constraint
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(30*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView]))
        
        //MainView Constraint
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView,"v1":mainView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-0-[v1(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":allLossView,"v1":mainView]))
        
        view.addSubview(coinDetailView)
        //coinDetailPage
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailView,"v1":mainView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailView,"v1":mainView]))
        self.addChildViewController(childViewController: coinDetailController, view: coinDetailView)
        
        
        let generalPage = coinDetailController.gerneralController
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        generalPage.scrollView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(generalPage.scrollView)
        })
        
    }
    
    
    @objc func handleRefresh(_ scrollView:UIScrollView){
        refreshData()
    }
    
//    @objc func editMarket(){
//        var picker: TCPickerViewInput = TCPickerView()
//        picker.title = "Market"
//        let exchangList = getExchangeList()
//        let values = exchangList.map{ TCPickerView.Value(title: $0) }
//        picker.values = values
//        picker.delegate = self as? TCPickerViewOutput
//        picker.selection = .single
//        picker.completion = { (selectedIndex) in
//            for i in selectedIndex {
//                let tradingPairList = self.getTradingPairsList(market: values[i].title)
//                if tradingPairList.count != 0{
//                    let abbrName = self.coinDetail?.abbrName ?? ""
//                    let filterName = "coinAbbName = '" + abbrName + "' "
//                    let statusItem = self.realm.objects(Transactions.self).filter(filterName)
//                    if let object = statusItem.first{
//                        try! self.realm.write {
//                            object.exchangeName = values[i].title
//                            object.tradingPairsName = tradingPairList[0]
//                        }
//                    }
//                }
//            }
//            self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
//        }
//        picker.show()
//    }
//
//    @objc func editTradingPairs(){
//        var picker: TCPickerViewInput = TCPickerView()
//        picker.title = "Market"
//        let abbrName = coinDetail?.abbrName ?? ""
//        let filterName = "coinAbbName = '" + abbrName + "' "
//        let getCoinExchange = self.realm.objects(Transactions.self).filter(filterName)
//        let exchangList = getTradingPairsList(market: getCoinExchange[0].exchangeName)
//        let values = exchangList.map{ TCPickerView.Value(title: $0) }
//        picker.values = values
//        picker.delegate = self as? TCPickerViewOutput
//        picker.selection = .single
//        picker.completion = { (selectedIndex) in
//            for i in selectedIndex {
//                //                self.titleTextField.text = values[i].title
//                let abbrName = self.coinDetail?.abbrName ?? ""
//                self.coinDetailController.gerneralController.tradingPairButton.setTitle(abbrName + "/" + values[i].title
//                    , for: .normal)
//                //                let filterName = "coinAbbName = '" + self.coinDetails.selectCoinAbbName + "' "
//                if let object = getCoinExchange.first{
//                    try! self.realm.write {
//                        object.tradingPairsName = values[i].title
//                    }
//                }
//            }
//            self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
//        }
//        picker.show()
//    }
//
//    func getExchangeList()->[String]{
//        var allExchanges = [String]()
//        //        allExchanges.append("Global Average")
//        let data = APIServices.fetchInstance.getExchangeList()
//        for (key,value) in data{
//            let abbrName = coinDetail?.abbrName ?? ""
//            let exactMarket = value.filter{name in return name.key == abbrName}
//            if exactMarket.count != 0{
//                allExchanges.append(key)
//            }
//        }
//        allExchanges.sort{ $0.lowercased() < $1.lowercased() }
//        allExchanges.insert("Global Average", at: 0)
//        if let index = allExchanges.index(of: "Huobi Australia") {
//            allExchanges.remove(at: index)
//            allExchanges.insert("Huobi Australia", at: 1)
//        }
//        return allExchanges
//    }
//
//    func getTradingPairsList(market:String)->[String]{
//        var allTradingPairs = [String]()
//        if market == "Global Average"{
//            allTradingPairs.append(priceType)
//        } else{
//            let abbrName = self.coinDetail?.abbrName ?? ""
//            let data = APIServices.fetchInstance.getTradingCoinList(market: market,coin:abbrName)
//            if data != []{
//                for pairs in data{
//                    allTradingPairs.append(pairs)
//                }
//                allTradingPairs.sort{ $0.lowercased() < $1.lowercased() }
//            }
//        }
//        return allTradingPairs
//    }
    

}
