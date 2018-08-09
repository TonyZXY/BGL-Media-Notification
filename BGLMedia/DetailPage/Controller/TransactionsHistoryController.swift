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

class TransactionsHistoryController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var factor:CGFloat?{
        didSet{
        }
    }
    
    var transactionHistory:Results<EachTransactions>{
        get{
            return realm.objects(EachTransactions.self).filter("coinAbbName = %@", generalData.coinAbbName)
        }
    }
    
    
    let realm = try! Realm()
//    var results = try! Realm().objects(AllTransactions.self)
    var indexSelected:Int = 0
    var generalData = generalDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let filterName = "coinAbbName = '" + generalData.coinAbbName + "' "
//        results = realm.objects(AllTransactions.self).filter(filterName)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh(_:)), name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        setUpView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
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
            cell.dateLabel.text = object.date + " " + object.time
            cell.timeline.backColor = ThemeColor().blueColor()
            cell.buyMarket.text = textValue(name: "tradingMarket_history") + ":" + object.exchangeName
//            cell.buyDeleteButton.setimage
            for result in object.currency{
                if result.name == priceType{
                    cell.SinglePriceResult.text = Extension.method.scientificMethod(number:result.price)
                    cell.costResult.text = Extension.method.scientificMethod(number:result.price * object.amount)
                }
            }
            cell.tradingPairsResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.amountResult.text = Extension.method.scientificMethod(number:object.amount)
            cell.buyDeleteButton.tag = object.id
//            cell.buyDeleteButton.setImage(UIImage(named: "wastebin.png", for: .normal)
            cell.buyDeleteButton.addTarget(self, action: #selector(deleteTransaction), for: .touchUpInside)
            let filterName = "coinAbbName = '" + object.coinAbbName + "' "
            let currentWorth = try! Realm().objects(Transactions.self).filter(filterName)
            var currentWorthData:Double = 0
            for value in currentWorth{
                currentWorthData = value.currentSinglePrice * object.amount
            }
            cell.worthResult.text = Extension.method.scientificMethod(number:currentWorthData)
            let delta = ((currentWorthData - object.totalPrice) / object.totalPrice) * 100
            checkDataRiseFallColor(risefallnumber: delta, label: cell.deltaResult, type: "Percent")
            
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
            cell.sellPriceResult.text = Extension.method.scientificMethod(number:object.singlePrice)
            cell.sellTradingPairResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.sellAmountResult.text = Extension.method.scientificMethod(number:object.amount)
            cell.sellProceedsResult.text = Extension.method.scientificMethod(number:object.totalPrice)
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
    
    @objc func deleteTransaction(sender:UIButton){
        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "alertTitle_history"), comment: ""), message: NSLocalizedString(textValue(name: "alertHint_history"), comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertDelete_history"), comment: ""), style: .destructive) { (_) in
            
            let coinObject = self.realm.objects(Transactions.self).filter("coinAbbName = %@",self.generalData.coinAbbName)
            if let coinTransactionCount = coinObject.first?.everyTransactions.count{
                let coinSelected = self.realm.objects(EachTransactions.self).filter("id = %@",sender.tag)
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
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: averageView)
        view.addConstraintsWithFormat(format: "V:|[v0(\(10*factor!))]", views: averageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: historyTableView,averageView)
        view.addConstraintsWithFormat(format: "V:[v1]-0-[v0]|", views: historyTableView,averageView)
    }
    
    lazy var historyTableView:UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().themeColor()
        let timelineTableViewCellNib = UINib(nibName: "TimeHistoryTableViewCell", bundle: Bundle(for: HistoryTableViewCell.self))
        let SellTableViewCellNib = UINib(nibName: "SellTableViewCell", bundle: Bundle(for: HistoryTableViewCell.self))
        tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "BuyHistory")
        tableView.register(SellTableViewCellNib, forCellReuseIdentifier: "SellHistory")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ThemeColor().themeWidgetColor()
        button.setImage(UIImage(named: "AddButton"), for: .normal)
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        return button
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        historyTableView.reloadData()
//        self.refresher.endRefreshing()
    }
    
}
