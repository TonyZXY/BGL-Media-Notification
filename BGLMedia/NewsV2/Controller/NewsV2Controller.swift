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
import SafariServices

class NewsV2Controller: UIViewController,UITableViewDataSource,UITableViewDelegate{
    let realm = try! Realm()
    var displayNumber:Int = 0
    var loadMoreData:Bool = false
    var changeLanguageStatus:Bool = false
    var resultNumber: Int = 0
    
    var newsObject:Results<NewsObject>{
        get{
            return realm.objects(NewsObject.self).sorted(byKeyPath: "publishedTime", ascending: false)
        }
    }
    
    var navigationBarItem:String{
        get{
            return textValue(name: "news_newsPage")
        }
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
    //        spinner.startAnimating()
    //        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(60))
    //        self.newsTableView.tableFooterView = spinner
    //        self.newsTableView.tableFooterView?.isHidden = false
    //
    //        let lastItem = displayNumber - 1
    //        if tableView == newsTableView {
    //            if indexPath.row == lastItem && displayNumber <= newsObject.count{
    //                print(displayNumber)
    //                if displayNumber != 0{
    //                    self.displayNumber += 5
    //                    getData(skip: displayNumber, limit: 5){ success in
    //                        if success{
    //                            DispatchQueue.main.async {
    //                                self.newsTableView.reloadData()
    //                                //                            self.refresher.endRefreshing()
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //            if displayNumber >= newsObject.count {
    //                spinner.stopAnimating()
    //            }
    //        }
    
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
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.newsTableView.switchRefreshFooter(to: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        newsTableView.switchRefreshFooter(to: .removed)
        
        //        DispatchQueue.main.async(execute: {
        //            self.newsTableView.beginHeaderRefreshing()
        //        })
        
        self.newsTableView.switchRefreshHeader(to: .refreshing)
        
        self.displayNumber += 20
        getData(skip:0,limit: 20){ success in
            if success{
                self.newsTableView.reloadData()
                let footer = DefaultRefreshFooter.footer()
                footer.textLabel.textColor = ThemeColor().whiteColor()
                footer.tintColor = ThemeColor().whiteColor()
                footer.textLabel.backgroundColor = ThemeColor().themeColor()
                self.newsTableView.configRefreshFooter(with: footer, container: self, action: {
                    self.handleFooter()
                })
                
            } else {
                self.newsTableView.reloadData()
                let footer = DefaultRefreshFooter.footer()
                footer.textLabel.textColor = ThemeColor().whiteColor()
                footer.tintColor = ThemeColor().whiteColor()
                footer.textLabel.backgroundColor = ThemeColor().themeColor()
                self.newsTableView.configRefreshFooter(with: footer, container: self, action: {
                    self.handleFooter()
                })
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if changeLanguageStatus{
            self.newsTableView.switchRefreshHeader(to: .removed)
            newsTableView.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
                self.handleRefresh(self.newsTableView)
                self.changeLanguageStatus = false
            })
            newsTableView.switchRefreshHeader(to: .refreshing)
        }
    }
    
    @objc func changeLanguage(){
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        changeLanguageStatus = true
        //        addRefreshHeader(){success in
        //            if success{
        //                let header = DefaultRefreshHeader.header()
        //                header.textLabel.textColor = ThemeColor().whiteColor()
        //                header.textLabel.font = UIFont.regularFont(12)
        //                header.tintColor = ThemeColor().whiteColor()
        //                header.imageRenderingWithTintColor = true
        //                self.newsTableView.configRefreshHeader(with:header, container: self, action: {
        //                    self.handleRefresh(self.newsTableView)
        //                })
        //                //                        DispatchQueue.main.async(execute: {
        //                self.newsTableView.beginHeaderRefreshing()
        //                //                        })
        //            }
        //        }
    }
    
    func addRefreshHeader(completion:@escaping (Bool)->Void){
        
        //            self.newsTableView.switchRefreshHeader(to: .removed)
        completion(true)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsTableViewCell
        if indexPath.row <= displayNumber{
            let width = self.view.frame.width
            cell.width = width
            let object = newsObject[indexPath.row]
            cell.news = object
            return cell
        } else{
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = newsObject[indexPath.row]
        
        let urlString = object.url
        if let url = URL(string: urlString!) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            self.present(vc, animated: true, completion: nil)
            //            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getData(skip:Int,limit:Int,completion: @escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["api","getNewsContentOnly?languageTag=EN&skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
            if pass{
                self.resultNumber = res.count
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
                let author = result["author"].string ?? ""
                let localeTag = result["localeTag"].string ?? ""
                let lanugageTag = result["languageTag"].string ?? ""
                let source = result["source"].string ?? ""
                let contentTagResult = result["contentTag"].array ?? [""]
                let contentTag = List<String>()
                for result in contentTagResult{
                    contentTag.append(result.string!)
                }
                
                if id != "0" {
                    if self.realm.object(ofType: NewsObject.self, forPrimaryKey: id) == nil {
                        self.realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, lanugageTag,source,contentTag])
                    } else {
                        self.realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag,lanugageTag,source,contentTag], update: true)
                    }
                }
            }
            try! self.realm.commitWrite()
            completion(true)
        }
    }
    
    @objc func handleRefresh(_ tableView: UITableView) {
        getData(skip: 0, limit: 20){ sccuess in
            if sccuess{
                self.displayNumber = 20
                self.newsTableView.reloadData()
                tableView.switchRefreshHeader(to: .normal(.success, 0.5))
                print("999888777666666666666")
                //                self.refresher.endRefreshing()
            } else{
                tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
                //                self.refresher.endRefreshing()
            }
        }
    }
    
    func setUpView(){
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(newsTableView)
        //        newsTableView.addSubview(refresher)
        //        view.addSubview(spinner)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsTableView]))
        //
        //        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        //
        //        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    
    lazy var newsTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.separatorStyle = .none
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        tableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(tableView)
        })
        let footer = DefaultRefreshFooter.footer()
        footer.textLabel.textColor = ThemeColor().whiteColor()
        footer.tintColor = ThemeColor().whiteColor()
        footer.textLabel.backgroundColor = ThemeColor().themeColor()
        tableView.configRefreshFooter(with: footer, container: self, action: {
            self.handleFooter()
        })
        tableView.rowHeight = 120 * self.view.frame.width/414
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "News"
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    func handleFooter(){
        if displayNumber <= newsObject.count{
            print(displayNumber)
            if displayNumber != 0{
                self.displayNumber += 20
                getData(skip: displayNumber-20, limit: 20){ success in
                    if success{
                        self.newsTableView.reloadData()
                        self.newsTableView.switchRefreshFooter(to: .normal)
                        //                            self.refresher.endRefreshing()
                    }
                }
            }
        }
        print("Already get: \(resultNumber)")
        if self.displayNumber >= self.newsObject.count {
            self.newsTableView.switchRefreshFooter(to: .normal)
            
        }
        if resultNumber < 20 {
            self.newsTableView.switchRefreshFooter(to: .noMoreData)
        }
        
    }
    
    
    
    //    lazy var refresher: UIRefreshControl = {
    //            let refreshControl = UIRefreshControl()
    ////            refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
    ////            refreshControl.tintColor = UIColor.white
    //            return refreshControl
    //    }()
}

