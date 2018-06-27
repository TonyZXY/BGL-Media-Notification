//
//  webmainViewController.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class WebMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var webTableView: UITableView!
    let data = ["Weibo","Wechat","Twitter","Facebook","Youtube"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        webTableView.dataSource = self
        webTableView.delegate = self
        let label01 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label01.textAlignment = .center
        label01.textColor = UIColor.white
        label01.text = "Blockchain Global社区"
        self.navigationItem.titleView = label01

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = webTableView.dequeueReusableCell(withIdentifier: "webtbCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.3294117647, green: 0.7019607843, blue: 0.6901960784, alpha: 0.8015839041)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 0.8411279966)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = webTableView.indexPathForSelectedRow
        let str = data[indexPath!.row]
        let vc = segue.destination as? WebDetailViewController
        vc?.str = str

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
