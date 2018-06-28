//
//  DefaultCurrencyViewController.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class DefaultLanguageController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{
    

    @IBOutlet weak var languageTableView: UITableView!
    
    @IBOutlet weak var languageSearchBar: UISearchBar!
    
    var storeData = ["CN","EN"]
    var data = [String]()
    let realm = try! Realm()
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = [textValue(name: "chinese_language"),textValue(name: "english_language")]
        // Do any additional setup after loading the view.
        languageTableView.dataSource = self
        languageTableView.delegate = self
        languageSearchBar.delegate = self
        filteredData = data
        let label10 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label10.textAlignment = .center
        label10.textColor = UIColor.white
        label10.text = "语言"
        self.navigationItem.titleView = label10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageTableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        if storeData[indexPath.row] == defaultLanguage{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        cell.textLabel?.textColor = #colorLiteral(red: 0.3294117647, green: 0.7019607843, blue: 0.6901960784, alpha: 0.8015839041)
        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        languageTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = storeData[indexPath.row]
        print(realm.configuration.fileURL ?? "")
        
        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "alertTitle_language"), comment: ""), message: NSLocalizedString(textValue(name: "alertHint_language"), comment: ""), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertChange_language"), comment: ""), style: .destructive) { (_) in
            UserDefaults.standard.set(str, forKey: "defaultLanguage")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        confirmAlertCtrl.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "alertCancel_language"), comment: ""), style: .cancel, handler:nil)
        confirmAlertCtrl.addAction(cancelAction)
        self.present(confirmAlertCtrl, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
