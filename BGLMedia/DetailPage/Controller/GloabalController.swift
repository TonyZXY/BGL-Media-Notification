//
//  GloabalController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 23/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class GloabalController: UIViewController {
    var menuitems = ["General","Transactions","Alerts"]
    let cryptoCompareClient = CryptoCompareClient()
    var coinDetail = CoinDetailData()
    var observer:NSObjectProtocol?
    var coinDetails = SelectCoin()
    let mainView = MainView()
    let allLossView = AllLossView()
    let realm = try! Realm()
    var coinData = try! Realm().objects(MarketTradingPairs.self)
    var detail = MarketTradingPairs()
    let coinDetailController = CoinDetailController()
    let general = generalDetail()
    var marketSelectedData = MarketTradingPairs()
    var globalMarketData = GlobalMarket()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        loadData()
        getCoinGloablDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPriceChange), name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
    }
    
    func setUpView(){
        addChildViewControllers(childViewControllers: coinDetailController, views: view)
        let titleLabel = UILabel()
        titleLabel.text = coinDetail.coinName
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
    }
    
    @objc func loadData(){
        let generalPage = coinDetailController.gerneralController
        generalPage.edit.isHidden = true
        generalPage.tradingPairs.text = coinDetail.coinName + "/" + priceType
        generalPage.market.text = "Global average"
        
        generalPage.marketCapResult.text = currecyLogo[priceType]! + scientificMethod(number: globalMarketData.market_cap ?? 0.0)
        generalPage.volumeResult.text = currecyLogo[priceType]! + scientificMethod(number: globalMarketData.volume_24h ?? 0.0)
        generalPage.circulatingSupplyResult.text = scientificMethod(number: globalMarketData.circulating_supply ?? 0.0)
        generalPage.coinSymbol = coinDetail.coinName
        general.coinAbbName = coinDetail.coinName
        coinDetailController.transactionHistoryController.generalData = general
        generalPage.defaultCurrencyLable.text = priceType
        generalPage.totalNumber.text = currecyLogo[priceType]! + scientificMethod(number:globalMarketData.price ?? 0.0)
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
    func getCoinGloablDetail(){
        let coinNameId = self.getCoinName(coinAbbName: coinDetail.coinName)
        print(coinNameId)
        if coinNameId != 0 {
            GetDataResult().getMarketCapCoinDetail(coinId: coinNameId, priceTypes: priceType){(globalMarket,bool) in
                if bool {
                    DispatchQueue.main.async {
                         self.globalMarketData = globalMarket!
                         self.loadData()
                         self.coinDetailController.gerneralController.spinner.stopAnimating()
                    }
                } else {
                    self.coinDetailController.gerneralController.spinner.stopAnimating()
                }
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
    
    @objc func setPriceChange() {
        let candleData = coinDetailController.gerneralController.vc
        if let priceChange = candleData.priceChange, let priceChangeRatio = candleData.priceChangeRatio {
            checkDataRiseFallColor(risefallnumber: priceChange, label: coinDetailController.gerneralController.totalRiseFall,type: "number")
            checkDataRiseFallColor(risefallnumber: priceChangeRatio, label: coinDetailController.gerneralController.totalRiseFallPercent,type: "Percent")
            coinDetailController.gerneralController.totalRiseFallPercent.text = "(" + coinDetailController.gerneralController.totalRiseFallPercent.text! + ")"
        }
    }

}
