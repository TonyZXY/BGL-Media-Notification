//
//  DefaultCurrencyViewController.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class DefaultCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate{

    @IBOutlet weak var currencyTableView: UITableView!
    
    @IBOutlet weak var currencySearchBar: UISearchBar!
    
    var data = [String]()
    let storeData = ["USD","AUD","CNY","EUR","JPY"]
    let realm = try! Realm()
    var filteredData: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyTableView.dataSource = self
        currencyTableView.delegate = self
        currencySearchBar.delegate = self
        
        data = [textValue(name: "usd_default"),textValue(name: "aud_default"),textValue(name: "rmb_default"),textValue(name: "eur_default"),textValue(name: "jpy_default")]
        filteredData = data
        let label10 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label10.textAlignment = .center
        label10.textColor = UIColor.white
        label10.text = "默认法定货币"
        self.navigationItem.titleView = label10
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyTableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        if storeData[indexPath.row] == priceType{
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
        currencyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = storeData[indexPath.row]
        print(realm.configuration.fileURL ?? "")
        UserDefaults.standard.set(str, forKey: "defaultCurrency")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
        navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
