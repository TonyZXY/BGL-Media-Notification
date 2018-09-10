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
import SwiftKeychainWrapper
import SafariServices
import MessageUI

class MoreController: UIViewController,UITableViewDelegate,UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
  
    var loginStatus:Bool{
        get{
            return  UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    var email:String{
        get{
//            return UserDefaults.standard.string(forKey: "UserEmail") ?? ""
            return KeychainWrapper.standard.string(forKey: "Email") ?? "null"
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
            return [[loginStatus == true ? textValue(name: "logout_cell") : textValue(name: "login_cell")],[textValue(name: "defaultCurrency_cell"),textValue(name: "language_cell"),textValue(name: "alert_cell"),textValue(name: "alert_clearCache")],[textValue(name: "about_app"),textValue(name: "more_disclaimer"), textValue(name: "help_privacy")],[textValue(name: "help_section"), textValue(name: "feedback_section")]]
        }
    }
    
    var sections:[String]?{
        get{
            return [textValue(name: "account_section"),textValue(name: "setting_section"), textValue(name: "aboutUs_section"),textValue(name: "help")]
        }
    }
    
    
    var pushItems:[[UIViewController]]{
        get{
            return [[LoginController(usedPlace: 0)],[CurrencyController(),LanguageController(),AlertNotificationController()],[AboutAppViewController()],[FAQViewController(),ReportProblemViewController()]]
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
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
//        self.tabBarController?.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
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
        sectionLabel.font = UIFont.semiBoldFont(14*factor)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(sectionLabel)
        sectionLabel.textColor = ThemeColor().textGreycolor()
        sectionLabel.text = self.sections?[section]
        
        NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10).isActive = true
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25 * view.frame.width/375
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
        let realm = try! Realm()
        if indexPath.section > 0{
            //            if indexPath.section == 1 && indexPath.row == 2{
            //                if notificationStatus{
            
            if indexPath.section == 1 && indexPath.row == 3{
                let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "title_clearCache"), comment: ""), message: NSLocalizedString(textValue(name: "confirm_clearCache"), comment: ""), preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "delete_clearCache"), comment: ""), style: .destructive) { (_) in
                    try! realm.write {
                        realm.delete(realm.objects(NewsFlash.self))
                        realm.delete(realm.objects(NewsObject.self))
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteCache"), object: nil)
                    }
                }
                confirmAlertCtrl.addAction(confirmAction)
                let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "cancel_clearCache"), comment: ""), style: .cancel, handler:nil)
                confirmAlertCtrl.addAction(cancelAction)
                self.present(confirmAlertCtrl, animated: true, completion: nil)
            } else if indexPath.section == 2 && indexPath.row == 2 {
                let urlString = "https://cryptogeekapp.com/policy"
                if let url = URL(string: urlString) {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    if #available(iOS 11.0, *) {
                        vc.dismissButtonStyle = .close
                    } else {
                        
                    }
                    vc.hidesBottomBarWhenPushed = true
                    vc.accessibilityNavigationStyle = .separate
                    self.present(vc, animated: true, completion: nil)
                    //            navigationController?.pushViewController(vc, animated: true)
                }
            } else if indexPath.section == 2 && indexPath.row == 1{
                let urlString = "https://cryptogeekapp.com/terms"
                if let url = URL(string: urlString) {
                    let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    if #available(iOS 11.0, *) {
                        vc.dismissButtonStyle = .close
                    } else {
                        
                    }
                    vc.hidesBottomBarWhenPushed = true
                    vc.accessibilityNavigationStyle = .separate
                    self.present(vc, animated: true, completion: nil)
                    //            navigationController?.pushViewController(vc, animated: true)
                }
            }else if indexPath.section == 3 && indexPath.row == 1{
                if MFMailComposeViewController.canSendMail() {
//                   self.navigationController?.pushViewController(configuredMailComposeViewController(), animated: true)
                    self.present(configuredMailComposeViewController(), animated: true, completion: nil)
                } else {
                    showSendMailErrorAlert()
                }
            }else{
                let changePage = pushItems[indexPath.section][indexPath.row]
                changePage.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(changePage, animated: true)
            }
        } else{
            if loginStatus{
                let hud = JGProgressHUD(style: .light)
                hud.textLabel.text = textValue(name: "logout_hud")
                hud.backgroundColor = ThemeColor().progressColor()
                hud.tintColor = ThemeColor().darkBlackColor()
                hud.show(in: (self.parent?.view)!)
                let body = ["email":email,"token":certificateToken,"deviceToken":deviceToken]
                if sendDeviceTokenStatus{
                    URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","logoutIOSDevice"], httpMethod: "POST", parameters: body) { (response, success) in
                        if success{
                            deleteMemory()
                            self.optionTableView.reloadData()
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud.textLabel.text = textValue(name: "success_success")
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                hud.dismiss()
                            }
                        } else{
                            let manager = NetworkReachabilityManager()
                            hud.indicatorView = JGProgressHUDErrorIndicatorView()
                            if !(manager?.isReachable)! {
                                hud.textLabel.text = textValue(name: "error_error")
                                hud.detailTextLabel.text = textValue(name: "noNetwork") // To change?
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                                    hud.dismiss()
                                }
                            } else {
                                hud.textLabel.text = textValue(name: "error_error")
                                hud.detailTextLabel.text = textValue(name: "timeout") // To change?
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
                    hud.textLabel.text = textValue(name: "success_success")
                    
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
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        view.addSubview(optionTableView)
        view.backgroundColor = ThemeColor().themeColor()
        optionTableView.rowHeight = 45 * view.frame.width/375
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":optionTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":optionTableView]))
    }
    
    lazy var optionTableView:UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.rowHeight = 45
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["cryptogeekapp@gmail.com"])
        mailComposerVC.setSubject(textValue(name: "report_feedback"))
        mailComposerVC.setMessageBody("", isHTML: false)
        mailComposerVC.navigationBar.tintColor = ThemeColor().whiteColor()
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: textValue(name: "feedback_error_title"), message: textValue(name: "feedback_error_message"), preferredStyle: .alert)
        let copyEmailaddressaction = UIAlertAction(title: textValue(name: "feedback_error_button1"), style: .default, handler: { (_) in
            UIPasteboard.general.string = "cryptogeekapp@gmail.com"
        })
        sendMailErrorAlert.addAction(copyEmailaddressaction)
        let cancelAlertAction = UIAlertAction(title: textValue(name: "feedback_error_button2"), style: .cancel, handler: nil)
        sendMailErrorAlert.addAction(cancelAlertAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
}
