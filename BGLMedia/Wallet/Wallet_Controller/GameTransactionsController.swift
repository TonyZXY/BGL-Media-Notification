//
//  GameTradingController.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/1/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift
import JGProgressHUD
import SwiftKeychainWrapper
import SwiftyJSON

class GameTransactionsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, TransactionFrom, UITextFieldDelegate {
    
    func setLoadPrice() {
        //will be called when coin is selected
        let index = IndexPath(row: 3, section: 0)
        let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
        cell.priceType.text = nil
    }
    
    var gameBalanceController: GameBalanceController?
    var newTransaction = EachTransactions()
    var cells = ["CoinTypeCell","CoinMarketCell","TradePairsCell","PriceCell","NumberCell","DateCell","TimeCell","AdditionalCell"]
    var color = ThemeColor()
    var transaction:String = "Buy"
    
    var transactionStatus = "Add"
    //var transactions = EachTransactions()
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var email:String{
        get{
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
        }
    }
    
    var certificateToken:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        }
    }
    
    //First load the page
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //Every time this page appear
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.loadPrice()
            self.transactionTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        if transaction == "Buy"{
            sectionView.backgroundColor = ThemeColor().blueColor()
        }else if transaction == "Sell" {
            sectionView.backgroundColor = ThemeColor().redColor()
        } else{
            sectionView.backgroundColor = ThemeColor().blueColor()
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    //Numbers of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    //Create table view each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[0], for: indexPath) as! TransCoinTypeCell
            cell.factor = factor
            cell.coinLabel.text = textValue(name: "coinForm")
            cell.coin.text = newTransaction.coinName
            if transactionStatus == "AddSpecific" {
                cell.isUserInteractionEnabled = false
                cell.accessoryType = .none
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[1], for: indexPath) as! TransCoinMarketCell
            cell.factor = factor
            cell.backgroundColor = color.themeColor()
            cell.marketLabel.text = textValue(name: "exchangeForm")
            cell.market.text = newTransaction.exchangeName
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[2], for: indexPath) as! TransTradePairsCell
            cell.factor = factor
            cell.tradeLabel.text = textValue(name: "tradingPairForm")
            if newTransaction.tradingPairsName == ""{
                cell.trade.text = ""
            } else {
                if newTransaction.tradingPairsName != ""{
                    cell.trade.text = newTransaction.coinAbbName + "/" + newTransaction.tradingPairsName
                }
            }
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[3], for: indexPath) as! TransPriceCell
            cell.factor = factor
            if transaction == "Buy"{
                cell.priceLabel.text = textValue(name: "buyPriceForm") + " " + newTransaction.tradingPairsName
            } else if transaction == "Sell"{
                cell.priceLabel.text = textValue(name: "sellPriceForm") + " " + newTransaction.tradingPairsName
            }
            cell.price.tag = indexPath.row
            cell.price.delegate = self
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[4], for: indexPath) as! TransNumberCell
            cell.factor = factor
            cell.gameUser = gameBalanceController?.gameUser
            cell.newTransaction = newTransaction
            if transaction == "Buy"{
                cell.numberLabel.text = textValue(name: "amountBoughtForm")
                cell.coinName = "AUD"
            } else if transaction == "Sell"{
                cell.numberLabel.text = textValue(name: "amountSoldForm")
                cell.coinName = (newTransaction.coinName == "") ? "Coin" : newTransaction.coinName
            }
            cell.number.tag = indexPath.row
            cell.number.delegate = self
            cell.isGameMode = true
            return cell
        } else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[5], for: indexPath) as! TransDateCell
            cell.factor = factor
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            if defaultLanguage == "CN"{
                datePicker.locale = Locale.init(identifier: "zh")
                formatter.locale = Locale(identifier: "zh")
            } else {
                datePicker.locale = Locale.init(identifier: "en")
                formatter.locale = Locale(identifier: "en")
            }
            cell.date.inputAccessoryView = toolBarDate
            cell.date.inputView = datePicker
            cell.date.text = formatter.string(from: datePicker.date)
            newTransaction.date = Extension.method.convertDateToStringPickerDate(date: datePicker.date)
            if transaction == "Buy"{
                cell.dateLabel.text = textValue(name: "buyDateForm")
            } else if transaction == "Sell"{
                cell.dateLabel.text = textValue(name: "sellDateForm")
            }
            cell.date.tag = indexPath.row
            textFieldDidEndEditing(cell.date)
            cell.date.delegate = self
            cell.pickerButton.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[6], for: indexPath) as! TransTimeCell
            cell.factor = factor
            
            let formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            if defaultLanguage == "CN"{
                timePicker.locale = Locale.init(identifier: "zh")
                formatter.locale = Locale(identifier: "zh")
            } else {
                timePicker.locale = Locale.init(identifier: "en")
                formatter.locale = Locale(identifier: "en")
            }
            cell.time.inputAccessoryView = toolBarTime
            cell.time.inputView = timePicker
            if transaction == "Buy"{
                cell.timeLabel.text = textValue(name: "buyTimeForm")
            } else if transaction == "Sell"{
                cell.timeLabel.text = textValue(name: "sellTimeForm")
            }
            
            cell.time.text = formatter.string(from: timePicker.date)
            newTransaction.time = Extension.method.convertTimeToStringPickerDate(date: timePicker.date)
            
            cell.time.tag = indexPath.row
            textFieldDidEndEditing(cell.time)
            cell.time.delegate = self
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[7], for: indexPath) as! TransAdditionalCell
            cell.factor = factor
            cell.additionalLabel.text = textValue(name: "additionalForm")
            cell.additional.text = newTransaction.additional
            cell.additional.tag = indexPath.row
            cell.additional.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let factor = view.frame.width/375
        if indexPath.row == 4 {
            return 150 * factor
        }
        return 80 * factor
    }
    
    @objc func showPickerView(){
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let searchdetail = SearchCoinController()
            searchdetail.hidesBottomBarWhenPushed = true
            searchdetail.delegate = self
            searchdetail.isGameMode = true
            navigationController?.pushViewController(searchdetail, animated: true)
        }
    }
    
    //Click add Transaction button, it will transfer the current trading price to specific price type, for example: USD -> AUD
    @objc func addTransaction(){
        guard let userID = gameBalanceController?.gameUser?.id else { return }
        transactionButton.isUserInteractionEnabled = false
        newTransaction.status = transaction

        let newDate = self.newTransaction.date + " " + self.newTransaction.time
        let trans:[String:Any] = [
            "status":newTransaction.status,
            "coinName":newTransaction.coinName,
            "coinAddName":newTransaction.coinAbbName,
            "exchangeName":newTransaction.exchangeName,
            "tradingPairName":newTransaction.tradingPairsName,
            "singlePrice":newTransaction.singlePrice,
            "amount":self.newTransaction.amount,
            "date":Extension.method.convertStringToDate2(date: newDate),
            "note":self.newTransaction.additional,
            ]
        let parameter:[String:Any] = ["token": certificateToken, "email": email, "user_id": userID, "transaction": trans]
        
        if String(newTransaction.amount) != "0.0" && String(newTransaction.singlePrice) != "0.0"{
            URLServices.fetchInstance.passServerData(urlParameters: ["game","addTransaction"], httpMethod: "POST", parameters: parameter) { (response, success) in
                //print(response)
                if success {
                    self.gameBalanceController?.gameUser?.updateCoinsBalance(response["data"]["account"])
                    self.gameBalanceController?.walletList.reloadData()
                } else {
                    //net work problem............
                }
                self.navigationController?.popViewController(animated: true)
            }
        } else{
            let hud = JGProgressHUD(style: .light)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.tintColor = ThemeColor().darkBlackColor()
            hud.textLabel.text = textValue(name: "error_transaction")
            hud.show(in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                hud.dismiss()
            }
            transactionButton.isUserInteractionEnabled = true
        }
    }
    
    //Click buy button it will turn to the "Buy" Type
    @objc func buyPage(){
        transaction = "Buy"
        buy.backgroundColor = ThemeColor().themeWidgetColor()
        sell.backgroundColor = ThemeColor().redColorTran()
        safeAreaView.backgroundColor = ThemeColor().blueColor()
        buy.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        sell.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
        transactionButton.backgroundColor = ThemeColor().themeWidgetColor()
        DispatchQueue.main.async {
            self.transactionTableView.reloadData()
        }
    }
    
    //Click buy button it will turn to the "Sell" Type
    @objc func sellPage(){
        transaction = "Sell"
        sell.backgroundColor = ThemeColor().redColor()
        buy.backgroundColor = ThemeColor().blueColorTran()
        safeAreaView.backgroundColor = ThemeColor().redColor()
        buy.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
        sell.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        transactionButton.backgroundColor = ThemeColor().redColor()
        DispatchQueue.main.async {
            self.transactionTableView.reloadData()
        }
    }
    
    //Load current selected coins trading price
    func loadPrice(){
        if newTransaction.coinName != "" && newTransaction.exchangeName != "" && newTransaction.tradingPairsName != ""{
            
            APIServices.fetchInstance.getHuobiAuCoinPrice(coinAbbName: newTransaction.coinAbbName, tradingPairName: newTransaction.tradingPairsName, exchangeName: newTransaction.exchangeName) { (response, success) in
                if success{
                    let index = IndexPath(row: 3, section: 0)
                    let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
                    let price = Double(response["tick"]["close"].string ?? "0") ?? 0
                    cell.price.text = "\(price)"
                    self.newTransaction.singlePrice = price
                    
                    let index2 = IndexPath(row: 4, section: 0)
                    let cell2 = self.transactionTableView.cellForRow(at: index2) as! TransNumberCell
                    cell2.price = price
                    cell2.calculateCoinAmount()
                }
            }
        }
    }
    
    //Set up all the layout constraint
    func setupView(){
        let factor = view.frame.width/375
        view.backgroundColor = ThemeColor().darkGreyColor()
        let titleLabel = UILabel()
        titleLabel.text = textValue(name: "navigationbar_transa")
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        languageLabel()
        transactionTableView.keyboardDismissMode = .onDrag
        
        view.addSubview(transactionButton)
        view.addSubview(transactionTableView)
        view.addSubview(addButtonView)
        addButtonView.addSubview(buy)
        addButtonView.addSubview(sell)
        
        transactionButton.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        //transactionTableView.rowHeight = 80 * factor
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":addButtonView,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":addButtonView,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        NSLayoutConstraint(item: buy, attribute: .centerY, relatedBy: .equal, toItem: addButtonView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sell, attribute: .centerY, relatedBy: .equal, toItem: addButtonView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addButtonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(20*factor)-[v0]-\(50*factor)-[v1(==v0)]-\(20*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buy,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        addButtonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buy,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        addButtonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buy,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buy,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(5*factor)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":addButtonView,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buy,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buy,"v1":sell,"v2":transactionTableView,"v3":transactionButton]))
        
        transactionButton.topAnchor.constraint(equalTo: transactionTableView.bottomAnchor).isActive = true
        transactionButton.heightAnchor.constraint(equalToConstant: 60*factor).isActive = true
        
        if #available(iOS 11.0, *) {
            transactionButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            view.addSubview(safeAreaView)
            safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            safeAreaView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        } else {
            transactionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.transactionTableView
        self.addChildViewController(tableVC)
        
    }
    
    //Delegate from search Page
    func getExchangeName() -> String {
        return newTransaction.exchangeName
    }
    
    func getCoinName() -> String {
        return newTransaction.coinAbbName
    }
    
    func setTradingPairsFirstType(firstCoinType: [String]) {
    }
    
    func setTradingPairsSecondType(secondCoinType: [String]) {
    }
    
    func setCoinName(name: String) {
        //transactions.coinName = name
        newTransaction.coinName = name
    }
    
    func setCoinAbbName(abbName: String) {
        //transactions.coinAbbName = abbName
        newTransaction.coinAbbName = abbName
    }
    
    func setExchangesName(exchangeName: String) {
        //transactions.exchangeName = exchangeName
        newTransaction.exchangeName = exchangeName
    }
    
    func setTradingPairsName(tradingPairsName: String) {
        //transactions.tradingPairsName = tradingPairsName
        newTransaction.tradingPairsName = tradingPairsName
    }
    
    //TextField edit delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 3{
            if textField.text == "" || textField.text == nil{
                textField.text = ""
                newTransaction.singlePrice = 0
            }
            if Extension.method.checkInputVaild(value: textField.text!){
                //transactions.singlePrice = Double(textField.text!)!
                newTransaction.singlePrice = Double(textField.text!)!
            }
        }
        if textField.tag == 4{
            if textField.text == "" || textField.text == nil{
                textField.text = ""
                newTransaction.amount = 0
            }
            if Extension.method.checkInputVaild(value: textField.text!){
                //transactions.amount = Double(textField.text!)!
                newTransaction.amount = Double(textField.text!)!
            }
        }
        if textField.tag == 5{
        }
        if textField.tag == 6{
        }
        if textField.tag == 7{
            //transactions.expenses = textField.text!
            newTransaction.expenses = textField.text!
        }
        if textField.tag == 8{
            //transactions.additional = textField.text!
            newTransaction.additional = textField.text!
        }
    }
    
    func languageLabel(){
        buy.setTitle(textValue(name: "buy"), for: .normal)
        sell.setTitle(textValue(name: "sell"), for: .normal)
        transactionButton.setTitle(textValue(name: "addTransaction"), for: .normal)
    }
    
    lazy var transactionTableView:UITableView = {
        var tableViews = UITableView()
        tableViews.backgroundColor = color.themeColor()
        tableViews.register(TransCoinTypeCell.self, forCellReuseIdentifier: "CoinTypeCell")
        tableViews.register(TransCoinMarketCell.self, forCellReuseIdentifier: "CoinMarketCell")
        tableViews.register(TransTradePairsCell.self, forCellReuseIdentifier: "TradePairsCell")
        tableViews.register(TransPriceCell.self, forCellReuseIdentifier: "PriceCell")
        tableViews.register(TransNumberCell.self, forCellReuseIdentifier: "NumberCell")
        tableViews.register(TransDateCell.self, forCellReuseIdentifier: "DateCell")
        tableViews.register(TransTimeCell.self, forCellReuseIdentifier: "TimeCell")
        tableViews.register(TransExpensesCell.self, forCellReuseIdentifier: "ExpensesCell")
        tableViews.register(TransAdditionalCell.self, forCellReuseIdentifier: "AdditionalCell")
        tableViews.rowHeight = 80
        tableViews.delegate = self
        tableViews.dataSource = self
        tableViews.separatorColor = ThemeColor().darkBlackColor()
        tableViews.separatorInset = UIEdgeInsets.zero
        tableViews.translatesAutoresizingMaskIntoConstraints = false
        return tableViews
    }()
    
    lazy var transactionButton:UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.semiBoldFont(20*view.frame.width/375)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        return button
    }()
    
    let addButtonView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buy:UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = ThemeColor().whiteColor()
        button.layer.cornerRadius = 5*view.frame.width/375
        button.titleLabel?.font = UIFont.semiBoldFont(15*view.frame.width/375)
        button.backgroundColor = ThemeColor().blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buyPage), for: .touchUpInside)
        return button
    }()
    
    lazy var sell:UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = ThemeColor().textGreycolor()
        button.layer.cornerRadius = 5*view.frame.width/375
        button.titleLabel?.font = UIFont.semiBoldFont(15*view.frame.width/375)
        button.backgroundColor = ThemeColor().redColorTran()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sellPage), for: .touchUpInside)
        return button
    }()
    
    
    var datepickerView:UIDatePicker = {
        var pickerView = UIDatePicker()
        pickerView.backgroundColor = ThemeColor().whiteColor()
        pickerView.datePickerMode = .date
        return pickerView
    }()
    
    lazy var datePicker:UIDatePicker = {
        var datePick = UIDatePicker()
        datePick.datePickerMode = .date
        datePick.maximumDate = Date()
        return datePick
    }()
    
    lazy var timePicker:UIDatePicker = {
        var timePick = UIDatePicker()
        timePick.datePickerMode = .time
        return timePick
    }()
    
    @objc func doneDateclick(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        if defaultLanguage == "CN"{
            formatter.locale = Locale(identifier: "zh")
        } else {
            formatter.locale = Locale(identifier: "en")
        }
        let index = IndexPath(row: 5, section: 0)
        let cell:TransDateCell = self.transactionTableView.cellForRow(at: index) as! TransDateCell
        cell.date.text = formatter.string(from: datePicker.date) + " ▼"
        newTransaction.date = Extension.method.convertDateToStringPickerDate(date: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func cancelclick(){
        view.endEditing(true)
    }
    
    lazy var toolBarDate:UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneItem = UIBarButtonItem(title: textValue(name: "picker_done"), style: .done, target: self, action: #selector(doneDateclick))
        doneItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        doneItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
        let cancelItem = UIBarButtonItem(title: textValue(name: "picker_cancel"), style: .done, target: self, action: #selector(cancelclick))
        cancelItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        cancelItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelItem,flexible,doneItem], animated: false)
        return toolbar
    }()
    
    lazy var toolBarTime:UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneItem = UIBarButtonItem(title: textValue(name: "picker_done"), style: .done, target: self, action: #selector(doneTimeClick))
        doneItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        doneItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
        let cancelItem = UIBarButtonItem(title: textValue(name: "picker_cancel"), style: .done, target: self, action: #selector(cancelclick))
        cancelItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        cancelItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelItem,flexible,doneItem], animated: false)
        return toolbar
    }()
    
    var safeAreaView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().blueColor()
        return view
    }()
    
    @objc func doneTimeClick(){
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        if defaultLanguage == "CN"{
            formatter.locale = Locale(identifier: "zh")
        } else {
            formatter.locale = Locale(identifier: "en")
        }
        let index = IndexPath(row: 6, section: 0)
        let cell:TransTimeCell = self.transactionTableView.cellForRow(at: index) as! TransTimeCell
        cell.time.text = formatter.string(from: timePicker.date) + " ▼"
        newTransaction.time = Extension.method.convertTimeToStringPickerDate(date: timePicker.date)
        view.endEditing(true)
    }
}
