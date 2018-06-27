//
//  MarketSelectController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 25/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class MarketSelectController: UIViewController,UITableViewDelegate,UITableViewDataSource,TransactionFrom{
    func setSinglePrice(single: Double) {
        newTransaction.singlePrice = single
    }
    
    var newTransaction = AllTransactions()
    var items = ["ExChangeName","Trading Pairs Name"]
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.marketTableView.reloadData()
        }
    }
    
    func setUpView(){
        let navigationDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.setRightBarButton(navigationDoneButton, animated: true)
        view.addSubview(marketTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketTableView]))
    }
    
    @objc func done(){
        if newTransaction.tradingPairsName != "" {
            let filterName = "coinAbbName = '" + newTransaction.coinAbbName + "' "
            let statusItem = realm.objects(MarketTradingPairs.self).filter(filterName)
            if let object = statusItem.first{
                try! self.realm.write {
                    object.exchangeName = newTransaction.exchangName
                    object.tradingPairsName = newTransaction.tradingPairsName
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadDetail"), object: nil)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "marketCell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = newTransaction.exchangName
        } else if indexPath.row == 1{
           cell.textLabel?.text = newTransaction.coinAbbName + "/" + newTransaction.tradingPairsName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let searchExchange = SearchExchangesController()
            searchExchange.delegate = self
            navigationController?.pushViewController(searchExchange, animated: true)
        } else if indexPath.row == 1{
            let searchTradingPairs = SearchTradingPairController()
            searchTradingPairs.delegate = self
            navigationController?.pushViewController(searchTradingPairs, animated: true)
        }
    }
    
    lazy var marketTableView:UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "marketCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    func getExchangeName() -> String {
        return newTransaction.exchangName
    }
    
    func getCoinName() -> String {
        return newTransaction.coinAbbName
    }
    
    func setCoinName(name: String) {
        newTransaction.coinName = name
    }
    
    func setCoinAbbName(abbName: String) {
        newTransaction.coinAbbName = abbName
    }
    
    func setExchangesName(exchangeName: String) {
        newTransaction.exchangName = exchangeName
    }
    
    func setTradingPairsName(tradingPairsName: String) {
        newTransaction.tradingPairsName = tradingPairsName
    }
    
    func setTradingPairsFirstType(firstCoinType: [String]) {
        
    }
    
    func setTradingPairsSecondType(secondCoinType: [String]) {
        
    }
}
