//
//  FAQViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.separatorStyle = .singleLineEtched
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    var questions:[String]? {
        get{
            return [
                    "What is CryptoGeek？",
                    "What are CryptoGeek features?",
                    "How to verify email address?",
                    "How to reset password?",
                    "How to use Alert function?",
                    "Where can I check My watchlist? ",
                    "Why data is not updated?",
                    "Does it support multi-devices?",
                    "How to clear cache"]
        }
    }
    
    var answers:[ExpandableAnswers] =  [
                ExpandableAnswers(isExpandabed: false, answer: "CryptoGeek is an application powered by Blockchain Global. It provides up to date cryptocurrencies market data, News Flash, Daily News and customised cryptocurrencies asset tracking services. "),
                ExpandableAnswers(isExpandabed: false, answer: "CryptoGeek features include:\nCustomised cryptocurrencies asset tracking services\n\nCryptocurrencies market data\nNews Flash\nDaily News "),
                ExpandableAnswers(isExpandabed: false, answer: "Your email address need to be verified to use further function. After signing up for your account, an email will be sent to the email address you have signed up in a minute.When viewing the email, please click the button or the address under the email. The email address will be verified automatically after clicking either of them.If you have missed or lost your verification email, you could will be shown a pop up window when you login to ask you to resend the verification email. "),
                ExpandableAnswers(isExpandabed: false, answer: "You might need to reset your password if you forgot it. By clicking the link \"Forgot Password?\", a popup window will be shown to you to let you enter your email to reset. After clicking the send email, you will recieve an email. When viewing the email, please click the button or the address under the email. Your web page will jump to the reset password page. After enter your new password ,the confirmation of your new password and click the reset button, your password will be reset and all your device that has been login with that account need to be re-login"),
                ExpandableAnswers(isExpandabed: false, answer: "You can add and check alert in your added transaction or in market(including a sepecific ) or in alert line of more tab.\n\nTo add a alert, you could click on \"Add\" button in either of these place. By finishing editing coin name, exchange, trading and price to focused, an alert will be added by clicking done. \n\nTo edit or delete these alert, you could tap into the alert and find the delete button in the sepecific alert.\n\nIf you are adding a price that is higher than current price, the app will notify you when the price reach above your watching price. If you are adding a price that is lower than current price, the app will notify you when the price reach below your watching price"),
                ExpandableAnswers(isExpandabed: false, answer: "Watchlist can be checked in watchlist tab of market. The price and the percentage of changing is stand for a 24-hour change"),
                ExpandableAnswers(isExpandabed: false, answer: "The data are all updated regularly and automatically. There are occasional system faults, but if you are seeing old data its most likely that you are having a problem with caching. Either your page is holding an old version of the product you want and not fetching a new one from our application. Make sure you slide down to \"Refresh\". Or your Internet Service Provider (ISP) is caching (keeping a copy of the web pages) on their server(s). You may have to contact your ISP."),
                ExpandableAnswers(isExpandabed: false, answer: "CryptoGeek does support multi-device. You could check news flash, daily news, your customised alert notification in all devices you have logged in. You could not check your crytocurrency in multi-devices because it is currently offline. When you reset your password, after you successfully reset your password, other devices will log out automatically."),
                ExpandableAnswers(isExpandabed: false, answer: "Clear cache could be found in more tab. Cache is where news and news flash saved when first loaded. This is for better application performance. When clearing cache, all news flash and news will be cleaned."),

        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        setupView()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let button = UIButton(type: .system)
            let width = view.frame.width/375
            
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.masksToBounds = true
            image.frame = CGRect(x: 0, y: 0, width: 22 * width, height: 22 * width)
            image.image = UIImage(named: "question")
            button.addSubview(image)
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10 * width).isActive = true
            image.widthAnchor.constraint(equalToConstant: 25 * width).isActive = true
            image.heightAnchor.constraint(equalToConstant: 25 * width).isActive = true
            //        button.setTitle("\(questions![section]) Open", for: .normal)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = questions?[section]
            label.textColor = ThemeColor().whiteColor()
            label.font = UIFont.semiBoldFont(16)
            label.textAlignment = .left
            button.addSubview(label)
            label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 15 * width).isActive = true
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 280 * width).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30 * width).isActive = true
            
            
            let image2 = UIImageView()
            image2.translatesAutoresizingMaskIntoConstraints = false
            image2.contentMode = .scaleAspectFit
            image2.layer.masksToBounds = true
            image2.frame = CGRect(x: 0, y: 0, width: 17 * width, height: 17 * width)
            image2.image = UIImage(named: "arrow")
            image2.transform = image2.transform.rotated(by: CGFloat(Double.pi/2))
            button.addSubview(image2)
            image2.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            image2.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -14 * width).isActive = true
            image2.widthAnchor.constraint(equalToConstant: 17 * width).isActive = true
            image2.heightAnchor.constraint(equalToConstant: 17 * width).isActive = true
            button.addTarget(self, action: #selector(collapse), for: .touchUpInside)
            button.tag = section
        
            let emptyLabel = UILabel()
            button.addSubview(emptyLabel)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyLabel.backgroundColor = UIColor.lightGray
            emptyLabel.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            emptyLabel.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
            emptyLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
            emptyLabel.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
            return button
        
        
    }
    
    
    @objc func collapse(sender: UIButton){
        let section = sender.tag

        let isExpanded = answers[section].isExpandabed
        answers[section].isExpandabed = !isExpanded
        let indexPath = IndexPath(row: 0, section: section)
        if isExpanded{
            helpTableView.deleteRows(at: [indexPath], with: .fade)
            UIView.animate(withDuration: 0.25, animations: {
                sender.subviews[2].transform = sender.subviews[2].transform.rotated(by: -CGFloat(Double.pi))
            })
        } else {
            helpTableView.insertRows(at: [indexPath], with: .fade)
            UIView.animate(withDuration: 0.25, animations: {
                sender.subviews[2].transform = sender.subviews[2].transform.rotated(by: CGFloat(Double.pi))
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !answers[section].isExpandabed {
            return 0
        } else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (questions?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * view.frame.width/375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = answers[indexPath.section].answer
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.regularFont(16)
        cell.backgroundColor = ThemeColor().greyColor()
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "help_FAQ")
        navigationItem.titleView = titleLabel
    }
    func setupView(){
        titleLabel.text = textValue(name: "help_FAQ")
        navigationItem.titleView = titleLabel
        
        view.addSubview(helpTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":helpTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":helpTableView]))
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
}



struct ExpandableAnswers {
    var isExpandabed : Bool
    let answer: String
}














