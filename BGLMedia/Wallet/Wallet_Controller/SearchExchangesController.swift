//
//  SearchExchangesController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 4/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class SearchExchangesController:UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    let cryptoCompareClient = CryptoCompareClient()
    var tableViews = UITableView()
    var color = ThemeColor()
    var allExchanges = [String]()
    var filterExchanges = [String]()
    var isSearching = false
    let getDataResult = GetDataResult()
    weak var delegate:TransactionFrom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getExchangeList()
        setupView()
        searchBar.becomeFirstResponder()
        searchBar.returnKeyType = UIReturnKeyType.done
        DispatchQueue.main.async {
            self.searchResult.reloadData()
        }
    }
    
    //Get trading Pairs Name
    func getExchangeList()->Void{
        let data = getDataResult.getExchangeList()
        for (key,value) in data{
            if delegate?.getCoinName() != ""{
                let exactMarket = value.filter{name in return name.key == delegate?.getCoinName()}
                if exactMarket.count != 0{
                    self.allExchanges.append(key)
                }
            }
            else {
                self.allExchanges.append(key)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterExchanges.count
        }
        return allExchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if isSearching{
            cell.textLabel?.text = filterExchanges[indexPath.row]
        } else {
            cell.textLabel?.text = allExchanges[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let table:UITableViewCell = searchResult.cellForRow(at: indexPath)!
        delegate?.setExchangesName(exchangeName: (table.textLabel?.text)!)
        delegate?.setTradingPairsName(tradingPairsName: "")
        navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            searchResult.reloadData()
        } else{
            isSearching = true
            filterExchanges = allExchanges.filter{ name in return name.lowercased().contains(searchBar.text!.lowercased())}
            searchResult.reloadData()
        }
    }
    
    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.barTintColor = color.walletCellcolor()
        searchBar.tintColor = color.themeColor()
        searchBar.backgroundColor = color.fallColor()
        return searchBar
    }()
    
    lazy var searchResult:UITableView = {
        tableViews.rowHeight = 80
        tableViews.separatorInset = UIEdgeInsets.zero
        tableViews.backgroundColor = color.themeColor()
        tableViews.delegate = self
        tableViews.dataSource = self
        tableViews.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableViews.translatesAutoresizingMaskIntoConstraints = false
        return tableViews
    }()
    
    func setupView(){
        view.addSubview(searchBar)
        view.addSubview(searchResult)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":searchResult]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":searchResult]))
    }
}
