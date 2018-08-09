//
//  MoreController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 15/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift
import Alamofire
import JGProgressHUD

class MoreController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let realm = try! Realm()
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
    
    var sendDeviceTokenStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "SendDeviceToken")
        }
    }
    
    var items:[[String]]? {
        get{
            let loginStatus = UserDefaults.standard.bool(forKey: "isLoggedIn")
            return [[textValue(name: "aboutUs_cell"),textValue(name: "community_cell"),textValue(name: "help")],[textValue(name: "defaultCurrency_cell"),textValue(name: "language_cell"),textValue(name: "alert_cell"),textValue(name: "alert_clearCache")],[loginStatus == true ? textValue(name: "logout_cell") : textValue(name: "login_cell")]]
        }
    }
    
    var sections:[String]?{
        get{
            return [textValue(name: "aboutUs_section"),textValue(name: "setting_section"),textValue(name: "account_section")]
        }
    }
    
    
    var pushItems:[[UIViewController]]{
        get{
            return [[AboutUsViewController(), BGLCommunityController(),HelpViewController()],[CurrencyController(),LanguageController(),AlertNotificationController()],[LoginController(usedPlace: 0)]]
        }
    }
    
    var navigationBarItem:String{
        get{
            return textValue(name: "settingTitle")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let factor = view.frame.width/375
        setUpView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshNotificationStatus), name:NSNotification.Name(rawValue: "refreshNotificationStatus"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        getNotificationStatus()
        optionTableView.reloadData()
    }
    
    @objc func refreshNotificationStatus(){
        //        getNotificationStatus()
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        let sectionLabel = UILabel()
        sectionLabel.font = UIFont.semiBoldFont(17*factor)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(sectionLabel)
        sectionLabel.textColor = ThemeColor().textGreycolor()
        sectionLabel.text = self.sections?[section]
        
        NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10).isActive = true
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * view.frame.width/375
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
        cell.textLabel?.font = UIFont.regularFont(16)
        //        cell.selectionStyle = .none
        cell.backgroundColor = ThemeColor().greyColor()
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
//        if let headerTitle = view as? UITableViewHeaderFooterView {
//            headerTitle.textLabel?.textColor = ThemeColor().textGreycolor()
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < 2{
            //            if indexPath.section == 1 && indexPath.row == 2{
            //                if notificationStatus{
            
            if indexPath.section == 1 && indexPath.row == 3{
                let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "title_clearCache"), comment: ""), message: NSLocalizedString(textValue(name: "confirm_clearCache"), comment: ""), preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "delete_clearCache"), comment: ""), style: .destructive) { (_) in
                    try! self.realm.write {
                        self.realm.delete(self.realm.objects(NewsFlash.self))
                        self.realm.delete(self.realm.objects(NewsObject.self))
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCache"), object: nil)
                    }
                }
                confirmAlertCtrl.addAction(confirmAction)
                let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "cancel_clearCache"), comment: ""), style: .cancel, handler:nil)
                confirmAlertCtrl.addAction(cancelAction)
                self.present(confirmAlertCtrl, animated: true, completion: nil)
            } else{
                let changePage = pushItems[indexPath.section][indexPath.row]
                changePage.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(changePage, animated: true)
            }
        } else{
            if loginStatus{
                let hud = JGProgressHUD(style: .light)
                hud.textLabel.text = "Log Out"
                hud.backgroundColor = ThemeColor().progressColor()
                hud.show(in: (self.parent?.view)!)
                
                let body = ["email":email,"token":certificateToken,"deviceToken":deviceToken]
                
                
                if sendDeviceTokenStatus{
                    URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","logoutIOSDevice"], httpMethod: "POST", parameters: body) { (response, success) in
                        if success{
                            deleteMemory()
                            self.optionTableView.reloadData()
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud.textLabel.text = "Success"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                hud.dismiss()
                            }
                        } else{
                            let manager = NetworkReachabilityManager()
                            hud.indicatorView = JGProgressHUDErrorIndicatorView()
                            if !(manager?.isReachable)! {
                                hud.textLabel.text = "Error"
                                hud.detailTextLabel.text = "No Network" // To change?
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                    hud.dismiss()
                                }
                            } else {
                                hud.textLabel.text = "Error"
                                hud.detailTextLabel.text = "Time Out" // To change?
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                    hud.dismiss()
                                }
                            }
                        }
                    }
                } else{
                    deleteMemory()
                    self.optionTableView.reloadData()
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = "Success"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        hud.dismiss()
                    }
                }
            } else{
                let login = LoginController(usedPlace: 0)
                self.present(login, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    func deleteMemory(){
//        UserDefaults.standard.set(false,forKey: "isLoggedIn")
//        UserDefaults.standard.set(true, forKey: "flashSwitch")
//        UserDefaults.standard.set(true, forKey: "priceSwitch")
//        UserDefaults.standard.set(false, forKey: "SendDeviceToken")
//        UserDefaults.standard.set(false, forKey: "getDeviceToken")
//        UserDefaults.standard.set("null", forKey: "UserEmail")
//        UserDefaults.standard.set("null", forKey: "CertificateToken")
//        UserDefaults.standard.set("null", forKey: "UserToken")
//
//        try! self.realm.write {
//            self.realm.delete(self.realm.objects(alertObject.self))
//            self.realm.delete(self.realm.objects(alertCoinNames.self))
//        }
//    }
//
    
    func setUpView(){
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        view.addSubview(optionTableView)
        view.backgroundColor = ThemeColor().themeColor()
        optionTableView.rowHeight = 50 * view.frame.width/375
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":optionTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":optionTableView]))
    }
    
    lazy var optionTableView:UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    
    
}
