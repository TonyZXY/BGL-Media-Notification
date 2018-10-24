//
//  GameAlertManageController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 17/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import JGProgressHUD


struct GameAlert{
    var _id: Int = 0
    var coinName = ""
    var price: String = ""
    var id:String = ""
    var isGreater: String = ""
}

//struct ExpandableNames{
//    var isExpanded:Bool
//    let name:[String]
//}

class GameAlertManageController: UIViewController,UITableViewDelegate,UITableViewDataSource, TransactionFrom, UITextFieldDelegate{

    

    

    
    
    
//    var newTransaction = Transactions()
//    let cryptoCompareClient = CryptoCompareClient()
    var newTransaction = Transactions()
    var sectionPrice:Double = 0
    var inputPrice:String = ""
    var alertObject = GameAlertObject()
    var status: String = "AddAlert"
    var coinName = coinAlert()
    
    
    
    var email:String{
        get{
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
        }
    }
    
    var token:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken")!
        }
    }
    
    var userID: String{
        get{
            return UserDefaults.standard.string(forKey: "user_id") ?? "null"
        }
    }
    
    
    lazy var gameAlertTable: UITableView = {
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
    
    lazy var alertButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(textValue(name: "alertDone_alert"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
  
    var showIndexPaths = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPrice()
        DispatchQueue.main.async {
            self.gameAlertTable.reloadData()
        }
    }
    
    
    func setUpView(){
        let factor = view.frame.width/375
        view.backgroundColor = ThemeColor().blueColor()
        if status == "Update"{
            alertButton.setTitle("Update", for: .normal)
            let navigationDoneButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteGameAlert))
            self.navigationItem.setRightBarButton(navigationDoneButton, animated: true)
        }
        
        alertButton.titleLabel?.font = UIFont.semiBoldFont(18*factor)
        view.addSubview(gameAlertTable)
        view.addSubview(alertButton)
        alertButton.addTarget(self, action: #selector(addNewGameAlert), for: .touchUpInside)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":gameAlertTable]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":gameAlertTable,"v1":alertButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        //        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(80*factor))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        
        alertButton.topAnchor.constraint(equalTo: gameAlertTable.bottomAnchor).isActive = true
        alertButton.heightAnchor.constraint(equalToConstant: 60*factor).isActive = true
        if #available(iOS 11.0, *) {
            alertButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            alertButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
    
    func loadPrice(){
        
        print(alertObject)
        if alertObject.coinName != "" {
            APIServices.fetchInstance.getHuobiAuCoinPrice(coinAbbName: alertObject.coinAbbName, tradingPairName: "AUD", exchangeName: "Huobi Australia") { (response, success) in
                if success{
                    print("sdf")
                    let singlePrice = Double(response["tick"]["close"].string ?? "0") ?? 0
                    print(singlePrice)
                    self.sectionPrice = singlePrice
                    let indexPathForSection = NSIndexSet(index: 0)
                    self.gameAlertTable.reloadSections(indexPathForSection as IndexSet, with: .automatic)
                    self.newTransaction.defaultCurrencyPrice = singlePrice
                }
            }
        } else {
            newTransaction.defaultCurrencyPrice = 0
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width / 375
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editAlertCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textColor = ThemeColor().whiteColor()
            cell.textLabel?.font = UIFont.regularFont(15*factor)
            cell.backgroundColor = ThemeColor().greyColor()
            let exchangeSection = textValue(name: "exchange_alert") + textValue(name: "Huobi_Au")
            let tradingPairs =  textValue(name: "tradingPair_alert") + alertObject.coinAbbName+"/AUD"
            cell.textLabel?.text = indexPath.row == 0 ?  exchangeSection : tradingPairs
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "priceTextFieldCell", for: indexPath) as! priceNotificationCell
            cell.factor = factor
            cell.backgroundColor = ThemeColor().greyColor()
            cell.priceTextField.tag = indexPath.row
            cell.priceTextField.delegate = self
            cell.priceTypeLabel.text = "AUD"
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            button.setTitle(textValue(name: "edit_alert"), for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            button.tag = section
            
            if coinName.status{
                alertObject.coinAbbName = coinName.coinAbbName
                alertObject.coinName = coinName.coinName
                button.isHidden = true
            }
            if status == "Update"{
                button.isHidden = true
            }
            
            coinImage.coinImageSetter(coinName: alertObject.coinAbbName, width: 30 * factor, height: 30 * factor, fontSize: 5 * factor)
            coinLabel.text = textValue(name: "coinName_alert") + alertObject.coinName
            coinLabel.font = UIFont.regularFont(14 * factor)
            
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
            priceLabel.text = Extension.method.scientificMethod(number: sectionPrice) + " AUD"
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
    
    
    

    
    @objc func handleExpandClose(button: UIButton){
        let coin = SearchCoinController()
        coin.delegate = self
        navigationController?.pushViewController(coin, animated: true)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
        } else {
            return 0
        }
    }
    
    
    @objc func deleteGameAlert(){
        
        let realm = try! Realm()
        let body:[String:Any] = ["email":email,"token":token,"alert":alertObject.id]
        URLServices.fetchInstance.passServerData(urlParameters: ["game","deleteAlert"], httpMethod: "POST", parameters: body) { (response, success) in
            if success{
                let filterId = "id = " + String(self.alertObject.id)
                let filterName = "coinAbbName = '" + self.alertObject.coinAbbName + "' "
                
                let coinsAlert = realm.objects(GameAlertObject.self).filter(filterName)
                
                try! realm.write {
                    realm.delete(realm.objects(GameAlertObject.self).filter(filterId))
                }
                if coinsAlert.count == 0{
                    try! realm.write {
                        realm.delete(realm.objects(alertCoinNames.self).filter(filterName))
                    }
                }
                self.navigationController?.popViewController(animated: true)
            } else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    
    @objc func addNewGameAlert(){
        let realm = try! Realm()
        alertObject.inputPrice = Double(inputPrice) ?? 0
        
        if String(alertObject.inputPrice) != "0.0" && alertObject.coinName != ""{
            alertButton.isUserInteractionEnabled = false
            
            var compareStatus = 0
            if sectionPrice < alertObject.inputPrice{
                compareStatus = 1
            } else {
                compareStatus = 2
            }
            
            alertObject.compareStatus = compareStatus
            
            if status == "Update"{
                let inner:[String:Any] = ["alert_id":alertObject.id,"coinName": alertObject.coinAbbName, "price": alertObject.inputPrice,"status": true, "isGreater": alertObject.compareStatus]
                let parameter2 = ["token": token, "email": email, "user_id": UserDefaults.standard.string(forKey: "user_id")!, "alert":inner] as [String: Any]
                
                URLServices.fetchInstance.passServerData(urlParameters: ["game","editAlert"], httpMethod: "POST", parameters: parameter2){ (response, success) in
                    if success{
                       realm.beginWrite()
                        let realmData: [Any] = [self.alertObject.id, self.alertObject.coinName,self.alertObject.coinAbbName, self.alertObject.inputPrice, self.alertObject.compareStatus, self.alertObject.switchStatus,Date()]
                        if realm.object(ofType: GameAlertObject.self, forPrimaryKey: self.alertObject.id) == nil{
                            realm.create(GameAlertObject.self, value: realmData)
                        } else {
                            realm.create(GameAlertObject.self, value: realmData, update: true)
                        }
                        
                        try! realm.commitWrite()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                let inner:[String:Any] = ["coinName": alertObject.coinAbbName, "price": alertObject.inputPrice, "isGreater": alertObject.compareStatus]
                let parameter2 = ["token": token, "email": email, "user_id": UserDefaults.standard.string(forKey: "user_id")!, "alert":inner] as [String: Any]
                
                URLServices.fetchInstance.passServerData(urlParameters: ["game","addAlert"], httpMethod: "POST", parameters: parameter2){ (response, success) in
                    if success{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addGameAlert"),object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        let hud = JGProgressHUD(style: .light)
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.tintColor = ThemeColor().darkBlackColor()
                        hud.textLabel.text = textValue(name: "error_transaction")
                        hud.show(in: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                            hud.dismiss()
                        }
                        self.alertButton.isUserInteractionEnabled = true
                    }
                }
                
            }
            
            
           
        } else{
            let hud = JGProgressHUD(style: .light)
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.textLabel.text = textValue(name: "error_transaction")
            hud.show(in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                hud.dismiss()
            }
            alertButton.isUserInteractionEnabled = true
        }
        
    }
    
    
    
    
    
    
    
    
    func setExchangesName(exchangeName: String) {
        
    }
    
    func setTradingPairsName(tradingPairsName: String) {
        
    }
    
    func setTradingPairsFirstType(firstCoinType: [String]) {
        
    }
    
    func setTradingPairsSecondType(secondCoinType: [String]) {
        
    }
    
    func getExchangeName() -> String {
        return "Huobi Australia"
    }
    
    func setLoadPrice() {
        
    }
    
    func setCoinName(name: String) {
        alertObject.coinName = name
    }
    
    func setCoinAbbName(abbName: String) {
        alertObject.coinAbbName = abbName
    }
    
    func getCoinName() -> String {
        return alertObject.coinAbbName
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" || textField.text == nil{
            textField.text = ""
            alertObject.inputPrice = 0
        } else{
            if Extension.method.checkInputVaild(value: textField.text!){
                inputPrice = textField.text!
            } else{
                alertObject.inputPrice = 0
            }
        }
    }
    
    

    
    
    

}
