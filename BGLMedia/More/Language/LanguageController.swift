//
//  LanguageController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 15/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class LanguageController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var storeData = ["CN","EN"]
    var language:[String]{
        get{
            return [textValue(name: "chinese_language"),textValue(name: "english_language")]
        }
    }
    
    var logoItems = ["CN","EN"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! languageCell
        cell.languageLabel.text = language[indexPath.row]
        cell.languageLogoLabel.text = logoItems[indexPath.row]
        if storeData[indexPath.row] == defaultLanguage{
            cell.isHighlighted = true
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.alpha = 0
//        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
//        cell.layer.transform = transform
//        UIView.animate(withDuration: 1.0) {
//            cell.alpha = 1.0
//            cell.layer.transform = CATransform3DIdentity
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let str = storeData[indexPath.row]
//        UserDefaults.standard.set(str, forKey: "defaultCurrency")
//        let selectedCell = tableView.cellForRow(at: indexPath)! as! currencyCell
//        selectedCell.isHighlighted = true
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
//        navigationController?.popViewController(animated: true)
        
        
        let str = storeData[indexPath.row]
        UserDefaults.standard.set(str, forKey: "defaultLanguage")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        let selectedCell = tableView.cellForRow(at: indexPath)! as! languageCell
        selectedCell.isHighlighted = true
        navigationController?.popViewController(animated: true)
        
//        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "alertTitle_language"), comment: ""), message: NSLocalizedString(textValue(name: "alertHint_language"), comment: ""), preferredStyle: .alert)
//        let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertChange_language"), comment: ""), style: .destructive) { (_) in
//            UserDefaults.standard.set(str, forKey: "defaultLanguage")
//            UserDefaults.standard.synchronize()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//
//        confirmAlertCtrl.addAction(confirmAction)
//        let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertCancel_language"), comment: ""), style: .cancel, handler:nil)
//        confirmAlertCtrl.addAction(cancelAction)
//        self.present(confirmAlertCtrl, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)! as! languageCell
        selectedCell.isHighlighted = false
    }
    
    lazy var communityTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(languageCell.self, forCellReuseIdentifier: "languageCell")
        return tableView
    }()
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(communityTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
    }
    
}

class languageCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    var cellView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 13
        return view
    }()
    
    var logoView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeWidgetColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        return view
    }()
    
    var languageLogoLabel: UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().walletCellcolor()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let languageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted{
                languageLabel.textColor = isHighlighted ? ThemeColor().themeColor() : UIColor.white
                cellView.backgroundColor = isHighlighted ? UIColor.white : ThemeColor().walletCellcolor()
            }
        }
    }
    
    //    override var isSelected: Bool {
    //        didSet {
    //            currencyLabel.textColor = isHighlighted ? ThemeColor().themeColor() : UIColor.white
    //            cellView.backgroundColor = isHighlighted ? UIColor.white : ThemeColor().walletCellcolor()
    //        }
    //    }
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(cellView)
        cellView.addSubview(logoView)
        cellView.addSubview(languageLogoLabel)
        cellView.addSubview(languageLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        NSLayoutConstraint(item: logoView, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        //        NSLayoutConstraint(item: currencyLabel, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: languageLabel, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: languageLogoLabel, attribute: .centerX, relatedBy: .equal, toItem: logoView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: languageLogoLabel, attribute: .centerY, relatedBy: .equal, toItem: logoView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(50)]-10-[v1]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoView,"v1":languageLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoView,"v1":languageLabel]))
    }
}
