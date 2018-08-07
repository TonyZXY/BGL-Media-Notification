//
//  GlobalMarketsController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 11/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift

class GlobalMarketsController:  UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate, UIPickerViewDataSource,UISearchBarDelegate{
    private static var selectedIntervalIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var pickerRow:[String]{
        get{
            return [textValue(name: "sortByHighestCap_market"),textValue(name: "sortByLowestCap_market"),textValue(name: "sortByBiggestGainers_market"),textValue(name: "sortByBiggestLosers_market"),textValue(name: "sortByLetter_market")]
        }
    }
    
    var filterItems:[String]{
        get{
            return [textValue(name: "filterByHour_market"),textValue(name: "filterByDay_market"), textValue(name: "filterByWeek_market")]
        }
    }

    var mainItems:[String]{
        get{
            return [textValue(name: "marketCap_Market"),textValue(name: "market_24hVolume"),textValue(name: "btcDominance_market")]
        }
    }
    
    let sortPickerView = UIPickerView()
    let realm = try! Realm()
    var filterOption:Int = 0
    var isSearching = false
    var filterItem:[String] = ["percent1h","percent24h","percent7d"]
    var changeLaugageStatus:Bool = false
    var changeCurrencyStatus:Bool = false
    
    var sortOption: Int? {
        get {
            return sortPickerView.selectedRow(inComponent: 0)
        }
    }
    
    var coinAlphabeticalObjects:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self).sorted(byKeyPath: "coinAbbName", ascending: true)
        }
    }
    
    var coinHightestCapObjects:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self).sorted(byKeyPath: "marketCap", ascending: false)
        }
    }
    
    var coinLowestCapObjects:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self).sorted(byKeyPath: "marketCap", ascending: true)
        }
    }
    
    var coinGainersObjects:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self).sorted(byKeyPath: filterItem[filterOption], ascending: false)
        }
    }
    
    var coinLosersObjects:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self).sorted(byKeyPath: filterItem[filterOption], ascending: true)
        }
    }
    
    var allCoinData:Results<GlobalAverageObject>{
        get{
            return realm.objects(GlobalAverageObject.self)
        }
    }
    
    var globalMarket:Results<GlobalMarketValueRealm>{
        get{
            return realm.objects(GlobalMarketValueRealm.self)
        }
    }
    
    var filterObject = try! Realm().objects(GlobalAverageObject.self)
    
//    var sortCoinList:[GlobalAverageObject]{
//        didSet{
//
//        }
//    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRow.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerRow[row]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()     
        setUpView()
        setSortbutton()
        sortdoneclick()
        filterDate.selectItem(at: GlobalMarketsController.selectedIntervalIndexPath, animated: true, scrollPosition: [])
        DispatchQueue.main.async(execute: {
            self.coinList.beginHeaderRefreshing()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGlobalMarket), name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency), name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeMarketData), name: NSNotification.Name(rawValue: "reloadGlobalNewMarketData"), object: nil)
    }
    
    @objc func changeMarketData(){
        coinList.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if changeLaugageStatus || changeCurrencyStatus {
            if changeLaugageStatus{
                coinList.switchRefreshHeader(to: .removed)
                coinList.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
                    self.handleRefresh(self.coinList)
                    
                })
            }
            self.changeLaugageStatus = false
            self.changeCurrencyStatus = false
            coinList.switchRefreshHeader(to: .refreshing)
        }
    }
    
    @objc func changeCurrency(){
        changeCurrencyStatus = true
    }
    
    @objc func changeLanguage(){
        changeLaugageStatus = true
        mainTotalCollectionView.reloadData()
        filterDate.reloadData()
        sortdoneclick()
        filterDate.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadGlobalNewMarketData"), object: nil)
    }
    
    @objc func updateGlobalMarket(){
        coinList.reloadData()
    }
    
    func getCoinData(completion:@escaping (Bool)->Void){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        APIServices.fetchInstance.getGlobalMarketData(){ success in
            if success{
                dispatchGroup.leave()
            } else{
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        URLServices.fetchInstance.getGlobalAverageCoinList(){ success in
            if success{
                dispatchGroup.leave()
            } else{
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue:.main){
            completion(true)
        }
    }
    

    
    func setUpView(){
        let width = view.frame.width
        let factor = width/414
//        view.addSubview(scrollView)
        view.addSubview(mainTotalCollectionView)
        view.addSubview(sortView)
        sortView.addSubview(sortCoin)
        sortView.addSubview(filterDate)
        view.addSubview(searchBar)
        view.addSubview(coinList)
        
        
        
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrollView]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrollView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortCoin]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(5*factor)-[v0(\(80*factor))]-0-[v1(\(40*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortView]))
        
        NSLayoutConstraint(item: sortCoin, attribute: .centerY, relatedBy: .equal, toItem: sortView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: filterDate, attribute: .centerY, relatedBy: .equal, toItem: sortView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":filterDate]))
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1(\(150*factor))]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":filterDate]))
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(20*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":filterDate]))
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(20*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortCoin]))
        
//        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(\(view.frame.width/2-20))]-", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":filterDate]))
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v1(\(view.frame.width/2-20))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortCoin]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView]))
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1(\(view.frame.width/2-20))]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":filterDate]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":filterDate]))
        
//        NSLayoutConstraint(item: filterDate, attribute: .centerY, relatedBy: .equal, toItem: sortCoin, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(5*factor)-[v1(\(30*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortView,"v1":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v1]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortView,"v1":searchBar]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(5*factor)-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
        
    }
    
    var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = ThemeColor().walletCellcolor()
//        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var mainTotalCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectview = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectview.backgroundColor = ThemeColor().walletCellcolor()
        collectview.delegate = self
        collectview.dataSource = self
        collectview.translatesAutoresizingMaskIntoConstraints = false
        collectview.register(TotalMarketCell.self, forCellWithReuseIdentifier: "MainTotalCell")
        return collectview
    }()
    
    let sortView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //排序按钮
    lazy var sortCoin:UITextField={
        let factor = view.frame.width/414
        var sort = UITextField()
        sort.tintColor = .clear
//        sort.layer.borderColor = UIColor.white.cgColor
        sort.textColor = ThemeColor().textGreycolor()
        sort.font = UIFont.regularFont(16*factor)
        sort.translatesAutoresizingMaskIntoConstraints = false
        return sort
    }()
    
    //时间分类
    lazy var filterDate:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collect = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collect.backgroundColor = ThemeColor().themeColor()
        collect.register(GlobalFilterCollectionView.self, forCellWithReuseIdentifier: "filterDate")
        collect.translatesAutoresizingMaskIntoConstraints = false
        collect.delegate = self
        collect.dataSource = self
        return collect
    }()
    
    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.backgroundColor = ThemeColor().darkGreyColor()
//        searchBar.isTranslucent = false
        searchBar.searchBarStyle = .default
        searchBar.returnKeyType = .search
        searchBar.layer.borderWidth = 1
        searchBar.barTintColor = ThemeColor().themeColor()
        searchBar.layer.borderColor = ThemeColor().darkGreyColor().cgColor
        searchBar.layer.backgroundColor = ThemeColor().darkGreyColor().cgColor
        searchBar.delegate = self
//        searchBar.showsCancelButton = true
//        searchBar.enablesReturnKeyAutomatically = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let attributes = [
            NSAttributedStringKey.foregroundColor : ThemeColor().whiteColor(),
            NSAttributedStringKey.font: UIFont.regularFont(13)
        ]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        return searchBar
    }()
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == nil || searchBar.text == ""{
            searchBar.text = ""
        }
    }
    
    
    
    lazy var coinList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = ThemeColor().themeColor()
        collectionView.register(GlobalCoinListCell.self, forCellWithReuseIdentifier: "GlobalAverage")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        collectionView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(collectionView)
        })
        return collectionView
    }()
    
    
    @objc func handleRefresh(_ collectionView: UICollectionView) {
        getCoinData(){success in
            if success{
                DispatchQueue.main.async {
                    self.mainTotalCollectionView.reloadData()
                    self.coinList.reloadData()
                    self.coinList.switchRefreshHeader(to: .normal(.success, 0.5))
                }
            } else{
                self.coinList.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    
    
    func setSortbutton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(sortdoneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let cancelbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(sortCancel))
        toolbar.setItems([cancelbutton,flexible,donebutton], animated: false)
        sortCoin.inputAccessoryView = toolbar
        sortCoin.inputView = sortPickerView
        sortPickerView.delegate = self
        sortPickerView.dataSource = self
        sortPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    @objc func sortdoneclick(){
        let row = sortPickerView.selectedRow(inComponent: 0)
        sortCoin.text = "▼ "+pickerRow[row]
        view.endEditing(true)
        self.coinList.reloadData()
    }
    
    @objc func sortCancel(){
        view.endEditing(true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainTotalCollectionView{
//            if globalMarket.count == 0{
//                return 0
//            } else{
                return 3
//            }
        }else if collectionView == filterDate{
            return 3
        }else if collectionView == coinList{
            if isSearching == true{
                return filterObject.count
            }
            return allCoinData.count
        } else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let factor = view.frame.width/414
        if collectionView == mainTotalCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTotalCell", for: indexPath) as! TotalMarketCell
                cell.factor = factor
                cell.totalFunds.text = mainItems[indexPath.row]
            if globalMarket.count != 0{
                let object = globalMarket[0]
                if indexPath.row == 0{
                    cell.number.text = object.total_market_cap + "B"
                } else if indexPath.row == 1{
                    cell.number.text = object.total_volume_24h + "B"
                } else if indexPath.row == 2{
                    cell.number.text = object.bitcoin_percentage_of_market_cap + "%"
                }
            }
            return cell
        } else if collectionView == filterDate{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterDate", for: indexPath) as! GlobalFilterCollectionView
            cell.label.text = filterItems[indexPath.row]
            return cell
        } else if collectionView == coinList{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlobalAverage", for: indexPath) as! GlobalCoinListCell
            cell.factor = factor
            var object = [coinHightestCapObjects,coinLowestCapObjects,coinGainersObjects,coinLosersObjects,coinAlphabeticalObjects][sortOption ?? 0][indexPath.row]
            if isSearching == true{
                object = filterObject[indexPath.row]
            }
            cell.object = object
            checkDataRiseFallColor(risefallnumber: [object.percent1h,object.percent24h,object.percent7d][filterOption], label: cell.coinChange, type: "PercentDown")
            return cell
        }else{
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let factor = view.frame.width/414
        if collectionView == mainTotalCollectionView{
            return CGSize(width:(mainTotalCollectionView.frame.width) / 3, height: mainTotalCollectionView.frame.height)
        } else if collectionView == filterDate{
           return CGSize(width: 50*factor, height: 20*factor)
        } else if collectionView == coinList{
            return CGSize(width:view.frame.width-10*factor, height: 70*factor)
        } else{
            return CGSize()
        }
    }
    
    //市场总数据view,日期筛选view--cell的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mainTotalCollectionView{
            return 0
        } else if collectionView == filterDate{
            return 0
        } else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coinList{
            return 5*view.frame.width/414
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let factor = view.frame.width/414
        if collectionView == coinList{
            return CGSize(width:view.frame.width*factor, height: 10*factor)
        } else{
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterDate {
            filterOption = indexPath.row
            GlobalMarketsController.selectedIntervalIndexPath = indexPath
            self.coinList.reloadData()
        } else if collectionView == coinList {
            let cell = coinList.cellForItem(at: indexPath) as! GlobalCoinListCell
            let global = GloabalController()
            global.hidesBottomBarWhenPushed = true
            global.pageStatus = "Global"
            global.coinDetail.coinName = cell.coinLabel.text!
            navigationController?.pushViewController(global, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            //            contentView.endEditing(true)
            coinList.reloadData()
        } else{
            isSearching = true
            filterObject = coinAlphabeticalObjects.filter("coinAbbName CONTAINS %@", searchBar.text!.uppercased())
            coinList.reloadData()
        }
    }
    
//    func searchbar
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        if indexPath.row == 0{
//            let index = IndexPath(row: 0, section: 0)
//            let cell:GlobalFilterCollectionView = coinList.cellForItem(at: index) as! GlobalFilterCollectionView
//            cell.isHighlighted = true
//        }
//
//    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        if collectionView == marketCell.coinList{
//            return 10
//        }else{
//            return CGFloat()
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == marketCell.coinList{
//            return CGSize(width:marketCell.frame.width, height: 10)
//        } else{
//            return CGSize()
//        }
//    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text == nil || searchBar.text == ""{
            searchBar.setShowsCancelButton(true, animated: true)
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.clearsContextBeforeDrawing = true
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
