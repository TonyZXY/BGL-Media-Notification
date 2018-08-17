//
//  LanguageController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 15/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import JGProgressHUD

class LanguageController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var storeData = ["CN","EN"]
    var language:[String]{
        get{
            return [textValue(name: "chinese_language"),textValue(name: "english_language")]
        }
    }
    
    var logoItems = ["CN","EN"]
    
    let rowNumber = ["CN":0,"EN":1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
         communityTableView.selectRow(at: IndexPath(row: rowNumber[defaultLanguage] ?? 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return language.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell") as! languageCell
        cell.factor = factor
        cell.languageLabel.text = language[indexPath.row]
        cell.languageLogoLabel.text = logoItems[indexPath.row]
//        if storeData[indexPath.row] == defaultLanguage{
//            cell.cellView.backgroundColor = ThemeColor().whiteColor()
//            cell.languageLabel.textColor = ThemeColor().darkBlackColor()
//        }
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
        let str = storeData[indexPath.row]
        UserDefaults.standard.set(str, forKey: "defaultLanguage")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        let selectedCell = tableView.cellForRow(at: indexPath)! as! languageCell
//        selectedCell.cellView.backgroundColor = ThemeColor().whiteColor()
//        selectedCell.languageLabel.textColor = ThemeColor().darkBlackColor()
        
        
        selectedCell.isSelected = true
//        let backItem = UIBarButtonItem()
//        backItem.title = textValue(name: "back_button")
//        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
//        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
//        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: (self.parent?.view)!)
        
//        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//        hud.textLabel.text = "Success"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            hud.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)! as! languageCell
        selectedCell.isSelected = false
    }
    
    lazy var communityTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40*view.frame.width/375
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(languageCell.self, forCellReuseIdentifier: "languageCell")
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        let sectionLabel = UILabel()
        sectionLabel.text = textValue(name: "language_setting")
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60*view.frame.width/375
    }
    
    func setUpView(){
        let factor = view.frame.width/375
        communityTableView.rowHeight = 70*factor
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(communityTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
    }
    
}

class languageCell:UITableViewCell{
    var factor:CGFloat?{
        didSet{
            setupviews()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    lazy var cellView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 13*factor!
        return view
    }()
    
    lazy var logoView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeWidgetColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15*factor!
        return view
    }()
    
    lazy var languageLogoLabel: UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().walletCellcolor()
        label.textAlignment = .center
        label.font = UIFont.boldFont(10*factor!)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFont(14*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted{
//                languageLabel.textColor = isHighlighted ? ThemeColor().themeColor() : UIColor.white
//                cellView.backgroundColor = isHighlighted ? UIColor.white : ThemeColor().walletCellcolor()
//            }
//        }
//    }
    
        override var isSelected: Bool {
            didSet {
                languageLabel.textColor = isSelected ? ThemeColor().themeColor() : UIColor.white
                cellView.backgroundColor = isSelected ? UIColor.white : ThemeColor().walletCellcolor()
            }
        }
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(cellView)
        cellView.addSubview(logoView)
        cellView.addSubview(languageLogoLabel)
        cellView.addSubview(languageLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        NSLayoutConstraint(item: logoView, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        //        NSLayoutConstraint(item: currencyLabel, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: languageLabel, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: languageLogoLabel, attribute: .centerX, relatedBy: .equal, toItem: logoView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: languageLogoLabel, attribute: .centerY, relatedBy: .equal, toItem: logoView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(15*factor!)-[v0(\(30*factor!))]-\(10*factor!)-[v1]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoView,"v1":languageLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoView,"v1":languageLabel]))
    }
}
