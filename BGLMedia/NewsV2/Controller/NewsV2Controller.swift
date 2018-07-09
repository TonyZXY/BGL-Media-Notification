//
//  NewsV2Controller.swift
//  BGLMedia
//
//  Created by Bruce Feng on 9/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class NewsV2Controller: UIViewController,UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsDetailTableViewCell
        cell.newsTitle.text = "hajajfs"
        cell.newsDescription.text = "sdfdssfsdfdsfdsfdsfdsfsdfdsfdsfsfsfdfdsfdsfdfdfdsfsfsdfsdfsdfdsfdfsdfsffdfsdfsdf"
        cell.newsAuthor.text = "Mike"
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         cell.alpha = 0
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
        
//        cell.alpha = 0
//        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
//        cell.layer.transform = transform
//        UIView.animate(withDuration: 1.0) {
//            cell.alpha = 1.0
//            cell.layer.transform = CATransform3DIdentity
//        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getData()
        // Do any additional setup after loading the view.
    }

    func getData(){
//        passServerData(urlParameters: ["api","getNewsContentOnly?languageTag=EN&Skip=0&limit=10"], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
//            if pass{
//                for value in res{
//                    let news = NewsObject()
//                    news._id = value["_id"].string!
//                    
//                }
//                
//                
//                
//                print(res)
//            }
//        }
    }
    
    func setUpView(){
        navigationController?.navigationBar.barTintColor = ThemeColor().themeColor()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.titleView = titleLabel
        
        
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(newsTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsTableView]))
    }

    lazy var newsTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsDetailTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "News"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    
}
