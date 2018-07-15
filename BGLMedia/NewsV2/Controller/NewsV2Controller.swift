//
//  NewsV2Controller.swift
//  BGLMedia
//
//  Created by Bruce Feng on 9/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class NewsV2Controller: UIViewController,UITableViewDataSource,UITableViewDelegate{
    let realm = try! Realm()
    var skip:Int = 0
    var limit:Int = 5
    var numberOfItemsToDisplay:Int=5
    var displayNumber:Int = 0
    var loadMoreData:Bool = false
    
    var newsObject:Results<NewsObject>{
        get{
            return realm.objects(NewsObject.self).sorted(byKeyPath: "publishedTime", ascending: false)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(60))
        self.newsTableView.tableFooterView = spinner
        self.newsTableView.tableFooterView?.isHidden = false
        
        let lastItem = displayNumber - 1
        if tableView == newsTableView {
        if indexPath.row == lastItem && displayNumber <= newsObject.count{
            print(displayNumber)
                if displayNumber != 0{
                    
                    getData(skip: displayNumber, limit: 5){ success in
                        if success{
                            DispatchQueue.main.async {
                                self.displayNumber += 5
                                self.newsTableView.reloadData()
                                //                            self.refresher.endRefreshing()
                            }
                        }
                    }
                }
            
            }
            
            if displayNumber >= newsObject.count {
                spinner.stopAnimating()
            }
        }
        
//        newsTableView.visibleCells
        
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.5) {
//            cell.alpha = 1.0
//            cell.layer.transform = CATransform3DIdentity
//        }
        
//        cell.alpha = 0
//        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
//        cell.layer.transform = transform
//        UIView.animate(withDuration: 1.0) {
//            cell.alpha = 1.0
//            cell.layer.transform = CATransform3DIdentity
//        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        spinner.stopAnimating()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getData(skip:0,limit: 5){ success in
            if success{
                self.displayNumber += 5
                self.newsTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        print(realm.objects(NewsObject.self).count)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsObject.count != 0{
            if newsObject.count > displayNumber {
                return displayNumber
            } else {
                return newsObject.count
            }
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsDetailTableViewCell
        if indexPath.row <= displayNumber{
            let object = newsObject[indexPath.row]
            cell.news = object
            return cell
        } else{
            return cell
        }
    }

    func getData(skip:Int,limit:Int,completion: @escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["api","getNewsContentOnly?languageTag=EN&skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
            if pass{
                self.storeDataToRealm(res:res){success in
                    if success{
                       completion(true)
                    }
                }
            } else{
                completion(false)
//                DispatchQueue.main.async {
//                self.displayNumber = 5
//                self.newsTableView.reloadData()
//                self.refresher.endRefreshing()
//                }
            }
        }
    }
    
    func storeDataToRealm(res:JSON,completion:@escaping (Bool)->Void){
        self.realm.beginWrite()
        if let collection = res.array{
            for result in collection{
                let id = result["_id"].string ?? "0"
                let title = result["title"].string ?? ""
                let newsDescription = result["newsDescription"].string ?? ""
                let imageURL = result["imageURL"].string ?? ""
                let url = result["url"].string ?? ""
                let publishedTime = Extension.method.convertStringToDate(date: result["publishedTime"].string ?? "")
                let author = result["author"].string!
                let localeTag = result["localeTag"].string!
                let lanugageTag = result["languageTag"].string!
                let contentTagResult = result["contentTag"].array!
                let contentTag = List<String>()
                for result in contentTagResult{
                    contentTag.append(result.string!)
                }
                
                if id != "0" {
                    if self.realm.object(ofType: NewsObject.self, forPrimaryKey: id) == nil {
                        self.realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, lanugageTag,contentTag])
                    } else {
                        self.realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag,lanugageTag,contentTag], update: true)
                    }
                }
            }
            try! self.realm.commitWrite()
            completion(true)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getData(skip: 0, limit: 5){ sccuess in
            if sccuess{
                self.displayNumber = 5
                self.newsTableView.reloadData()
                self.refresher.endRefreshing()
            } else{
                self.refresher.endRefreshing()
            }
        }
    }
    
    func setUpView(){
        navigationItem.titleView = titleLabel
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(newsTableView)
        newsTableView.addSubview(refresher)
//        view.addSubview(spinner)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsTableView]))
//
//        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }

    lazy var newsTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsDetailTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
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
    
    var spinner:UIActivityIndicatorView{
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }
    
    lazy var refresher: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
            refreshControl.tintColor = UIColor.white
            return refreshControl
    }()
}
