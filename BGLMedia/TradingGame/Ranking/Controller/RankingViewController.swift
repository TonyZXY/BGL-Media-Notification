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
    
    let rankMenuHeight:CGFloat = 70
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
        rankDataReader.getAllRankData(completion: {(success) in
            if success {
                // got data and update ui in main thread
                DispatchQueue.main.async {
                    self.weeklyRankTableController.userRank = self.rankDataReader.getUserWeeklyViewModel()
                    self.totalRankTableController.userRank = self.rankDataReader.getUserTotalViewModel()
                    self.weeklyRankTableController.allRank = self.rankDataReader.getWeeklyViewModels()
                    self.totalRankTableController.allRank = self.rankDataReader.getTotalViewModels()
//                    print(self.rankDataReader.rankInfoModel)
//                    print(self.rankDataReader.weeklyRankModels.count)
//                    print(self.rankDataReader.totalRankModels.count)
//                    print(self.rankDataReader.userRankModel)
                }
            }else{
                // data getting failed
            }
            
        })
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        rankMenu.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(rankMenu.cellLabels.count)
    }
    
    func  scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexpath = NSIndexPath(item: Int(index), section: 0)
        rankMenu.menuView.selectItem(at: indexpath as IndexPath, animated: true, scrollPosition:[])
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
    
    /**
        responsible for getting all rankdata into dataModel and also responsible to covert dataModel to viewModel
     */
    class RankDataReader {
        var rankInfoModel = RankDetailModel()
        var weeklyRankModels = [RankObjectModel]()
        var totalRankModels = [RankObjectModel]()
        var userRankModel = RankObjectModel()
        
        
        func getAllRankData(completion: @escaping (Bool) -> (Void)){
            //            var token = UserDefaults.standard.string(forKey: "CertificateToken")
            //            var email = UserDefaults.standard.string(forKey: "UserEmail")
            let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOjEwMDAwMDAyLCJwYXNzd29yZCI6ImY5ZjAwZjM0OTI4OWM1MTFmODA1YTUwNWVhMjRmYjBjMDg5MzM3MmYzNDEzZGJiYjQyNzEwMzEzNTQ1ZWMyOGMiLCJpYXQiOjE1Mzg0NDMwNDF9.BXZCtkdec6aX77w0UpmKB9suj0OxYxtGwWc6z6a0MEQ"
            let email = "test123@test.com"
            let user_id = 1000005
            URLServices.fetchInstance.passServerData(urlParameters: ["game","getRanking"], httpMethod: "POST", parameters: ["token": token,"email": email,"user_id": user_id]){ (res,success) in
                if success{
                    print("成功啦")
                    self.clearAllData()
                    // store data
                    var data = JSON(res)["data"]
                    self.rankInfoModel = RankDetailModel(data)
//                    print(data)
                    // both ranking data are array
                    let weekly_rank = data["weekly_rank"].array ?? []
                    let total_rank = data["total_rank"].array ?? []
                    //user rank is a single object
                    let user_rank = data["user_rank"]
                    self.userRankModel = RankObjectModel(user_rank)
                    
                    for obj in weekly_rank{
                        let rank = RankObjectModel(obj)
                        self.weeklyRankModels.append(rank)
                    }
                    
                    for obj in total_rank{
                        let rank = RankObjectModel(obj)
//                        print(rank.total)
                        self.totalRankModels.append(rank)
                    }
                    
                    completion(true)
                    
                } else{
                    print("失败啦")
                    completion(false)
                }
            }
        }
        
        func clearAllData(){
            self.rankInfoModel = RankDetailModel()
            self.weeklyRankModels.removeAll()
            self.totalRankModels.removeAll()
            self.userRankModel = RankObjectModel()
        }
        // function that returns the viewmodels we want to display
        func convertToViewModels(rankModels: [RankObjectModel], displayMode: RankObjectViewModel.DisplayMode)->[RankObjectViewModel]{
            var viewModels = [RankObjectViewModel]()
            for rankModel in rankModels{
                viewModels.append(RankObjectViewModel(rankModel, displayMode: displayMode))
            }
            return viewModels
        }
        
        func getWeeklyViewModels()->[RankObjectViewModel]{
            return self.convertToViewModels(rankModels: weeklyRankModels, displayMode: RankObjectViewModel.DisplayMode.weekly)
        }
        
        func getTotalViewModels()->[RankObjectViewModel]{
            return self.convertToViewModels(rankModels: totalRankModels, displayMode: RankObjectViewModel.DisplayMode.total)
        }
        
        func getUserWeeklyViewModel()->RankObjectViewModel{
            return RankObjectViewModel(userRankModel, displayMode: RankObjectViewModel.DisplayMode.weekly)
        }
        
        func getUserTotalViewModel()->RankObjectViewModel{
            return RankObjectViewModel(userRankModel, displayMode: RankObjectViewModel.DisplayMode.total)
        }
    }
}
