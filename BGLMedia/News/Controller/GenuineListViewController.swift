//
//  GenuineListViewController.swift
//  BGL-MediaApp
//
//  Created by Xuyang Zheng on 4/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import RealmSwift

class GenuineListViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var position: Int = 0 {
        didSet {
            numberOfItemsToDisplay = 7
            fetchOfflineData()
            fetchData()
        }
    }
    
    weak var homeViewController: NewsHomeViewController?
    
    var numberOfItemsToDisplay: Int = 7
    
    var newsArrayList: Results<Genuine>?
    var videoArrayList: Results<Video>?
    var selectionOtherTwo: [String] = ["原创文章", "原创视频", "百科", "分析"]
    
    lazy var selectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = ThemeColor().themeColor()
        layout.minimumInteritemSpacing = 2
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    lazy var cellListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumLineSpacing = 5
        cv.backgroundColor = ThemeColor().themeColor()
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOfflineData()
        fetchData()
        setupView()
        
        cellListView.register(GenuineCell.self, forCellWithReuseIdentifier: "genuineCell")
        cellListView.register(GenuineSliderViewCell.self, forCellWithReuseIdentifier: "sliderCell")
        selectionView.register(SelectionViewCell.self, forCellWithReuseIdentifier: "selectionCell")
        cellListView.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
        selectionView.reloadData() // REVIEW: no need to call it here as it's loaded on start-Johnny Lin
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        selectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        view.addSubview(line)
        view.addSubview(selectionView)
        view.addSubview(cellListView)
        cellListView.addSubview(self.refresher)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: line)
        view.addConstraintsWithFormat(format: "H:|-5-[v0]|", views: selectionView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: cellListView)
        view.addConstraintsWithFormat(format: "V:|[v0(1)]-5-[v1(30)]", views: line, selectionView)
        
        cellListView.topAnchor.constraint(equalTo: selectionView.bottomAnchor).isActive = true
        cellListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItem: Int
        if collectionView == self.cellListView { // if it the list blow
            if (position != 1) { // if not video list
                if (newsArrayList != nil) { // prevent crash
                    if (newsArrayList?.count)! > numberOfItemsToDisplay { // check the number of the list
                        numberOfItem = numberOfItemsToDisplay + 1
                    } else {
                        numberOfItem = (newsArrayList?.count)! + 1
                    }
                } else {
                    numberOfItem = 0
                }
            } else { // if video list
                if (videoArrayList != nil) { // prevent crash
                    if (videoArrayList?.count)! > numberOfItemsToDisplay { // check number of item in the list
                        numberOfItem = numberOfItemsToDisplay
                    } else {
                        numberOfItem = (videoArrayList?.count)!
                    }
                } else {
                    numberOfItem = 0
                }
            }
        } else { // if it is tabbar
            numberOfItem = 4
        }
        return numberOfItem
    }
    
    
    // items in the collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // if not selection list
        if collectionView == self.cellListView {
            if (position != 1) { // if not video list
                if indexPath.item == 0 { // if slider cell
                    let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! GenuineSliderViewCell
                    cell3.homeViewController = self.homeViewController
                    if (newsArrayList?.count != 0) {
                        cell3.newsArrayList = Array(newsArrayList![0...2])
                    }
                    return cell3
                } else { // other cells
                    let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "genuineCell", for: indexPath) as! GenuineCell
                    if newsArrayList?.count != 0 {
                        cell2.genuine = newsArrayList?[indexPath.item - 1]
                    }
                    return cell2
                }
            } else { // video cells
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
                if videoArrayList?.count != 0 {
                    cell.video = videoArrayList?[indexPath.item]
                }
                return cell
            }
        } else { // selection list
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! SelectionViewCell
            cell1.textLabel.text = selectionOtherTwo[indexPath.item]
            return cell1
        }
    }
    
    // size of every cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        if position == 1 {
            if collectionView == self.cellListView {
                let height = (view.frame.width - 30) * 9 / 16 + 75
                size = CGSize(width: cellListView.frame.width, height: height)
            } else {
                size = CGSize(width: 70, height: selectionView.frame.height)
            }
        } else {
            if collectionView == self.cellListView {
                if indexPath.item == 0 {
                    size = CGSize(width: cellListView.frame.width, height: 250)
                } else {
                    size = CGSize(width: cellListView.frame.width, height: 110)
                }
            } else {
                size = CGSize(width: 70, height: selectionView.frame.height)
            }
        }
        return size
    }
    
    // click actions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == selectionView) {
            position = indexPath.item
        } else {
            if (position == 1) {
                let videoDetailViewController = VideoDetailViewController()
                videoDetailViewController.video = videoArrayList?[indexPath.item]
                homeViewController!.navigationController?.pushViewController(videoDetailViewController, animated: true)
            } else {
                if (indexPath.item != 0) {
                    let genuineDetailViewController = NewsDetailWebViewController()
                    genuineDetailViewController.news = (newsArrayList?[indexPath.item - 1].title, newsArrayList?[indexPath.item - 1].url) as? (title: String, url: String)
                    homeViewController?.navigationController?.pushViewController(genuineDetailViewController, animated: true)
                }
            }
        }
    }
    
    // load more data
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == cellListView {
            if indexPath.item == numberOfItemsToDisplay - 1 && numberOfItemsToDisplay <= (newsArrayList?.count)! {
                numberOfItemsToDisplay += 5
                fetchData(skip: (newsArrayList?.count)!)
            }
        }
    }
    
    // refresh
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refresher.beginRefreshing()
        numberOfItemsToDisplay = 7
        fetchData()
        self.refresher.endRefreshing()
    }
    
    // load data online whit no arguement
    func fetchData() {
        if (position != 1) {
            APIService.shardInstance.fetchGenuineData(contentType: selectionOtherTwo[position], currentNumber: 0) { (gens: Results<Genuine>) in
                self.newsArrayList = gens
                self.cellListView.reloadData()
            }
        } else {
            APIService.shardInstance.fetchVideoData(currentNumber: 0) { (video: Results<Video>) in
                self.videoArrayList = video
                self.cellListView.reloadData()
            }
        }
    }
    
    // load data from database
    func fetchOfflineData() {
        if (position != 1) {
            APIService.shardInstance.fetchGenuineOffline(contentType: selectionOtherTwo[position]) { (gen: Results<Genuine>) in
                self.newsArrayList = gen
                self.cellListView.reloadData()
            }
        } else {
            APIService.shardInstance.fetchVideoOffline { (video: Results<Video>) in
                self.videoArrayList = video
                self.cellListView.reloadData()
            }
        }
    }
    
    // load data when load more data (with arguement)
    func fetchData(skip: Int) {
        if (position != 1) {
            APIService.shardInstance.fetchGenuineData(contentType: selectionOtherTwo[position], currentNumber: skip) { (gens: Results<Genuine>) in
                self.newsArrayList = gens
                self.cellListView.reloadData()
            }
        } else {
            APIService.shardInstance.fetchVideoData(currentNumber: 0) { (video: Results<Video>) in
                self.videoArrayList = video
                self.cellListView.reloadData()
            }
        }
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
