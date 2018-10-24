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
import SwiftKeychainWrapper

struct alertResult{
    var isExpanded:Bool = false
    var coinName:String = ""
    var coinAbbName:String = ""
    var avaliable:Bool = true
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

    var token : NotificationToken?

    var alerts:[alertResult] = [alertResult]()
    var coinName = coinAlert()
    var coinAbbName = "null"
    var status = ""
    var oldAlerts = [Int:Bool]()
//    var TransactionDelegate:TransactionFrom?
//    var changeSwitchStatus:Bool{
//        get{
//            return UserDefaults.standard.bool(forKey: "changeAlertStatus")
//        }
//    }
    
//    var changeStatus:Bool = false
    
    
    var allAlert:[alertResult]{
        get{
            var allResult = [alertResult]()
            let results = try! Realm().objects(alertObject.self)
            var coinNameResults = try! Realm().objects(alertCoinNames.self)
            if coinName.status{
                coinNameResults = coinNameResults.filter("coinAbbName = '" + coinName.coinAbbName + "' ")
            }
            
            for value in coinNameResults{
                var alertResults = alertResult()
                let speCoin = results.filter("coinAbbName = '" + value.coinAbbName + "' ")
                alertResults.isExpanded = false
                alertResults.coinAbbName = value.coinAbbName
                alertResults.coinName = value.coinName
                for result in speCoin{
                    alertResults.avaliable = result.available
                    alertResults.name.append(result)
                }
                allResult.append(alertResults)
            }
            return allResult
        }
    }
    
    var allAlerts:Results<alertObject>{
        get{
            return try! Realm().objects(alertObject.self).sorted(byKeyPath: "dateTime",ascending: false)
        }
    }
    
    var email:String{
        get{
//            return UserDefaults.standard.string(forKey: "UserEmail") ?? "null"
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
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
    
//    var buildInterestStatus:Bool{
//        get{
//            return UserDefaults.standard.bool(forKey: "buildInterest")
//        }
//    }
    
    
    
    var alertStatuss:Results<alertObject>{
        get{
            return try! Realm().objects(alertObject.self).sorted(byKeyPath: "dateTime",ascending: false)
        }
    }
//    var twoDimension = [ExpandableNames(isExpanded: true, name: ["ds"]),ExpandableNames(isExpanded: true, name: ["sdf","sfsdfsf"])]
//
//    var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alerts = allAlert
//        view.backgroundColor = ThemeColor().blueColor()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotificationStatus), name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addAlerts), name: NSNotification.Name(rawValue: "addAlert"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        for result in alertStatuss{
            oldAlerts[result.id] = result.switchStatus
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAlert"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        token?.invalidate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        getNotificationStatus()
//        if NotificationStatus{
//            if loginStatus{
//                writeAlertToRealm()
//            }
//        }
        checkSetUpView()
        if status == "setting"{
            getNotification()
        }
        
    }
    
    @objc func changeLanguage(){
        checkSetUpView()
        alertButton.setTitle(textValue(name: "addAlert_alert"), for: .normal)
        loginMainLabel.text = textValue(name: "needLoginLabel")
        loginLabel.text = textValue(name: "needLoginText")
        loginButton.setTitle(textValue(name: "login"), for: .normal)
    }
    
    func getNotification(){
        if loginStatus{
            writeAlertToRealm()
        }
    }
    
 

    override func viewDidDisappear(_ animated: Bool){
        if status == "setting"{
            if checkAlertStatusChange(){
                 self.sendNotification()
            }
        } else if status == "detailPage"{
            if checkAlertStatusChange(){
                sendNotification()
            }
        }
    }
    


    
    func checkAlertStatusChange()->Bool{
        for results in allAlerts{
            if results.switchStatus != oldAlerts[results.id]{
                return true
            }
        }
        return false
    }
    
    func sendNotification(){
        var alertStatus = [[String:Any]]()
        let alla = allAlerts
        for result in alla{
            let alert:[String:Any] = ["id":result.id,"status":result.switchStatus]
            alertStatus.append(alert)
        }
        
        
        if alertStatus.count != 0{
            let body:[String:Any] = ["email":email,"token":certificateToken,"interest":alertStatus]
            URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","editInterestStatus"], httpMethod: "POST", parameters: body) { (response, success) in
                if success{}
            }
        }
    }
    
    
    @objc func refreshNotificationStatus(){
        getNotificationStatus()
    }
    
    func checkSetUpView(){
        if loginStatus{
            setUpView()
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
        let sectionView = UIView()
        let coinImage = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        coinImage.frame = CGRect(x: 0, y: 0, width: 30*factor!, height: 30*factor!)
        coinImage.clipsToBounds = true
        print(alerts)
        coinImage.coinImageSetter(coinName: alerts[section].name[0].coinAbbName, width: 30*factor!, height: 30*factor!, fontSize: 5*factor!)
        coinImage.contentMode = UIViewContentMode.scaleAspectFit
        coinImage.translatesAutoresizingMaskIntoConstraints = false
        
        let coinLabel = UILabel()
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.textColor = ThemeColor().whiteColor()
        coinLabel.font = UIFont.regularFont(17*factor!)
        coinLabel.text = alerts[section].coinName
        
        let avaliableLabel = UILabel()
        avaliableLabel.textColor = ThemeColor().redColor()
        avaliableLabel.translatesAutoresizingMaskIntoConstraints = false
        avaliableLabel.font = UIFont.regularFont(17*factor!)
        if !alerts[section].avaliable{
            avaliableLabel.text = "Unavaliable!"
        }
        
        
        
        let button = UIButton(type:.system)
        let isExpanded = alerts[section].isExpanded
        button.setTitle(!isExpanded ? "▼":"▲", for: .normal)
//        button.backgroundColor = ThemeColor().greenColor()
        button.contentEdgeInsets = UIEdgeInsetsMake(0, view.frame.width, 0, 0)
        button.titleLabel?.font = UIFont.regularFont(25*factor!)
        //        button.backgroundColor = ThemeColor().bglColor()
        button.setTitleColor(ThemeColor().textGreycolor(), for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
      
        sectionView.clipsToBounds = true
        sectionView.addSubview(button)
        sectionView.addSubview(coinImage)
        sectionView.addSubview(coinLabel)
        sectionView.addSubview(avaliableLabel)

        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        //        views.translatesAutoresizingMaskIntoConstraints = false
        
        sectionView.layer.borderWidth = 0.5
        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinImage, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: avaliableLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor!)-[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-\(10*factor!)-[v0]-\(5*factor!)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coinImage,"v2":avaliableLabel]))
        
//        avaliableLabel.rightAnchor.constraint(lessThanOrEqualTo: button.leftAnchor, constant: 10).isActive = true
//        avaliableLabel.rightAnchor.constraint(greaterThanOrEqualTo: button.leftAnchor, constant: 10).isActive = true
        avaliableLabel.trailingAnchor.constraint(lessThanOrEqualTo: sectionView.trailingAnchor, constant: -40*factor!).isActive = true
       
        
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button,"v1":avaliableLabel]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button]))
        
        
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
        
        
        button.setTitle(isExpanded ? "▼":"▲", for: .normal)

        if !isExpanded{
            alertTableView.insertRows(at: indexPaths, with: .fade)
        } else{
            alertTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    @objc func Login(){
        let loginPage = LoginController(usedPlace: 0)
        self.present(loginPage, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60 * factor!
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
        
        let object = alerts[indexPath.section].name[indexPath.row]
        cell.factor = factor!
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
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        view.addSubview(alertView)
        alertButton.titleLabel?.font = UIFont.semiBoldFont(18 * factor!)
        alertView.addSubview(alertTableView)
        alertView.addSubview(alertButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        
        alertButton.topAnchor.constraint(equalTo: alertTableView.bottomAnchor).isActive = true
        alertButton.heightAnchor.constraint(equalToConstant: 60*factor!).isActive = true
        if #available(iOS 11.0, *) {
            alertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            view.addSubview(safeAreaView)
            safeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            safeAreaView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        } else {
            alertButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }


    }
    
    
    var safeAreaView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().blueColor()
        return view
    }()
    
    func setUpNoNotificationView(){
        view.addSubview(alertHintView)
        alertMainHintLabel.font = UIFont.regularFont(20*factor!)
        alertHintLabel.font = UIFont.regularFont(13*factor!)
        alertButton.layer.cornerRadius = 15*factor!
        alertButton.titleLabel?.font = UIFont.semiBoldFont(18*factor!)
        alertHintView.addSubview(alertMainHintLabel)
        alertHintView.addSubview(alertHintLabel)
        alertHintView.addSubview(alertOpenButton)
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintView]))
        
  
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(30*factor!)-[v1]-\(10*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertMainHintLabel]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(10*factor!)-[v1(\(50*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(40*factor!)-[v1]-\(40*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertHintLabel,"v1":alertOpenButton]))
        alertHintView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertMainHintLabel,"v1":alertOpenButton]))
    }
    
    func setUpLoginView(){
        view.addSubview(loginView)
        loginLabel.font = UIFont.regularFont(13*factor!)
        loginButton.layer.cornerRadius = 20*factor!
        loginButton.titleLabel?.font = UIFont.semiBoldFont(18*factor!)
        loginMainLabel.font = UIFont.regularFont(20*factor!)
        loginView.addSubview(loginLabel)
        loginView.addSubview(loginButton)
        loginView.addSubview(loginMainLabel)
        

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginView]))
      
        
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(30*factor!)-[v1]-\(10*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginMainLabel]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(10*factor!)-[v1(\(50*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1(\(200 * factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginButton.centerXAnchor.constraint(equalTo: loginView.centerXAnchor).isActive = true
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel,"v1":loginButton]))
        loginView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor!)-[v0]-\(30*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginMainLabel,"v1":loginButton]))
        
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
        label.text = textValue(name: "needLoginLabel")
        label.textColor = ThemeColor().whiteColor()
        label.font = label.font.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    var loginLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.text = textValue(name: "needLoginText")
        label.textAlignment = .center
        label.font = label.font.withSize(13)
        return label
    }()
    
    var loginButton:UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(textValue(name: "login"), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(Login), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        return button
    }()
    
    var alertView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = ThemeColor().blueColor()
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
        tableView.rowHeight = 30*factor!
        tableView.bounces = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var alertButton:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(textValue(name: "addAlert_alert"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewAlert), for: .touchUpInside)
        return button
    }()
    
    @objc func addNewAlert(){
        let alert = AlertManageController()
        if coinName.status{
            alert.coinName.status = true
            alert.coinName.coinAbbName = coinName.coinAbbName
            alert.coinName.coinName = coinName.coinName
        }
        navigationController?.pushViewController(alert, animated: true)
    }
    
    func writeAlertToRealm(){
        let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
        let body:[String:Any] = ["email":email,"token":certificateToken]
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: (self.parent?.view)!)
        URLServices.fetchInstance.passServerData(urlParameters:["userLogin","getInterest"],httpMethod:"POST",parameters:body){(response, pass) in
            if pass{
                let responseSuccess = response["success"].bool ?? false
                if responseSuccess{
                    self.writeRealm(json:response){(pass) in
                        if pass{
                            DispatchQueue.main.async {
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
                    let code = response["code"].int ?? 0
                    if code == 800{
                        
                        deleteMemory()
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.textLabel.text = textValue(name: "hud_Error")
                        hud.detailTextLabel.text = textValue(name: "hud_passwordReset") // To change?
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "resetDevice_title"), comment: ""), message: NSLocalizedString(textValue(name: "resetDevice_description"), comment: ""), preferredStyle: .alert)
                        let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "resetDevice_confirm"), comment: ""), style: .destructive) { (_) in
                            self.checkSetUpView()
                        }
                        confirmAlertCtrl.addAction(confirmAction)
                        self.present(confirmAlertCtrl, animated: true, completion: nil)
                    } else{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }
                }
            } else{
                let manager = NetworkReachabilityManager()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                if !(manager?.isReachable)! {
                    hud.textLabel.text = textValue(name: "hud_Error")
                    hud.detailTextLabel.text = "No Network" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                } else {
                    hud.textLabel.text = textValue(name: "hud_Error")
                    hud.detailTextLabel.text = "Time Out" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                }
            }
        }
    }
    
    func writeRealm(json:JSON,completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        if json["success"].bool!{
            for result in json["data"].array!{
                realm.beginWrite()
                let id = result["_id"].int ?? 0
                let coinName = result["from"].string ?? "null"
                let coinAbbName = result["from"].string ?? "null"
                let tradingPairs = result["to"].string ?? "null"
                let exchangName = result["market"].string ?? "null"
                let comparePice = result["price"].double ?? 0
                let compareStatus = result["isgreater"].int ?? 0
                let switchStatus = result["status"].bool ?? true
                let available = result["available"].bool ?? true
                
                let realmData:[Any] = [id,coinName,coinAbbName,tradingPairs,exchangName,comparePice,compareStatus,switchStatus,Date(),available]
                if realm.object(ofType: alertObject.self, forPrimaryKey: id) == nil {
                    realm.create(alertObject.self, value: realmData)
                } else {
                    realm.create(alertObject.self, value: realmData, update: true)
                }
                
                if realm.object(ofType: alertCoinNames.self, forPrimaryKey: coinAbbName) == nil {
                    realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!])
                } else {
                    realm.create(alertCoinNames.self, value: [result["from"].string!,result["from"].string!], update: true)
                }
                try! realm.commitWrite()
                oldAlerts[id] = switchStatus
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
