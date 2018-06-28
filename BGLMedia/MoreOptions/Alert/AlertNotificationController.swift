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
    var cellItems:[String]{
        get{
            return [textValue(name: "flashNews_alert"),textValue(name: "price_alert"),textValue(name: "edit_alert")]
        }
    }
    
    var switchStatusItem:[String] = ["Flash","Currency","Edit"]
    
    var SwitchOption:[Bool]{
        get{
            return [UserDefaults.standard.value(forKey: "flashSwitch") as! Bool,UserDefaults.standard.value(forKey: "priceSwitch") as! Bool]
        }
    }
    
    var switchLabel = ["flashSwitch","priceSwitch"]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
            cell.backgroundColor = ThemeColor().themeColor()
            cell.textLabel?.text = cellItems[indexPath.row]
            cell.accessibilityHint = switchStatusItem[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            let swithButton = UISwitch()
            swithButton.isOn = SwitchOption[indexPath.row]
            cell.accessoryView = swithButton
            swithButton.tag = indexPath.row
            swithButton.addTarget(self, action: #selector(switchIsInAction(sender:)), for: .valueChanged)
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "editCurrency", for: indexPath)
            cell.backgroundColor = ThemeColor().themeColor()
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = cellItems[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            cell.isHidden = true
            if SwitchOption[1] == true{
                cell.isHidden = false
            }
            return cell
        }
    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
//        if cell.accessibilityHint == "Edit"{
//            let alert = AlertController()
//            navigationController?.pushViewController(alert, animated: true)
//        }
        if indexPath.row == 2{
            let alert = AlertController()
            navigationController?.pushViewController(alert, animated: true)
        }
//        if indexPath.row == 0{
//            let cell:SwitchTableViewCell = tableView.cellForRow(at: indexPath) as! SwitchTableViewCell
//            if cell.swithButton.isOn == true{
//                UserDefaults.standard.set(true, forKey: "flashSwitch")
//                print("sfsf")
//            } else{
//                UserDefaults.standard.set(false, forKey: "flashSwitch")
//            }
//        } else if indexPath.row == 1 {
//            let cell:SwitchTableViewCell = tableView.cellForRow(at: indexPath) as! SwitchTableViewCell
//            if cell.swithButton.isOn{
//                UserDefaults.standard.set(true, forKey: "priceSwitch")
//            } else{
//                UserDefaults.standard.set(false, forKey: "priceSwitch")
//            }
//        }
//        notificationTableView.reloadData()
//        notificationTableView.deselectRow(at: indexPath, animated: true)
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
        view.addSubview(notificationTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notificationTableView]))
    }
    
    lazy var notificationTableView:UITableView = {
       var tableView = UITableView()
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "notification")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "editCurrency")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    

    
    
    class SwitchTableViewCell:UITableViewCell{
        
//        var object:switchObject?{
//            didSet{
//                if self.object?.type == "Flash"{
//                    if self.object?.switchStatus == true{
////                        swithButton.isOn = true
//                        UserDefaults.standard.set(true, forKey: "flashSwitch")
//                    } else{
//                        swithButton.isOn = false
//                        UserDefaults.standard.set(false, forKey: "flashSwitch")
//                    }
//                } else if self.object?.type == "Currency"{
//                    if self.object?.switchStatus == true{
////                        swithButton.isOn = true
//                        UserDefaults.standard.set(true, forKey: "priceSwitch")
//                    } else{
////                        swithButton.isOn = false
//                        UserDefaults.standard.set(false, forKey: "priceSwitch")
//                    }
//                }
//            }
//        }
        
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setUpView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init has not been completed")
        }
        
        func setUpView(){
            self.backgroundColor = ThemeColor().themeColor()
//            self.addSubview(swithButton)
//            self.addSubview(notifiLabel)
            self.selectionStyle = .none
//            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":notifiLabel]))
//            NSLayoutConstraint(item: notifiLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
            
//            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":swithButton]))
//            NSLayoutConstraint(item: swithButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        }
        
//        var swithButton:UISwitch = {
//            var switchButton = UISwitch()
//            switchButton.isOn = false
//            switchButton.thumbTintColor = UIColor.red
//            switchButton.tintColor = UIColor.green
//            switchButton.onTintColor = ThemeColor().bglColor()
//            switchButton.translatesAutoresizingMaskIntoConstraints = false
//            return switchButton
//        }()
        
//        var notifiLabel:UILabel = {
//            var label = UILabel()
//            label.textColor = UIColor.white
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
    }

}
