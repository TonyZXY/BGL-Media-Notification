//
//  AboutAppViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var iconImage: UIImageView = {
        let width = view.frame.width/375
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        image.frame = CGRect(x: 0, y: 0, width: 60 * width, height: 60 * width)
        image.image = UIImage(named: "CryptoGeekAppIcon")
        return image
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let versionNumber: Any? = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let buildVersion: Any? = Bundle.main.infoDictionary!["CFBundleVersion"]
        label.textColor = ThemeColor().whiteColor()
        label.font = UIFont.semiBoldFont(14)
        label.textAlignment = .center
        label.text = "v"+(versionNumber as? String)! + "(" + (buildVersion as? String)! + ")"
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.font = UIFont.semiBoldFont(14)
        label.textAlignment = .center
        label.text = "BlockChain Global"
        return label
    }()
    
    let supportLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.font = UIFont.semiBoldFont(14)
        label.textAlignment = .center
        label.text = "Support: cryptogeek@gmail.com"
        return label
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
    var items:[String]? {
        get{
            return [textValue(name: "feedback_rateus")]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        setUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = items![indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.regularFont(16)
        cell.backgroundColor = ThemeColor().greyColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let appID = "1406241883"
            //                let urlStr = "itms-apps://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
            let urlStr2 = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software" // (Option 2) Open App Review Tab
            
            
            if let url = URL(string: urlStr2), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else if indexPath.row == 1 {
            let nextPage = AboutFunctionController()
            nextPage.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextPage, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setUpView(){
        let height = view.frame.height/736
        let width = view.frame.width/375
        titleLabel.text = textValue(name: "about_app")
        navigationItem.titleView = titleLabel
        view.addSubview(iconImage)
        view.addSubview(versionLabel)
        view.addSubview(companyLabel)
        view.addSubview(supportLabel)
        view.addSubview(helpTableView)
        
        iconImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50 * height ).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 120 * width).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 120 * width).isActive = true
        
        versionLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 5 * height).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        versionLabel.widthAnchor.constraint(equalToConstant: 200 * width).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 30 * height).isActive = true
        
        helpTableView.topAnchor.constraint(equalTo: versionLabel.bottomAnchor,constant: 20 * height).isActive = true
        helpTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        helpTableView.heightAnchor.constraint(equalToConstant: 150 * height).isActive = true
        
        if #available(iOS 11.0, *) {
            supportLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20 * height).isActive = true
        } else {
            supportLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20 * height).isActive = true
        }
        supportLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        supportLabel.widthAnchor.constraint(equalToConstant: 300 * width).isActive = true
        supportLabel.heightAnchor.constraint(equalToConstant: 30 * height).isActive = true
        
        companyLabel.bottomAnchor.constraint(equalTo: supportLabel.topAnchor).isActive = true
        companyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        companyLabel.widthAnchor.constraint(equalToConstant: 300 * width).isActive = true
        companyLabel.heightAnchor.constraint(equalToConstant: 30 * height).isActive = true

    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "about_app")
        navigationItem.titleView = titleLabel
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
}
