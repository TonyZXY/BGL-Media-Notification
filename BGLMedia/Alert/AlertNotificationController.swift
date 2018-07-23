//
//  AlertNotificationController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import SwiftyJSON

class switchObject{
    var type:String?
    var switchStatus:Bool?
}

class AlertNotificationController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var switchStatus = switchObject()
    var cellItems:[[String]]{
        get{
            var allowStatus:String = ""
            if !loginStatus{
                allowStatus = textValue(name: "alertUnavaliable_alert")
            } else if !NotificationStatus{
                allowStatus = textValue(name: "alertUnavaliable_alert")
            } else{
                allowStatus = textValue(name: "alertavaliable_alert")
            }
            return [[allowStatus],[textValue(name: "flashNews_alert"),textValue(name: "price_alert")],[textValue(name: "edit_alert")]]
        }
    }
    
    var switchStatusItem:[[String]] = [["setting"],["Flash","Currency"],["Edit"]]
    
    var SwitchOption:[Bool]{
        get{
            return [UserDefaults.standard.bool(forKey: "flashSwitch"),UserDefaults.standard.bool(forKey: "priceSwitch")]
        }
    }
    
    
    var buildInterestStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "buildInterest")
        }
    }
    
    var loginStatus:Bool{
        get{
            return  UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var sendDeviceTokenStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "SendDeviceToken")
        }
    }
    
    var switchLabel = ["flashSwitch","priceSwitch"]
    
    
    var NotificationStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "NotificationSetting")
        }
    }
    
    var sectionItem:[String]{
        get{
            var allowStatus:String = ""
            if !loginStatus{
                allowStatus = textValue(name: "notlogin_alert")
            }else if !NotificationStatus{
                allowStatus = textValue(name: "notallow_alert")
            } else{
                allowStatus = textValue(name: "alertStatus_alert")
            }
            
            return [allowStatus,textValue(name: "pushSection_alert"),textValue(name: "editSection_alert")]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if SwitchOption[1] == false{
            return 2
        } else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            if loginStatus == true && NotificationStatus == true{
                let sectionView = UIView()
                sectionView.backgroundColor = ThemeColor().darkGreyColor()
                let sectionLabel = UILabel()
                sectionLabel.text = sectionItem[section]
                sectionLabel.textColor = ThemeColor().textGreycolor()
                sectionLabel.translatesAutoresizingMaskIntoConstraints = false
                
                sectionView.addSubview(sectionLabel)
                
                NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
                NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10).isActive = true
                return sectionView
            } else{
                let sectionView = UIView()
                sectionView.backgroundColor = ThemeColor().blueColor()
                let sectionLabel = UILabel()
                sectionLabel.text = sectionItem[section]
                sectionLabel.textColor = ThemeColor().whiteColor()
                sectionLabel.lineBreakMode = .byWordWrapping
                sectionLabel.numberOfLines = 0
                sectionLabel.translatesAutoresizingMaskIntoConstraints = false
                let sectionButton = UIButton()
                
                if !loginStatus{
                    sectionButton.setTitle("Login", for: .normal)
                    sectionButton.addTarget(self, action: #selector(GoTologin), for: .touchUpInside)
                } else{
                    sectionButton.setTitle("Go to Setting", for: .normal)
                    sectionButton.addTarget(self, action: #selector(deviceSetting), for: .touchUpInside)
                }
                sectionButton.translatesAutoresizingMaskIntoConstraints = false
                sectionView.addSubview(sectionLabel)
                sectionView.addSubview(sectionButton)
                
                
                NSLayoutConstraint(item: sectionLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: sectionLabel, attribute: .centerX, relatedBy: .equal, toItem: sectionView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10).isActive = true
                NSLayoutConstraint(item: sectionLabel, attribute: .right, relatedBy: .equal, toItem: sectionView, attribute: .right, multiplier: 1, constant: -10).isActive = true
                
                
                NSLayoutConstraint(item: sectionButton, attribute: .centerX, relatedBy: .equal, toItem: sectionView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: sectionButton, attribute: .top, relatedBy: .equal, toItem: sectionLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: sectionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 20).isActive = true
                return sectionView
            }
        } else {
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        let sectionLabel = UILabel()
        sectionLabel.text = sectionItem[section]
        sectionLabel.textColor = ThemeColor().textGreycolor()
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sectionView.addSubview(sectionLabel)
        
        NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10).isActive = true
//        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
//        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
        return sectionView
        }
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
                    print("Setting is opened: \(success)")
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
    
    @objc func GoTologin(){
        let login = LoginController()
        present(login, animated: true, completion: nil)
   
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 100
        } else{
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
        cell.backgroundColor = ThemeColor().greyColor()
        cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
        cell.accessibilityHint = switchStatusItem[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = ThemeColor().whiteColor()
        cell.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0)
//        if cell.isUserInteractionEnabled = false
        
        if indexPath.section == 1 {
            let swithButton = UISwitch()
            swithButton.isOn = SwitchOption[indexPath.row]
            cell.accessoryView = swithButton
            swithButton.tag = indexPath.row
            cell.selectionStyle = .none
            swithButton.addTarget(self, action: #selector(switchIsInAction(sender:)), for: .valueChanged)
            if !NotificationStatus || !loginStatus{
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = ThemeColor().grayPlaceHolder()
            }
            return cell
        } else if indexPath.section == 2{
            cell.accessoryType = .disclosureIndicator
            if !NotificationStatus || !loginStatus{
                cell.isUserInteractionEnabled = false
                cell.backgroundColor = ThemeColor().grayPlaceHolder()
            }
            return cell
        } else{
            return cell
        }
        
        
        
//        if indexPath.section == 0{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
//            cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
//            cell.selectionStyle = .none
//            cell.backgroundColor = UIColor.white
//            cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
//            cell.accessibilityHint = switchStatusItem[indexPath.row]
//            cell.textLabel?.textColor = UIColor.black
//            let loginStatus = UserDefaults.standard.bool(forKey: "isLoggedIn")
//            if indexPath.row < 2{
//                let swithButton = UISwitch()
//                swithButton.isOn = SwitchOption[indexPath.row]
//                cell.accessoryView = swithButton
//                swithButton.tag = indexPath.row
//                swithButton.addTarget(self, action: #selector(switchIsInAction(sender:)), for: .valueChanged)
//                if !loginStatus{
//                    cell.isHidden = true
//                }
//            } else{
//                if loginStatus{
//                    cell.accessoryType = .disclosureIndicator
//                    if SwitchOption[1] == false{
//                        cell.isHidden = true
//                    }
//                }else {
//                    cell.isHidden = true
//                }
//            }
//            return cell
//        }
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
                let alert = AlertController()
                alert.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(alert, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getNotificationStatus()
        setUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotificationStatus), name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserStatus), name:NSNotification.Name(rawValue: "logIn"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "logIn"), object: nil)
    }
    
    @objc func refreshNotificationStatus(){
        getNotificationStatus()
    }
    
    @objc func refreshUserStatus(){
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        loginButton.setTitle(status ? "Log Out" : "Log in", for: .normal)
        loginLabel.text = status ? "User" : "Guest"
        self.notificationTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationStatus()
        getNotificationStatusData()
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
                self.notificationTableView.reloadData()
            }
        })
    }

    @objc func addLogin(){
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if status{
            UserDefaults.standard.set(false,forKey: "isLoggedIn")
            loginButton.setTitle("Login in",for: .normal)
            self.notificationTableView.reloadData()
        } else{
            let loginPage = LoginController()
            navigationController?.present(loginPage, animated: true, completion: nil)
        }
    }
    
    @objc func switchIsInAction(sender:UISwitch){
        if sender.isOn{
            if sender.tag == 0{
                UserDefaults.standard.set(true, forKey: "flashSwitch")
            } else if sender.tag == 1{
                UserDefaults.standard.set(true, forKey: "priceSwitch")
            }
        } else{
            if sender.tag == 0{
                UserDefaults.standard.set(false, forKey: "flashSwitch")
            } else if sender.tag == 1{
                UserDefaults.standard.set(false, forKey: "priceSwitch")
            }
        }
        DispatchQueue.main.async {
            self.notificationTableView.reloadData()
        }
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(notificationTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView,"v1":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView,"v1":loginStatusView]))
    }
    
    var loginStatusView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var loginLabel:UILabel = {
        var loginLabel = UILabel()
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        loginLabel.text = status ? "User" : "Guest"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        return loginLabel
    }()
    
    var loginButton:UIButton = {
        var loginButton = UIButton(type:.system)
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        loginButton.setTitle(status ? "Login Out" : "Login in", for: .normal)
        loginButton.addTarget(self, action: #selector(addLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    lazy var notificationTableView:UITableView = {
       var tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "editCurrency")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.rowHeight = 40
//        tableView.separatorInset = .zero
        tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
//    func getNotificationStatus(){
//            let current = UNUserNotificationCenter.current()
//            current.getNotificationSettings(completionHandler: { (settings) in
//                if settings.authorizationStatus == .notDetermined {
//                    // Notification permission has not been asked yet, go for it!
//                }
//
//                if settings.authorizationStatus == .denied {
//                    UserDefaults.standard.set(false, forKey: "NotificationSetting")
//                    // Notification permission was previously denied, go to settings & privacy to re-enable
//                }
//
//                if settings.authorizationStatus == .authorized {
//                    UserDefaults.standard.set(true, forKey: "NotificationSetting")
//                    // Notification permission was already gransnted
//                }
//    //            DispatchQueue.main.async {
//    //                self.notificationTableView.reloadData()
//    //            }
//            })
//        }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        postNotificationStatusData()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        postNotificationStatusData()
//    }
    
    func getNotificationStatusData(){
        if UserDefaults.standard.string(forKey: "UserToken") != nil{
            if UserDefaults.standard.bool(forKey: "isLoggedIn"){
                let email = UserDefaults.standard.string(forKey: "UserEmail")!
                let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
                print(email)
                print(certificateToken)
                let parameter = ["email":email,"token":certificateToken]
                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","getNotificationStatus"], httpMethod: "POST", parameters: parameter) { (response, success) in
                    if success{
                        print(response)
                        UserDefaults.standard.set(response["data"]["interest"].bool!,forKey: "priceSwitch")
                        UserDefaults.standard.set(response["data"]["flash"].bool!,forKey: "flashSwitch")
                        self.notificationTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func postNotificationStatusData(){
//        if buildInterestStatus{
            if UserDefaults.standard.string(forKey: "UserToken") != nil && UserDefaults.standard.bool(forKey: "isLoggedIn") != false {
                let flashNotification = UserDefaults.standard.bool(forKey: "flashSwitch")
                let priceAlert = UserDefaults.standard.bool(forKey: "priceSwitch")
                let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
                let email = UserDefaults.standard.string(forKey: "UserEmail")!
                let parameter:[String:Any] = ["email":email,"token":certificateToken,"flash":flashNotification,"interest":priceAlert]
                URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","changeNotification"], httpMethod: "POST", parameters: parameter) { (response, success) in
                    print(response)
                }
            }
//        }
    }
}
