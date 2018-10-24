//
//  RankMenuController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 27/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankViewController : UIViewController,MenuBarViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    let factor = UIScreen.main.bounds.width/375
    // rank menu part
    lazy var rankMenu : MenuBarViewOld = {
        var menu = MenuBarViewOld(menuLabels: [textValue(name: "rankMenuTitle_Weekly"),textValue(name: "rankMenuTitle_Total")])
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
    
    var weeklyRankTableController = WeeklyRankTableViewController()
    var totalRankTableController = TotalRankTableViewController()
    
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
    
        view.addSubview(rankMenu)
        view.addSubview(rankTableContainer)
        rankMenu.matchAllAnchors(top:view.safeArea().topAnchor,leading:view.safeArea().leadingAnchor,trailing:view.safeArea().trailingAnchor,heightConstant:CGFloat(rankMenuHeight*factor))
        rankTableContainer.matchAllAnchors(top:rankMenu.bottomAnchor,bottom: view.safeArea().bottomAnchor,leading: view.safeArea().leadingAnchor,trailing:view.safeArea().trailingAnchor)
    }
    
    func menuBarView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        rankMenu.menuViewCollection.selectItem(at: indexpath as IndexPath, animated: true, scrollPosition:[])
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rankMenu.cellLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rankContainerCellID, for: indexPath)
        if indexPath.row == 0{
//            cell.backgroundColor = .white
            addChildViewController(childViewController: weeklyRankTableController, cell: cell)
        }else{
//            cell.backgroundColor = .brown
            addChildViewController(childViewController: totalRankTableController, cell: cell)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}
