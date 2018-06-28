//
//  MarketController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 29/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class MarketController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    let tickerDataFetcher = TickerDataFetcherV2()
    let global = GlobalMarketController()
    let watchList = WatchListController()
    var color = ThemeColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        cancelTouchKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency), name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func changeLanguage(){
        menuBar.collectionView.reloadData()
        global.changeLanguage()
        watchList.watchList.sortDate.reloadData()
        watchList.watchList.coinList.reloadData()
        watchList.watchList.marketSortPickerView.setPickerViewDoneButton()
    }
    
    @objc func changeCurrency(){
        global.marketCell.coinList.reloadData()
        watchList.watchList.coinList.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tickerDataFetcher.fetchTickerDataWrapper()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateWatchInWatchList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "removeWatchInMarketsCell"), object: nil)
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionviews.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
        if indexPath.row == 0{
            addChildViewController(childViewControllers: global,cell:cell)
            return cell
        } else if indexPath.row == 1{
            addChildViewController(childViewControllers: watchList,cell:cell)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
            return cell
        }
    }
    
//    func addChildViewController(childViewControllers:UIViewController,cell:UICollectionViewCell){
//        addChildViewController(childViewControllers)
//        cell.contentView.addSubview(childViewControllers.view)
//        childViewControllers.view.frame = view.bounds
//        childViewControllers.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        childViewControllers.didMove(toParentViewController: self)
//
//        //Constraints
//        childViewControllers.view.translatesAutoresizingMaskIntoConstraints = false
//        childViewControllers.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        childViewControllers.view.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
//        childViewControllers.view.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
//        childViewControllers.view.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x/2
    }
    
    func  scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexpath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexpath as IndexPath, animated: true, scrollPosition:[])
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.marketController = self
        return mb
    }()
    
    lazy var collectionviews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionview.isPagingEnabled = true
        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    func setUpView(){
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = color.themeColor()
        
        let titleLabel = UILabel()
        titleLabel.text = "Blockchain Global"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        
        //Set Up Menu Bar
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        
        //Set Up collection View
        view.addSubview(collectionviews)
        collectionviews.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "containterController")
        collectionviews.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        collectionviews.backgroundColor = color.themeColor()
        
    }
}


