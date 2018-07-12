//
//  webmainViewController.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import SafariServices

class WebMainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var webTableView: UITableView!
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        data = [textValue(name: "weibo_community"),textValue(name: "wechat_community"),textValue(name: "twitter_community"),textValue(name: "facebook_community"),textValue(name: "youtube_community")]
        webTableView.dataSource = self
        webTableView.delegate = self
        let label01 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label01.textAlignment = .center
        label01.textColor = UIColor.white
        label01.text = textValue(name: "bgl_community")
        self.navigationItem.titleView = label01

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = "https://www.google.com"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
//            vc.delegate = self as! SFSafariViewControllerDelegate
            navigationController?.pushViewController(vc, animated: true)
//            present(vc, animated: true)
        }
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let indexPath = webTableView.indexPathForSelectedRow
//        let str = indexPath!.row
//        let vc = segue.destination as? WebDetailViewController
//        vc?.str = str
//
//    }


}
