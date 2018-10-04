//
//  RankMenuController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 27/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class RankViewController : UIViewController,RankMenuViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // rank menu part
    lazy var rankMenu : RankMenuView = {
        var menu = RankMenuView(menuLabels: [textValue(name: "rankMenuTitle_Weekly"),textValue(name: "rankMenuTitle_Total")])
        menu.customDelegate = self
        return menu
    }()
    
    let rankMenuHeight:CGFloat = 100
    // rank table container
    lazy var rankTableContainer: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        var rtc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        rtc.dataSource = self
        rtc.delegate = self
        rtc.register(UICollectionViewCell.self, forCellWithReuseIdentifier: rankContainerCellID)
        rtc.bounces = false
        rtc.alwaysBounceHorizontal = false
        rtc.showsHorizontalScrollIndicator = false
        rtc.isPagingEnabled = true
        return rtc
    }()
    
    let rankContainerCellID = "RankTableContainerCell"
    
    var weeklyRankTableController = RankTableViewController()
    var totalRankTableController = RankTableViewController()
    
    var rankDataReader = RankDataReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        RankDataReader().getAllRankData()
    }

    func setupView(){
        rankMenu.customDelegate = self
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        
        let factor = view.frame.width/414
        view.addSubview(rankMenu)
        view.addSubview(rankTableContainer)
        rankMenu.matchAllAnchors(top:view.safeArea().topAnchor,leading:view.safeArea().leadingAnchor,trailing:view.safeArea().trailingAnchor,height:CGFloat(rankMenuHeight*factor))
        rankTableContainer.matchAllAnchors(top:rankMenu.bottomAnchor,bottom: view.safeArea().bottomAnchor,leading: view.safeArea().leadingAnchor,trailing:view.safeArea().trailingAnchor)
    }
    
    func rankMenuView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // click to scroll to the view
        let i = NSIndexPath(item: indexPath.row, section: 0)
        rankTableContainer.scrollToItem(at: i as IndexPath, at: .left, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankMenu.cellLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rankContainerCellID, for: indexPath)
        if indexPath.row == 0{
//            cell.backgroundColor = .white
            addChildViewController(childViewControllers: weeklyRankTableController, cell: cell)
        }else{
//            cell.backgroundColor = .brown
            addChildViewController(childViewControllers: totalRankTableController, cell: cell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    class RankDataReader {
        
        var weeklyRankModels = [RankModel]()
        var totalRankModels = [RankModel]()
        var userRankModel : RankModel?
        
        
        func getAllRankData(){
//            var token = UserDefaults.standard.string(forKey: "CertificateToken")
//            var email = UserDefaults.standard.string(forKey: "UserEmail")
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOjEwMDAwMDAyLCJwYXNzd29yZCI6ImY5ZjAwZjM0OTI4OWM1MTFmODA1YTUwNWVhMjRmYjBjMDg5MzM3MmYzNDEzZGJiYjQyNzEwMzEzNTQ1ZWMyOGMiLCJpYXQiOjE1Mzg0NDMwNDF9.BXZCtkdec6aX77w0UpmKB9suj0OxYxtGwWc6z6a0MEQ"
            let email = "test123@test.com"
            let user_id = 1000005
            URLServices.fetchInstance.passServerData(urlParameters: ["game","getRanking"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id]){ (res,success) in
                if success{
                    print("成功啦")
                    // record data in realm
                    var data = JSON(res)["data"]
                    let title = data["title"].string ?? ""
                    let rank_time = Extension.method.convertStringToDate(date: data["rank_time"].string ?? "")
                    let rank_time_string = data["rank_time_string"].string ?? ""
                    let week_number = data["week_number"].int ?? -1
                    // both ranking data
                    let weekly_rank = data["weekly_rank"].array ?? []
                    let total_rank = data["total_rank"].array ?? []
                    //user rank is a single object
                    let user_rank = data["user_rank"] ?? []
                    
                    for obj in weekly_rank{
                        let _id = obj["_id"].string ?? ""
                        let user_id = obj["user_id"].string ?? ""
                        let user_nickname = obj["user_nickname"].string ?? ""
                        let total = obj["total"].float ?? -1
                        let week_percentage = obj["week_percentage"].float ?? -1
                        let week_rank = obj["week_rank"].int ?? -1
                        let total_rank = obj["total_rank"].int ?? -1
                    }
                    
                    for obj in total_rank{
                        let rank = RankModel(obj)
                    }
                    
                    
                    
                } else{
                    print("失败啦")
                }
            }
        }
    }
}
