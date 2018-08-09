//
//  AlertManageController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 22/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

struct interset{
    var _id:Int = 0
    var coinFrom:String = "BTC"
    var coinTo:String = "AUD"
    var market:String = "BTCmarkets"
    var price:String = "123"
    var status:String = "true"
    var id:String = "123"
    var isGreater:String = "1"
}


//    "interest":["_id":"","coinFrom":"BTC","coinTo":"AUD","market":"BTCmarkets","price":123,"status":true,"id":"123","isGreater":1]


struct ExpandableNames{
    var isExpanded:Bool
    let name:[String]
}

class AlertManageController: UIViewController,UITableViewDelegate,UITableViewDataSource,TransactionFrom,UITextFieldDelegate{
    func setLoadPrice() {
    }
    
    var newTransaction = Transactions()
    let cryptoCompareClient = CryptoCompareClient()
    let realm = try! Realm()
    var sectionPrice:Double = 0
    var inputPrice:String = ""
    var intersetObject = alertObjects()
    var coinName = coinAlert()
    
    var status:String = "AddAlert"
    
    func getExchangeName() -> String {
        return intersetObject.exchangName
    }
    
    func getCoinName() -> String {
        return intersetObject.coinAbbName
    }
    
    func setCoinName(name: String) {
        intersetObject.coinName = name
    }
    
    func setCoinAbbName(abbName: String) {
        intersetObject.coinAbbName = abbName
    }
    
    func setExchangesName(exchangeName: String) {
        intersetObject.exchangName = exchangeName
    }
    
    func setTradingPairsName(tradingPairsName: String) {
        intersetObject.tradingPairs = tradingPairsName
    }
    
    func setTradingPairsFirstType(firstCoinType: [String]) {
        
    }
    
    func setTradingPairsSecondType(secondCoinType: [String]) {
        
    }
    func setSinglePrice(single: Double) {
        newTransaction.currentSinglePrice = single
    }
    
    
    
    var email:String{
        get{
            return UserDefaults.standard.string(forKey: "UserEmail")!
        }
    }
    
    var token:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken")!
        }
    }
    
    var twoDimension = [ExpandableNames(isExpanded: true, name: ["a","sf"]),ExpandableNames(isExpanded: true, name: ["sdf"])]
    
    
    var showIndexPaths = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadPrice()
        DispatchQueue.main.async {
            self.alertTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let factor = view.frame.width/375
        return 80 * factor
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        if section == 0{
            let coinImage = UIImageView(image: UIImage(named: "navigation_arrow.png"))
            coinImage.frame = CGRect(x: 0, y: 0, width: 30*factor, height: 30*factor)
            coinImage.clipsToBounds = true
            coinImage.contentMode = UIViewContentMode.scaleAspectFit
            coinImage.translatesAutoresizingMaskIntoConstraints = false
            let coinLabel = UILabel()
            coinLabel.translatesAutoresizingMaskIntoConstraints = false
            coinLabel.textColor = ThemeColor().whiteColor()
            
            let button = UIButton(type:.system)
            button.setTitle("Edit", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            button.tag = section
            
            if coinName.status{
                intersetObject.coinAbbName = coinName.coinAbbName
                intersetObject.coinName = coinName.coinName
                button.isHidden = true
            }
            if status == "Update"{
                button.isHidden = true
            }
            
            coinImage.coinImageSetter(coinName: intersetObject.coinAbbName, width: 30*factor, height: 30*factor, fontSize: 5*factor)
            coinLabel.text = "Coin Name: " + intersetObject.coinName
            coinLabel.font = UIFont.regularFont(14*factor)
            
            
            
            
            
            let sectionView = UIView()
            sectionView.clipsToBounds = true
            sectionView.addSubview(button)
            sectionView.addSubview(coinImage)
            sectionView.addSubview(coinLabel)
            sectionView.backgroundColor = ThemeColor().darkGreyColor()
            button.translatesAutoresizingMaskIntoConstraints = false
            //        views.translatesAutoresizingMaskIntoConstraints = false
            
//            sectionView.layer.borderWidth = 1
            
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: coinImage, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: coinLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0(\(30*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(30*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-\(10*factor)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coinImage]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button]))
            
            return sectionView
        } else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        if section == 0{
            let sectionView = UIView()
            sectionView.clipsToBounds = true
            sectionView.backgroundColor = ThemeColor().darkGreyColor()
            let fixLabel = UILabel()
            fixLabel.text = textValue(name: "exampleLabel_alert")
            fixLabel.font = UIFont.regularFont(14*factor)
            fixLabel.textColor = ThemeColor().whiteColor()
            fixLabel.translatesAutoresizingMaskIntoConstraints = false
            let priceLabel = UILabel()
            priceLabel.text = Extension.method.scientificMethod(number: sectionPrice) + " " + intersetObject.tradingPairs
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            priceLabel.textColor = ThemeColor().whiteColor()
            priceLabel.font = UIFont.regularFont(14*factor)
            sectionView.addSubview(fixLabel)
            sectionView.addSubview(priceLabel)
            priceLabel.tag = 100
            NSLayoutConstraint(item: fixLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: priceLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":fixLabel]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel]))
            return sectionView
        } else{
            return UIView()
        }
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleExpandClose(button:UIButton ){
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in twoDimension[section].name.indices{
            let indexPath = IndexPath(row:row,section:section)
            indexPaths.append(indexPath)
        }
        let isExpanded = twoDimension[section].isExpanded
        twoDimension[section].isExpanded = !isExpanded
        
        
        
        button.setTitle(isExpanded ? "Edit":"Edit", for: .normal)
        
        //        if !isExpanded{
        //            alertTableView.insertRows(at: indexPaths, with: .fade)
        //        } else{
        //            alertTableView.deleteRows(at: indexPaths, with: .fade)
        //        }
        let coin = SearchCoinController()
        coin.delegate = self
        navigationController?.pushViewController(coin, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
        } else{
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimension.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if !twoDimension[section].isExpanded{
        //            return 0
        //        }
        return twoDimension[section].name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAlertCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = ThemeColor().whiteColor()
            cell.textLabel?.font = UIFont.regularFont(15*factor)
            cell.backgroundColor = ThemeColor().greyColor()
            let exchangeSection = "Exchange: " + intersetObject.exchangName
            let tradingPairs = intersetObject.tradingPairs == "" ? "TradingPairs: " : "TradingPairs: " + intersetObject.coinAbbName + "/" + intersetObject.tradingPairs
            cell.textLabel?.text = indexPath.row == 0 ?  exchangeSection : tradingPairs
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "priceTextFieldCell", for: indexPath) as! priceNotificationCell
            cell.factor = factor
            cell.backgroundColor = ThemeColor().greyColor()
            cell.priceTextField.tag = indexPath.row
            cell.priceTextField.delegate = self
            cell.priceTextField.text = String(intersetObject.compare)
            cell.priceTypeLabel.text = intersetObject.tradingPairs
            
            return cell
        }
        //        let name = twoDimension[indexPath.section].name[indexPath.row]
        
        
        //        cell.compareLabel.text = twoDimension[indexPath.section].name[indexPath.row]
        
        //        cell.textLabel?.text = name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            //            intersetObject.exchangName = ""
            //            intersetObject.tradingPairs = ""
            let exchange = SearchExchangesController()
            exchange.delegate = self
            navigationController?.pushViewController(exchange, animated: true)
        }else if indexPath.section == 0 && indexPath.row == 1{
            let trading = SearchTradingPairController()
            trading.delegate = self
            navigationController?.pushViewController(trading, animated: true)
        }
    }
    
    func setUpView(){
        let factor = view.frame.width/375
        view.backgroundColor = ThemeColor().blueColor()
        if status == "Update"{
            alertButton.setTitle("Update", for: .normal)
            let navigationDoneButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAlert))
            self.navigationItem.setRightBarButton(navigationDoneButton, animated: true)
        }
        
        alertButton.titleLabel?.font = UIFont.semiBoldFont(18*factor)
        view.addSubview(alertTableView)
        view.addSubview(alertButton)
        alertButton.addTarget(self, action: #selector(addNewAlert), for: .touchUpInside)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView,"v1":alertButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(80*factor))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        
        alertButton.topAnchor.constraint(equalTo: alertTableView.bottomAnchor).isActive = true
        alertButton.heightAnchor.constraint(equalToConstant: 60*factor).isActive = true
        if #available(iOS 11.0, *) {
            alertButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//            let safeAreaView = UIView()
//            safeAreaView.translatesAutoresizingMaskIntoConstraints = false
//            safeAreaView.backgroundColor = ThemeColor().blueColor()
//            view.addSubview(safeAreaView)
//            safeAreaView.topAnchor.constraint(equalTo: alertButton.safeAreaLayoutGuide.bottomAnchor).isActive = true
//            safeAreaView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            alertButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    @objc func deleteAlert(){
        let body:[String:Any] = ["email":email,"token":token,"interest":[["_id":intersetObject.id]]]
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","deleteInterest"], httpMethod: "POST", parameters: body) { (response, success) in
            if success{
                print(response)
                let filterId = "id = " + String(self.intersetObject.id)
                let filterName = "coinAbbName = '" + self.intersetObject.coinAbbName + "' "
                
                let coinsAlert = self.realm.objects(alertObject.self).filter(filterName)
                
                try! self.realm.write {
                    self.realm.delete(self.realm.objects(alertObject.self).filter(filterId))
                }
                if coinsAlert.count == 0{
                    try! self.realm.write {
                        self.realm.delete(self.realm.objects(alertCoinNames.self).filter(filterName))
                    }
                }
                self.navigationController?.popViewController(animated: true)
            } else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    lazy var alertTableView:UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "editAlertCell")
        tableView.register(priceNotificationCell.self, forCellReuseIdentifier: "priceTextFieldCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var PriceTextFieldCell:UITableViewCell = {
        var tableViewCell = UITableViewCell()
        tableViewCell.translatesAutoresizingMaskIntoConstraints = false
        return tableViewCell
    }()
    
    lazy var alertButton:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(textValue(name: "alertDone_alert"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func addNewAlert(){
        if intersetObject.coinName != "" && intersetObject.exchangName != "" && intersetObject.tradingPairs != ""{
            var compareStatus:Int = 0
            let Inputprice = Double(inputPrice) ?? 0
            if sectionPrice < Inputprice {
                compareStatus = 1
            } else {
                compareStatus = 2
            }
            intersetObject.compare = Inputprice
            intersetObject.compareStatus = compareStatus
            if intersetObject.exchangName == "Global Average"{
                intersetObject.exchangName = "GLOBAL"
            }
            if status == "Update"{
                let interest:[String:Any] = ["_id":intersetObject.id,"from":intersetObject.coinAbbName,"to":intersetObject.tradingPairs,"market":intersetObject.exchangName,"price":intersetObject.compare,"isGreater":intersetObject.compareStatus]
                let body:[String:Any] = ["email":email,"token":token,"interest":interest]
                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","editInterest"], httpMethod: "POST", parameters: body) { (response, success) in
                    print(response)
                    if success{
                        self.realm.beginWrite()
                        let realmData:[Any] = [self.intersetObject.id,self.intersetObject.coinName,self.intersetObject.coinAbbName,self.intersetObject.tradingPairs,self.intersetObject.exchangName,self.intersetObject.compare,self.intersetObject.compareStatus,self.intersetObject.switchStatus,Date()]
                        if self.realm.object(ofType: alertObject.self, forPrimaryKey: self.intersetObject.id) == nil {
                            self.realm.create(alertObject.self, value: realmData)
                        } else {
                            self.realm.create(alertObject.self, value: realmData, update: true)
                        }
                        try! self.realm.commitWrite()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            } else{
                
                let inter:[String:Any] = ["from":intersetObject.coinAbbName,"to":intersetObject.tradingPairs,"market":intersetObject.exchangName,"price":intersetObject.compare ,"isGreater":intersetObject.compareStatus]
                let parameter = ["email":email,"token":token,"interest":inter] as [String : Any]
                
                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","addInterest"], httpMethod: "POST", parameters: parameter) { (response, success) in
                    if success{
                        print(response)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAlert"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAlert"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            
            //            realm.beginWrite()
            //            var currentTransactionId:Int = 0
            //            let transaction = realm.objects(alertObject.self)
            //            if transaction.count != 0{
            //                currentTransactionId = (transaction.last?.id)! + 1
            //            } else {
            //                currentTransactionId = 1
            //            }
            
            
            
            //
            //
            //
            //
            //
            //            let realmData:[Any] = [currentTransactionId,newTransaction.coinName,newTransaction.coinAbbName,newTransaction.tradingPairsName,newTransaction.exchangName,price,true,true,Date()]
            //            if realm.object(ofType: alertObject.self, forPrimaryKey: currentTransactionId) == nil {
            //                realm.create(alertObject.self, value: realmData)
            //            } else {
            //                realm.create(alertObject.self, value: realmData, update: true)
            //            }
            //
            //            if realm.object(ofType: alertCoinNames.self, forPrimaryKey: newTransaction.coinAbbName) == nil {
            //                realm.create(alertCoinNames.self, value: [newTransaction.coinAbbName,newTransaction.coinName])
            //            } else {
            //                realm.create(alertCoinNames.self, value: [newTransaction.coinAbbName,newTransaction.coinName], update: true)
            //            }
            
            //            try! realm.commitWrite()
            //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAlert"), object: nil)
            //            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func loadPrice(){
        var readData:Double = 0
        if intersetObject.coinName != "" && intersetObject.exchangName != "" && intersetObject.tradingPairs != ""{
            if intersetObject.exchangName == "Global Average"{
                URLServices.fetchInstance.passServerData(urlParameters: ["coin","getCoin?coin=" + intersetObject.coinAbbName], httpMethod: "GET", parameters: [String : Any]()) { (response, success) in
                    if success{
                        if let result = response["quotes"].array{
                            for results in result{
                                if results["currency"].string ?? "" == priceType{
                                    let price = results["data"]["price"].double ?? 0
                                    self.sectionPrice = price
                                    let indexPathForSection = NSIndexSet(index: 0)
                                    self.alertTableView.reloadSections(indexPathForSection as IndexSet, with: .automatic)
                                }
                            }
                        }
                    } else{

                    }
                }
            } else{
                cryptoCompareClient.getTradePrice(from: intersetObject.coinAbbName, to: intersetObject.tradingPairs, exchange: intersetObject.exchangName){
                    result in
                    switch result{
                    case .success(let resultData):
                        for(_, value) in resultData!{
                            readData = value
                        }
                        self.sectionPrice = readData
                        
                        
                        
                        //                    let cell:TransPriceCell = self.transactionTableView.cellForRow(at: index) as! TransPriceCell
                        //                    cell.priceType.text = Extension.method.scientificMethod(number: readData)
                        
                        
                        
                        let indexPathForSection = NSIndexSet(index: 0)
                        self.alertTableView.reloadSections(indexPathForSection as IndexSet, with: .automatic)
                        
                        
                        
                        //                    self.alertTableView.reloadData()
                        self.newTransaction.currentSinglePrice = Double(String(readData))!
                    case .failure(let error):
                        print("the error \(error.localizedDescription)")
                    }
                }
            }
        } else{
            newTransaction.currentSinglePrice = 0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text == nil{
            textField.text = "0"
        } else{
            if Extension.method.checkInputVaild(value: textField.text!){
               inputPrice = textField.text!
            }
        }
    }
    
    func sendAlertToServer(parameter: [String : Any], completion:@escaping (JSON, Bool)->Void){
        
        let url = URL(string: "http://10.10.6.18:3030/userLogin/addInterest")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        urlRequest.setValue("gmail.com",email)
        
        Alamofire.request(urlRequest).response { (response) in
            if let data = response.data{
                let res = JSON(data)
                UserDefaults.standard.set(true,forKey: "buildInterest")
                completion(res,true)
            }
        }
    }
    
    //    func getAlertFromServer(parameter: String, completion:@escaping (JSON, Bool)->Void){
    //
    //
    //
    //
    //
    //        let url = URL(string: "http://10.10.6.18:3030/userLogin/interestOfUser/" + parameter)
    //        var urlRequest = URLRequest(url: url!)
    //        urlRequest.httpMethod = "GET"
    //        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        Alamofire.request(urlRequest).response { (response) in
    //            if let data = response.data{
    //                var res = JSON(data)
    //                completion(res,true)
    //            }
    //        }
    //    }
    
}

