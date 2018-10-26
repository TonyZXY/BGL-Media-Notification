//
//  GameBalanceController.swift
//  BGLMedia
//
//  Created by Fan Wu on 10/4/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftKeychainWrapper
import SwiftyJSON

class GameBalanceController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    let factor = UIScreen.main.bounds.width/375
    var image = AppImage()

    let cryptoCompareClient = CryptoCompareClient()
    var coinDetail = SelectCoin()
    var totalProfit:Double = 0
    var totalAssets:Double = 0
    var changeLaugageStatus:Bool = false
    var changeCurrencyStatus:Bool = false
    var countField:String = ""
    
    let realizedHint = HintAlertController()
    let unrealizedHint = HintAlertController()
    
    var gameUser: GameUser?
    var timer = Timer()
    
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
    
    //The First Time load the Page
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBasicView()
        checkTransaction()

        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency), name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNewAssetsData), name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewMarketData), name: NSNotification.Name(rawValue: "reloadAssetsTableView"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadWallet"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadNewMarketData"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "reloadAssetsTableView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if gameUser != nil {
            setupTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    private func setupTimer() {
        //will refresh the coins' price every 10 sec
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in self.updateCells() }
    }
    
    func checkLoginStatus() {
        if !UserDefaults.standard.bool(forKey: "isLoggedIn"){
            let login = LoginController(usedPlace: 0)
            self.present(login, animated: true, completion: nil)
        } else {
            checkNickname()
        }
    }
    
    private func checkNickname() {
        if gameUser == nil {
            let parameter = ["token": certificateToken, "email": email]
            URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","checkAccount"], httpMethod: "POST", parameters: parameter) { (response, success) in
                if success {
                    if response["data"]["nick_name"].stringValue == "" {
                        self.popNicknameAlert(true)
                    } else {
                        self.setupGameUser(response)
                    }
                } else {
                    self.popNetworkFailureAlert()
                }
            }
        }
    }
    
    private func popNetworkFailureAlert() {
        let alert = UIAlertController(title: textValue(name: "networkFailure"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc private func registerNickname(_ nickname: String) {
        let parameter = ["token": certificateToken, "email": email, "nickname": nickname]
        URLServices.fetchInstance.passServerData(urlParameters: ["game","register"], httpMethod: "POST", parameters: parameter) { (response, success) in
            //print(response)
            if response["code"].stringValue == "200" {
                self.setupGameUser(response)
            } else if response["code"].stringValue == "789" {
                self.popNicknameAlert(false)
            } else {
                self.popNetworkFailureAlert()
            }
        }
    }
    
    private func setupGameUser(_ json: JSON) {
        gameUser = GameUser(json)
        
        DispatchQueue.main.async(execute: {
            self.walletList.switchRefreshHeader(to: .refreshing)
        })
        
        setupTimer()
        
        UserDefaults.standard.set(gameUser?.id, forKey: "user_id")
    }
    
    private func popNicknameAlert(_ isFirst: Bool) {
        var alert = UIAlertController()
        if isFirst {
            alert = UIAlertController(title: textValue(name: "nickname"), message: nil, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: textValue(name: "nicknameNotUnique"), message: nil, preferredStyle: .alert)
        }
        alert.addTextField { (textField) in  }
        alert.addAction(UIAlertAction(title: textValue(name: "alertCancel"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] act in
            if let nickname =  alert?.textFields?.first?.text {
                if nickname == "" {
                    self.popNicknameAlert(true)
                } else {
                    self.registerNickname(nickname)
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    private func getTransSum(completion: @escaping (_ transSums: [TransSum], _ error: String?) -> Void) {
        guard let userID = gameUser?.id else { return }
        let parameter:[String:Any] = ["token": certificateToken, "email": email, "user_id": userID]
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getUserAverageHistory"], httpMethod: "POST", parameters: parameter) { (response, success) in
            if success {
                let transSums = response["data"].arrayValue.map({ (item) -> TransSum in
                    return TransSum(item)
                })
                completion(transSums, nil)
                
            } else {
                completion([], textValue(name: "networkFailure"))
            }
        }
    }
    
    private func updateGameUserTransSum(_ transSums: [TransSum]) {
        guard let coins = gameUser?.coins else { return }
        for (index, _) in coins.enumerated() {
            transSums.forEach({ (transSum) in
                if coins[index].abbrName.lowercased() == transSum.abbrName.lowercased() {
                    if transSum.status == "Buy" {
                        self.gameUser?.coins[index].totalAmountOfBuy = transSum.totalAmount
                        self.gameUser?.coins[index].totalValueOfBuy = transSum.totalValue
                    } else {
                        self.gameUser?.coins[index].totalAmountOfSell = transSum.totalAmount
                        self.gameUser?.coins[index].totalValueOfSell = transSum.totalValue
                    }
                }
            })
        }
    }
    
    func getCoinsPrice(completion: @escaping (_ jsonArray: [JSON], _ error: String?) -> Void) {
        URLServices.fetchInstance.passServerData(urlParameters: ["game","getCoinData"], httpMethod: "GET", parameters: [:]) { (response, success) in
            if success {
                completion(response["data"].arrayValue, nil)
            } else {
                completion([], textValue(name: "networkFailure"))
            }
        }
    }
    
    private func updateGameUserCoinsPrice(_ jsonArray: [JSON]) {
        guard let coins = gameUser?.coins else { return }
        for (index, _) in coins.enumerated() {
            if coins[index].abbrName == "AUD" {
                self.gameUser?.coins[index].price = 1
            }
            
            if let coinDetail = jsonArray.first(where: { (item) -> Bool in
                item["coin_name"].stringValue == coins[index].abbrName.lowercased()
            }) {
                self.gameUser?.coins[index].price = coinDetail["current_price"].doubleValue
            }
        }
        updateSummaryTextField()
    }
    
    private func updateCells() {
        getCoinsPrice { (jsonArray, error) in
            if let _ = error {
//                let alert = UIAlertController(title: err, message: nil, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true)
            } else {
                self.updateGameUserCoinsPrice(jsonArray)
                DispatchQueue.main.async {
                    self.walletList.reloadData()
                }
            }
        }
    }
    
    private func updateSummaryTextField() {
        var totalValue = 0.0
        var unrealisedNumber = 0.0
        var realisedNumber = 0.0
        gameUser?.coins.forEach({ (coin) in
            totalValue = totalValue + coin.amount * coin.price
            unrealisedNumber = unrealisedNumber + coin.profitNumber
            realisedNumber = realisedNumber + coin.realisedProfitNumber
        })
        
        checkDataRiseFallColor(risefallnumber: totalValue, label: totalNumber,currency:"AUD", type: "Default")
        checkDataRiseFallColor(risefallnumber: unrealisedNumber, label: unrealizedResult,currency:"AUD", type: "Number")
        checkDataRiseFallColor(risefallnumber: realisedNumber, label: realizedResult,currency:"AUD", type: "Number")
    }
    
    @objc func reloadNewMarketData(){
        walletList.reloadData()
    }
    
    @objc func refreshNewAssetsData(){
        self.checkTransaction()
    }
    
    func checkTransaction(){
        if gameUser?.coins.count == 0{
            setUpInitialView()  //won't be call, keep it just in case one day needed
        } else {
            setupView()
        }
    }
    
    @objc func changeLanguage(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        checkTransaction()
        walletList.switchRefreshHeader(to: .removed)
        walletList.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
            self.handleRefresh(self.walletList)
        })
        DispatchQueue.main.async(execute: {
            self.walletList.switchRefreshHeader(to: .refreshing)
        })
    }
    
    @objc func changeCurrency(){
        DispatchQueue.main.async(execute: {
            self.walletList.switchRefreshHeader(to: .refreshing)
        })
    }
    
    //TableView Cell Number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameUser?.coins.count ?? 0
    }
    
    //Each Table View Cell Create
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        let cell = WalletsCell(style: UITableViewCellStyle.default, reuseIdentifier: "WalletCell")
        cell.factor = factor
        guard let assets = gameUser?.coins[indexPath.row] else { return cell }
        cell.coinName.text = assets.name
        if assets.name == "AUD" {
            cell.coinAmount.text = Extension.method.scientificMethod(number: assets.amount) + " " + assets.abbrName
            cell.isUserInteractionEnabled = false
        } else {
            cell.coinAmount.text = "\(assets.amount) " + assets.abbrName
        }
        cell.coinSinglePrice.text = "A$\(assets.price)"
        checkDataRiseFallColor(risefallnumber: assets.totalValue, label: cell.coinTotalPrice,currency:"AUD", type: "Default")
        cell.coinTotalPrice.text = "(" + cell.coinTotalPrice.text! + ")"
        cell.coinTotalPrice.textColor = ThemeColor().textGreycolor()
        
        checkDataRiseFallColor(risefallnumber: assets.profitPercentage, label: cell.profitChange,currency:"AUD", type: "Percent")
        cell.profitChange.text = "(" + cell.profitChange.text! + ")"
        checkDataRiseFallColor(risefallnumber: assets.profitNumber, label: cell.profitChangeNumber,currency:"AUD", type: "Number")
        cell.coinImage.coinImageSetter(coinName: assets.abbrName, width: 30, height: 30, fontSize: 5)
//        cell.selectCoin.selectCoinAbbName = assets.coinAbbName
//        cell.selectCoin.selectCoinName = assets.coinName
        if assets.realisedProfitNumber != 0{
            cell.unrealisedPrice.text = String(Extension.method.scientificMethod(number: assets.realisedProfitNumber))
            if String(assets.realisedProfitNumber).prefix(1) != "-" {
                cell.unrealisedLabel.text = "Realized Profit:"
            } else{
                cell.unrealisedLabel.text = "Realized Loss:"
            }
        }
        
        return cell
    }

    @objc func refreshData(){
        checkTransaction()
        if !UserDefaults.standard.bool(forKey: "isLoggedIn") {
            gameUser = nil
            reloadNewMarketData()
            updateSummaryTextField()
        } else {
            checkNickname()
        }
    }
    
    @objc func refreshPage(){
        self.walletList.beginHeaderRefreshing()
    }
    
    //Click Add Transaction Button Method
    @objc func changetotransaction(){
        if gameUser == nil {
            checkLoginStatus()
        } else {
            let transaction = GameTransactionsController()
            transaction.gameBalanceController = self
            transaction.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(transaction, animated: true)
        }
    }
    
    //Refresh Method
    @objc func handleRefresh(_ tableView:UITableView) {
        if gameUser != nil {
            getTransSum { (transSums, error) in
                if let _ = error {
                    self.walletList.switchRefreshHeader(to: .normal(.failure, 0.5))
                } else {
                    self.updateGameUserTransSum(transSums)
                    self.updateCoinAmount()
                    self.updateCells()
                    self.walletList.switchRefreshHeader(to: .normal(.success, 0.5))
                }
            }
        } else {
            self.walletList.switchRefreshHeader(to: .normal(.none, 0.5))
            checkLoginStatus()
        }
    }
    
    private func updateCoinAmount(){
        if gameUser != nil{
            let param : [String:Any] = ["token":certificateToken,"email":email,"user_id":gameUser!.id]
            URLServices.fetchInstance.passServerData(urlParameters: ["game","getAccount"], httpMethod: "POST", parameters: param){ (response, success) in
                if success {
                    let data = response["data"]
                    if let coins = self.gameUser?.coins{
                        var newList : [GameCoin] = []
                        for coin in coins{
                            var newCoin = coin
                            let newAmount = Double(data[coin.abbrName.lowercased()].stringValue) ?? 0
                            if newAmount > 0 {
                                newCoin.amount = newAmount
                                newList.append(newCoin)
                            }
                        }
                        self.gameUser!.coins = newList
                    }
                }
            }
        }
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.delete{
//            let item = assetss[indexPath.row]
//            let eachTransaction = item.everyTransactions
//            var deleteID = [Int]()
//            for result in eachTransaction{
//                deleteID.append(result.id)
//            }
//
//            if loginStatus{
//                let body:[String:Any] = ["email":email,"token":certificateToken,"transactionID":deleteID]
//                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","deleteTransaction"], httpMethod: "POST", parameters: body) { (response, success) in
//                    if success{
//                        print("success")
//                    }else{
//                        print("error")
//                    }
//                }
//            }
//
//            try! Realm().write {
//                try! Realm().delete(eachTransaction)
//                try! Realm().delete(item)
//            }
//            checkTransaction()
//            caculateTotal()
//            self.walletList.reloadData()
//        }
//    }
    
    //Select specific coins and change to detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if gameUser != nil {
            let detailPage = GameCoinPageController()
            detailPage.hidesBottomBarWhenPushed = true
            //        let cell = self.walletList.cellForRow(at: indexPath) as! WalletsCell
            //        coinDetail = cell.selectCoin
            detailPage.coinDetail = gameUser?.coins[indexPath.row]
            detailPage.gameBalanceController = self
            detailPage.coinDetailController.alertControllers.status = "detailPage"
            navigationController?.pushViewController(detailPage, animated: true)
        }
    }
    
    func setUpBasicView(){
        view.backgroundColor = ThemeColor().navigationBarColor()
        //NavigationBar
        let titilebarlogo = UIImageView()
        titilebarlogo.image = UIImage(named: "cryptogeek_icon_")
        titilebarlogo.contentMode = .scaleAspectFit
        titilebarlogo.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        titilebarlogo.clipsToBounds = true
        navigationItem.titleView = titilebarlogo
    }
    
    
    func setUpInitialView(){
        let factor = view.frame.width/375
        existTransactionView.removeFromSuperview()
        view.addSubview(invisibleView)
        invisibleView.addSubview(buttonView)
        invisibleView.addSubview(hintMainView)
        invisibleView.addSubview(hintView)
        buttonView.addSubview(addTransactionButton)
        hintView.addSubview(hintLabel)
        hintMainView.addSubview(hintMainLabel)
        
        
        hintMainLabel.text = textValue(name: "mainHint")
        hintMainLabel.font = UIFont.regularFont(23*factor)
        hintLabel.text = textValue(name: "hintLabel")
        hintLabel.font = UIFont.regularFont(13*factor)
        
        //View No transactions
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":invisibleView]))
        
        
        //Main Hint View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainView,"v1":buttonView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(80*factor))]-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainView,"v1":buttonView]))
        
        NSLayoutConstraint(item: hintMainLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: hintMainView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintMainLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: hintMainView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        hintMainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainLabel]))
        hintMainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintMainLabel]))
        
        
        //Button View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonView,"v1":hintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(60*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":buttonView,"v1":hintView]))
        NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: invisibleView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -80*factor).isActive = true
        NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: invisibleView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addTransactionButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: buttonView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v5(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        buttonView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v5(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":addTransactionButton]))
        
        //Hint Label View
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView,"v1":buttonView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(5*factor)-[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintView,"v1":buttonView]))
        
        NSLayoutConstraint(item: hintLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: hintView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: hintLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: hintView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
        hintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
    }
    
    //Set Up View Layout
    func setupView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        
        totalLabel.text = textValue(name:"gameBalance")
        unrealizedLabel.setTitle(textValue(name: "hintUnrealizedTitle"), for: .normal)
        realizedLabel.setTitle(textValue(name: "hintRealizedTitle"), for: .normal)
        totalLabel.font = UIFont.regularFont(20*factor)
        totalNumber.font = UIFont.boldFont(30*factor)
        totalChange.font = UIFont.regularFont(20*factor)
        addTransactionButton.layer.cornerRadius = 25*factor
        
        //Add Subview
        invisibleView.removeFromSuperview()
        view.addSubview(existTransactionView)
        existTransactionView.addSubview(totalProfitView)
        existTransactionView.addSubview(buttonView)
        existTransactionView.addSubview(walletList)
        totalProfitView.addSubview(totalLabel)
        totalProfitView.addSubview(totalNumber)
        realizedView.addSubview(addTransactionButton)
        existTransactionView.addSubview(realizedView)
        realizedView.addSubview(unrealizedLabel)
        realizedView.addSubview(realizedLabel)
        realizedView.addSubview(unrealizedResult)
        realizedView.addSubview(realizedResult)
        
        // modified
        totalProfitView.addSubview(toRankButton)
        totalProfitView.addConstraintsWithFormat(format: "H:[v0]-\(15*factor)-|", views: toRankButton)
        totalProfitView.addConstraintsWithFormat(format: "V:[v0]-\(15*factor)-|", views: toRankButton)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":existTransactionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":existTransactionView]))
        
        
        
        //        Total Profit View Constraints(总资产)
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView]))
        
        NSLayoutConstraint(item: totalLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: totalProfitView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        totalNumber.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10).isActive = true
        totalNumber.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10).isActive = true
        
        totalProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v1]-\(10*factor)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":totalLabel,"v2":totalNumber,"v3":totalChange]))
        totalProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v1":totalLabel,"v2":totalNumber,"v3":totalChange]))
        
        
        
        
        //Realized View
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v4]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView,"v4":realizedView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-0-[v4(\(60*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":totalProfitView,"v4":realizedView]))
        
        addTransactionButton.centerXAnchor.constraint(equalTo: realizedView.centerXAnchor, constant: 0).isActive = true
        addTransactionButton.centerYAnchor.constraint(equalTo: realizedView.bottomAnchor, constant: 0).isActive = true
        addTransactionButton.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        addTransactionButton.widthAnchor.constraint(equalToConstant: 50*factor).isActive = true
        unrealizedLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        unrealizedLabel.leftAnchor.constraint(equalTo: realizedView.leftAnchor, constant: 0).isActive = true
        unrealizedLabel.bottomAnchor.constraint(equalTo: realizedView.centerYAnchor, constant: 0).isActive = true
        realizedLabel.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        realizedLabel.rightAnchor.constraint(equalTo: realizedView.rightAnchor, constant: 0).isActive = true
        realizedLabel.bottomAnchor.constraint(equalTo: realizedView.centerYAnchor, constant: 0).isActive = true
        
        unrealizedResult.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        unrealizedResult.leftAnchor.constraint(equalTo: realizedView.leftAnchor, constant: 0).isActive = true
        unrealizedResult.topAnchor.constraint(equalTo: realizedView.centerYAnchor, constant: 0).isActive = true
        realizedResult.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        realizedResult.rightAnchor.constraint(equalTo: realizedView.rightAnchor, constant: 0).isActive = true
        realizedResult.topAnchor.constraint(equalTo: realizedView.centerYAnchor, constant: 0).isActive = true
        
        
        //Add Transaction Button Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v4]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":realizedView,"v4":buttonView]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-0-[v4(\(30*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":realizedView,"v4":buttonView]))
        
        //Wallet List Constraints
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v6]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":buttonView,"v6":walletList]))
        existTransactionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v7]-\(10*factor)-[v6]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v7":buttonView,"v6":walletList]))
        
    }
    
    @objc func realizedHintshow(){
        realizedHint.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        realizedHint.cancelButton.addTarget(self, action: #selector(cancelRealizeHint), for: .touchUpInside)
        realizedHint.titleLabel.text = textValue(name: "hintRealizedTitle")
        realizedHint.descriptionLabel.text = textValue(name: "hintRealizedDescription")
        realizedHint.cancelButton.setTitle(textValue(name: "done_resend"), for: .normal)
        self.parent?.addChildViewController(realizedHint)
        self.parent?.view.addSubview(realizedHint.view)
    }
    
    @objc func unrealizedHintshow(){
        unrealizedHint.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        unrealizedHint.cancelButton.addTarget(self, action: #selector(cancelUnrealizeHint), for: .touchUpInside)
        unrealizedHint.titleLabel.text = textValue(name: "hintUnrealizedTitle")
        unrealizedHint.descriptionLabel.text = textValue(name: "hintUnrealizedDescription")
        unrealizedHint.cancelButton.setTitle(textValue(name: "done_resend"), for: .normal)
        self.parent?.addChildViewController(unrealizedHint)
        self.parent?.view.addSubview(unrealizedHint.view)
    }
    
    @objc func cancelRealizeHint(){
        realizedHint.removeFromParentViewController()
        realizedHint.view.removeFromSuperview()
    }
    
    @objc func cancelUnrealizeHint(){
        unrealizedHint.removeFromParentViewController()
        unrealizedHint.view.removeFromSuperview()
    }
    
    var realizedView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().greyColor()
        return view
    }()
    
    var unrealizedLabel:UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(textValue(name: "hintUnrealizedTitle"), for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = UIFont.regularFont(15)
        button.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2)
        let hintImage = UIImage(named: "help")?.reSizeImage(reSize: CGSize(width: 10, height: 10))
        button.setImage(hintImage, for: .normal)
        button.addTarget(self, action: #selector(unrealizedHintshow), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return button
    }()
    
    var realizedLabel:UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(textValue(name: "hintRealizedTitle"), for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -2, 0, 2)
        let hintImage = UIImage(named: "help")?.reSizeImage(reSize: CGSize(width: 10, height: 10))
        button.setImage(hintImage, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(15)
        button.addTarget(self, action: #selector(realizedHintshow), for: .touchUpInside)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return button
    }()
    
    var unrealizedResult:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var realizedResult:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var hintMainLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = label.font.withSize(23)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var hintMainView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var hintLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.text = "We just need one or more transactions.Add your first transaction via the + button below"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }()
    
    var hintView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var existTransactionView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var invisibleView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    lazy var totalProfitView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalLabel:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalNumber:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.font = label.font.withSize(30)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalChange:UILabel = {
        var label = UILabel()
        //        label.text = "--"
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var buttonView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var spinner:UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView()
        spinner.tintColor = UIColor.white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    var addTransactionButton:UIButton = {
        var button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "AddButton.png"), for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changetotransaction), for: .touchUpInside)
        return button
    }()
    
    lazy var walletList:UITableView = {
        let factor = view.frame.width/375
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(WalletsCell.self, forCellReuseIdentifier: "WalletCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12*factor)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        tableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(tableView)
        })
        //        tableView.rowHeight = 70*factor
        tableView.estimatedRowHeight = 70*factor
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var toRankButton: ToRankPageButton = {
        let buttonHeight:CGFloat = 24 * factor
        let buttonWidth:CGFloat = 24 * factor
        let button = ToRankPageButton(width: buttonWidth, height: buttonHeight,parentController: self)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
