//
//  GlobalMarketController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 4/6/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class GlobalMarketController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    let marketCell = MarketView()

    var color = ThemeColor()
    
    var sortItems:[String]{
        get{
            return [textValue(name: "sortByLetter_market"),textValue(name: "sortByHighestPrice_market")]
        }
    }
    
    var filterDateitems:[String]{
        get{
            return [textValue(name: "filterByWeek_market"),textValue(name: "filterByDay_market"),textValue(name: "filterByHour_market")]
        }
    }
    
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
    
    var currency:String{
        get{
            return currecyLogo[priceType]!
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setSortbutton()
        sortdoneclick()
        refreshGlobalData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataAfterUpdateWatchList), name: NSNotification.Name(rawValue: "removeWatchInMarketsCell"), object: nil)
        
        refreshTimer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(refreshGlobalData), userInfo: nil, repeats: true)
        
        marketCell.coinList.addSubview(refresher)
    }
    
    func changeLanguage(){
        marketCell.totalCollectionView.reloadData()
        marketCell.coinList.reloadData()
        marketCell.filterDate.reloadData()
        sortdoneclick()
    }
    
    
    func setUpView(){
        view.addSubview(marketCell)
        marketCell.coinList.addSubview(spinner)
        marketCell.totalCollectionView.delegate = self
        marketCell.totalCollectionView.dataSource = self
        marketCell.filterDate.delegate = self
        marketCell.filterDate.dataSource = self
        marketCell.searchBar.delegate  = self
        marketCell.coinList.delegate = self
        marketCell.coinList.dataSource = self
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketCell]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":marketCell]))
        
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: marketCell.coinList, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: marketCell.coinList, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == marketCell.totalCollectionView{
            return 3
        } else if collectionView == marketCell.filterDate{
            return 3
        }else if collectionView == marketCell.coinList{
            if isSearching == true {
                return filteredCoinList.count
            }
            
            if GlobalMarketController.initStatus == 0 {
                GlobalMarketController.initStatus = 1
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
        if collectionView == marketCell.totalCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! MarketsTotalView
            
            if indexPath.row == 0 {
                cell.totalFunds.text = textValue(name: "marketCap_Market")
                if let total_market_cap = globalData?.total_market_cap {
                    cell.number.text = currency + total_market_cap + "B"
                } else {
                    cell.number.text = "--"
                }
            } else if indexPath.row == 1 {
                cell.totalFunds.text = textValue(name: "market_24hVolume")
                if let total_volume_24h = globalData?.total_volume_24h {
                    cell.number.text = currency + total_volume_24h + "B"
                } else {
                    cell.number.text = "--"
                }
            } else if indexPath.row == 2 {
                cell.totalFunds.text = textValue(name: "btcDominance_market")
                if let bitcoin_percentage_of_market_cap = globalData?.bitcoin_percentage_of_market_cap {
                    cell.number.text = bitcoin_percentage_of_market_cap + "%"
                } else {
                    cell.number.text = "--"
                }
            }
            cell.totalFunds.textColor = UIColor.white
            return cell
        } else if collectionView == marketCell.filterDate{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SortDate", for: indexPath) as! MarketFilterCollectionView
            cell.label.text = filterDateitems[indexPath.row]
            return cell
        } else if collectionView == marketCell.coinList{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarketCollectionViewCell", for: indexPath) as! MarketCollectionViewCell
            var object = sortOption == 0 ? tickerDataRealmObjects[indexPath.row] : tickerDataRealmObjectsSortedByPrice[indexPath.row]
            if isSearching {
                object = filteredCoinList[indexPath.row]
            }
            cell.coinType.text = textValue(name: "globalAverage_market")
            checkDataRiseFallColor(risefallnumber: [object.percent_change_7d, object.percent_change_24h, object.percent_change_1h][filterDateSelection ?? 0] ?? 0.0, label: cell.coinChange, type: "Percent")
//            cell.priceChange =  [object.percent_change_7d, object.percent_change_24h, object.percent_change_1h][filterDateSelection ?? 0]
            cell.object = object
            return cell
        } else{
            return UICollectionViewCell()
        }
    }
    
    //市场总数据view,日期筛选view--cell的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == marketCell.totalCollectionView{
            return CGSize(width:(marketCell.totalCollectionView.frame.width-5) / 3, height: marketCell.totalCollectionView.frame.height)
        } else if collectionView == marketCell.filterDate{
            return CGSize(width:marketCell.filterDate.frame.width / 3, height: marketCell.filterDate.frame.height)
        } else if collectionView == marketCell.coinList{
            return CGSize(width:marketCell.frame.width-10, height: 70)
        }else{
            return CGSize()
        }
    }
    
    //市场总数据view,日期筛选view--cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == marketCell.totalCollectionView{
            return 0
        } else if collectionView == marketCell.filterDate{
            return 0
        } else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == marketCell.coinList{
            return 10
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == marketCell.coinList{
            return CGSize(width:marketCell.frame.width, height: 10)
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
        marketCell.sortCoin.inputAccessoryView = toolbar
        marketCell.sortCoin.inputView = sortPickerView
        sortPickerView.delegate = self
        sortPickerView.dataSource = self
        sortPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    //定义pickview done 按钮
    @objc func sortdoneclick(){
        let row = sortPickerView.selectedRow(inComponent: 0)
        marketCell.sortCoin.text = "▼ "+sortItems[row]
        view.endEditing(true)
        marketCell.coinList.reloadData()
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
                        self.marketCell.totalCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("the error \(error.localizedDescription)")
                }
            }
        }
        
        tickerDataFetcher.fetchTickerDataWrapper()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == marketCell.filterDate {
            filterDateSelection = indexPath.row
            marketCell.coinList.reloadData()
        }
        if collectionView == marketCell.coinList {
            let cell = marketCell.coinList.cellForItem(at: indexPath) as! MarketCollectionViewCell
            let global = GloabalController()
            global.coinDetail.coinName = cell.coinLabel.text!
            navigationController?.pushViewController(global, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
//            contentView.endEditing(true)
            marketCell.coinList.reloadData()
        } else{
            isSearching = true
            filteredCoinList = tickerDataRealmObjects.filter("symbol CONTAINS %@", searchBar.text!.uppercased())
            marketCell.coinList.reloadData()
        }
    }
    
    @objc func reloadDataAfterUpdateWatchList() {
        if tickerDataRealmObjects.count != 0 {
            spinner.stopAnimating()
        }
        marketCell.coinList.reloadData()
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
