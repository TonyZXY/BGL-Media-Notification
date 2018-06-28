//
//  AlertController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 21/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

struct alertResult{
    var isExpanded:Bool = true
    var coinName:String = ""
    var coinAbbName:String = ""
    var name:[alertObject] = [alertObject]()
}

class AlertController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var realm = try! Realm()
    var alerts:[alertResult] = [alertResult]()
    var allAlert:[alertResult]{
        get{
            var allResult = [alertResult]()
            let results = realm.objects(alertObject.self)
            let coinNameResults = realm.objects(alertCoinNames.self)
            for value in coinNameResults{
                var alertResults = alertResult()
                let speCoin = results.filter("coinName = '" + value.coinName + "' ")
                alertResults.isExpanded = true
                alertResults.coinName = value.coinName
                for data in speCoin{
                    alertResults.name.append(data)
                }
                allResult.append(alertResults)
            }
            return allResult
        }
    }
    
    
    
    var twoDimension = [ExpandableNames(isExpanded: true, name: ["ds"]),ExpandableNames(isExpanded: true, name: ["sdf","sfsdfsf"])]
    
    var showIndexPaths = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        alerts = allAlert
        NotificationCenter.default.addObserver(self, selector: #selector(addAlerts), name: NSNotification.Name(rawValue: "addAlert"), object: nil)
        // Do any additional setup after loading the view.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addAlert"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    @objc func addAlerts(){
        alertTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let coinImage = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        coinImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        coinImage.clipsToBounds = true
        coinImage.coinImageSetter(coinName: alerts[section].name[0].coinAbbName, width: 30, height: 30, fontSize: 5)
        coinImage.contentMode = UIViewContentMode.scaleAspectFit
        coinImage.translatesAutoresizingMaskIntoConstraints = false
        
        let coinLabel = UILabel()
        coinLabel.translatesAutoresizingMaskIntoConstraints = false
        coinLabel.text = alerts[section].coinName
        
        
        //        let myTextField = UITextField()
        //        let bottomLine = CALayer()
        //        bottomLine.frame = CGRect(x: 0.0, y: myTextField.frame.height - 1, width: myTextField.frame.width, height: 1.0)
        //        bottomLine.backgroundColor = UIColor.white.cgColor
        //        myTextField.borderStyle = UITextBorderStyle.none
        //        myTextField.layer.addSublayer(bottomLine)
        
        let button = UIButton(type:.system)
        button.setTitle("Close", for: .normal)
        //        button.backgroundColor = ThemeColor().bglColor()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        
        
        let sectionView = UIView()
        sectionView.clipsToBounds = true
        sectionView.addSubview(button)
        sectionView.addSubview(coinImage)
        sectionView.addSubview(coinLabel)
        sectionView.backgroundColor = ThemeColor().bglColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        //        views.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
        sectionView.layer.borderWidth = 1
        
        NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinImage, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: coinLabel, attribute: .centerY, relatedBy: .equal, toItem: sectionView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinLabel,"v1":coinImage]))
        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":button]))
        
        return sectionView
    }
    
    @objc func handleExpandClose(button:UIButton ){
        let section = button.tag
        var indexPaths = [IndexPath]()
        for row in alerts[section].name.indices{
            let indexPath = IndexPath(row:row,section:section)
            indexPaths.append(indexPath)
        }
        let isExpanded = alerts[section].isExpanded
        alerts[section].isExpanded = !isExpanded
        
        
        button.setTitle(isExpanded ? "Open":"Close", for: .normal)
        
        if !isExpanded{
            alertTableView.insertRows(at: indexPaths, with: .fade)
        } else{
            alertTableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !alerts[section].isExpanded{
            return 0
        }
        return alerts[section].name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editAlertCell", for: indexPath) as! AlertTableViewCell
        //        let name = twoDimension[indexPath.section].name[indexPath.row]
      
        let object = alerts[indexPath.section].name[indexPath.row]
        var compare:String = ""
        if object.status == true{
            compare = ">"
        }else if object.status == false{
            compare = "<"
        } else {
            compare = "="
        }
        
        let compareLabel = "1 " + object.coinAbbName + " " + compare + " " + String(object.compare)
        let coinDetail = object.exchangName + " - " + object.coinAbbName + "/" + object.tradingPairs
        let dateToString = DateFormatter()
        dateToString.dateFormat = "EEEE, dd MMMM yyyy HH:mm"
        dateToString.locale = Locale(identifier: "en_AU")
        let timess = dateToString.string(from: object.dateTime)
        cell.dateLabel.text = timess
        cell.compareLabel.text = compareLabel
        cell.coinDetailLabel.text = coinDetail
        return cell
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().themeColor()
        
        let addButton = UIButton()
        addButton.setTitle("➕", for: .normal)
        addButton.titleLabel?.font = addButton.titleLabel?.font.withSize(25)
        addButton.backgroundColor = UIColor.white
        addButton.layer.cornerRadius = 25
        addButton.addTarget(self, action: #selector(addAlert), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(alertTableView)
        alertTableView.addSubview(addButton)
         view.addSubview(alertButton)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-3-[v0(80)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertButton,"v1":alertTableView]))

//        NSLayoutConstraint(item: addButton, attribute: .top, relatedBy: .equal, toItem: alertTableView, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: addButton, attribute: .trailing, relatedBy: .equal, toItem: alertTableView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
//
        
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(50)]-100-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":addButton,"v1":alertTableView]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-50-[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":addButton,"v1":alertTableView]))
        
        NSLayoutConstraint(item: addButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: addButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: addButton, attribute: .centerX, relatedBy: .equal, toItem: alertTableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addButton, attribute: .centerY, relatedBy: .equal, toItem: alertTableView, attribute: .centerY, multiplier: 1, constant: 150).isActive = true

    }
    
    @objc func addAlert(){
        let addAlert = AlertManageController()
        navigationController?.pushViewController(addAlert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var alertTableView:UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: "editAlertCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var alertButton:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(textValue(name: "addAlert_alert"), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = ThemeColor().bglColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addNewAlert), for: .touchUpInside)
        return button
    }()
    
    @objc func addNewAlert(){
        let alert = AlertManageController()
        navigationController?.pushViewController(alert, animated: true)
    }
    
}
