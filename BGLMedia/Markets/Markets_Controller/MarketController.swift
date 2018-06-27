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
    let general = generalDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = color.themeColor()
        NotificationCenter.default.addObserver(self, selector: #selector(globalToDetail), name: NSNotification.Name(rawValue: "selectGlobalCoin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(watchListToDetail), name: NSNotification.Name(rawValue: "selectWatchListCoin"), object: nil)
        setupMenuBar()
        setupColleectionView()
        let titleLabel = UILabel()
        titleLabel.text = "Blockchain Global"
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
        cancelTouchKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tickerDataFetcher.fetchTickerDataWrapper()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectGlobalCoin"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectWatchListCoin"), object: nil)
    }
    
    @objc func globalToDetail(notificaiton:Notification){
        let result = notificaiton.object as! MarketsCell
        let global = GloabalController()
        global.coinDetail.coinName = result.general.coinAbbName
        navigationController?.pushViewController(global, animated: true)
    }
    
    @objc func watchListToDetail(notificaiton:Notification){
        let result = notificaiton.object as! WatchList
        let global = GloabalController()
        global.coinDetail.coinName = result.general.coinAbbName
        navigationController?.pushViewController(global, animated: true)
    }
    
    var color = ThemeColor()
    var menuitems = ["Markets","Watchlists"]
    
    private var coinListUpdateObserver: NSObjectProtocol?
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionviews.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: menuitems[indexPath.row], for: indexPath)
        
        return cell
    }
    
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
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
    }
    
    private func setupColleectionView(){
        view.addSubview(collectionviews)
        collectionviews.register(MarketsCell.self, forCellWithReuseIdentifier: "Markets")
        collectionviews.register(WatchList.self, forCellWithReuseIdentifier: "Watchlists")
        collectionviews.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        collectionviews.backgroundColor = color.themeColor()
    }
    
    class market:UICollectionViewCell{
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        let view:UIView = {
            var view = UIView()
            return view
        }()
        
        func setupView(){
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    class watchlist:UICollectionViewCell{
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.yellow
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateWatchInWatchList"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "removeWatchInMarketsCell"), object: nil)
    }
}


