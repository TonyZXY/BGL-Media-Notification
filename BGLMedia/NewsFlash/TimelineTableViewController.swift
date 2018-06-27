//
//  TimelineTableViewController.swift
//  news app for blockchain
//
//  Created by Sheng Li on 23/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class TimelineTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        
        //Prevent empty rows
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = ThemeColor().themeColor()
        self.tableView.separatorStyle = .none
        
        self.tableView.addSubview(self.refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNews()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        
        let object = results[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
        
        let bglGreen = #colorLiteral(red: 0.5019607843, green: 0.8588235294, blue: 0.7176470588, alpha: 1)
        cell.timelinePoint = TimelinePoint(diameter: CGFloat(16.0), color: bglGreen, filled: false)
        cell.timelinePointInside = TimelinePoint(diameter: CGFloat(4.0), color: bglGreen, filled: true, insidePoint: true)
        cell.timeline.backColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        cell.titleLabel.text = dateFormatter.string(from: object.dateTime)
        cell.descriptionLabel.text = object.contents
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
    }
    
    private func getNews() {
        Alamofire.request("http://10.10.6.111:3000/api/flash", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.JSONtoData(json: json)
                DispatchQueue.main.async {
                    self.cleanOldNewsFlash()
                    self.results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func JSONtoData(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        realm.beginWrite()
        if let collection = json.array {
            for item in collection {
                let date = dateFormatter.date(from: item["publishedTime"].string!)
                let id = "\(item["_id"].string!)"
                if realm.object(ofType: NewsFlash.self, forPrimaryKey: id) == nil {
                    realm.create(NewsFlash.self, value: [id, date!, item["shortMassage"].string!])
                } else {
                    realm.create(NewsFlash.self, value: [id, date!, item["shortMassage"].string!], update: true)
                }
            }
        }
        try! realm.commitWrite()
    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    func cleanOldNewsFlash() {
//        let oneWeekBefore = Date.init(timeIntervalSinceNow: -(86400*7))
//        let oldObjects = realm.objects(NewsFlash.self).filter("dateTime < %@", oneWeekBefore)
//
//        try! realm.write {
//            realm.delete(oldObjects)
//        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getNews()
        self.refresher.endRefreshing()
    }
}
