//
//  ViewController.swift
//  news app for blockchain
//
//  Created by Sheng Li on 12/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class MoreOptionMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var settingTitle: UINavigationBar!
    
//    var sections = [String]() // Two Sections' names
////    var items = [[String]]()
//
    var items:[[String]]? {
        get{
            return [[textValue(name: "aboutUs_cell"),textValue(name: "community_cell")],[textValue(name: "defaultCurrency_cell"),textValue(name: "notification_cell"),textValue(name: "display_cell"),textValue(name: "other_cell"),textValue(name: "language_cell"),textValue(name: "alert_cell")]]
        }
    }
    
    var sections:[String]?{
        get{
            return [textValue(name: "aboutUs_section"),textValue(name: "setting_section")]
        }
    }
    
//    var items = [
//        ["关于Blockchain Global","Blockchain Global社区"], //About us list items
//        ["默认法定货币","应用通知选项","界面显示选项","其他选项","语言设置"] // other app settings
//    ]
    let segueIdentities  = ["aboutUs","bglCommu","defaultCurrency","notifiOption","viewOption","otherOption","defaultLanguage","alertNotification"]

    @IBOutlet weak var tableView00: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = ThemeColor().themeColor()
        settingTitle.topItem?.title = textValue(name: "settingTitle")
        // Do any additional setup after loading the view, typically from a nib.
        tableView00.delegate = self
        tableView00.dataSource = self
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Blockchain Global"
        self.navigationItem.titleView = label
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func changeLanguage(){
        settingTitle.topItem?.title = textValue(name: "settingTitle")
        tableView00.reloadData()
    }
    
    deinit {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections?[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items![section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbCell", for: indexPath)
        cell.textLabel?.text = items![indexPath.section][indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.3294117647, green: 0.7019607843, blue: 0.6901960784, alpha: 0.8015839041)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.8411279966)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secnum = indexPath
        
        // select view segues accoding to indexPath values
        if ((secnum == [0,0]) || (secnum == [0,1])) {
            performSegue(withIdentifier: segueIdentities[indexPath.row], sender: self)
            //print(segueIdentities[indexPath.row])
        } else {
            performSegue(withIdentifier: segueIdentities[(indexPath.row+2)], sender: self)
            //print(segueIdentities[(indexPath.row+2)])
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

