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
//    var marketSelectedData = MarketTradingPairs()
    var globalMarketData = GlobalMarket.init()
    var refreshTimer: Timer!
    
    var GlobalData:Results<GlobalAverageObject>{
        get{
            let filterName = "coinAbbName = '" + coinDetails.selectCoinAbbName + "' "
            let objects = realm.objects(GlobalAverageObject.self).filter(filterName)
            return objects
        }
    }
    
    var assetsData:Results<Transactions>{
        get{
            let filterName = "coinAbbName = '" + coinDetails.selectCoinAbbName + "' "
            let objects = realm.objects(Transactions.self).filter(filterName)
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
        refreshPage()
        setPriceChange()
        
//        self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
        
//        refreshTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPriceChange), name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(updateMarketData), name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadDetail"), object: nil)
    }
    
    
    //Remove the refresh notification (From market and tradingpairs change)
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshDetailPage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
    }
    
    @objc func updateMarketData(){
        refreshPage()
    }
    
    //Load page data
    @objc func refreshPage(){
        let generalPage = coinDetailController.gerneralController
        let filterName = "coinAbbName = '" + coinDetails.selectCoinAbbName + "' "
        let selectItem = realm.objects(Transactions.self).filter(filterName)
        for value in selectItem{
            let candleChartDatas = candleChartData()
            candleChartDatas.coinSymbol = value.coinAbbName
            candleChartDatas.coinExchangeName = value.exchangeName
            candleChartDatas.coinTradingPairsName = value.tradingPairsName
            generalPage.candleChartDatas = candleChartDatas
                
            checkDataRiseFallColor(risefallnumber: value.currentRiseFall, label: allLossView.profitLoss,currency:value.tradingPairsName, type:"Number")
            mainView.portfolioResult.text = Extension.method.scientificMethod(number:value.totalAmount) + " " + value.coinAbbName
            checkDataRiseFallColor(risefallnumber: value.currentTotalPrice, label: mainView.marketValueRsult,currency:value.tradingPairsName, type: "Default")
            checkDataRiseFallColor(risefallnumber: value.currentNetValue, label: mainView.netCostResult,currency:value.tradingPairsName, type: "Default")
            checkDataRiseFallColor(risefallnumber: value.currentSinglePrice, label:  generalPage.totalNumber,currency:value.tradingPairsName, type: "Default")
            generalPage.exchangeButton.setTitle(value.exchangeName, for: .normal)
            generalPage.tradingPairButton.setTitle(value.coinAbbName + "/" +  value.tradingPairsName, for: .normal)
            general.coinAbbName = value.coinAbbName
            general.coinName = value.coinName
            general.exchangeName = value.exchangeName
            general.tradingPairs = value.tradingPairsName
//            marketSelectedData.coinAbbName = value.coinAbbName
//            marketSelectedData.coinName = value.coinName
//            marketSelectedData.exchangeName = value.exchangeName
//            marketSelectedData.tradingPairsName = value.tradingPairsName
//            marketSelectedData.transactionPrice = value.transactionPrice
//            marketSelectedData.coinAmount = value.totalAmount
            coinDetailController.transactionHistoryController.generalData = general
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
        let dispatchGroup = DispatchGroup()
        var currency:Double = 0
        var singlePrice:Double = 0
        
        
        if let assets = assetsData.first {
            dispatchGroup.enter()
            if assets.exchangeName == "Global Average"{
                URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + assets.coinAbbName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
                    if success{
                        if let responseResult = response["quotes"].array{
                            for results in responseResult{
                                if results["currency"].string ?? "" == priceType{
                                    singlePrice = results["data"]["price"].double ?? 0
                                }
                            }
                        }
                        dispatchGroup.leave()
                    } else{
                        dispatchGroup.leave()
                    }
                }
            } else{
                APIServices.fetchInstance.getExchangePriceData(from: assets.coinAbbName, to: assets.tradingPairsName, market: assets.exchangeName) { (success, response) in
                    if success{
                        singlePrice = response["RAW"]["PRICE"].double ?? 0
                        dispatchGroup.leave()
                    } else{
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.enter()
            APIServices.fetchInstance.getCryptoCurrencyApis(from: assets.tradingPairsName, to: [priceType]){ (success, response) in
                if success{
                    for result in response{
                        currency = (result.1.double) ?? 0
                    }
                    dispatchGroup.leave()
                } else{
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.enter()
        getRiseFallData(){success in
            if success{
                dispatchGroup.leave()
            } else{
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue:.main){
            if let assets = self.assetsData.first{
                try! self.realm.write {
                    assets.currentSinglePrice = singlePrice
                    assets.currentTotalPrice = assets.currentSinglePrice * assets.totalAmount
                    assets.currentNetValue = assets.transactionPrice * (1/currency)
                    assets.currentRiseFall = (assets.currentSinglePrice * assets.totalAmount) - (assets.transactionPrice * (1/currency))
                    assets.defaultCurrencyPrice = singlePrice * currency
                    assets.defaultTotalPrice = assets.defaultCurrencyPrice * assets.totalAmount
                    assets.totalRiseFallNumber = assets.defaultTotalPrice - assets.transactionPrice
                    assets.totalRiseFallPercent = ((assets.defaultTotalPrice - assets.transactionPrice) / assets.transactionPrice) * 100
                }
            }
            completion(true)
        }
    }

    //Get coin global price
    @objc func setPriceChange() {
        getRiseFallData(){_ in}
    }
    
    func getRiseFallData(completion:@escaping (Bool)->Void){
        var realmCoinAbbName = ""
        var realmTradingPairsName = ""
        var realmMarket = ""
        if let assets = assetsData.first {
            realmCoinAbbName = assets.coinAbbName
            realmTradingPairsName = assets.exchangeName == "Global Average" ? priceType : assets.tradingPairsName
            realmMarket = assets.exchangeName
        }
        
        if realmCoinAbbName != "" && realmTradingPairsName != "" && realmMarket != ""{
            APIServices.fetchInstance.getRiseFallPeriod(period: chartPeriod, from: realmCoinAbbName, to: realmTradingPairsName, market: realmMarket) { (success, response) in
                if success{
                    if response["Response"].string ?? "" == "Success"{
                        if let periodData = response["Data"].array{
                            let price = periodData.last!["close"].double! - periodData.first!["open"].double!
                            let change = (price /  periodData.first!["open"].double!) * 100
                            checkDataRiseFallColor(risefallnumber: price, label: self.coinDetailController.gerneralController.totalRiseFall,currency:realmTradingPairsName,type: "Number")
                            checkDataRiseFallColor(risefallnumber: change, label: self.coinDetailController.gerneralController.totalRiseFallPercent,currency:realmTradingPairsName,type: "Percent")
                            self.coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + self.coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
                            completion(true)
                        }
                    }
                } else{
                    completion(false)
                }
            }
        } else{
            completion(false)
        }
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
//        if #available(iOS 11.0, *) {
//            childViewControllers.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: views.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        } else {
//           childViewControllers.view.bottomAnchor.constraint(equalTo: views.bottomAnchor).isActive = true
//        }
        childViewControllers.view.leftAnchor.constraint(equalTo: views.leftAnchor).isActive = true
        childViewControllers.view.widthAnchor.constraint(equalTo: views.widthAnchor).isActive = true
        childViewControllers.view.heightAnchor.constraint(equalTo: views.heightAnchor).isActive = true
    }
    
    //Set up layout constraints
    func setUpView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        let factor = view.frame.width/375
        coinDetailController.gerneralController.factor = factor
        allLossView.factor = factor
        mainView.factor = factor
        //        coinDetailController.gerneralController.edit.addTarget(self, action: #selector(edit), for: .touchUpInside)
        coinDetailController.gerneralController.exchangeButton.addTarget(self, action: #selector(editMarket), for: .touchUpInside)
        coinDetailController.gerneralController.tradingPairButton.addTarget(self, action: #selector(editTradingPairs), for: .touchUpInside)
        view.backgroundColor = ThemeColor().blueColor()
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldFont(17*factor)
        titleLabel.text = coinDetails.selectCoinName
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
        addChildViewControllers(childViewControllers: coinDetailController, views: coinDetailView)
//        if #available(iOS 11.0, *) {
//            coinDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        } else {
//           coinDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        }

        
        
        
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
                    let filterName = "coinAbbName = '" + self.coinDetails.selectCoinAbbName + "' "
                    let statusItem = self.realm.objects(Transactions.self).filter(filterName)
                    if let object = statusItem.first{
                        try! self.realm.write {
                            object.exchangeName = values[i].title
                            object.tradingPairsName = tradingPairList[0]
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
        picker.title = "Market"
        let filterName = "coinAbbName = '" + self.coinDetails.selectCoinAbbName + "' "
        let getCoinExchange = self.realm.objects(Transactions.self).filter(filterName)
        let exchangList = getTradingPairsList(market: getCoinExchange[0].exchangeName)
        let values = exchangList.map{ TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndex) in
            for i in selectedIndex {
                //                self.titleTextField.text = values[i].title
                self.coinDetailController.gerneralController.tradingPairButton.setTitle(self.coinDetails.selectCoinAbbName + "/" + values[i].title
                    , for: .normal)
                //                let filterName = "coinAbbName = '" + self.coinDetails.selectCoinAbbName + "' "
                if let object = getCoinExchange.first{
                    try! self.realm.write {
                        object.tradingPairsName = values[i].title
                    }
                }
            }
            self.coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
        }
        picker.show()
    }
    
    func getExchangeList()->[String]{
        var allExchanges = [String]()
//        allExchanges.append("Global Average")
        let data = APIServices.fetchInstance.getExchangeList()
        for (key,value) in data{
            let exactMarket = value.filter{name in return name.key == self.coinDetails.selectCoinAbbName}
            if exactMarket.count != 0{
                allExchanges.append(key)
            }
        }
        allExchanges.sort{ $0.lowercased() < $1.lowercased() }
        allExchanges.insert("Global Average", at: 0)
        return allExchanges
    }
    
    func getTradingPairsList(market:String)->[String]{
        var allTradingPairs = [String]()
        if market == "Global Average"{
            allTradingPairs.append(priceType)
        } else{
            let data = APIServices.fetchInstance.getTradingCoinList(market: market,coin:self.coinDetails.selectCoinAbbName)
            if data != []{
                for pairs in data{
                    allTradingPairs.append(pairs)
                }
                allTradingPairs.sort{ $0.lowercased() < $1.lowercased() }
            }
        }
        return allTradingPairs
    }
    
    var coinDetailView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
