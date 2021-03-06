//
//  GloabalController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 23/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class GloabalController: UIViewController,ExchangeSelect{
    
    func setTradingPairs(tradingPair: String) {
        coinDetailController.gerneralController.exchangeButton.setTitle(tradingPair, for: .normal)
        updateMarketData()
    }
    
    func setExchangesName(exchangeName: String) {
        coinDetailController.gerneralController.exchangeButton.setTitle(exchangeName, for: .normal)
        
    }
    
    var newTransaction = Transactions()
    var selectStatus = "Global"
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
    var globalMarketData = GlobalMarket()
    var pageStatus = "Global"
    var coinAbbName = ""
    var exchangeName = ""
    var tradingPairs = ""
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var coinRealm:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self).filter("coinAbbName == %@", coinDetail.coinName)
        }
    }
    
    var GlobalData:Results<GlobalAverageObject>{
        get{
            let filterName = "coinAbbName = '" + coinDetail.coinName + "' "
            let objects = realm.objects(GlobalAverageObject.self).filter(filterName)
            return objects
        }
    }
    
    var WatchListData:Results<WatchListRealm>{
        get{
            let filterName = "coinAbbName = '" + coinDetail.coinName + "' "
            let objects = realm.objects(WatchListRealm.self).filter(filterName)
            return objects
        }
    }
    
    var chartPeriod:String{
        get{
            return UserDefaults.standard.string(forKey: "chartPeriod") ?? "Minute"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadData()
        setPriceChange()

        NotificationCenter.default.addObserver(self, selector: #selector(setPriceChange), name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarketData), name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMarketData), name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
    }
    
    @objc func updateMarketData(){
            self.coinDetailController.transactionHistoryController.historyTableView.switchRefreshHeader(to: .refreshing)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
    }
    
    @objc func reloadMarketData(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadAssetsTableView"), object: nil)
    }
    
    
    @objc func reloadData(completion:@escaping (Bool)->Void){
        let filterName = "coinAbbName = '" + coinDetail.coinName + "' "
        let selectItem = realm.objects(WatchListRealm.self).filter(filterName).sorted(byKeyPath: "date")
        for value in selectItem{
            coinAbbName = value.coinAbbName
            exchangeName = value.market
            tradingPairs = value.tradingPairsName
        }
        
        if selectItem.count != 0{
            if (selectItem.first?.market)! == "Huobi Australia"{
                APIServices.fetchInstance.getHuobiAuCoinPrice(coinAbbName: (selectItem.first?.coinAbbName)!, tradingPairName: (selectItem.first?.tradingPairsName)!, exchangeName: (selectItem.first?.market)!) { (response, success) in
                    if success{
                        print(response)
                        let closePrice = Double(response["tick"]["close"].string ?? "0") ?? 0
                        let openPrice = Double(response["tick"]["open"].string ?? "0") ?? 0
                        let price = ((closePrice - openPrice) / openPrice) * 100
                        let filterName = "coinAbbName = '" + self.coinAbbName + "' "
                        let statusItem = self.realm.objects(WatchListRealm.self).filter(filterName)
                        if let object = statusItem.first{
                            try! self.realm.write {
                                object.price = closePrice
                                object.profitChange = price
                            }
                        }
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }else{
                APIServices.fetchInstance.getExchangePriceData(from: (selectItem.first?.coinAbbName)!, to: (selectItem.first?.tradingPairsName)!, market: (selectItem.first?.market)!) { (success, response) in
                    if success{
                        print(response)
                        let singlePrice = response["RAW"]["PRICE"].double ?? 0
                        let profitChange = response["RAW"]["CHANGEPCT24HOUR"].double ?? 0
                        let filterName = "coinAbbName = '" + self.coinAbbName + "' "
                        let statusItem = self.realm.objects(WatchListRealm.self).filter(filterName)
                        if let object = statusItem.first{
                            try! self.realm.write {
                                object.price = singlePrice
                                object.profitChange = profitChange
                            }
                        }
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }
    }
    }
    
    func setUpView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        let factor = view.frame.width/375
        coinDetailController.gerneralController.factor = factor
        coinDetailController.transactionHistoryController.factor = factor
        coinDetailController.alertControllers.factor = factor
        coinDetailController.gerneralController.exchangeButton.setTitle(newTransaction.exchangeName, for: .normal)
        coinDetailController.gerneralController.exchangeButton.addTarget(self, action: #selector(editMarket), for: .touchUpInside)
        coinDetailController.gerneralController.tradingPairButton.addTarget(self, action: #selector(editTradingPairs), for: .touchUpInside)
        let generalPage = coinDetailController.gerneralController
        addChildViewControllers(childViewControllers: coinDetailController, views: view)
        
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        generalPage.scrollView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(generalPage.scrollView)
        })
        
        let titleLabel = UILabel()
        titleLabel.text = coinDetail.coinName
        titleLabel.font = UIFont.boldFont(17*factor)
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        if pageStatus != "WatchList"{
            generalPage.exchangeButton.isEnabled = false
            generalPage.tradingPairButton.isEnabled = false
        }
    }
    
    @objc func handleRefresh(_ scrollView:UIScrollView){
        refreshData(){success in
            if success{
                self.loadData()
                self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .normal(.success, 0.5))
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadGlobalNewMarketData"), object: nil)
            }else{
                self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    func refreshData(completion: @escaping (Bool)->Void){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        if pageStatus == "WatchList"{
            if WatchListData.first?.market == "Global Average"{
                if let coin = WatchListData.first{
                    APIServices.fetchInstance.getMarketCapOneCoinWatchListData(coinId:coin.coinId){(success,response) in
                        if success{
                            try! self.realm.write {
                                self.WatchListData[0].price = response["data"]["quotes"][priceType]["price"].double ?? 0
                                self.WatchListData[0].profitChange = response["data"]["quotes"][priceType]["percent_change_24h"].double ?? 0
                            }
                        } else{}
                        dispatchGroup.leave()
                    }
                } else{
                    dispatchGroup.leave()
                }
            }else{
                reloadData(){success in
                     dispatchGroup.leave()
                }
            }
        }else{
            if let coin = coinRealm.first{
                APIServices.fetchInstance.getMarketCapOneCoinData(coinId:coin.coinId){(success,response) in
                    if success{
                        try! self.realm.write {
                            self.GlobalData[0].price = response["data"]["quotes"][priceType]["price"].double ?? 0
                            self.GlobalData[0].percent24h = response["data"]["quotes"][priceType]["percent_change_24h"].double ?? 0
                        }
                    } else{}
                    dispatchGroup.leave()
                }
            } else{
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        getRiseFallData(){success in
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue:.main){
            completion(true)
        }
    }
    
    @objc func editMarket(){
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Market"
        let exchangList = getExchangeList()
        let values = exchangList.map{ TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndex) in
            for i in selectedIndex {
                let tradingPairList = self.getTradingPairsList(market: values[i].title)
                if tradingPairList.count != 0{
                    self.coinDetailController.gerneralController.exchangeButton.setTitle(values[i].title, for: .normal)
                    self.coinDetailController.gerneralController.tradingPairButton.setTitle(
                        self.coinDetail.coinName + "/" + tradingPairList[0], for: .normal)
                    let filterName = "coinAbbName = '" + self.coinDetail.coinName + "' "
                    let statusItem = self.realm.objects(WatchListRealm.self).filter(filterName)
                    if let object = statusItem.first{
                        try! self.realm.write {
                            object.market = values[i].title
                            object.tradingPairsName = tradingPairList[0]
                            if values[i].title == "Global Average"{
                                object.isGlobalAverage = true
                            } else{
                                object.isGlobalAverage = false
                            }
                        }
                    }
                }
            }
            self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
        }
        picker.show()
    }
    
    @objc func editTradingPairs(){
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Trading Pairs"
        let tradingPairsList = getTradingPairsList(market: self.WatchListData[0].market)
        let values = tradingPairsList.map{ TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndex) in
            for i in selectedIndex {
                //                self.titleTextField.text = values[i].title
                self.coinDetailController.gerneralController.tradingPairButton.setTitle(self.coinDetail.coinName + "/" + values[i].title
                    , for: .normal)
                let filterName = "coinAbbName = '" + self.coinDetail.coinName + "' "
                let statusItem = self.realm.objects(WatchListRealm.self).filter(filterName)
                if let object = statusItem.first{
                    try! self.realm.write {
                        object.tradingPairsName = values[i].title
                        if self.WatchListData[0].market == "Global Average" {
                            object.isGlobalAverage = true
                        } else {
                            object.isGlobalAverage = false
                        }
                    }
                }
               self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
            }
        }
        picker.show()
    }
    
    func getExchangeList()->[String]{
        var allExchanges = [String]()
        let data = APIServices.fetchInstance.getExchangeList()
        for (key,value) in data{
            let exactMarket = value.filter{name in return name.key == coinDetail.coinName}
            if exactMarket.count != 0{
                allExchanges.append(key)
            }
        }
        allExchanges.sort{ $0.lowercased() < $1.lowercased() }
        allExchanges.insert("Global Average", at: 0)
        if let index = allExchanges.index(of: "Huobi Australia") {
            allExchanges.remove(at: index)
            allExchanges.insert("Huobi Australia", at: 1)
        }
        return allExchanges
    }
    
    func getTradingPairsList(market:String)->[String]{
        var allTradingPairs = [String]()
        if market == "Global Average"{
            allTradingPairs.append(priceType)
        } else{
            let data = APIServices.fetchInstance.getTradingCoinList(market: market,coin:coinDetail.coinName)
            if data != []{
                for pairs in data{
                    allTradingPairs.append(pairs)
                }
                allTradingPairs.sort{ $0.lowercased() < $1.lowercased() }
            }
        }
        return allTradingPairs
    }
    
    @objc func loadData(){
        let generalPage = coinDetailController.gerneralController
        if pageStatus == "WatchList"{
            general.coinAbbName = WatchListData[0].coinAbbName
            general.coinName = WatchListData[0].coinName
            general.exchangeName = WatchListData[0].market
            general.tradingPairs = WatchListData[0].tradingPairsName
            let candleChartDatas = candleChartData()
            candleChartDatas.coinSymbol = general.coinAbbName
            candleChartDatas.coinExchangeName = general.exchangeName
            candleChartDatas.coinTradingPairsName = general.tradingPairs
            generalPage.candleChartDatas = candleChartDatas
            checkDataRiseFallColor(risefallnumber: WatchListData[0].price, label: generalPage.totalNumber, currency: WatchListData[0].tradingPairsName, type: "Default")
            generalPage.exchangeButton.setTitle(WatchListData[0].market, for: .normal)
            generalPage.tradingPairButton.setTitle(WatchListData[0].coinAbbName + "/" + WatchListData[0].tradingPairsName, for: .normal)
        } else{
            generalPage.totalNumber.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number:coinRealm[0].price)
            general.coinAbbName = GlobalData[0].coinAbbName
            general.coinName = GlobalData[0].coinName
            general.exchangeName = "Global Average"
            general.tradingPairs = priceType
            let candleChartDatas = candleChartData()
            candleChartDatas.coinSymbol = general.coinAbbName
            candleChartDatas.coinExchangeName = general.exchangeName
            candleChartDatas.coinTradingPairsName = general.tradingPairs
            generalPage.candleChartDatas = candleChartDatas
            generalPage.exchangeButton.setTitle("Global Average", for: .normal)
            generalPage.tradingPairButton.setTitle(coinDetail.coinName + "/" + priceType, for: .normal)
            generalPage.exchangeButton.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
            generalPage.tradingPairButton.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
        }
        generalPage.marketCapResult.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number: GlobalData[0].marketCap )
        generalPage.volumeResult.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number: GlobalData[0].volume24 )
        generalPage.circulatingSupplyResult.text = Extension.method.scientificMethod(number: GlobalData[0].circulatingSupply )
        generalPage.candleChartDatas?.coinSymbol = coinDetail.coinName
        general.coinAbbName = coinDetail.coinName
        coinDetailController.transactionHistoryController.generalData = general
        coinDetailController.alertControllers.coinName.coinAbbName = general.coinAbbName
        coinDetailController.alertControllers.coinName.status = true
        coinDetailController.alertControllers.coinName.coinName = general.coinName
    }
    
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
    
    @objc func setPriceChange() {
        getRiseFallData(){_ in}
    }
    
    
    func getRiseFallData(completion:@escaping (Bool)->Void){
        var realmCoinAbbName = ""
        var realmTradingPairsName = ""
        var realmMarket = ""
        if pageStatus == "WatchList"{
            if let coin = WatchListData.first{
                realmCoinAbbName = coin.coinAbbName
                realmTradingPairsName = coin.tradingPairsName
                realmMarket = coin.market
            }
        }else{
            if let coin = coinRealm.first{
                realmCoinAbbName = coin.coinAbbName
                realmTradingPairsName = priceType
                realmMarket = "Global Average"
            }
        }
        
        if realmCoinAbbName != "" && realmTradingPairsName != "" && realmMarket != ""{
            if realmMarket == "Huobi Australia"{
                self.getHuobiRiseFallData(chartPeriod: chartPeriod, realmCoinAbbName: realmCoinAbbName, realmTradingPairsName: realmTradingPairsName, realmMarket: realmMarket){
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
    
    
    func getHuobiRiseFallData(chartPeriod: String, realmCoinAbbName: String, realmTradingPairsName: String, realmMarket: String,completion:@escaping (Bool)->Void){
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
                        //                            print(response["Data"].array)
                        if periodData != []{
                            let price = periodData.last!["close"].double! - periodData.first!["open"].double!
                            let change = (price /  periodData.first!["open"].double!) * 100
                            checkDataRiseFallColor(risefallnumber: price, label: self.coinDetailController.gerneralController.totalRiseFall,currency:realmTradingPairsName,type: "Number")
                            checkDataRiseFallColor(risefallnumber: change, label: self.coinDetailController.gerneralController.totalRiseFallPercent,currency:realmTradingPairsName,type: "Percent")
                            self.coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + self.coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
                        }
                    }
                    completion(true)
                } else{
                    completion(false)
                }
            } else{
                completion(false)
            }
        }
    }
}


