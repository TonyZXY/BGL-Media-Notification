//
//  TransactionsController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 23/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift
import JGProgressHUD

class TransactionsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout,TransactionFrom,UITextFieldDelegate{
    
    
//   var datepickerView = UIDatePicker()
    
    func setLoadPrice() {
        let index = IndexPath(row: 3, section: 0)
        let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
        cell.priceType.text = nil
    }
    
    var newTransaction = EachTransactions()
    var cells = ["CoinTypeCell","CoinMarketCell","TradePairsCell","PriceCell","NumberCell","DateCell","TimeCell","AdditionalCell"]
    var color = ThemeColor()
    var transaction:String = "Buy"
    let cryptoCompareClient = CryptoCompareClient()
   
//    var transcationData = TransactionFormData()
    var updateTransaction = EachTransactions()
    var transactionStatus = "Add"
    var transactionNumber:Int = 0
    var transactions = EachTransactions()
//    var inputStatus = false
    
    //First load the page
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        updateTransactionDetail()
        
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
            view.backgroundColor = ThemeColor().blueColor()
        }else if transaction == "Sell" {
            sectionView.backgroundColor = ThemeColor().redColor()
            view.backgroundColor = ThemeColor().redColor()
        } else{
            sectionView.backgroundColor = ThemeColor().blueColor()
            view.backgroundColor = ThemeColor().blueColor()
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
            if transactionStatus == "Update" || transactionStatus == "AddSpecific"{
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
            if transactionStatus == "Update"{
                cell.price.text = Extension.method.scientificMethod(number: newTransaction.singlePrice)
            }
            cell.price.tag = indexPath.row
            cell.price.delegate = self
//            cell.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//            cell.layer.shadowOffset = CGSize(width: 0, height: 3)
//            cell.layer.shadowOpacity = 1
//            cell.layer.shadowRadius = 0
//            cell.layer.masksToBounds = false
            return cell
        } else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[4], for: indexPath) as! TransNumberCell
            cell.factor = factor
            if transaction == "Buy"{
                cell.numberLabel.text = textValue(name: "amountBoughtForm")
            } else if transaction == "Sell"{
                cell.numberLabel.text = textValue(name: "amountSoldForm")
            }
            if transactionStatus == "Update"{
                cell.number.text = String(newTransaction.amount)
            }
            cell.number.tag = indexPath.row
            cell.number.delegate = self
            cell.number.clearsOnBeginEditing = true
            return cell
        } else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[5], for: indexPath) as! TransDateCell
            cell.factor = factor
//            let toolbar = UIToolbar()
//            toolbar.sizeToFit()
//
//            let doneItem = UIBarButtonItem()
//            doneItem.title = textValue(name: "back_button")
//            doneItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//            doneItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
//
//
//
////            let donebutton = UIBarButtonItem(barButtonSystemItem: , target: self, action: #selector(doneclick))
//            let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
//            let cancelbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelclick))
//            toolbar.setItems([cancelbutton,flexible,doneItem], animated: false)
//            datePicker.datePickerMode = .date
//            datePicker.maximumDate = Date()
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
            cell.date.text = formatter.string(from: datePicker.date) + " ▼"
            newTransaction.date = Extension.method.convertDateToStringPickerDate(date: datePicker.date)
//            cell.date.frame = CGRect(x: 0, y: 0, width: cell.date.frame.width+30, height: 20)
            if transaction == "Buy"{
                cell.dateLabel.text = textValue(name: "buyDateForm")
            } else if transaction == "Sell"{
                cell.dateLabel.text = textValue(name: "sellDateForm")
            }
            if transactionStatus == "Update"{
                let updateDate = Extension.method.convertStringToDatePickerDate(date: newTransaction.date)
                cell.date.text = formatter.string(from: updateDate) + " ▼"
            }
            cell.date.tag = indexPath.row
            textFieldDidEndEditing(cell.date)
            cell.date.delegate = self
            cell.pickerButton.addTarget(self, action: #selector(showPickerView), for: .touchUpInside)
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
            
            if transactionStatus == "Update"{
                let updateTime = Extension.method.convertStringToTimePickerDate(date: newTransaction.time)
                cell.time.text = formatter.string(from: updateTime) + " ▼"
            } else{
                cell.time.text = formatter.string(from: timePicker.date) + " ▼"
                newTransaction.time = Extension.method.convertTimeToStringPickerDate(date: timePicker.date)
            }
            
            
            
            cell.time.tag = indexPath.row
            textFieldDidEndEditing(cell.time)
            cell.time.delegate = self
            return cell
        }
//        else if indexPath.row == 7{
//            let cell = tableView.dequeueReusableCell(withIdentifier: cells[7], for: indexPath) as! TransExpensesCell
//            cell.expensesLabel.text = textValue(name: "trasactionFeeForm")
//            cell.expensesbutton.text = textValue(name: "transactionFeeButtonForm")
//            cell.changeText(first: transcationData.tradingPairsFirst,second:transcationData.tradingPairsSecond)
//            cell.expenses.text = String(newTransaction.expenses)
//            cell.expenses.tag = indexPath.row
//            cell.expenses.delegate = self
//            return cell
//        }
        else if indexPath.row == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[7], for: indexPath) as! TransAdditionalCell
            cell.factor = factor
            cell.additionalLabel.text = textValue(name: "additionalForm")
            cell.additional.text = newTransaction.additional
            cell.additional.tag = indexPath.row
            cell.additional.delegate = self
            return cell
        }else {
            return UITableViewCell()
        }
    }
    
    @objc func showPickerView(){
//        let datePickerContainer = UIView()
//        datePickerContainer.frame = CGRect(x: 0, y: view.frame.height-300, width: view.frame.width, height: 300)
//        datePickerContainer.backgroundColor = UIColor.white
//        datepickerView.frame = CGRect(x: 0, y: 30, width: view.frame.width, height: 250)
//        datepickerView.maximumDate = Date()
//        datepickerView.datePickerMode = UIDatePickerMode.date
////        datepickerView.addTarget(self, action: "dateChangedInDate:", forControlEvents: .valueChanged)
//        datePickerContainer.addSubview(datepickerView)
//        var doneButton = UIButton()
//        doneButton.setTitle("Done", for: .normal)
//        doneButton.titleLabel?.font = UIFont.semiBoldFont(18)
//        doneButton.setTitleColor(UIColor.blue, for: .normal)
////        doneButton.addTarget(self, action: Selector("dismissPicker:"), forControlEvents: UIControlEvents.TouchUpInside)
//        doneButton.frame = CGRect(x: view.frame.width-50, y: 5, width: 70.0, height: 30.0)
//        datePickerContainer.addSubview(doneButton)
//        self.view.addSubview(datePickerContainer)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let searchdetail = SearchCoinController()
            searchdetail.hidesBottomBarWhenPushed = true
            searchdetail.delegate = self
            navigationController?.pushViewController(searchdetail, animated: true)
        } else if indexPath.row == 1{
            let searchdetail = SearchExchangesController()
            searchdetail.hidesBottomBarWhenPushed = true
            searchdetail.delegate = self
            navigationController?.pushViewController(searchdetail, animated: true)
        } else if indexPath.row == 2{
            let searchdetail = SearchTradingPairController()
            searchdetail.hidesBottomBarWhenPushed = true
            searchdetail.delegate = self
            navigationController?.pushViewController(searchdetail, animated: true)
        }
    }
    
    //Click add Transaction button, it will transfer the current trading price to specific price type, for example: USD -> AUD
    @objc func addTransaction(){
        transactionButton.isUserInteractionEnabled = false
        newTransaction.totalPrice = Double(newTransaction.amount) * newTransaction.singlePrice
        newTransaction.status = transaction
        
        if newTransaction.coinName != "" && newTransaction.coinName != "" && newTransaction.exchangeName != "" && newTransaction.tradingPairsName != "" && String(newTransaction.amount) != "0.0" && String(newTransaction.singlePrice) != "0.0"{
            
            transactionButton.setTitle(textValue(name: "loading"), for: .normal)
            
            APIServices.fetchInstance.getCryptoCurrencyApis(from: self.newTransaction.tradingPairsName, to: ["AUD","USD","JPY","EUR","CNY"]) { (success, response) in
                if success{
                    let allCurrencys = List<EachCurrency>()
                    for result in response{
                        let currencys = EachCurrency()
                        currencys.name = result.0
                        currencys.price = ((result.1.double) ?? 0) * self.newTransaction.singlePrice
                        allCurrencys.append(currencys)
                    }
                    self.newTransaction.currency = allCurrencys
                   

                    if self.transactionStatus == "Update"{
                        self.UpdateTransactionToRealm(){succees in
                            if success{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTransaction"), object: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTransaction"), object: nil)
                                self.navigationController?.popViewController(animated: true)
                            } else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        self.AddTransactionToRealm(){success in
                            if success{
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTransaction"), object: nil)
                                if self.transactionStatus == "AddSpecific"{
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTransaction"), object: nil)
                                } else{
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
                                }
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                 self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                } else{
                    self.navigationController?.popViewController(animated: true)
                }
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
    
    func AddTransactionToRealm(completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        let lastId = (realm.objects(EachTransactions.self).sorted(byKeyPath: "id").last?.id) ?? 0
        self.newTransaction.id = lastId + 1
        let tran = Transactions()
        tran.coinAbbName = self.newTransaction.coinAbbName
        tran.coinName = self.newTransaction.coinName
        tran.exchangeName = self.newTransaction.exchangeName
        tran.tradingPairsName = self.newTransaction.tradingPairsName
        let object = realm.objects(Transactions.self).filter("coinAbbName == %@", self.newTransaction.coinAbbName)
        
        try! realm.write {
            if object.count != 0{
//                if self.newTransaction.exchangeName != "Global Average"{
                    object[0].exchangeName = self.newTransaction.exchangeName
                    object[0].tradingPairsName = self.newTransaction.tradingPairsName
//                }
                object[0].everyTransactions.append(self.newTransaction)
            } else{
                tran.everyTransactions.append(self.newTransaction)
                realm.add(tran)
            }
        }
        completion(true)
    }
    
    func UpdateTransactionToRealm(completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        try! realm.write {
            realm.add(newTransaction, update: true)
        }
        completion(true)
    }
    
    
    
    //Write transaction to realm
//    func writeToRealm(){
//        //Write to Transaction Model to realm
//        realm.beginWrite()
//        var currentTransactionId:Int = 0
//        if transactionStatus == "Update"{
//            currentTransactionId = newTransaction.id
//        } else {
//            let transaction = realm.objects(AllTransactions.self)
//            if transaction.count != 0{
//                currentTransactionId = (transaction.last?.id)! + 1
//            } else {
//                currentTransactionId = 1
//            }
//        }
//        let realmData:[Any] = [currentTransactionId,newTransaction.status,newTransaction.coinName,newTransaction.coinAbbName,newTransaction.exchangeName, newTransaction.tradingPairsName,newTransaction.singlePrice,newTransaction.totalPrice,newTransaction.amount,newTransaction.date,newTransaction.time,newTransaction.expenses,newTransaction.additional,0,0,0,0,newTransaction.currency]
//        if realm.object(ofType: AllTransactions.self, forPrimaryKey: currentTransactionId) == nil {
//            realm.create(AllTransactions.self, value: realmData)
//        } else {
//            realm.create(AllTransactions.self, value: realmData, update: true)
//        }
//        try! realm.commitWrite()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
//        self.navigationController?.popViewController(animated: true)
//    }
    
    //Click buy button it will turn to the "Buy" Type
    @objc func buyPage(){
        transaction = "Buy"
        buy.backgroundColor = ThemeColor().themeWidgetColor()
        sell.backgroundColor = ThemeColor().redColorTran()
        view.backgroundColor = ThemeColor().blueColor()
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
        view.backgroundColor = ThemeColor().redColor()
        buy.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
        sell.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        transactionButton.backgroundColor = ThemeColor().redColor()
        DispatchQueue.main.async {
            self.transactionTableView.reloadData()
        }
    }
    
    //Load current selected coins trading price
    func loadPrice(){
//        if transactionNumber == 1 {
//            transactionNumber = 0
//        } else {
            var readData:Double = 0
            if newTransaction.coinName != "" && newTransaction.exchangeName != "" && newTransaction.tradingPairsName != ""{
                if newTransaction.exchangeName == "Global Average"{
                    let index = IndexPath(row: 3, section: 0)
                    let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
                    cell.priceType.text = " "
                    URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + newTransaction.coinAbbName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
                        if success{
                            if let result = response["quotes"].array{
                                for results in result{
                                    if results["currency"].string ?? "" == priceType{
                                        let price = results["data"]["price"].double ?? 0
//                                        let index = IndexPath(row: 3, section: 0)
//                                        let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
                                        cell.priceType.text = Extension.method.scientificMethod(number: price)
                                    }
                                }
                            }
                        }
                    }
                } else{
//                    APIServices.fetchInstance.getExchangePriceData(from: newTransaction.coinAbbName, to: newTransaction.tradingPairsName, market:  newTransaction.exchangeName) { (success, response) in
//                        if #imageLiteral(resourceName: "success"){
//
//                        }
//
//
//                        result in
//                        switch result{
//                        case .success(let resultData):
//                            for(_, value) in resultData!{
//                                readData = value
//                            }
//                            let index = IndexPath(row: 3, section: 0)
//                            let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
//                            cell.priceType.text = Extension.method.scientificMethod(number: readData)
//                        case .failure(let error):
//                            print("the error \(error.localizedDescription)")
//                        }
//                    }
                    
                    
                    
                    cryptoCompareClient.getTradePrice(from: newTransaction.coinAbbName, to: newTransaction.tradingPairsName, exchange: newTransaction.exchangeName){
                        result in
                        switch result{
                        case .success(let resultData):
                            for(_, value) in resultData!{
                                readData = value
                            }
                            let index = IndexPath(row: 3, section: 0)
                            let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
                            cell.priceType.text = Extension.method.scientificMethod(number: readData)
                        case .failure(let error):
                            print("the error \(error.localizedDescription)")
                        }
                    }
                }
            } else{
                newTransaction.singlePrice = 0
            }
//        }
    }
    
    //If this page is open from transaction history page, it can display the data in the transaction form and allow them to update
    func updateTransactionDetail(){
        if transactionStatus == "Update"{
//            transactionNumber = 1
            newTransaction.id = updateTransaction.id
            newTransaction.coinAbbName = updateTransaction.coinAbbName
            newTransaction.coinName = updateTransaction.coinName
            newTransaction.exchangeName = updateTransaction.exchangeName
            newTransaction.tradingPairsName = updateTransaction.tradingPairsName
            newTransaction.singlePrice = updateTransaction.singlePrice
            newTransaction.amount = updateTransaction.amount
            newTransaction.date = updateTransaction.date
            newTransaction.time = updateTransaction.time
            newTransaction.expenses = updateTransaction.expenses
            newTransaction.additional = updateTransaction.additional
//            transcationData.tradingPairsFirst = [newTransaction.coinAbbName,"%" + newTransaction.coinAbbName]
//            transcationData.tradingPairsSecond = [newTransaction.tradingPairsName, "%" + newTransaction.coinAbbName]
        }
    }
    
    //Set up all the layout constraint
    func setupView(){
        let factor = view.frame.width/375
        view.backgroundColor = ThemeColor().blueColor()
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
        transactionTableView.rowHeight = 80 * factor
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
//        return transactions.exchangeName
    }
    
    func getCoinName() -> String {
        return newTransaction.coinAbbName
//        return transactions.coinAbbName
    }
    
    func setTradingPairsFirstType(firstCoinType: [String]) {
//        transcationData.tradingPairsFirst = firstCoinType
    }
    
    func setTradingPairsSecondType(secondCoinType: [String]) {
//        transcationData.tradingPairsSecond = secondCoinType
    }
    
    func setCoinName(name: String) {
        transactions.coinName = name
        newTransaction.coinName = name
    }
    
    func setCoinAbbName(abbName: String) {
        transactions.coinAbbName = abbName
        newTransaction.coinAbbName = abbName
    }
    
    func setExchangesName(exchangeName: String) {
        transactions.exchangeName = exchangeName
        newTransaction.exchangeName = exchangeName
    }
    
    func setTradingPairsName(tradingPairsName: String) {
        transactions.tradingPairsName = tradingPairsName
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
                transactions.singlePrice = Double(textField.text!)!
                newTransaction.singlePrice = Double(textField.text!)!
            }
        }
        if textField.tag == 4{
            if textField.text == "" || textField.text == nil{
                textField.text = ""
                newTransaction.amount = 0
            }
            if Extension.method.checkInputVaild(value: textField.text!){
                transactions.amount = Double(textField.text!)!
                newTransaction.amount = Double(textField.text!)!
            }
//            self.newTransaction.usdTotalPrice = newTransaction.usdSinglePrice * Double(self.newTransaction.amount)
//            self.newTransaction.audTotalPrice = newTransaction.audSinglePrice * Double(self.newTransaction.amount)
        }
        if textField.tag == 5{
//            transactions.date = textField.text!
//            print(textField.text!)
//            newTransaction.date = textField.text!
        }
        if textField.tag == 6{
//            transactions.time = textField.text!
//            newTransaction.time = textField.text!
        }
        if textField.tag == 7{
            transactions.expenses = textField.text!
            newTransaction.expenses = textField.text!
        }
        if textField.tag == 8{
            transactions.additional = textField.text!
            newTransaction.additional = textField.text!
        }
    }
    
    func languageLabel(){
        buy.setTitle(textValue(name: "buy"), for: .normal)
        sell.setTitle(textValue(name: "sell"), for: .normal)
        if transactionStatus == "Update" {
            transactionButton.setTitle(textValue(name: "updateTransaction"), for: .normal)
        } else {
            transactionButton.setTitle(textValue(name: "addTransaction"), for: .normal)
        }
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
//        tableViews.bounces = false
        tableViews.separatorColor = ThemeColor().darkBlackColor()
        tableViews.separatorInset = UIEdgeInsets.zero
//        tableViews.separatorColor = UIColor.black
//        tableViews.separatorInset = UIEdgeInsets.init(top: -30, left: 0, bottom: -10, right: 0)
        tableViews.translatesAutoresizingMaskIntoConstraints = false
        //        tableViews.separatorStyle = .none
        return tableViews
    }()
    
    lazy var transactionButton:UIButton = {
        var button = UIButton(type: .system)
//        if transactionStatus == "Add" {
//            button.setTitle("添加交易", for: .normal)
//        } else if transactionStatus == "Update" {
//            button.setTitle("更新交易", for: .normal)
//        }
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
    
//    lazy var toolBar:UIToolbar = {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let doneItem = UIBarButtonItem(title: textValue(name: "back_button"), style: .done, target: self, action: #selector(doneclick))
//        doneItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//        doneItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
//        let cancelItem = UIBarButtonItem(title: textValue(name: "back_button"), style: .done, target: self, action: #selector(cancelclick))
//        cancelItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//        cancelItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().systemBarButtonColor()], for: .normal)
//        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
//        toolbar.setItems([cancelItem,flexible,doneItem], animated: false)
//        return toolbar
//    }()
    
}
