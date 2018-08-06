//
//  SearchTradingPair.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 4/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class SearchTradingPairController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    let cryptoCompareClient = CryptoCompareClient()
    var tableViews = UITableView()
    var color = ThemeColor()
    var allTradingPairs = [String]()
//    let getDataResults = GetDataResult()
    var delegate:TransactionFrom?
    var selectValues:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        getTradingPairsList()
        setupView()
    }
    
    //Get Trading Pairs Name
    func getTradingPairsList()->Void{
        if delegate?.getExchangeName() == "Global Average"{
            allTradingPairs.append(priceType)
        } else{
            let data = APIServices.fetchInstance.getTradingCoinList(market: (delegate?.getExchangeName())!,coin:(delegate?.getCoinName())!)
            if data != []{
                for pairs in data{
                    self.allTradingPairs.append(pairs)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTradingPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 0
        cell.layer.masksToBounds = false
        cell.textLabel?.text = allTradingPairs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let table:UITableViewCell = searchResult.cellForRow(at: indexPath)!
        delegate?.setTradingPairsSecondType(secondCoinType: [])
        var allPairs = [String]()
        allPairs.append((table.textLabel?.text)!)
        allPairs.append("%"+(table.textLabel?.text)!)
        
        //Delegate selected tradingPairsName to the transaction page
        delegate?.setTradingPairsName(tradingPairsName: (table.textLabel?.text)!)
        delegate?.setTradingPairsSecondType(secondCoinType: allPairs)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        view.addSubview(searchResult)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchResult]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchResult]))
        
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.searchResult
        self.addChildViewController(tableVC)
    }
    
    lazy var searchResult:UITableView = {
        tableViews.backgroundColor = color.themeColor()
        tableViews.rowHeight = 80
//        tableViews.separatorInset = UIEdgeInsets.zero
        tableViews.delegate = self
        tableViews.dataSource = self
        tableViews.separatorStyle = .none
        tableViews.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViews.translatesAutoresizingMaskIntoConstraints = false
        return tableViews
    }()
}
