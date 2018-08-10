//
//  HelpViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var helpTableView:UITableView = {
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
    
    var items:[[String]]? {
        get{
            return [[textValue(name: "aboutUs_cell"),textValue(name: "community_cell"),textValue(name: "about_app")],[textValue(name: "feedback_rateus"),textValue(name: "feedBack_reportbug")],[textValue(name: "help_FAQ"), textValue(name: "help_userAgreement"), textValue(name: "help_privacy")]]
        }
    }
    
    var sections:[String]?{
        get{
            return [textValue(name: "aboutUs_section"),textValue(name: "feedback_section"), textValue(name: "help_section")]
        }
    }
    var pushItems:[[UIViewController]]{
        get{
            return [[AboutUsViewController(), BGLCommunityController(),AboutAppViewController()],[],[FAQViewController(),AgreementViewController(),PrivacyViewController()]]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        helpTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items![section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = items![indexPath.section][indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.regularFont(16)
        cell.backgroundColor = ThemeColor().greyColor()
        let indexPathForSpecial = IndexPath.init(row: 0, section: 1)
        if indexPath != indexPathForSpecial{
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let nextPage = pushItems[indexPath.section][indexPath.row]
            nextPage.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextPage, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == 0{
                let appID = "1340353421"
                let urlStr = "itms-apps://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
                let urlStr2 = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software" // (Option 2) Open App Review Tab
                
                
                if let url = URL(string: urlStr2), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            } else{
                let nextPage = ReportProblemViewController()
                nextPage.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(nextPage, animated: true)
            }
            
        } else if indexPath.section == 2 {
            let nextPage = pushItems[indexPath.section][indexPath.row]
            nextPage.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextPage, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections!.count
    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "help")
        navigationItem.titleView = titleLabel
        helpTableView.reloadData()
    }
    
    
    func setUpView(){
        titleLabel.text = textValue(name: "help")
        navigationItem.titleView = titleLabel

        view.addSubview(helpTableView)
        helpTableView.rowHeight = 50 * view.frame.width/375
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":helpTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":helpTableView]))
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    
    
}
