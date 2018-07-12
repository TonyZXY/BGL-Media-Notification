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
    var limit:Int = 10
    var numberOfItemsToDisplay:Int=10
    var numberOfItemsToDisplays:Int{
        get{
            return realm.objects(NewsObject.self).count
        }
    }
    
    var newsObjects:Results<NewsObject>{
        get{
            return realm.objects(NewsObject.self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastItem = numberOfItemsToDisplay - 1
        
            if indexPath.row == lastItem {
                print("refresh")
//                 getData(skip: skip, limit: limit)
            }
 
        
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
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
    
    var newsObject:Results<NewsObject>{
        get{
            return realm.objects(NewsObject.self).sorted(byKeyPath: "_id", ascending: true)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        numberOfItemsToDisplay = realm.objects(NewsObject.self).count
        getData(skip:0,limit: 10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 15
        return newsObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsDetailTableViewCell
        let object = newsObject[indexPath.row]
        cell.news = object
        return cell
    }

    func getData(skip:Int,limit:Int){
        URLServices.fetchInstance.passServerData(urlParameters: ["api","getNewsContentOnly?languageTag=EN&Skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
            if pass{
                self.storeDataToRealm(res:res){success in
                    if success{
//                        self.skip += 10
//                        self.numberOfItemsToDisplay += 10
                        DispatchQueue.main.async {
                            self.newsTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func storeDataToRealm(res:JSON,completion:@escaping (Bool)->Void){
        self.realm.beginWrite()
        if let collection = res.array{
            for result in collection{
                let id = result["_id"].string!
                let title = result["title"].string!
                let newsDescription = result["newsDescription"].string!
                let imageURL = result["imageURL"].string!
                let url = result["url"].string!
                let publishedTime = result["publishedTime"].string!.timeFormatter()
                let author = result["author"].string!
                let localeTag = result["localeTag"].string!
                let contentTag = result["contentTag"].string!
                let lanugageTag = result["languageTag"].string!
                
                if self.realm.object(ofType: NewsObject.self, forPrimaryKey: id) == nil {
                    self.realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, contentTag, lanugageTag])
                } else {
                    self.realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, contentTag,lanugageTag], update: true)
                }
            }
            try! self.realm.commitWrite()
            completion(true)
        }
    }
    
    func setUpView(){
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
    
    
}
