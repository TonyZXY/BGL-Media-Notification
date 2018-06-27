////
////  GeunineListViewCell.swift
////  news app for blockchain
////
////  Created by Xuyang Zheng on 8/5/18.
////  Copyright © 2018 Sheng Li. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class GenuineListViewCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    // this var represent the tabbar at the top, change by set the position into other value, and will set content at same time
//    var position: Int = 0 {
//        didSet {
//            numberOfItemsToDisplay = 7
//            fetchOfflineData()
//            fetchData()
//        }
//    }
//    // This int represent the position of Selection Bar -- Use to distingush VIDEO cell with NEWS CELL
//
//
//    weak var homeViewController: NewsHomeViewController?
//
//    //current to be 7, display 7 items when page launch
//    var numberOfItemsToDisplay: Int = 7
//
//    // the list that contain the data which used in this page
//    var newsArrayList: Results<Genuine>?
//    var videoArrayList: Results<Video>?
//
//    let view: UIView = {
//        let vi = UIView()
//        return vi
//    }()
//
//    // tabbar value
//    var selectionOtherTwo: [String] = ["原创文章", "原创视频", "百科", "分析"]
//
//    lazy var selectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = ThemeColor().themeColor()
//        layout.minimumInteritemSpacing = 2
//        cv.delegate = self
//        cv.dataSource = self
//        return cv
//    }()
//
//    let line: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.gray
//        return view
//    }()
//
//    lazy var cellListView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        layout.minimumLineSpacing = 5
//        cv.backgroundColor = ThemeColor().themeColor()
//        cv.dataSource = self
//        cv.delegate = self
//        return cv
//    }()
//
//    lazy var refresher: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
//        refreshControl.tintColor = UIColor.white
//        return refreshControl
//    }()
//
//    // set up views when launch the screen
//    override func setupViews() {
//        super.setupViews()
//        fetchOfflineData()
//        fetchData()
//        setupRootView()
//        setupSubViews()
//        cellListView.register(GenuineCell.self, forCellWithReuseIdentifier: "genuineCell")
//        cellListView.register(GenuineSliderViewCell.self, forCellWithReuseIdentifier: "sliderCell")
//        selectionView.register(SelectionViewCell.self, forCellWithReuseIdentifier: "selectionCell")
//        cellListView.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
//        selectionView.reloadData() // REVIEW: no need to call it here as it's loaded on start-Johnny Lin
//        let selectedIndexPath = IndexPath(item: 0, section: 0)
//        selectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .left)
//    }
//
//    func setupRootView() {
//        addSubview(view)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: view)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: view)
//        view.backgroundColor = ThemeColor().themeColor()
//    }
//
//    // constrains of the view
//    func setupSubViews() {
//        view.addSubview(line)
//        view.addSubview(selectionView)
//        view.addSubview(cellListView)
//        cellListView.addSubview(self.refresher)
//
//        addConstraintsWithFormat(format: "H:|[v0]|", views: line)
//        addConstraintsWithFormat(format: "H:|-5-[v0]|", views: selectionView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: cellListView)
//        addConstraintsWithFormat(format: "V:|[v0(1)]-5-[v1(30)]", views: line, selectionView)
//
//        cellListView.topAnchor.constraint(equalTo: selectionView.bottomAnchor).isActive = true
//        cellListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//
//    // set up item number of the collectionview
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var numberOfItem: Int
//        if collectionView == self.cellListView { // if it the list blow
//            if (position != 1) { // if not video list
//                if (newsArrayList != nil) { // prevent crash
//                    if (newsArrayList?.count)! > numberOfItemsToDisplay { // check the number of the list
//                        numberOfItem = numberOfItemsToDisplay + 1
//                    } else {
//                        numberOfItem = (newsArrayList?.count)! + 1
//                    }
//                } else {
//                    numberOfItem = 0
//                }
//            } else { // if video list
//                if (videoArrayList != nil) { // prevent crash
//                    if (videoArrayList?.count)! > numberOfItemsToDisplay { // check number of item in the list
//                        numberOfItem = numberOfItemsToDisplay
//                    } else {
//                        numberOfItem = (videoArrayList?.count)!
//                    }
//                } else {
//                    numberOfItem = 0
//                }
//            }
//        } else { // if it is tabbar
//            numberOfItem = 4
//        }
//        return numberOfItem
//    }
//
//
//    // items in the collectionview
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // if not selection list
//        if collectionView == self.cellListView {
//            if (position != 1) { // if not video list
//                if indexPath.item == 0 { // if slider cell
//                    let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! GenuineSliderViewCell
//                    cell3.homeViewController = self.homeViewController
//                    if (newsArrayList?.count != 0) {
//                        cell3.newsArrayList = Array(newsArrayList![0...2])
//                    }
//                    return cell3
//                } else { // other cells
//                    let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "genuineCell", for: indexPath) as! GenuineCell
//                    if newsArrayList?.count != 0 {
//                        cell2.genuine = newsArrayList?[indexPath.item - 1]
//                    }
//                    return cell2
//                }
//            } else { // video cells
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
//                if videoArrayList?.count != 0 {
//                    cell.video = videoArrayList?[indexPath.item]
//                }
//                return cell
//            }
//        } else { // selection list
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! SelectionViewCell
//            cell1.textLabel.text = selectionOtherTwo[indexPath.item]
//            return cell1
//        }
//    }
//
//    // size of every cells
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var size: CGSize
//        if position == 1 {
//            if collectionView == self.cellListView {
//                let height = (frame.width - 30) * 9 / 16 + 75
//                size = CGSize(width: cellListView.frame.width, height: height)
//            } else {
//                size = CGSize(width: 70, height: selectionView.frame.height)
//            }
//        } else {
//            if collectionView == self.cellListView {
//                if indexPath.item == 0 {
//                    size = CGSize(width: cellListView.frame.width, height: 150)
//                } else {
//                    size = CGSize(width: cellListView.frame.width, height: 110)
//                }
//            } else {
//                size = CGSize(width: 70, height: selectionView.frame.height)
//            }
//        }
//        return size
//    }
//
//    // click actions
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if (collectionView == selectionView) {
//            position = indexPath.item
//        } else {
//            if (position == 1) {
//                let videoDetailViewController = VideoDetailViewController()
//                videoDetailViewController.video = videoArrayList?[indexPath.item]
//                homeViewController!.navigationController?.pushViewController(videoDetailViewController, animated: true)
//            } else {
//                if (indexPath.item != 0) {
//                    let genuineDetailViewController = NewsDetailWebViewController()
//                    genuineDetailViewController.news = (newsArrayList?[indexPath.item - 1].title, newsArrayList?[indexPath.item - 1].url) as? (title: String, url: String)
//                    homeViewController?.navigationController?.pushViewController(genuineDetailViewController, animated: true)
//                }
//            }
//        }
//    }
//
//    // load more data
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == cellListView {
//            if indexPath.item == numberOfItemsToDisplay - 1 && numberOfItemsToDisplay <= (newsArrayList?.count)! {
//                numberOfItemsToDisplay += 5
//                fetchData(skip: (newsArrayList?.count)!)
//            }
//        }
//    }
//
//    // refresh
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        self.refresher.beginRefreshing()
//        numberOfItemsToDisplay = 7
//        fetchData()
//        self.refresher.endRefreshing()
//    }
//
//    // load data online whit no arguement
//    func fetchData() {
//        if (position != 1) {
//            APIService.shardInstance.fetchGenuineData(contentType: selectionOtherTwo[position], currentNumber: 0) { (gens: Results<Genuine>) in
//                self.newsArrayList = gens
//                self.cellListView.reloadData()
//            }
//        } else {
//            APIService.shardInstance.fetchVideoData(currentNumber: 0) { (video: Results<Video>) in
//                self.videoArrayList = video
//                self.cellListView.reloadData()
//            }
//        }
//    }
//
//    // load data from database
//    func fetchOfflineData() {
//        if (position != 1) {
//            APIService.shardInstance.fetchGenuineOffline(contentType: selectionOtherTwo[position]) { (gen: Results<Genuine>) in
//                self.newsArrayList = gen
//                self.cellListView.reloadData()
//            }
//        } else {
//            APIService.shardInstance.fetchVideoOffline { (video: Results<Video>) in
//                self.videoArrayList = video
//                self.cellListView.reloadData()
//            }
//        }
//    }
//
//    // load data when load more data (with arguement)
//    func fetchData(skip: Int) {
//        if (position != 1) {
//            APIService.shardInstance.fetchGenuineData(contentType: selectionOtherTwo[position], currentNumber: skip) { (gens: Results<Genuine>) in
//                self.newsArrayList = gens
//                self.cellListView.reloadData()
//            }
//        } else {
//            APIService.shardInstance.fetchVideoData(currentNumber: 0) { (video: Results<Video>) in
//                self.videoArrayList = video
//                self.cellListView.reloadData()
//            }
//        }
//    }
//}
