//
//  NewsViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 6/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    let newsFlashController =  TimelineTableViewController()
    
    
    let newsController = NewsV2Controller()
    var navigationBarItem:String{
        get{
            return textValue(name: "news_newsPage")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    @objc func changeLanguage(){
//        titleLabel.text = navigationBarItem
//        navigationItem.titleView = titleLabel
//        menuBar.collectionView.reloadData()
//        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
    }
    
    @objc func changeCurrency(){
        //        DispatchQueue.main.async(execute: {
        //            self.global.coinList.beginHeaderRefreshing()
        //            self.watchList.coinList.beginHeaderRefreshing()
        //        })
    }
    
    deinit {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
//        //        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeCurrency"), object: nil)
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
            addChildViewController(childViewControllers: newsFlashController,cell:cell)
            return cell
        } else if indexPath.row == 1{
            addChildViewController(childViewControllers: newsController,cell:cell)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

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
    
    lazy var menuBar: NewsMenuBar = {
        let mb = NewsMenuBar()
        mb.newsViewController = self
        return mb
    }()
    
    var collectionviews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionview.isPagingEnabled = true
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    lazy var titleLabel: UILabel = {
        let factor = view.frame.width/375
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.semiBoldFont(17*factor)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    func setUpView(){
        Extension.method.reloadNavigationBarBackButton(navigationBarItem: self.navigationItem)
        let factor = view.frame.width/414
        titleLabel.text = navigationBarItem
        navigationItem.titleView = titleLabel
        
        collectionviews.delegate = self
        collectionviews.dataSource = self
        
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
