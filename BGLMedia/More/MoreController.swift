//
//  MoreController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 15/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import UserNotifications

class MoreController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var loginStatus:Bool{
        get{
            return  UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var email:String{
        get{
            return UserDefaults.standard.string(forKey: "UserEmail") ?? ""
        }
    }
    
    var certificateToken:String{
        get{
            return UserDefaults.standard.string(forKey: "CertificateToken") ?? ""
        }
    }
    
    var deviceToken:String{
        get{
            return UserDefaults.standard.string(forKey: "UserToken") ?? ""
        }
    }
    
    var notificationStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "NotificationSetting")
        }
    }
    
    var items:[[String]]? {
        get{
            let loginStatus = UserDefaults.standard.bool(forKey: "isLoggedIn")
            return [[textValue(name: "aboutUs_cell"),textValue(name: "community_cell")],[textValue(name: "defaultCurrency_cell"),textValue(name: "language_cell"),textValue(name: "alert_cell")],[loginStatus == true ? textValue(name: "logout_cell") : textValue(name: "login_cell")]]
        }
    }
    
    var sections:[String]?{
        get{
            return [textValue(name: "aboutUs_section"),textValue(name: "setting_section"),textValue(name: "account_section")]
        }
    }
    
    
    var pushItems:[[UIViewController]]{
        get{
            return [[AboutUsViewController(), BGLCommunityController()],[CurrencyController(),LanguageController(),AlertNotificationController()],[LoginPageViewController()]]
        }
    }
    
    var navigationBarItem:String{
        get{
            return textValue(name: "settingTitle")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotificationStatus), name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationStatus()
        optionTableView.reloadData()
    }
    
    @objc func refreshNotificationStatus(){
        getNotificationStatus()
    }
    
    @objc func changeLanguage(){
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        optionTableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections?[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items![section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = items![indexPath.section][indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        cell.backgroundColor = ThemeColor().walletCellcolor()
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = ThemeColor().themeWidgetColor()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < 2{
            let changePage = pushItems[indexPath.section][indexPath.row]
            changePage.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(changePage, animated: true)
        } else{
            if loginStatus{
                let body = ["email":email,"token":certificateToken,"deviceToken":deviceToken]
                URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","logoutIOSDevice"], httpMethod: "POST", parameters: body) { (response, success) in
                    if success{
                        print(response)
                        UserDefaults.standard.set(false,forKey: "isLoggedIn")
                        UserDefaults.standard.set(true, forKey: "flashSwitch")
                        UserDefaults.standard.set(true, forKey: "priceSwitch")
                        UserDefaults.standard.set(false, forKey: "SendDeviceToken")
                        UserDefaults.standard.set("", forKey: "UserEmail")
                        UserDefaults.standard.set("", forKey: "CertificateToken")
                    }
                }
                
                optionTableView.reloadData()
            } else{
                if notificationStatus{
                    let login = LoginPageViewController()
                    self.present(login, animated: true, completion: nil)
                } else{
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
            }
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
//            DispatchQueue.main.async {
//                self.notificationTableView.reloadData()
//            }
        })
    }
    
    func setUpView(){
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        view.addSubview(optionTableView)
        view.backgroundColor = ThemeColor().themeColor()
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":optionTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":optionTableView]))
    }
    
    lazy var optionTableView:UITableView = {
        var tabelView = UITableView()
        tabelView.backgroundColor = ThemeColor().themeColor()
        tabelView.delegate = self
        tabelView.separatorStyle = .none
        tabelView.dataSource = self
        tabelView.isScrollEnabled = false
        tabelView.rowHeight = 80
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tabelView.translatesAutoresizingMaskIntoConstraints = false
        return tabelView
    }()

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
}
