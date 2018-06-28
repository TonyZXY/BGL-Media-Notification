//
//  OtherDetailViewController.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift

class OtherDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var otherDTableView: UITableView!
    
    let data = ["我的钱包","收藏列表","市场行情","快讯","新闻"]
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        otherDTableView.dataSource = self
        otherDTableView.delegate = self
        let label130 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label130.textAlignment = .center
        label130.textColor = UIColor.white
        label130.text = "启动时默认显示页面"
        self.navigationItem.titleView = label130
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = otherDTableView.dequeueReusableCell(withIdentifier: "otherDCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.3294117647, green: 0.7019607843, blue: 0.6901960784, alpha: 0.8015839041)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str1 = data[indexPath.row]
        print(realm.configuration.fileURL ?? "")
        
        let newDisplayPage = defDisplayOpt()
        newDisplayPage.displayId = "defDisplayId00"
        newDisplayPage.defDisplayPage = str1
        try! realm.write {
            realm.add(newDisplayPage, update:true)
        }
        
        navigationController?.popToRootViewController(animated: true)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
