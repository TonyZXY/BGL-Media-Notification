//
//  TransactionsController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 21/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift
import SwiftKeychainWrapper

class TransactionsHistoryController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var factor:CGFloat?{
        didSet{
        }
    }
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var email:String{
        get{
            //            return UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
        }
    }
    
    var certificateToken:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        }
    }
    
    var transactionHistory:Results<EachTransactions>{
        get{
            return realm.objects(EachTransactions.self).filter("coinAbbName = %@", generalData.coinAbbName).sorted(byKeyPath: "date",ascending:true).sorted(byKeyPath: "time",ascending:true)
        }
    }
    
    var assetsData:Results<Transactions>{
        get{
            let filterName = "coinAbbName = '" + generalData.coinAbbName + "' "
            let objects = realm.objects(Transactions.self).filter(filterName)
            return objects
        }
    }
    
    let realm = try! Realm()
//    var results = try! Realm().objects(AllTransactions.self)
    var indexSelected:Int = 0
    var generalData = generalDetail()
    var worthData = [String:Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let filterName = "coinAbbName = '" + generalData.coinAbbName + "' "
//        results = realm.objects(AllTransactions.self).filter(filterName)
        if transactionHistory.count > 0{
        historyTableView.switchRefreshHeader(to: .refreshing)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadTransaction"), object: nil)
        setUpView()
    }
    
    @objc func refreshData(){
        historyTableView.switchRefreshHeader(to: .refreshing)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadTransaction"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = transactionHistory[indexPath.row]
        //Create buy transaction cell
        if object.status == "Buy"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyHistory", for: indexPath) as! HistoryTableViewCell
            cell.historyView.layer.borderWidth = 1
            cell.historyView.layer.cornerRadius = 8
            cell.historyView.layer.borderColor = ThemeColor().blueColor().cgColor
            cell.buyLanguage()
            cell.dateLabel.textColor = UIColor.white
            cell.buyMarket.textColor = UIColor.white
            cell.labelPoint.text = "B"
            cell.labelPoint.layer.backgroundColor = ThemeColor().blueColor().cgColor
            let date = Extension.method.convertStringToDatePickerDate(date: object.date)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            let formatter2 = DateFormatter()
            formatter2.dateStyle = .none
            formatter2.timeStyle = .short
            if defaultLanguage == "CN"{
                formatter.locale = Locale(identifier: "zh")
                formatter2.locale = Locale(identifier: "zh")
            } else {
                formatter.locale = Locale(identifier: "en")
                formatter2.locale = Locale(identifier: "en")
            }
            let time = Extension.method.convertStringToTimePickerDate(date: object.time)
            cell.dateLabel.text = formatter.string(from: date) + " " + formatter2.string(from: time)
            cell.timeline.backColor = ThemeColor().blueColor()
            cell.buyMarket.text = textValue(name: "tradingMarket_history") + ": " + object.exchangeName
            
            
//            for result in object.currency{
//                if result.name == priceType{
//                    cell.SinglePriceResult.text = Extension.method.scientificMethod(number:result.price) + " " + object.tradingPairsName
//                    cell.costResult.text = Extension.method.scientificMethod(number:result.price * object.amount) + " " + object.tradingPairsName
//                }
//            }
            
            cell.SinglePriceResult.text = Extension.method.scientificMethod(number:object.singlePrice) + " " + object.tradingPairsName
            cell.costResult.text = Extension.method.scientificMethod(number:object.totalPrice) + " " + object.tradingPairsName
            
            cell.tradingPairsResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.amountResult.text = Extension.method.scientificMethod(number:object.amount)
            cell.buyDeleteButton.tag = object.id
            cell.buyDeleteButton.addTarget(self, action: #selector(deleteTransaction), for: .touchUpInside)
//            let filterName = "coinAbbName = '" + object.coinAbbName + "' "
//            let currentWorth = try! Realm().objects(Transactions.self).filter(filterName)
//            var currentWorthData:Double = 0
//            for value in currentWorth{
//                currentWorthData = value.defaultCurrencyPrice * object.amount
//            }
            cell.worthResult.text = Extension.method.scientificMethod(number:object.worth) + " " + object.tradingPairsName
//            let delta = ((currentWorthData - object.totalPrice) / object.totalPrice) * 100
            checkDataRiseFallColor(risefallnumber: object.delta, label: cell.deltaResult,currency:object.tradingPairsName, type: "Percent")
            
//            cell.deltaResult.text = Extension.method.scientificMethod(number:delta) + "%"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
            return cell
        } else if object.status == "Sell"{
            //Create sell transaction cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellHistory", for: indexPath) as! HistoryTableViewCell
            cell.historyView.layer.cornerRadius = 8
            cell.historyView.layer.borderWidth = 1
            cell.historyView.layer.borderColor = ThemeColor().redColor().cgColor
            cell.sellLanguage()
            cell.sellDateLabel.textColor = UIColor.white
            cell.sellMarket.textColor = UIColor.white
            cell.labelPoint.text = "S"
            cell.timeline.backColor = ThemeColor().redColor()
            cell.labelPoint.layer.backgroundColor = ThemeColor().redColor().cgColor
            
            
            
            
            
            cell.sellDateLabel.text = object.date + " " + object.time
            cell.sellPriceResult.text = Extension.method.scientificMethod(number:object.singlePrice) + " " + object.tradingPairsName
            cell.sellTradingPairResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.sellAmountResult.text = Extension.method.scientificMethod(number:object.amount)
            cell.sellProceedsResult.text = Extension.method.scientificMethod(number:object.totalPrice) + " " + object.tradingPairsName
            cell.sellMarket.text = textValue(name: "tradingMarket_history") + ": " + object.exchangeName
            cell.sellDeleteButton.tag = object.id
            cell.sellDeleteButton.addTarget(self, action: #selector(deleteTransaction), for: .touchUpInside)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionForm = TransactionsController()
        //        let cell = self.historyTableView.cellForRow(at: indexPath) as! HistoryTableViewCell
        transactionForm.updateTransaction = transactionHistory[indexPath.row]
        transactionForm.transactionStatus = "Update"
        navigationController?.pushViewController(transactionForm, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 0{
//            let footerView = UIView()
//            footerView.backgroundColor = ThemeColor().redColor()
//            return footerView
//        }
//        return UIView()
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    @objc func deleteTransaction(sender:UIButton){
        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "alertTitle_history"), comment: ""), message: NSLocalizedString(textValue(name: "alertHint_history"), comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertDelete_history"), comment: ""), style: .destructive) { (_) in
            
            let coinObject = self.realm.objects(Transactions.self).filter("coinAbbName = %@",self.generalData.coinAbbName)
            if let coinTransactionCount = coinObject.first?.everyTransactions.count{
                let coinSelected = self.realm.objects(EachTransactions.self).filter("id = %@",sender.tag)
                
                if self.loginStatus{
                    let body:[String:Any] = ["email":self.email,"token":self.certificateToken,"transactionID":[sender.tag]]
                    URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","deleteTransaction"], httpMethod: "POST", parameters: body) { (response, success) in
                        if success{
                            print("success")
                        }else{
                            print("error")
                        }
                    }
                }
                
                
                
                
                if coinTransactionCount == 1{
                    try! self.realm.write {
                        self.realm.delete(coinSelected)
                        self.realm.delete(coinObject)
                    }
                } else{
                    try! self.realm.write {
                        self.realm.delete(coinSelected)
                    }
                }
            }
            self.historyTableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
        }
        confirmAlertCtrl.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertCancel_history"), comment: ""), style: .cancel, handler:nil)
        confirmAlertCtrl.addAction(cancelAction)
        self.present(confirmAlertCtrl, animated: true, completion: nil)
        
        
        
    }
    @objc func addTransaction(sender: UIButton){
        let transaction = TransactionsController()
        transaction.newTransaction.coinAbbName = generalData.coinAbbName
        transaction.newTransaction.coinName = generalData.coinName
        transaction.transactionStatus = "AddSpecific"
        self.navigationController?.pushViewController(transaction, animated: true)
    }
    
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
//        refreshControl.tintColor = UIColor.white
//        return refreshControl
//    }()
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(historyTableView)
        view.addSubview(averageView)
        view.addSubview(addHistoryButton)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: averageView)
        view.addConstraintsWithFormat(format: "V:|[v0(\(10*factor!))]", views: averageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: historyTableView,averageView)
        view.addConstraintsWithFormat(format: "V:[v1]-0-[v0]", views: historyTableView,averageView)
        
        
//        NSLayoutConstraint(item: addHistoryButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        addHistoryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addHistoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addHistoryButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        if #available(iOS 11.0, *) {
            addHistoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        } else {
            addHistoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        }
    }
    
    lazy var historyTableView:UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().darkGreyColor()
        let timelineTableViewCellNib = UINib(nibName: "TimeHistoryTableViewCell", bundle: Bundle(for: HistoryTableViewCell.self))
        let SellTableViewCellNib = UINib(nibName: "SellTableViewCell", bundle: Bundle(for: HistoryTableViewCell.self))
        tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "BuyHistory")
        tableView.register(SellTableViewCellNib, forCellReuseIdentifier: "SellHistory")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.bounces = false
        let footerView = UIView()
        footerView.backgroundColor = ThemeColor().darkGreyColor()
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        tableView.separatorStyle = .none
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        tableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(tableView)
        })
        return tableView
    }()
    
    var averageView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var addHistoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "AddButton"), for: .normal)
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 30
        button.backgroundColor = ThemeColor().darkGreyColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    @objc func handleRefresh(_ tableView: UITableView){
//        loadData(){success in
//            if success{
//                self.historyTableView.reloadData()
//                self.historyTableView.switchRefreshHeader(to: .normal(.success, 0.5))
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
////                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDetailPage"), object: nil)
//            } else{
//                self.historyTableView.switchRefreshHeader(to: .normal(.failure, 0.5))
//            }
//        }
//         var worthData = [String:Double]()
        
        getWorthData(){success in
            if success{
                self.historyTableView.reloadData()
                self.historyTableView.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                self.historyTableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    func getWorthData(completion:@escaping (Bool)->Void){
        if transactionHistory.count > 0{
        let dispatchGroup = DispatchGroup()
        for result in transactionHistory{
            dispatchGroup.enter()
            if result.exchangeName == "Global Average"{
                URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + result.coinAbbName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
                    if success{
                        if let responseResult = response["quotes"].array{
                            for results in responseResult{
                                if results["currency"].string ?? "" == result.tradingPairsName{
                                    let singlePrice = results["data"]["price"].double ?? 0
                                    try! self.realm.write {
                                            result.worth = singlePrice * result.amount
                                            result.delta = (((singlePrice * result.amount) - result.totalPrice) / result.totalPrice) * 100
                                    }
                                    dispatchGroup.leave()
                                }
                            }
                        } else{
                           dispatchGroup.leave()
                        }
                    } else{
                        dispatchGroup.leave()
                    }
                }
            } else{
                APIServices.fetchInstance.getExchangePriceData(from: result.coinAbbName, to: result.tradingPairsName, market: result.exchangeName) { (success, response) in
                    if success{
                        let singlePrice = response["RAW"]["PRICE"].double ?? 0
                        try! self.realm.write {
                            result.worth = singlePrice * result.amount
                            result.delta = (((singlePrice * result.amount) - result.totalPrice) / result.totalPrice) * 100
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
            completion(true)
        }
    }
}
