//
//  AlertNotificationController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class switchObject{
    var type:String?
    var switchStatus:Bool?
}

class AlertNotificationController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var switchStatus = switchObject()
    var cellItems:[[String]]{
        get{
            return [["open"],[textValue(name: "flashNews_alert"),textValue(name: "price_alert"),textValue(name: "edit_alert")]]
        }
    }
    
    var switchStatusItem:[String] = ["Flash","Currency","Edit"]
    
    var SwitchOption:[Bool]{
        get{
            return [UserDefaults.standard.value(forKey: "flashSwitch") as! Bool,UserDefaults.standard.value(forKey: "priceSwitch") as! Bool]
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
        let hintLabel = UILabel()
        hintLabel.text = "Please go to setting open the Notification"
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
        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-0-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":hintLabel,"v1":button]))


        return sectionView
    }
    
    @objc func deviceSetting(){
        let settingsButton = NSLocalizedString("Settings", comment: "")
        let cancelButton = NSLocalizedString("Cancel", comment: "")
        let message = NSLocalizedString("Your need to give a permission from notification settings.", comment: "")
        let goToSettingsAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        goToSettingsAlert.addAction(UIAlertAction(title: settingsButton, style: .destructive, handler: { (action: UIAlertAction) in
            DispatchQueue.main.async {
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        UIApplication.shared.openURL(settingsUrl as URL)
                    }
                }
            }
        }))
        
//        logoutUserAlert.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: nil))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 50
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
                if SwitchOption[1] == true{
                    cell.isHidden = false
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
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
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
        notificationTableView.reloadData()
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(loginStatusView)
        view.addSubview(notificationTableView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView,"v1":loginStatusView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-40-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView,"v1":loginStatusView]))
    }
    
    var loginStatusView:UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.white
        var loginLabel = UILabel()
        loginLabel.text = "Guest"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        var statusLabel = UILabel()
        statusLabel.text = "Login in"
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(loginLabel)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint(item: loginLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: statusLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":loginLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":statusLabel]))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
