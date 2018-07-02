//
//  AlertNotificationController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import UserNotifications

class switchObject{
    var type:String?
    var switchStatus:Bool?
}

class AlertNotificationController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var switchStatus = switchObject()
    var cellItems:[[String]]{
        get{
            let status = UserDefaults.standard.bool(forKey: "NotificationSetting")
            let result = status == true ? [["Open"],[textValue(name: "flashNews_alert"),textValue(name: "price_alert"),textValue(name: "edit_alert")]] : [["Close"]]
            return result
        }
    }
    
    var switchStatusItem:[String] = ["Flash","Currency","Edit"]
    
    var SwitchOption:[Bool]{
        get{
            return [UserDefaults.standard.bool(forKey: "flashSwitch"),UserDefaults.standard.bool(forKey: "priceSwitch")]
        }
    }
    
    var switchLabel = ["flashSwitch","priceSwitch"]
    var sectionItem = ["Notification","Option"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().bglColor()
        let hintLabel = UILabel()
        hintLabel.text = sectionItem[section]
        hintLabel.textColor = UIColor.black
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sectionView.addSubview(hintLabel)
        sectionView.addSubview(statusLabel)
        
        NSLayoutConstraint(item: hintLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
         NSLayoutConstraint(item: statusLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":statusLabel]))
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().themeColor()
        
        if UserDefaults.standard.bool(forKey: "NotificationSetting"){
            let hintLabel = UILabel()
            hintLabel.text = "You can go to set the Notification"
            hintLabel.font = hintLabel.font.withSize(10)
            hintLabel.textColor = UIColor.white
            hintLabel.translatesAutoresizingMaskIntoConstraints = false
            sectionView.addSubview(hintLabel)
            
            let button = UIButton(type: .system)
            button.setTitle("setting", for: .normal)
            button.setTitleColor(UIColor.yellow, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(deviceSetting), for: .touchUpInside)
            sectionView.addSubview(button)
            
            NSLayoutConstraint(item: hintLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
            NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel,"v1":button]))
            
            
        } else {
            let settingButton = UIButton(type:.system)
            settingButton.setTitle("Go to setting the Notification", for: .normal)
            settingButton.setTitleColor(UIColor.white, for: .normal)
            settingButton.backgroundColor = UIColor.red
            settingButton.translatesAutoresizingMaskIntoConstraints = false
            settingButton.addTarget(self, action: #selector(deviceSetting), for: .touchUpInside)
            sectionView.addSubview(settingButton)
            
//            NSLayoutConstraint(item: settingButton, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//            NSLayoutConstraint(item: settingButton, attribute: .centerX, relatedBy: .equal, toItem: sectionView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":settingButton]))
            sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":settingButton]))
            
            
        }
        return sectionView
    }
    
    @objc func deviceSetting(){
        print("success")
        
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 80
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
            cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.white
            cell.textLabel?.text = cellItems[indexPath.section][indexPath.row]
            cell.accessibilityHint = switchStatusItem[indexPath.row]
            cell.textLabel?.textColor = UIColor.black
            if indexPath.row < 2{
                let swithButton = UISwitch()
                swithButton.isOn = SwitchOption[indexPath.row]
                cell.accessoryView = swithButton
                swithButton.tag = indexPath.row
                swithButton.addTarget(self, action: #selector(switchIsInAction(sender:)), for: .valueChanged)
            } else{
                cell.accessoryType = .disclosureIndicator
                if SwitchOption[1] == false{
                    cell.isHidden = true
                }
            }
            return cell
        }
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            let alert = AlertController()
            navigationController?.pushViewController(alert, animated: true)
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
        loginButton.setTitle(status ? "Login Out" : "Login in", for: .normal)
        loginLabel.text = status ? "User" : "Guest"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    func getNotificationStatus(){
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                print("1")
                // Notification permission has not been asked yet, go for it!
            }
            
            if settings.authorizationStatus == .denied {
                UserDefaults.standard.set(false, forKey: "NotificationSetting")
                print("disable")
                // Notification permission was previously denied, go to settings & privacy to re-enable
            }
            
            if settings.authorizationStatus == .authorized {
                UserDefaults.standard.set(true, forKey: "NotificationSetting")
                print("enable")
                // Notification permission was already gransnted
            }
            DispatchQueue.main.async {
                self.notificationTableView.reloadData()
            }
            print("trys")
        })
    }

    @objc func addLogin(){
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if status{
            UserDefaults.standard.set(false,forKey: "isLoggedIn")
            loginButton.setTitle("Login in",for: .normal)
        } else{
            let loginPage = LoginPageViewController()
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
        view.addSubview(loginStatusView)
        view.addSubview(notificationTableView)
        loginStatusView.addSubview(loginLabel)
        loginStatusView.addSubview(loginButton)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView,"v1":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-40-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView,"v1":loginStatusView]))
        
        
        NSLayoutConstraint(item: loginLabel, attribute: .centerY, relatedBy: .equal, toItem: loginStatusView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loginButton, attribute: .centerY, relatedBy: .equal, toItem: loginStatusView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        loginStatusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel]))
        loginStatusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginButton]))
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
        print("button")
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        loginButton.setTitle(status ? "Login Out" : "Login in", for: .normal)
        loginButton.addTarget(self, action: #selector(addLogin), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        return loginButton
    }()
    
    lazy var notificationTableView:UITableView = {
       var tableView = UITableView()
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "notification")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "editCurrency")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
 
    class SwitchTableViewCell:UITableViewCell{
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setUpView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init has not been completed")
        }
        
        func setUpView(){
            self.backgroundColor = ThemeColor().themeColor()
            self.selectionStyle = .none
        }
    }
}
