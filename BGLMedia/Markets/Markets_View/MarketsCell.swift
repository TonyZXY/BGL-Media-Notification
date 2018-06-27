//
//  MarketsCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 30/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class MarketsCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var color = ThemeColor()
    var sortItems = ["按字母排序","按最高价排序"]
    var filterDateitems = ["1W","1D","1H"]
    var coinItems = ["bitcoin","haha"]
    let general = generalDetail()
    //排序窗口 sort window
    let sortPickerView = UIPickerView()
    
    let realm = try! Realm()
    var globalData: GlobalDataRealm? {
        get {
            return try! Realm().object(ofType: GlobalDataRealm.self, forPrimaryKey: "0")
        }
    }
    var refreshTimer: Timer!
    
    let currency = "AUD $"
    
    var tickerDataRealmObjects: Results<TickerDataRealm> {
        get {
            return try! Realm().objects(TickerDataRealm.self).sorted(byKeyPath: "symbol", ascending: true)
        }
    }
    
    var tickerDataRealmObjectsSortedByPrice: Results<TickerDataRealm> {
        get {
            return try! Realm().objects(TickerDataRealm.self).sorted(byKeyPath: "price", ascending: false)
        }
    }
    
    var filterDateSelection: Int?
    
    var numberOfCoinWillDisplay = 10
    
    static var initStatus = 0
    
    var isSearching = false
    
    lazy var filteredCoinList = try! Realm().objects(TickerDataRealm.self)
    
    let tickerDataFetcher = TickerDataFetcherV2()
    
    var sortOption: Int {
        get {
            return sortPickerView.selectedRow(inComponent: 0)
        }
    }
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        if tickerDataRealmObjects.count == 0 {
            spinner.startAnimating()
        }
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setSortbutton()
        sortdoneclick()
        refreshGlobalData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataAfterUpdateWatchList), name: NSNotification.Name(rawValue: "removeWatchInMarketsCell"), object: nil)
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(refreshGlobalData), userInfo: nil, repeats: true)
        
        coinList.addSubview(refresher)
    }
    
    //总额view
    lazy var totalCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectview = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectview.backgroundColor = color.themeColor()
        collectview.delegate = self
        collectview.dataSource = self
        return collectview
    }()
    
    //排序按钮
    let sortCoin:UITextField={
        var sort = UITextField()
        sort.tintColor = .clear
        sort.layer.borderColor = UIColor.white.cgColor
        sort.textColor = UIColor.white
        return sort
    }()
    
    //时间分类
    lazy var filterDate:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collect = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collect.backgroundColor = color.themeColor()
        collect.delegate = self
        collect.dataSource = self
        return collect
    }()
    
    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.barTintColor = color.themeColor()
        searchBar.tintColor = color.themeColor()
        searchBar.backgroundColor = color.themeColor()
        searchBar.returnKeyType = .done
        return searchBar
    }()
    
    lazy var coinList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = color.themeColor()
        collectionView.register(MarketCollectionViewCell.self, forCellWithReuseIdentifier: "MarketCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    func setupView(){
        addSubview(totalCollectionView)
        addSubview(sortCoin)
        addSubview(filterDate)
        addSubview(searchBar)
        addSubview(coinList)
        coinList.addSubview(spinner)
        //总额View
        totalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        totalCollectionView.register(MarketsTotalView.self, forCellWithReuseIdentifier: "CellId")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalCollectionView]))
        
        //排序按钮
        sortCoin.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":totalCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":totalCollectionView]))
        
        //时间分类 Constraints
        filterDate.translatesAutoresizingMaskIntoConstraints = false
        filterDate.register(MarketFilterCollectionView.self, forCellWithReuseIdentifier: "SortDate")
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(200)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":filterDate,"v1":sortCoin]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":filterDate,"v1":totalCollectionView]))
        
        //搜索栏
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":sortCoin]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":sortCoin]))
        
        //币种列表
        coinList.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
        
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: coinList, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: coinList, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //市场总数据view,日期筛选view--cell数量
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == totalCollectionView{
            return 3
        } else if collectionView == filterDate{
            return 3
        }else if collectionView == coinList{
            if isSearching == true {
                return filteredCoinList.count
            }
            
            if MarketsCell.initStatus == 0 {
                MarketsCell.initStatus = 1
                if tickerDataRealmObjects.count == 0 {
                    return 0
                }
            }
            return tickerDataRealmObjects.count
        }else {
            return 0
        }
    }
    
    //市场总数据view,日期筛选view--cell的设定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == totalCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! MarketsTotalView
            
            if indexPath.row == 0 {
                cell.totalFunds.text = "市场总资产"
                if let total_market_cap = globalData?.total_market_cap {
                    cell.number.text = currency + total_market_cap + "B"
                } else {
                    cell.number.text = "--"
                }
            } else if indexPath.row == 1 {
                cell.totalFunds.text = "24小时交易量"
                if let total_volume_24h = globalData?.total_volume_24h {
                    cell.number.text = currency + total_volume_24h + "B"
                } else {
                    cell.number.text = "--"
                }
            } else if indexPath.row == 2 {
                cell.totalFunds.text = "BTC占比"
                if let bitcoin_percentage_of_market_cap = globalData?.bitcoin_percentage_of_market_cap {
                    cell.number.text = bitcoin_percentage_of_market_cap + "%"
                } else {
                    cell.number.text = "--"
                }
            }
            cell.totalFunds.textColor = UIColor.white
            return cell
        } else if collectionView == filterDate{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortDate", for: indexPath) as! MarketFilterCollectionView
            cell.label.text = filterDateitems[indexPath.row]
            return cell
        } else if collectionView == coinList{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
            var object = sortOption == 0 ? tickerDataRealmObjects[indexPath.row] : tickerDataRealmObjectsSortedByPrice[indexPath.row]
            if isSearching {
                object = filteredCoinList[indexPath.row]
            }
            cell.priceChange = [object.percent_change_7d, object.percent_change_24h, object.percent_change_1h][filterDateSelection ?? 0]
            cell.object = object
            
            return cell
        } else{
            return UICollectionViewCell()
        }
    }
    
    //市场总数据view,日期筛选view--cell的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == totalCollectionView{
            return CGSize(width:(totalCollectionView.frame.width-5) / 3, height: totalCollectionView.frame.height)
        } else if collectionView == filterDate{
            return CGSize(width:filterDate.frame.width / 3, height: filterDate.frame.height)
        } else if collectionView == coinList{
            return CGSize(width:self.frame.width-10, height: 100)
        }else{
            return CGSize()
        }
    }
    
    //市场总数据view,日期筛选view--cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == totalCollectionView{
            return 0
        } else if collectionView == filterDate{
            return 0
        } else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coinList{
            return 10
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == coinList{
            return CGSize(width:self.frame.width, height: 10)
        } else{
            return CGSize()
        }
    }
    
    //市场行情列表 行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //市场行情cell的设定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinsMarkets", for: indexPath) as! MarketsCoinTableViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.backgroundColor = color.walletCellcolor()
        return cell
    }
    
    //排序窗口列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //排序窗口选项数量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortItems.count
    }
    
    //排序窗口选项名称
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortItems[row]
    }
    
    //建立pickview toolbar
    func setSortbutton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(sortdoneclick))
        toolbar.setItems([donebutton], animated: false)
        sortCoin.inputAccessoryView = toolbar
        sortCoin.inputView = sortPickerView
        sortPickerView.delegate = self
        sortPickerView.dataSource = self
        sortPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    //定义pickview done 按钮
    @objc func sortdoneclick(){
        let row = sortPickerView.selectedRow(inComponent: 0)
        sortCoin.text = "▼ "+sortItems[row]
        self.endEditing(true)
        coinList.reloadData()
    }
    
    @objc func refreshGlobalData() {
        let marketCapClient = MarketCapClient()
        
        DispatchQueue.global(qos: .userInitiated).async {
            marketCapClient.getGlobalCap(convert: "AUD"){ result in
                switch result{
                case .success(let resultData):
                    guard let globalCap = resultData else {return}
                    
                    let bitcoin_percentage_of_market_cap = String(globalCap["bitcoin_percentage_of_market_cap"]!!)
                    let total_market_cap_aud = String((globalCap["total_market_cap_aud"]!! / 10000000.0).rounded() / 100.0)
                    let total_24h_volume_aud = String((globalCap["total_24h_volume_aud"]!! / 10000000.0).rounded() / 100.0)
                    
                    let realm = try! Realm()
                    realm.beginWrite()
                    realm.create(GlobalDataRealm.self, value: [bitcoin_percentage_of_market_cap, total_market_cap_aud, total_24h_volume_aud, "0"], update: true)
                    try! realm.commitWrite()
                    
                    DispatchQueue.main.async {
                        self.totalCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("the error \(error.localizedDescription)")
                }
            }
        }
        
        tickerDataFetcher.fetchTickerDataWrapper()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterDate {
            filterDateSelection = indexPath.row
            coinList.reloadData()
        }
        if collectionView == coinList {
            let cell = coinList.cellForItem(at: indexPath) as! MarketCollectionViewCell
            general.coinAbbName = cell.coinLabel.text!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectGlobalCoin"), object: self)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            contentView.endEditing(true)
            coinList.reloadData()
        } else{
            isSearching = true
            filteredCoinList = tickerDataRealmObjects.filter("symbol CONTAINS %@", searchBar.text!.uppercased())
            coinList.reloadData()
        }
    }
    
    @objc func reloadDataAfterUpdateWatchList() {
        if tickerDataRealmObjects.count != 0 {
            spinner.stopAnimating()
        }
        coinList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        tickerDataFetcher.fetchTickerDataWrapper()
        self.refresher.endRefreshing()
    }
}

