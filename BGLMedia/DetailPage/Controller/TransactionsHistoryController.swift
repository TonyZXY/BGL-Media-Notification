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

    let realm = try! Realm()
    var results = try! Realm().objects(AllTransactions.self)
    var indexSelected:Int = 0
    var generalData = generalDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filterName = "coinAbbName = '" + generalData.coinAbbName + "' "
        results = realm.objects(AllTransactions.self).filter(filterName)
             NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh(_:)), name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        setUpView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = results[indexPath.row]
        //Create buy transaction cell
        if object.status == "Buy"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyHistory", for: indexPath) as! HistoryTableViewCell
            cell.buyLanguage()
            cell.dateLabel.textColor = UIColor.white
            cell.buyMarket.textColor = UIColor.white
            cell.labelPoint.text = "B"
            cell.labelPoint.layer.backgroundColor = ThemeColor().greenColor().cgColor
            cell.dateLabel.text = object.date + " " + object.time
            cell.buyMarket.text = textValue(name: "tradingMarket_history") + ":" + object.exchangName
            cell.SinglePriceResult.text = scientificMethod(number:object.audSinglePrice)
            cell.tradingPairsResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.amountResult.text = scientificMethod(number:object.amount)
            cell.costResult.text = scientificMethod(number:object.audTotalPrice)
            cell.buyDeleteButton.tag = object.id
            cell.buyDeleteButton.addTarget(self, action: #selector(deleteTransaction), for: .touchUpInside)
            let filterName = "coinAbbName = '" + object.coinAbbName + "' "
            let currentWorth = try! Realm().objects(MarketTradingPairs.self).filter(filterName)
            var currentWorthData:Double = 0
            for value in currentWorth{
                currentWorthData = value.singlePrice * object.amount
            }
            cell.worthResult.text = scientificMethod(number:currentWorthData)
            let delta = ((currentWorthData - object.totalPrice) / object.totalPrice) * 100
            cell.deltaResult.text = scientificMethod(number:delta) + "%"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
            return cell
        } else if object.status == "Sell"{
             //Create sell transaction cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellHistory", for: indexPath) as! HistoryTableViewCell
            cell.sellLanguage()
            cell.sellDateLabel.textColor = UIColor.white
            cell.sellMarket.textColor = UIColor.white
            cell.labelPoint.text = "S"
            cell.labelPoint.layer.backgroundColor = ThemeColor().redColor().cgColor
            cell.sellDateLabel.text = object.date + " " + object.time
            cell.sellPriceResult.text = scientificMethod(number:object.singlePrice)
            cell.sellTradingPairResult.text = object.coinAbbName + "/" + object.tradingPairsName
            cell.sellAmountResult.text = scientificMethod(number:object.amount)
            cell.sellProceedsResult.text = scientificMethod(number:object.totalPrice)
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
        transactionForm.updateTransaction = results[indexPath.row]
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
            let filterId = "id = " + String(sender.tag)
            let filterName = "coinAbbName = '" + self.generalData.coinAbbName + "' "
            let statusItem = self.realm.objects(AllTransactions.self)
            let specificTransaction = statusItem.filter(filterId)
       
            let coinTransaction = statusItem.filter(filterName)
//                 print(coinTransaction.count)
            if coinTransaction.count == 1{
                let coinSelected = self.realm.objects(MarketTradingPairs.self).filter(filterName)
                try! self.realm.write {
                    self.realm.delete(coinSelected)
                }
            }
            try! self.realm.write {
                self.realm.delete(specificTransaction)
            }
            self.historyTableView.reloadData()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteTransaction"), object: nil)
        }
        confirmAlertCtrl.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertCancel_history"), comment: ""), style: .cancel, handler:nil)
        confirmAlertCtrl.addAction(cancelAction)
        self.present(confirmAlertCtrl, animated: true, completion: nil)
        
        
        
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(historyTableView)
        view.addSubview(averageView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: averageView)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: averageView)
        
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
        
        //Prevent empty rows
        tableView.tableFooterView = UIView()
//        tableView.backgroundColor = #colorLiteral(red: 0.2, green: 0.2039215686, blue: 0.2235294118, alpha: 1)
        tableView.separatorStyle = .none
        tableView.addSubview(self.refresher)
        return tableView
    }()
    
    var averageView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        historyTableView.reloadData()
        self.refresher.endRefreshing()
    }

}
