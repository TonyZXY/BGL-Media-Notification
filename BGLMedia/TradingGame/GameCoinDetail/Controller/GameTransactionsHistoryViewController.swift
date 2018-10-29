//
//  GameTransactionsHistoryViewController.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/12/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftKeychainWrapper

class GameTransactionsHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
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
    
    var indexSelected:Int = 0
    var worthData = [String:Double]()
    var gameBalanceController: GameBalanceController? 
    var coinDetail : GameCoin?
    var transactions = [EachTransactions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.switchRefreshHeader(to: .refreshing)
        
        setUpView()
    }
    
    private func getAllTransactions(completion: @escaping (_ jsonArray: [JSON], _ error: String?) -> Void) {
        guard let userID = gameBalanceController?.gameUser?.id else { return }
        let parameter:[String:Any] = ["token": certificateToken, "email": email, "user_id": userID]
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getAllTransactions"], httpMethod: "POST", parameters: parameter) { (response, success) in
            if success {
                completion(response["data"].arrayValue, nil)
            } else {
                completion([], textValue(name: "networkFailure"))
            }
        }
    }
    
    private func updateTransactions(completion: @escaping (_ success: Bool) -> Void) {
        transactions.removeAll()
        getAllTransactions { (jsonArray, error)  in
            if let _ = error {
                completion(false)
            } else {
                jsonArray.forEach({ (json) in
                    if self.coinDetail?.abbrName.lowercased() == json["coin_add_name"].stringValue.lowercased() {
                        self.transactions.append(self.fillTransactionDataWith(json))
                    }
                })
                self.transactions.sort {
                    Extension.method.convertStringToDate(date: $0.date) > Extension.method.convertStringToDate(date: $1.date) }
                completion(true)
            }
        }
    }
    
    private func fillTransactionDataWith(_ json: JSON) -> EachTransactions {
        let transaction = EachTransactions()
        transaction.additional = json["note"].stringValue
        transaction.amount = json["amount"].doubleValue
        transaction.coinAbbName = json["coin_add_name"].stringValue
        transaction.coinName = json["coin_name"].stringValue
        transaction.date = json["date"].stringValue
        transaction.exchangeName = json["exchange_name"].stringValue
        transaction.tradingPairsName = json["trading_pair_name"].stringValue
        transaction.status = json["status"].stringValue
        transaction.singlePrice = json["single_price"].doubleValue
        transaction.totalPrice = transaction.singlePrice * transaction.amount
        transaction.worth = (coinDetail?.price ?? 0) * transaction.amount
        transaction.delta = (transaction.worth - transaction.totalPrice) * 100 / transaction.totalPrice
        return transaction
    }
    
    @objc func refreshData(){
        historyTableView.switchRefreshHeader(to: .refreshing)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let object = transactions[indexPath.row]
        //Create buy transaction cell
        if object.status.lowercased() == "Buy".lowercased(){
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyHistory", for: indexPath) as! HistoryTableViewCell
            cell.historyView.layer.borderWidth = 1
            cell.historyView.layer.cornerRadius = 8
            cell.historyView.layer.borderColor = ThemeColor().blueColor().cgColor
            cell.buyLanguage()
            cell.dateLabel.textColor = UIColor.white
            cell.buyMarket.textColor = UIColor.white
            cell.labelPoint.text = "B"
            cell.labelPoint.layer.backgroundColor = ThemeColor().blueColor().cgColor
            let date = Extension.method.convertStringToDate(date: object.date)
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
            
            cell.dateLabel.text = formatter.string(from: date) + " " + formatter2.string(from: date)
            cell.timeline.backColor = ThemeColor().blueColor()
            cell.buyMarket.text = textValue(name: "tradingMarket_history") + ": " + object.exchangeName
            
            

            
            cell.SinglePriceResult.text = Extension.method.scientificMethod(number:object.singlePrice) + " " + object.tradingPairsName
            cell.costResult.text = Extension.method.scientificMethod(number:object.totalPrice) + " " + object.tradingPairsName
            
            cell.tradingPairsResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.amountResult.text = Extension.method.scientificMethod(number:object.amount)
            cell.buyDeleteButton.isHidden = true

            cell.worthResult.text = Extension.method.scientificMethod(number:object.worth) + " " + object.tradingPairsName
            checkDataRiseFallColor(risefallnumber: object.delta, label: cell.deltaResult,currency:object.tradingPairsName, type: "Percent")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
            return cell
        } else if object.status.lowercased() == "Sell".lowercased(){
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
            
            let date = Extension.method.convertStringToDate(date: object.date)
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
            
            cell.sellDateLabel.text = formatter.string(from: date) + " " + formatter2.string(from: date)
            
            cell.sellPriceResult.text = Extension.method.scientificMethod(number:object.singlePrice) + " " + object.tradingPairsName
            cell.sellTradingPairResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.sellAmountResult.text = Extension.method.scientificMethod(number:object.amount)
            cell.sellProceedsResult.text = Extension.method.scientificMethod(number:object.totalPrice) + " " + object.tradingPairsName
            cell.sellMarket.text = textValue(name: "tradingMarket_history") + ": " + object.exchangeName
            cell.sellDeleteButton.isHidden = true
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
    }
    
    @objc func addTransaction(sender: UIButton){
        guard let coinD = coinDetail else { return }
        let transaction = GameTransactionsController()
        transaction.gameBalanceController = gameBalanceController
        transaction.newTransaction.coinAbbName = coinD.abbrName
        transaction.newTransaction.coinName = coinD.name
        transaction.newTransaction.exchangeName = coinD.exchangeName
        transaction.newTransaction.tradingPairsName = coinD.tradingPairName
        transaction.transactionStatus = "AddSpecific"
        self.navigationController?.pushViewController(transaction, animated: true)
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(historyTableView)
        view.addSubview(averageView)
        view.addSubview(addHistoryButton)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: averageView)
        view.addConstraintsWithFormat(format: "V:|[v0(\(10*factor!))]", views: averageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: historyTableView,averageView)
        view.addConstraintsWithFormat(format: "V:[v1]-0-[v0]", views: historyTableView,averageView)
        
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
        
        updateTransactions { (success) in
            if success{
                self.historyTableView.reloadData()
                self.historyTableView.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                self.historyTableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    

}
