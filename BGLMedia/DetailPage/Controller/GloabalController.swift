//
//  GloabalController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 23/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

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
//    var coinData = try! Realm().objects(MarketTradingPairs.self)
//    var detail = MarketTradingPairs()
    let coinDetailController = CoinDetailController()
    let general = generalDetail()
//    var marketSelectedData = MarketTradingPairs()
    var globalMarketData = GlobalMarket()
    var pageStatus = "Global"
    var coinAbbName = ""
    var exchangeName = ""
    var tradingPairs = ""
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadData()
        //        getCoinGloablDetail()
        
//        coinDetailController.gerneralController.scrollView.switchRefreshHeader(to: .refreshing)
        
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(setPriceChange), name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMarketData), name: NSNotification.Name(rawValue: "updateSpecificMarket"), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateSpecificMarket"), object: nil)
    }
    
    @objc func updateMarketData(){
        reloadData(){ success in
            if success{
                self.loadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateWatchList"), object: nil)
            }
        }
    }
    
    
    @objc func reloadData(completion:@escaping (Bool)->Void){
        let filterName = "coinAbbName = '" + coinDetail.coinName + "' "
        let selectItem = realm.objects(WatchListRealm.self).filter(filterName)
        for value in selectItem{
            coinAbbName = value.coinAbbName
            exchangeName = value.market
            tradingPairs = value.tradingPairsName
        }
        
        APIServices.fetchInstance.getExchangePriceData(from: coinAbbName, to: tradingPairs, market: exchangeName) { (success, response) in
            if success{
                let singlePrice = response["RAW"]["PRICE"].double ?? 0
                APIServices.fetchInstance.getCryptoCurrencyApis(from: self.tradingPairs, to: [priceType]) { (success, response) in
                    if success{
                        var currency:Double = 0
                        for result in response{
                            currency = (result.1.double) ?? 0
                        }
                        let filterName = "coinAbbName = '" + self.coinAbbName + "' "
                        let statusItem = self.realm.objects(WatchListRealm.self).filter(filterName)
                        if let object = statusItem.first{
                            try! self.realm.write {
                                object.price = currency * singlePrice
                            }
                        }
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
            }else{
                completion(false)
            }
        }
    }
    
    
//        cryptoCompareClient.getTradePrice(from: coinAbbName, to: tradingPairs, exchange: exchangeName){ result in
//            //            print(result)
//            switch result{
//            case .success(let resultData):
//                for results in resultData!{
//                    let single = Double(results.value)
//                    //                    print(single)
//                    APIServices.fetchInstance.getCryptoCurrencyApi(from: self.tradingPairs, to: [priceType], price: single){success,jsonResult in
//                        //                        print(jsonResult)
//                        if success{
//                            DispatchQueue.main.async {
//                                var pricess:Double = 0
//                                for result in jsonResult{
//                                    pricess = Double(result.value) * single
//                                }
//
//                                let filterName = "coinAbbName = '" + self.coinAbbName + "' "
//                                let statusItem = self.realm.objects(WatchListRealm.self).filter(filterName)
//                                if let object = statusItem.first{
//                                    try! self.realm.write {
//                                        object.price = pricess
//                                    }
//                                }
//                                completion(true)
//                            }
//                        } else{
//                            self.coinDetailController.gerneralController.spinner.stopAnimating()
//                            completion(false)
//                            //                            print("fail")
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("the error \(error.localizedDescription)")
//            }
//        }
    
    
    func setUpView(){
        let factor = view.frame.width/375
        coinDetailController.gerneralController.factor = factor
        coinDetailController.transactionHistoryController.factor = factor
        coinDetailController.alertControllers.factor = factor
        coinDetailController.gerneralController.exchangeButton.setTitle(newTransaction.exchangeName, for: .normal)
        //        coinDetailController.gerneralController.edit.addTarget(self, action: #selector(edit), for: .touchUpInside)
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
        
        if pageStatus == "WatchList"{
            
        } else{
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
        if pageStatus == "WatchList"{
            if WatchListData.first?.market == "Global Average"{
                if let coin = WatchListData.first{
                    APIServices.fetchInstance.getMarketCapOneCoinWatchListData(coinId:coin.coinId){(success,response) in
                        if success{
                            try! self.realm.write {
                                self.WatchListData[0].price = response["data"]["quotes"][priceType]["price"].double ?? 0
                                self.WatchListData[0].profitChange = response["data"]["quotes"][priceType]["percent_change_24h"].double ?? 0
                            }
                            completion(true)
                        } else{
                            completion(false)
                        }
                    }
                } else{
                    completion(false)
                }
            } else{
                reloadData(){success in
                    if success{
                        completion(true)
                    }else{
                        completion(false)
                    }
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
                        completion(true)
                    } else{
                        completion(false)
                    }
                }
            } else{
                completion(false)
            }
        }
    }
    
    @objc func editMarket(){
        ////        let searchMarket = SearchExchangesController()
        //////        searchMarket.delegate = self
        ////        searchMarket.hidesBottomBarWhenPushed = true
        ////        navigationController?.pushViewController(searchMarket, animated: true)
        //        let alert = UIAlertController(style: .actionSheet, title: "Market")
        //
        //        alert.addLocalePicker()
        ////            alert.title = info?.currencyCode
        ////            alert.message = "is selected"
        //            // action with selected object
        //
        //        alert.addAction(title: "OK", style: .cancel)
        //        alert.show()
        
        //        let alert = UIAlertController(style: .actionSheet, message: "Select Country")
        //        alert.addLocalePicker(type: .country) { info in
        //            // action with selected object
        //        }
        //        alert.addAction(title: "OK", style: .cancel)
        //        alert.show()
        
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
                            object.isGlobalAverage = false
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
                        object.isGlobalAverage = false
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
        return allExchanges
    }
    
    func getTradingPairsList(market:String)->[String]{
        var allTradingPairs = [String]()
        let data = APIServices.fetchInstance.getTradingCoinList(market: market,coin:coinDetail.coinName)
        if data != []{
            for pairs in data{
                allTradingPairs.append(pairs)
            }
        }
        return allTradingPairs
    }
    
//    @objc func edit(){
//        let market = MarketSelectController()
//        market.newTransaction.coinAbbName = general.coinAbbName
//        market.newTransaction.coinName = general.coinName
//        market.newTransaction.exchangName = general.exchangeName
//        market.newTransaction.tradingPairsName = general.tradingPairs
//        market.selectStatus = "WatchList"
//        navigationController?.pushViewController(market, animated: true)
//    }
    
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
            
            generalPage.totalNumber.text = currecyLogo[priceType]! + Extension.method.scientificMethod(number:WatchListData[0].price)
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
    
    func loadMarketData(){
        //        let generalPage = coinDetailController.gerneralController
        //        generalPage.tradingPairs.text = WatchListData[0].coinAbbName + "/" + WatchListData[0].tradingPairsName
        //        generalPage.market.text = WatchListData[0].market
        
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
    
    //Get coins global data and Global Average Price
    //    func getCoinGloablDetail(){
    //        let coinNameId = self.getCoinName(coinAbbName: coinDetail.coinName)
    //        print(coinNameId)
    //        if coinNameId != 0 {
    //            GetDataResult().getMarketCapCoinDetail(coinId: coinNameId, priceTypes: priceType){(globalMarket,bool) in
    //                if bool {
    //                    DispatchQueue.main.async {
    //                         self.globalMarketData = globalMarket!
    //                         self.loadData()
    //                         self.coinDetailController.gerneralController.spinner.stopAnimating()
    //                    }
    //                } else {
    //                    self.coinDetailController.gerneralController.spinner.stopAnimating()
    //                }
    //            }
    //        }
    //    }
    
    //Get coin Id
    //    func getCoinName(coinAbbName:String)->Int{
    //        let data = GetDataResult().getMarketCapCoinList()
    //        var coinId:Int = 0
    //
    //        for value in data {
    //            if value.symbol == coinAbbName{
    //                coinId = value.id!
    //            }
    //        }
    //        if coinId == 0{
    //            self.coinDetailController.gerneralController.spinner.stopAnimating()
    //            let generalPage = coinDetailController.gerneralController
    //            generalPage.marketCapResult.text = "--"
    //            generalPage.volumeResult.text = "--"
    //            generalPage.circulatingSupplyResult.text = "--"
    //        }
    //        return coinId
    //    }
    
    @objc func setPriceChange() {
        let candleData = coinDetailController.gerneralController.vc
        if let priceChange = candleData.priceChange, let priceChangeRatio = candleData.priceChangeRatio {
            checkDataRiseFallColor(risefallnumber: priceChange, label: coinDetailController.gerneralController.totalRiseFall,type: "number")
            checkDataRiseFallColor(risefallnumber: priceChangeRatio, label: coinDetailController.gerneralController.totalRiseFallPercent,type: "Percent")
            coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
        }
    }
    
}


