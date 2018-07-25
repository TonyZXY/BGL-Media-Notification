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
            return [textValue(name: "filterByWeek_market"),textValue(name: "filterByDay_market"),textValue(name: "filterByHour_market")]
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
    var filterItem:[String] = ["percent7d","percent24h","percent1h"]
    
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
        DispatchQueue.main.async(execute: {
            self.coinList.beginHeaderRefreshing()
        })
        
        filterDate.selectItem(at: GlobalMarketsController.selectedIntervalIndexPath, animated: true, scrollPosition: [])
//
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateGlobalMarket), name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
//        let selectindexpath = NSIndexPath(item: 0, section: 0)
//        coinList.selectItem(at: selectindexpath as IndexPath, animated: true, scrollPosition:.left)
        
        APIServices.fetchInstance.getGlobalMarketData(){ ss in
            if ss{
                DispatchQueue.main.async {
                    self.mainTotalCollectionView.reloadData()
                }
            }
        }
//        print(realm.objects(GlobalAverageObject.self))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateGlobalMarket"), object: nil)
    }
    
    @objc func updateGlobalMarket(){
        coinList.reloadData()
    }
    
    func getCoinData(compeletion:@escaping (Bool)->Void){
        URLServices.fetchInstance.getGlobalAverageCoinList(){ success in
            if success{
                    compeletion(true)
            } else{
                print("Fail to get Global Average CoinList")
                compeletion(false)
            }
        }
    }
    

    
    func setUpView(){
//        view.addSubview(scrollView)
        view.addSubview(mainTotalCollectionView)
        view.addSubview(sortView)
        sortView.addSubview(sortCoin)
        sortView.addSubview(filterDate)
        view.addSubview(searchBar)
        view.addSubview(coinList)
        
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        coinList.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(self.coinList)
        })
        
        
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrollView]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrollView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortCoin]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0(80)]-0-[v1(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortView]))
        
        NSLayoutConstraint(item: sortCoin, attribute: .centerY, relatedBy: .equal, toItem: sortView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: filterDate, attribute: .centerY, relatedBy: .equal, toItem: sortView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":filterDate]))
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1(150)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":filterDate]))
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":filterDate]))
        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortCoin]))
        
//        sortView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(\(view.frame.width/2-20))]-", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortCoin,"v1":filterDate]))
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v1(\(view.frame.width/2-20))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":sortCoin]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView]))
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1(\(view.frame.width/2-20))]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":filterDate]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainTotalCollectionView,"v1":filterDate]))
        
//        NSLayoutConstraint(item: filterDate, attribute: .centerY, relatedBy: .equal, toItem: sortCoin, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-5-[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortView,"v1":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v1]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sortView,"v1":searchBar]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-5-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinList,"v1":searchBar]))
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
        collectview.backgroundColor = ThemeColor().themeColor()
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
    let sortCoin:UITextField={
        var sort = UITextField()
        sort.tintColor = .clear
//        sort.layer.borderColor = UIColor.white.cgColor
        sort.textColor = ThemeColor().textGreycolor()
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
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.barTintColor = ThemeColor().themeColor()
        searchBar.tintColor = ThemeColor().themeColor()
        searchBar.backgroundColor = ThemeColor().themeColor()
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var coinList:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.backgroundColor = ThemeColor().themeColor()
        collectionView.register(GlobalCoinListCell.self, forCellWithReuseIdentifier: "GlobalAverage")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    @objc func handleRefresh(_ collectionView: UICollectionView) {
        getCoinData(){success in
            if success{
                DispatchQueue.main.async {
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
                return 3
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
        if collectionView == mainTotalCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTotalCell", for: indexPath) as! TotalMarketCell
                cell.totalFunds.text = mainItems[indexPath.row]
            if globalMarket.count != 0 {
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
            var object = [coinHightestCapObjects,coinLowestCapObjects,coinGainersObjects,coinLosersObjects,coinAlphabeticalObjects][sortOption ?? 0][indexPath.row]
            if isSearching == true{
                object = filterObject[indexPath.row]
            }
            cell.object = object
            checkDataRiseFallColor(risefallnumber: [object.percent7d,object.percent24h,object.percent1h][filterOption], label: cell.coinChange, type: "PercentDown")
            return cell
        }else{
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainTotalCollectionView{
            return CGSize(width:(mainTotalCollectionView.frame.width) / 3, height: mainTotalCollectionView.frame.height)
        } else if collectionView == filterDate{
           return CGSize(width: 50, height: 20)
        } else if collectionView == coinList{
            return CGSize(width:view.frame.width-10, height: 70)
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
            return 5
        }else{
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == coinList{
            return CGSize(width:view.frame.width, height: 10)
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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
    
    
    
}
