//
//  AlertManageController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 22/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import RealmSwift

struct ExpandableNames{
    var isExpanded:Bool
    let name:[String]
}

class AlertManageController: UIViewController,UITableViewDelegate,UITableViewDataSource,TransactionFrom,UITextFieldDelegate{
    var newTransaction = AllTransactions()
    let cryptoCompareClient = CryptoCompareClient()
    let realm = try! Realm()
    var sectionPrice:Double = 0
    var inputPrice:String = ""
    func getExchangeName() -> String {
        return newTransaction.exchangName
    }
    
    func getCoinName() -> String {
        return newTransaction.coinAbbName
    }
    
    func setCoinName(name: String) {
        newTransaction.coinName = name
    }
    
    func setCoinAbbName(abbName: String) {
        newTransaction.coinAbbName = abbName
    }
    
    func setExchangesName(exchangeName: String) {
        newTransaction.exchangName = exchangeName
    }
    
    func setTradingPairsName(tradingPairsName: String) {
        newTransaction.tradingPairsName = tradingPairsName
    }
    
    func setTradingPairsFirstType(firstCoinType: [String]) {
        
    }
    
    func setTradingPairsSecondType(secondCoinType: [String]) {
        
    }
    func setSinglePrice(single: Double) {
        newTransaction.singlePrice = single
    }

    
    var twoDimension = [ExpandableNames(isExpanded: true, name: ["a","sf"]),ExpandableNames(isExpanded: true, name: ["sdf"])]

    var showIndexPaths = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
       
        
        let res = realm.objects(alertObject.self)
        print(res)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        loadPrice()
        DispatchQueue.main.async {
            self.alertTableView.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let coinImage = UIImageView(image: UIImage(named: "navigation_arrow.png"))
            coinImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            coinImage.clipsToBounds = true
            
            coinImage.contentMode = UIViewContentMode.scaleAspectFit
            coinImage.translatesAutoresizingMaskIntoConstraints = false
            coinImage.coinImageSetter(coinName: newTransaction.coinAbbName, width: 30, height: 30, fontSize: 5)
            let coinLabel = UILabel()
            coinLabel.translatesAutoresizingMaskIntoConstraints = false
            coinLabel.text = newTransaction.coinName
            
            
            //        let myTextField = UITextField()
            //        let bottomLine = CALayer()
            //        bottomLine.frame = CGRect(x: 0.0, y: myTextField.frame.height - 1, width: myTextField.frame.width, height: 1.0)
            //        bottomLine.backgroundColor = UIColor.white.cgColor
            //        myTextField.borderStyle = UITextBorderStyle.none
            //        myTextField.layer.addSublayer(bottomLine)
            let button = UIButton(type:.system)
            button.setTitle("Edit", for: .normal)
            //        button.backgroundColor = ThemeColor().bglColor()
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            button.tag = section
            
            
            
            let sectionView = UIView()
            sectionView.clipsToBounds = true
            sectionView.addSubview(button)
            sectionView.addSubview(coinImage)
            sectionView.addSubview(coinLabel)
            sectionView.backgroundColor = ThemeColor().bglColor()
            button.translatesAutoresizingMaskIntoConstraints = false
            //        views.translatesAutoresizingMaskIntoConstraints = false
            
            sectionView.layer.borderWidth = 1
            
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: coinImage, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: coinLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coinImage]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button]))
            
            return sectionView
        } else {
            let sectionView = UIView()
            sectionView.clipsToBounds = true
            sectionView.backgroundColor = ThemeColor().bglColor()

            let fixLabel = UILabel()
            fixLabel.text = textValue(name: "exampleLabel_alert")
            fixLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let priceLabel = UILabel()
            priceLabel.text = self.scientificMethod(number: sectionPrice) + " " + newTransaction.tradingPairsName
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            sectionView.addSubview(fixLabel)
            sectionView.addSubview(priceLabel)

            NSLayoutConstraint(item: fixLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: priceLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":fixLabel]))
             sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel]))
            return sectionView
        }
        

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
        return 60
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
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAlertCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            
            let exchangeSection = "Exchange: " + newTransaction.exchangName
            let tradingPairs = newTransaction.tradingPairsName == "" ? "TradingPairs: " : "TradingPairs: " + newTransaction.coinAbbName + "/" + newTransaction.tradingPairsName
            cell.textLabel?.text = indexPath.row == 0 ?  exchangeSection : tradingPairs
           
           
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "priceTextFieldCell", for: indexPath) as! priceNotificationCell
            
            cell.priceTextField.tag = indexPath.row
            cell.priceTextField.delegate = self
//            cell.priceTextField.text = inputPrice
            cell.priceTypeLabel.text = newTransaction.tradingPairsName
            cell.priceTypeLabel.backgroundColor = UIColor.yellow
            return cell
        }
//        let name = twoDimension[indexPath.section].name[indexPath.row]
        
        
//        cell.compareLabel.text = twoDimension[indexPath.section].name[indexPath.row]
        
//        cell.textLabel?.text = name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
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
        view.addSubview(alertTableView)
        view.addSubview(alertButton)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-3-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView,"v1":alertButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(80)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
    }
    
    lazy var alertTableView:UITableView = {
       var tableView = UITableView()
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "editAlertCell")
        tableView.register(priceNotificationCell.self, forCellReuseIdentifier: "priceTextFieldCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
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
        button.backgroundColor = ThemeColor().bglColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addTransaction), for: .touchUpInside)
        return button
    }()
    
    @objc func addTransaction(){        
        if newTransaction.coinName != "" && newTransaction.tradingPairsName != "" && newTransaction.exchangName != ""{
            realm.beginWrite()
            var currentTransactionId:Int = 0
            let transaction = realm.objects(alertObject.self)
            if transaction.count != 0{
                currentTransactionId = (transaction.last?.id)! + 1
            } else {
                currentTransactionId = 1
            }
            var compareStatus:Bool = false
            print(inputPrice)
            let price = Double(inputPrice)!
            
            if sectionPrice > price {
                compareStatus = true
            } else {
                compareStatus = false
            }
            let realmData:[Any] = [currentTransactionId,newTransaction.coinName,newTransaction.coinAbbName,newTransaction.tradingPairsName,newTransaction.exchangName,price,compareStatus,Date()]
            if realm.object(ofType: alertObject.self, forPrimaryKey: currentTransactionId) == nil {
                realm.create(alertObject.self, value: realmData)
            } else {
                realm.create(alertObject.self, value: realmData, update: true)
            }
            
            if realm.object(ofType: alertCoinNames.self, forPrimaryKey: newTransaction.coinName) == nil {
                realm.create(alertCoinNames.self, value: [newTransaction.coinName])
            } else {
                realm.create(alertCoinNames.self, value: [newTransaction.coinName], update: true)
            }
            
            try! realm.commitWrite()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addAlert"), object: nil)
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func loadPrice(){
        var readData:Double = 0
        if newTransaction.coinName != "" && newTransaction.exchangName != "" && newTransaction.tradingPairsName != ""{
            cryptoCompareClient.getTradePrice(from: newTransaction.coinAbbName, to: newTransaction.tradingPairsName, exchange: newTransaction.exchangName){
                result in
                switch result{
                case .success(let resultData):
                    for(_, value) in resultData!{
                        readData = value
                    }
                    self.sectionPrice = readData
                    self.alertTableView.reloadData()
                    self.newTransaction.singlePrice = Double(String(readData))!
                //                                        self.textFieldDidEndEditing(cell.price)
                case .failure(let error):
                    print("the error \(error.localizedDescription)")
                }
            }
        } else{
            newTransaction.singlePrice = 0
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            if textField.text == "" || textField.text == nil{
                textField.text = "0"
            } else{
                inputPrice = textField.text!
            }
    }
    
    
    
//

    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 0 {
//            if textField.text == "" || textField.text == nil{
//                textField.text = "0"
//            } else{
//                inputPrice = textField.text!
//            }
//            print(inputPrice)
//        }
//    }
}

//class EditAlertCell:UITableViewCell{
//    var status:Bool
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init has not been completed")
//    }
//}



