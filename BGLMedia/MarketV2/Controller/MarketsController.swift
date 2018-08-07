//
//  MarketsController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 11/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class MarketsController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var alertGetStatus:Bool = false
    var alertSendStatus:Bool = false
    var navigationBarItem:String{
        get{
            return textValue(name: "globalMarket")
        }
    }
    
    var global = GlobalMarketsController()
    var watchList = WatchListsController()
    var alert = AlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
//        cancelTouchKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrency), name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
    }
    
    @objc func changeLanguage(){
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        menuBar.collectionView.reloadData()
        
//        global = GlobalMarketsController()
//        watchList = WatchListsController()
//        collectionviews.reloadData()
//        global.mainTotalCollectionView.reloadData()
//        global.sortdoneclick()
//        global.coinList.reloadData()
//        global.filterDate.reloadData()
//
//        watchList.coinList.reloadData()
//
//        watchList.watchList.sortDate.reloadData()
//        watchList.watchList.coinList.reloadData()
//        watchList.watchList.marketSortPickerView.setPickerViewDoneButton()
        
    }
    
    @objc func changeCurrency(){
//        DispatchQueue.main.async(execute: {
//            self.global.coinList.beginHeaderRefreshing()
//            self.watchList.coinList.beginHeaderRefreshing()
//        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if alertGetStatus{
            self.alert.getNotification()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if alertSendStatus{
            self.alert.sendNotification()
        }
    }
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionviews.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
        if indexPath.row == 0{
            addChildViewController(childViewControllers: global,cell:cell)
            return cell
        } else if indexPath.row == 1{
            addChildViewController(childViewControllers: watchList,cell:cell)
            return cell
        } else if indexPath.row == 2{
            alert.factor = view.frame.width/375
            addChildViewController(childViewControllers: alert,cell:cell)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 2{
            self.alert.getNotification()
            alertGetStatus = true
            alertSendStatus = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 2{
            alertGetStatus = false
            alertSendStatus = false
            self.alert.sendNotification()
            
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x/3
    }
    
    func  scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexpath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexpath as IndexPath, animated: true, scrollPosition:[])
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.marketsController = self
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
    
    lazy var titleLabel: UILabel = {
        let factor = view.frame.width/375
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.semiBoldFont(17*factor)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    func setUpView(){
        let factor = view.frame.width/414
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        
        //Set Up Menu Bar
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        
        if #available(iOS 11.0, *) {
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        }
        
        //Set Up collection View
        view.addSubview(collectionviews)
        collectionviews.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "containterController")
        collectionviews.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        collectionviews.backgroundColor = ThemeColor().themeColor()
        
        if #available(iOS 11.0, *) {
            collectionviews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        }
    }
}


