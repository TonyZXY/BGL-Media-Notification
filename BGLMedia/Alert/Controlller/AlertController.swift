//
//  AlertController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 21/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import Alamofire
import SwiftyJSON
import JGProgressHUD

struct alertResult{
    var isExpanded:Bool = true
    var coinName:String = ""
    var coinAbbName:String = ""
    var name:[alertObject] = [alertObject]()
}


struct coinAlert{
    var status:Bool = false
    var coinAbbName:String = ""
    var coinName:String = ""
}

class AlertController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var factor:CGFloat?{
        didSet{
            
        }
    }
    
    var realm = try! Realm()
    var alerts:[alertResult] = [alertResult]()
    var coinName = coinAlert()
    var coinAbbName = "null"
    var TransactionDelegate:TransactionFrom?
    var allAlert:[alertResult]{
        get{
            var allResult = [alertResult]()
            let results = realm.objects(alertObject.self)
            var coinNameResults = realm.objects(alertCoinNames.self)
            if coinName.status{
                coinNameResults = coinNameResults.filter("coinAbbName = '" + coinName.coinAbbName + "' ")
            }

            for value in coinNameResults{
                var alertResults = alertResult()
                let speCoin = results.filter("coinAbbName = '" + value.coinAbbName + "' ")
                alertResults.isExpanded = true
                alertResults.coinAbbName = value.coinAbbName
                alertResults.coinName = value.coinName
                for data in speCoin{
                    alertResults.name.append(data)
                }
                allResult.append(alertResults)
            }
            return allResult
        }
    }
    
    var allAlerts:Results<alertObject>{
        get{
            return realm.objects(alertObject.self)
        }
    }
    
    var email:String{
        get{
            return UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
        }
    }
    
    var certificateToken:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? "null"
        }
    }
    
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var NotificationStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "NotificationSetting")
        }
    }
    
    var buildInterestStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "buildInterest")
        }
    }
    
    
    var twoDimension = [ExpandableNames(isExpanded: true, name: ["ds"]),ExpandableNames(isExpanded: true, name: ["sdf","sfsdfsf"])]
    
    var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts = allAlert
        view.backgroundColor = ThemeColor().darkGreyColor()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotificationStatus), name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addAlerts), name: NSNotification.Name(rawValue: "addAlert"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAlert"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        tabBarController?.tabBar.isHidden = true
        getNotificationStatus()
        if NotificationStatus{
            if loginStatus{
                writeAlertToRealm()
            }
        }
        checkSetUpView()
    }
    
    
    override func viewDidDisappear(_ animated: Bool){
        var alertStatus = [[String:Any]]()
        print(realm.objects(alertObject.self))
        let alla = allAlerts
        for result in alla{
            let alert:[String:Any] = ["id":result.id,"status":result.switchStatus]
            alertStatus.append(alert)
        }
        

        if alertStatus.count != 0{
            let body:[String:Any] = ["email":email,"token":certificateToken,"interest":alertStatus]
            URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","editInterestStatus"], httpMethod: "POST", parameters: body) { (response, success) in
                if success{
                    print(response)
                } else{
                    print(response)
                }
            }
        }
    }
    
    @objc func refreshNotificationStatus(){
        getNotificationStatus()
    }
    
    func checkSetUpView(){

            if loginStatus{
                setUpView()
//                view.willRemoveSubview(setUpLoginView)
            } else{
                setUpLoginView()
            }
    }
    
    @objc func addAlerts(){
        alerts = allAlert
        alertTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let coinImage = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        coinImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        coinImage.clipsToBounds = true
        coinImage.coinImageSetter(coinName: alerts[section].name[0].coinAbbName, width: 30, height: 30, fontSize: 5)
        coinImage.contentMode = UIViewContentMode.scaleAspectFit
        coinImage.translatesAutoresizingMaskIntoConstraints = false
        
        let coinLabel = UILabel()
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.textColor = ThemeColor().whiteColor()
        coinLabel.text = alerts[section].coinName
        
        let button = UIButton(type:.system)
        button.setTitle("Close", for: .normal)
        //        button.backgroundColor = ThemeColor().bglColor()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        let sectionView = UIView()
        sectionView.clipsToBounds = true
        sectionView.addSubview(button)
        sectionView.addSubview(coinImage)
        sectionView.addSubview(coinLabel)
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
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
    }
    
    @objc func handleExpandClose(button:UIButton ){
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in alerts[section].name.indices{
            let indexPath = IndexPath(row:row,section:section)
            indexPaths.append(indexPath)
        }
        let isExpanded = alerts[section].isExpanded
        alerts[section].isExpanded = !isExpanded
        
        
        button.setTitle(isExpanded ? "Open":"Close", for: .normal)
        
        if !isExpanded{
            alertTableView.insertRows(at: indexPaths, with: .fade)
        } else{
            alertTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    @objc func Login(){
        let loginPage = LoginController()
        self.present(loginPage, animated: true, completion: nil)
//        navigationController?.pushViewController(loginPage, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !alerts[section].isExpanded{
            return 0
        }
        return alerts[section].name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editAlertCell", for: indexPath) as! AlertTableViewCell
        //        let name = twoDimension[indexPath.section].name[indexPath.row]
      
        let object = alerts[indexPath.section].name[indexPath.row]
//        var compare:String = ""
//        if object.compareStatus == 1{
//            compare = ">"
//        }else if object.compareStatus == 2{
//            compare = "<"
//        } else {
//            compare = "="
//        }
//
//        let compareLabel = "1 " + object.coinAbbName + " " + compare + " " + String(object.price)
//        let coinDetail = object.exchangName + " - " + object.coinAbbName + "/" + object.tradingPairs
//        let dateToString = DateFormatter()
//        dateToString.dateFormat = "EEEE, dd MMMM yyyy HH:mm"
//        dateToString.locale = Locale(identifier: "en_AU")
//        let timess = dateToString.string(from: object.dateTime)
//        cell.dateLabel.text = timess
//        cell.compareLabel.text = compareLabel
//        cell.coinDetailLabel.text = coinDetail
//        cell.swithButton.isOn = object.switchStatus
        cell.object = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertEdit = AlertManageController()
        alertEdit.intersetObject.coinAbbName = alerts[indexPath.section].name[indexPath.row].coinAbbName
        alertEdit.intersetObject.exchangName = alerts[indexPath.section].name[indexPath.row].exchangName
        alertEdit.intersetObject.tradingPairs = alerts[indexPath.section].name[indexPath.row].tradingPairs
        alertEdit.intersetObject.coinName = alerts[indexPath.section].name[indexPath.row].coinName
        alertEdit.intersetObject.compare = alerts[indexPath.section].name[indexPath.row].price
        alertEdit.intersetObject.id =   alerts[indexPath.section].name[indexPath.row].id
        alertEdit.status = "Update"
        navigationController?.pushViewController(alertEdit, animated: true)
    }
    
    func setUpView(){
        view.addSubview(alertView)
        alertView.addSubview(alertTableView)
        alertView.addSubview(alertButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-3-[v0(80)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton,"v1":alertTableView]))
    }
    
    func setUpNoNotificationView(){
        view.addSubview(alertHintView)
        alertHintView.addSubview(alertMainHintLabel)
        alertHintView.addSubview(alertHintLabel)
        alertHintView.addSubview(alertOpenButton)
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintView]))
        
//        NSLayoutConstraint(item: alertHintLabel, attribute: .centerX, relatedBy: .equal, toItem: alertHintView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: alertHintLabel, attribute: .centerY, relatedBy: .equal, toItem: alertHintView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: alertMainHintLabel, attribute: .centerX, relatedBy: .equal, toItem: alertHintLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: alertOpenButton, attribute: .centerX, relatedBy: .equal, toItem: alertHintLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[v1]-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertMainHintLabel]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v1]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertMainHintLabel,"v1":alertOpenButton]))
    }
    
    func setUpLoginView(){
        view.addSubview(loginView)
        loginView.addSubview(loginLabel)
        loginView.addSubview(loginButton)
        loginView.addSubview(loginMainLabel)
        
//        alertOpenButton.setTitle("Open Notification", for: .normal)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginView]))
//        NSLayoutConstraint(item: loginButton, attribute: .centerX, relatedBy: .equal, toItem: loginView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: loginButton, attribute: .centerY, relatedBy: .equal, toItem: loginView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: loginLabel, attribute: .centerX, relatedBy: .equal, toItem: loginButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginButton,"v1":loginLabel]))
//        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginButton,"v1":loginLabel]))
//        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginButton,"v1":loginLabel]))
        
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[v1]-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginMainLabel]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[v0]-30-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginMainLabel,"v1":loginButton]))
        
    }
    
    @objc func deviceSetting(){
        let alertController = UIAlertController(title: "Alert Title is here", message: "Alert Description is here", preferredStyle: .alert)
        
        // Setting button action
        let settingsAction = UIAlertAction(title: "Go to Setting", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    // Checking for setting is opened or not
//                    print("Setting is opened: \(success)")
                })
            }
        }
        
        alertController.addAction(settingsAction)
        // Cancel button action
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ (_) -> Void in
            // Magic is here for cancel button
        }
        alertController.addAction(cancelAction)
        // This part is important to show the alert controller ( You may delete "self." from present )
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getNotificationStatus(){
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
            }
            
            if settings.authorizationStatus == .denied {
                UserDefaults.standard.set(false, forKey: "NotificationSetting")
                // Notification permission was previously denied, go to settings & privacy to re-enable
            }
            
            if settings.authorizationStatus == .authorized {
                UserDefaults.standard.set(true, forKey: "NotificationSetting")
                // Notification permission was already gransnted
            }
            
            DispatchQueue.main.async {
                self.checkSetUpView()
            }
        })
    }
    
//    func getAlertStatus(){
//
//    }
    
    
    @objc func addAlert(){
        let addAlert = AlertManageController()
        navigationController?.pushViewController(addAlert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var loginView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var loginMainLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please Login First"
        label.textColor = ThemeColor().whiteColor()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    var loginLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.text = "Login to access this function"
        label.textAlignment = .center
        label.font = label.font.withSize(13)
        return label
    }()
    
    var loginButton:UIButton = {
       var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(Login), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        return button
    }()
    
    var alertView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var alertHintView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    var alertMainHintLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Open your Notification"
        label.font = label.font.withSize(20)
        label.textColor = UIColor.white
        return label
    }()
    
    var alertHintLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "If you want to use alert functions, you need to go to setting page to open it, click the button and towards to setting page"
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.font = label.font.withSize(13)
        label.numberOfLines = 0
        label.textColor = UIColor.white
        return label
    }()
    
    var alertOpenButton:UIButton = {
        var button = UIButton(type:.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.red
        button.setTitle("Open Notification", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(deviceSetting), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    lazy var alertTableView:UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: "editAlertCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var alertButton:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(textValue(name: "addAlert_alert"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().bglColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewAlert), for: .touchUpInside)
        return button
    }()
    
    @objc func addNewAlert(){
//        let checkSendDeviceToken = UserDefaults.standard.bool(forKey: "SendDeviceToken")
//        if !checkSendDeviceToken{
//            let email = UserDefaults.standard.string(forKey: "UserEmail")
//            let token = UserDefaults.standard.string(forKey: "UserToken")
//            let parameter = ["email": email, "token": token]
//            let url = URL(string: "http://10.10.6.18:3030/deviceManage/addAlertDevice")
//            var urlRequest = URLRequest(url: url!)
//            urlRequest.httpMethod = "POST"
//            let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
//            urlRequest.httpBody = httpBody
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            
//            Alamofire.request(urlRequest).response { (response) in
//                if let data = response.data{
//                    var res = JSON(data)
//                    UserDefaults.standard.set(true, forKey: "SendDeviceToken")
//                }
//            }
//        }
        
        let alert = AlertManageController()
        if coinName.status{
            alert.coinName.status = true
            alert.coinName.coinAbbName = coinName.coinAbbName
            alert.coinName.coinName = coinName.coinName
        }
        navigationController?.pushViewController(alert, animated: true)
    }
    
    func writeAlertToRealm(){
            let email = UserDefaults.standard.string(forKey: "UserEmail")!
            let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
            let body:[String:Any] = ["email":email,"token":certificateToken]

            let hud = JGProgressHUD(style: .light)
            hud.show(in: (self.parent?.view)!)
        
            URLServices.fetchInstance.passServerData(urlParameters:["userLogin","getInterest"],httpMethod:"POST",parameters:body){(response, pass) in
                if pass{
                    self.writeRealm(json:response){(pass) in
                        if pass{
                            DispatchQueue.main.async {
                                print(self.realm.objects(alertObject.self))
                                self.alerts = self.allAlert
                                self.alertTableView.reloadData()
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    hud.dismiss()
                                }
                            }
                        } else{
                            self.alerts = self.allAlert
                            self.alertTableView.reloadData()
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                hud.dismiss()
                            }
                        }
                    }
                } else{
                    let manager = NetworkReachabilityManager()
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    if !(manager?.isReachable)! {
                        hud.textLabel.text = "Error"
                        hud.detailTextLabel.text = "No Network" // To change?
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                        
                    } else {
                        hud.textLabel.text = "Error"
                        hud.detailTextLabel.text = "Time Out" // To change?
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                        
                    }
                }
            }
    }
    
    func writeRealm(json:JSON,completion:@escaping (Bool)->Void){
        if json["success"].bool!{
            for result in json["data"].array!{
                self.realm.beginWrite()
                let id = result["_id"].int ?? 0
                let coinName = result["from"].string ?? "null"
                let coinAbbName = result["from"].string ?? "null"
                let tradingPairs = result["to"].string ?? "null"
                let exchangName = result["market"].string ?? "null"
                let comparePice = result["price"].double ?? 0
                let compareStatus = result["isgreater"].int ?? 0
                let switchStatus = result["status"].bool ?? true
                
                
                let realmData:[Any] = [id,coinName,coinAbbName,tradingPairs,exchangName,comparePice,compareStatus,switchStatus,Date()]
                if self.realm.object(ofType: alertObject.self, forPrimaryKey: id) == nil {
                    self.realm.create(alertObject.self, value: realmData)
                } else {
                    self.realm.create(alertObject.self, value: realmData, update: true)
                }
                
                if self.realm.object(ofType: alertCoinNames.self, forPrimaryKey: coinAbbName) == nil {
                    self.realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!])
                } else {
                    self.realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!], update: true)
                }
                try! self.realm.commitWrite()
            }
            completion(true)
        } else{
            try! realm.write {
                realm.delete(realm.objects(alertObject.self))
            }
            completion(false)
        }
    }
    
}
