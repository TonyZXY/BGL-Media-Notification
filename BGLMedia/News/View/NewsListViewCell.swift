////
////  ListViewCell.swift
////  NewsApp4
////
////  Created by Xuyang Zheng on 3/5/18.
////  Copyright © 2018 Xuyang Zheng. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class NewsListViewCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    // tabbar position, change when tab the bar, refresh page data when changed
//    var position: Int = 0 {
//        didSet {
//            numberOfItemsToDisplay = 7
//            fetchOfflineData()
//            fetchData()
//        }
//    }
//
//    // display 7 items when launch the page
//    var numberOfItemsToDisplay: Int = 7
//
//    weak var homeViewController: NewsHomeViewController?
//
//    let newsController = NewsDetailWebViewController()
//
//    var newsArrayList: Results<News>?
//
//    let view: UIView = {
//        let vi = UIView()
//        return vi
//    }()
//
//    // the selection options (can be change into automaticly fetch from database)
//    var selectionOptionOne: [String] = ["国内", "国际", "深度", "趋势"]
//
//    lazy var selectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = ThemeColor().themeColor()
//        layout.minimumInteritemSpacing = 2
//        cv.dataSource = self
//        cv.delegate = self
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
//    // set up views
//    override func setupViews() {
//        super.setupViews()
//        fetchOfflineData()
//        fetchData()
//        setupRootView()
//        setupSubViews()
//        // REVIEW: put in a separate method - registerCells -Johnny Lin
//        cellListView.register(NewsCell.self, forCellWithReuseIdentifier: "newsCell")
//        cellListView.register(NewsSliderViewCell.self, forCellWithReuseIdentifier: "sliderCell")
//        selectionView.register(SelectionViewCell.self, forCellWithReuseIdentifier: "selectionCell")
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
//    // constraints of the view
//    func setupSubViews() {
//        view.addSubview(line)
//        view.addSubview(selectionView)
//        view.addSubview(cellListView)
//        cellListView.addSubview(self.refresher)
//
//        addConstraintsWithFormat(format: "H:|[v0]|", views: line)
//
//        addConstraintsWithFormat(format: "H:|-5-[v0]|", views: selectionView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: cellListView)
//        addConstraintsWithFormat(format: "V:|[v0(1)]-5-[v1(30)]", views: line, selectionView)
//
//
//        cellListView.topAnchor.constraint(equalTo: selectionView.bottomAnchor).isActive = true
//        cellListView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//
//    // number of the items
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        var numberOfItem: Int
//        if collectionView == self.cellListView { // if not tabbar
//            if newsArrayList != nil { // if have news list
//                if (newsArrayList?.count)! > numberOfItemsToDisplay { // check number of items
//                    numberOfItem = numberOfItemsToDisplay + 1
//                } else {
//                    numberOfItem = (newsArrayList?.count)! + 1
//                }
//            } else {
//                numberOfItem = 0
//            }
//        } else { // if tabbar view
//            numberOfItem = 4
//        }
//        return numberOfItem
//    }
//
//    // cell of the item
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.cellListView { // if not tabbar
//            if indexPath.item == 0 { // if slider cell
//                let cell3 = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! NewsSliderViewCell
//                cell3.homeViewController = self.homeViewController
//                if (newsArrayList?.count != 0) {
//                    // implemented data load
//                    cell3.newsArrayList = Array(newsArrayList![0...2])
//                }
//                return cell3
//            } else { // list view
//                let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
//                cell2.news = newsArrayList?[indexPath.item - 1]
//                return cell2
//            }
//        } else { // tabbar cell
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "selectionCell", for: indexPath) as! SelectionViewCell
//            cell1.textLabel.text = selectionOptionOne[indexPath.item]
//            return cell1
//        }
//    }
//
//    // size of all cells
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var size: CGSize
//        if collectionView == self.cellListView {
//            if indexPath.item == 0 {
//                size = CGSize(width: cellListView.frame.width, height: 150)
//            } else {
//                size = CGSize(width: cellListView.frame.width, height: 110)
//            }
//        } else {
//            size = CGSize(width: 70, height: selectionView.frame.height)
//        }
//        return size
//    }
//
//    // click action
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if (collectionView == selectionView) {
//            position = indexPath.item
//        } else {
//            if (indexPath.item != 0) {
//                newsController.news = (newsArrayList?[indexPath.item - 1].title, newsArrayList?[indexPath.item - 1].url) as? (title: String, url: String)
//                homeViewController?.navigationController?.pushViewController(newsController, animated: true)
//            }
//        }
//    }
//
//    // load moew data
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if collectionView == cellListView {
//            if indexPath.item == numberOfItemsToDisplay - 1 && numberOfItemsToDisplay <= (newsArrayList?.count)! {
//                numberOfItemsToDisplay += 5
//                fetchData(skip: (newsArrayList?.count)!)
//            }
//        }
//    }
//
//    // refresh data
//    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        self.refresher.beginRefreshing()
//        numberOfItemsToDisplay = 7
//        fetchData()
//        self.refresher.endRefreshing()
//    }
//
//    // fetch data without arguement
//    func fetchData() {
//        APIService.shardInstance.fetchNewsData(contentType: selectionOptionOne[position], currentNumber: 0) { (news: Results<News>) in
//            self.newsArrayList = news
//            self.cellListView.reloadData()
//        }
//    }
//
//    // fetch offline data
//    func fetchOfflineData() {
//        APIService.shardInstance.fetchNewsOffline(contentType: selectionOptionOne[position]) { (news: Results<News>) in
//            self.newsArrayList = news
//            self.cellListView.reloadData()
//        }
//    }
//
//    // fetch data with arguement, used when load more data
//    func fetchData(skip: Int) {
//        APIService.shardInstance.fetchNewsData(contentType: selectionOptionOne[position], currentNumber: skip) { (news: Results<News>) in
//            self.newsArrayList = news
//            self.cellListView.reloadData()
//        }
//    }
//
//
//}
//
