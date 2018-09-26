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
import JGProgressHUD
import SwiftKeychainWrapper

class switchObject{
    var type:String?
    var switchStatus:Bool?
}

class AlertNotificationController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var switchStatus = switchObject()
//    var changeSwitchStatus = false
    var oldAlert = [String:Bool]()
    var cellItems:[[String]]{
        get{
            var allowStatus:String = ""
            if !loginStatus{
                allowStatus = textValue(name: "alertUnavailable_alert")
            } else if !NotificationStatus{
                allowStatus = textValue(name: "alertUnavailable_alert")
            } else{
                allowStatus = textValue(name: "alertAvailable_alert")
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
    
    var flashSwitchStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "flashSwitch")
        }
    }
    
    var priceSwitchStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "priceSwitch")
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
            return [textValue(name: "alertStatus_alert"),textValue(name: "pushSection_alert"),textValue(name: "editSection_alert")]
        }
    }
    
    var email:String{
        get{
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
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
        let factor = view.frame.width/375
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        let sectionLabel = UILabel()
        sectionLabel.text = sectionItem[section]
        sectionLabel.textColor = ThemeColor().textGreycolor()
        sectionLabel.font = UIFont.regularFont(18*factor)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(sectionLabel)
        NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -10*factor).isActive = true
        NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10*factor).isActive = true
        //        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
        //        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            if !loginStatus || !NotificationStatus{
                return 60
            } else{
                return 0
            }
        } else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        if section == 0{
            if !loginStatus || !NotificationStatus{
                let sectionView = UIView()
                sectionView.backgroundColor = ThemeColor().darkGreyColor()
                let sectionButton = UIButton()
                sectionButton.titleLabel?.lineBreakMode = .byWordWrapping
                sectionButton.titleLabel?.numberOfLines = 0
                sectionButton.titleLabel?.contentMode = .left
                if !loginStatus{
                    let settingString = textValue(name: "notlogin_alert")
                    
                    let myAttribute = [NSAttributedStringKey.font: UIFont.regularFont(13*factor), NSAttributedStringKey.foregroundColor: ThemeColor().textGreycolor()]
                    let myString = NSMutableAttributedString(string: settingString, attributes: myAttribute)
                    var myRange = NSRange(location: 0, length: 0)
                    if defaultLanguage == "EN"{
                        myRange = NSRange(location: settingString.count-5, length: 5)
                    } else if defaultLanguage == "CN"{
                        myRange = NSRange(location: 16, length: 2)
                    }
                    myString.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeColor().blueColor(), range: myRange)
                    sectionButton.setAttributedTitle(myString, for: .normal)
                    
                    
                    sectionButton.addTarget(self, action: #selector(GoTologin), for: .touchUpInside)
                } else{
                    let settingString = textValue(name: "notallow_alert")
                    let myAttribute = [NSAttributedStringKey.font: UIFont.regularFont(13*factor), NSAttributedStringKey.foregroundColor: ThemeColor().textGreycolor()]
                    let myString = NSMutableAttributedString(string: settingString, attributes: myAttribute )
                    var myRange = NSRange(location: 0, length: 0)
                    if defaultLanguage == "EN"{
                        myRange = NSRange(location: 72, length: 14)
                    } else if defaultLanguage == "CN"{
                        myRange = NSRange(location: 20, length: 2)
                    }
                    
                    
                    myString.addAttribute(NSAttributedStringKey.foregroundColor, value: ThemeColor().blueColor(), range: myRange)
                    sectionButton.setAttributedTitle(myString, for: .normal)
                    //                    let myAttribute = [NSAttributedStringKey.font: UIFont.regularFont(13) ]
                    //                    let myString = NSMutableAttributedString(string: "Go to Setting", attributes: myAttribute )
                    //                    let myRange = NSRange(location: 1, length: 3) // range starting at location 17 with a lenth of 7: "Strings"
                    //                    myString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: myRange)
                    //
                    //                    sectionButton.setAttributedTitle(myString, for: .normal)
                    sectionButton.addTarget(self, action: #selector(deviceSetting), for: .touchUpInside)
                }
                sectionButton.translatesAutoresizingMaskIntoConstraints = false
                sectionView.addSubview(sectionButton)
                
                
                
                NSLayoutConstraint(item: sectionButton, attribute: .right, relatedBy: .equal, toItem: sectionView, attribute: .right, multiplier: 1, constant: -10*factor).isActive = true
                NSLayoutConstraint(item: sectionButton, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10*factor).isActive = true
                NSLayoutConstraint(item: sectionButton, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
                return sectionView
            } else{
                return UIView()
            }
        } else{
            return UIView()
        }
    }
    
    
    @objc func deviceSetting(){
        
        let alertController = UIAlertController(title: "Notification Allow", message: "Go to setting page to set Notification", preferredStyle: .alert)
        
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
        let login = LoginController(usedPlace: 0)
        present(login, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60*view.frame.width/375
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
        cell.backgroundColor = ThemeColor().greyColor()
        cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
        cell.accessibilityHint = switchStatusItem[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = ThemeColor().whiteColor()
        cell.textLabel?.font = UIFont.regularFont(14*factor)
        cell.separatorInset = UIEdgeInsetsMake(0, 16*factor, 0, 0)
        cell.isUserInteractionEnabled = true
        if indexPath.section == 1 {
            let swithButton = UISwitch()
            swithButton.isOn = SwitchOption[indexPath.row]
            cell.accessoryView = swithButton
            swithButton.tag = indexPath.row
            cell.selectionStyle = .none
            swithButton.addTarget(self, action: #selector(switchIsInAction(sender:)), for: .valueChanged)
            if !loginStatus{
                swithButton.tintColor = ThemeColor().textGreycolor()
                swithButton.thumbTintColor = ThemeColor().greyColor()
                swithButton.onTintColor = ThemeColor().textGreycolor()
                cell.textLabel?.textColor = ThemeColor().textGreycolor()
                cell.isUserInteractionEnabled = false
            }
            return cell
        } else if indexPath.section == 2{
            cell.accessoryType = .disclosureIndicator
            if !loginStatus{
                cell.textLabel?.textColor = ThemeColor().textGreycolor()
                cell.isUserInteractionEnabled = false
            }
            return cell
        } else{
            cell.selectionStyle = .none
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
        let factor = view.frame.width/375
        if indexPath.section == 2 && indexPath.row == 0{
            let alert = AlertController()
            alert.status = "setting"
            alert.factor = factor
            alert.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(alert, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotificationStatus()
        setUpView()
        
        oldAlert["Flash"] = flashSwitchStatus
        oldAlert["Currency"] = priceSwitchStatus
        
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
    
    func checkAlertChange()->Bool{
        if flashSwitchStatus != oldAlert["Flash"] || priceSwitchStatus != oldAlert["Currency"]{
            return true
        } else{
            return false
        }
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
            let loginPage = LoginController(usedPlace: 0)
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
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
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
        let factor = view.frame.width/375
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "editCurrency")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.rowHeight = 40 * factor
        //        tableView.separatorInset = .zero
        tableView.separatorInset = UIEdgeInsetsMake(0, 16*factor, 0, 0);
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.bounces = false
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
        if checkAlertChange(){
            postNotificationStatusData()
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        postNotificationStatusData()
    //    }
    
    func getNotificationStatusData(){
        if UserDefaults.standard.bool(forKey: "isLoggedIn"){
            let hud = JGProgressHUD(style: .light)
            hud.show(in: (self.parent?.view)!)
            
//            let email = UserDefaults.standard.string(forKey: "UserEmail")!
            
//            let eamil = KeychainWrapper.standard.string(forKey: "Email") ?? "null"
            
            let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
            let parameter = ["email":email,"token":certificateToken]
            URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","getNotificationStatus"], httpMethod: "POST", parameters: parameter) { (response, success) in
                if success{
                    let responseSuccess = response["success"].bool ?? false
                    if responseSuccess{
                        UserDefaults.standard.set(response["data"]["interest"].bool!,forKey: "priceSwitch")
                        UserDefaults.standard.set(response["data"]["flash"].bool!,forKey: "flashSwitch")
                        self.notificationTableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            hud.dismiss()
                        }
                    } else{
                        let code = response["code"].int ?? 0
                        if code == 800{
                            deleteMemory()
                            hud.indicatorView = JGProgressHUDErrorIndicatorView()
                            hud.textLabel.text = "Error"
                            hud.detailTextLabel.text = "Password Reset" // To change?
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                hud.dismiss()
                            }
                            let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "resetDevice_title"), comment: ""), message: NSLocalizedString(textValue(name: "resetDevice_description"), comment: ""), preferredStyle: .alert)
                            let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "resetDevice_confirm"), comment: ""), style: .destructive) { (_) in
                                self.navigationController?.popViewController(animated: true)
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
                        hud.textLabel.text = "Error"
                        hud.detailTextLabel.text = "No Network" // To change?
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                        
                    } else{
                        hud.textLabel.text = "Error"
                        hud.detailTextLabel.text = "Time Out"
                        hud.dismiss()
                    }
                }
            }
        }
    }
    
    func postNotificationStatusData(){
        //        if buildInterestStatus{
        if UserDefaults.standard.bool(forKey: "isLoggedIn") != false {
            let flashNotification = UserDefaults.standard.bool(forKey: "flashSwitch")
            let priceAlert = UserDefaults.standard.bool(forKey: "priceSwitch")
            let certificateToken = UserDefaults.standard.string(forKey: "CertificateToken")!
//            let email = UserDefaults.standard.string(forKey: "UserEmail")!
            let parameter:[String:Any] = ["email":email,"token":certificateToken,"flash":flashNotification,"interest":priceAlert]
            URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","changeNotification"], httpMethod: "POST", parameters: parameter) { (response, success) in
            }
        }
    }
}
