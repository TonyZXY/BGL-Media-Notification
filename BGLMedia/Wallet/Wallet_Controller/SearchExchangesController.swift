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
//    let getDataResult = GetDataResult()
    weak var delegate:TransactionFrom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getExchangeList()
        setupView()
        searchBar.becomeFirstResponder()
    }
    
    //Get trading Pairs Name
    func getExchangeList()->Void{
        allExchanges.append("Global Average")
        let data = APIServices.fetchInstance.getExchangeList()
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
        self.searchResult.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterExchanges.count
        }
        return allExchanges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cell.layer.shadowOpacity = 1
//        cell.layer.shadowRadius = 0
//        cell.layer.masksToBounds = false
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
        delegate?.setLoadPrice()
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.tintColor = ThemeColor().darkBlackColor()
        searchBar.barTintColor = ThemeColor().darkBlackColor()
        searchBar.layer.borderColor = ThemeColor().darkBlackColor().cgColor
        
        var searchTextField:UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if (searchTextField?.responds(to: #selector(getter: UITextField.attributedPlaceholder)))!{
            searchTextField!.attributedPlaceholder = NSAttributedString(string:textValue(name: "search_placeholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13), NSAttributedStringKey.foregroundColor: ThemeColor().textGreycolor()])
        }
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(sortdoneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let cancelbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(sortCancel))
        toolbar.setItems([cancelbutton,flexible,donebutton], animated: false)
        searchBar.inputAccessoryView = toolbar
        
        return searchBar
    }()
    
    @objc func sortdoneclick(){
        view.endEditing(true)
    }
    
    @objc func sortCancel(){
        view.endEditing(true)
    }
    
    lazy var searchResult:UITableView = {
        tableViews.rowHeight = 80
       tableViews.separatorInset = UIEdgeInsets.zero
//        tableViews.contentInset = UIEdgeInsets.zero
//        tableViews.scrollIndicatorInsets = UIEdgeInsets.zero
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
        
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.searchResult
        self.addChildViewController(tableVC)
    }
}
