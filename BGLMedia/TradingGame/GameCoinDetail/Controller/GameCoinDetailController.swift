//
//  GameCoinDetailController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 9/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
/**
    mostly copied form CoinDetailController
 */
class GameCoinDetailController: UIViewController,MenuBarViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    let factor = UIScreen.main.bounds.width/375
    
    var observer:NSObjectProtocol?
    var observer1:NSObject?
    var alertGetStatus:Bool = false
    //    var alertSendStatus:Bool = false
    var firstTime:Bool = false
    let gerneralController = GameGerneralController()
    let transactionHistoryController = GameTransactionsHistoryViewController()
    let alertControllers = AlertController()
    var gameBalanceController: GameBalanceController? {
        didSet {
            transactionHistoryController.gameBalanceController = gameBalanceController
        }
    }
    var coinDetail : GameCoin? {
        didSet {
            transactionHistoryController.coinDetail = coinDetail
        }
    }
    
    var loginStatus:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "isLoggedIn")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if alertGetStatus{
            alertControllers.getNotification()
            if loginStatus{
                safeAreaView.backgroundColor = ThemeColor().blueColor()
            } else{
                safeAreaView.backgroundColor = ThemeColor().themeColor()
            }
        }
    }
    
    func setUpView(){
        collectionviews.delegate = self
        collectionviews.dataSource = self
        //        view.backgroundColor = ThemeColor().blueColor()
        let factor = view.frame.width/375
        
        self.transactionHistoryController.factor = factor
        self.alertControllers.factor = factor
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":menuBar]))
        
        //CollectionView
        view.addSubview(collectionviews)
        collectionviews.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "containterController")
        collectionviews.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        collectionviews.backgroundColor = ThemeColor().themeColor()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x/3
    }
    
    func  scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexpath = NSIndexPath(item: Int(index), section: 0)
        menuBar.menuViewCollection.selectItem(at: indexpath as IndexPath, animated: true, scrollPosition:[])
    }
    
    lazy var menuBar: MenuBarView = {
        let labels = [textValue(name: "general_detail"),
                      textValue(name: "transaction_detail"),
                      textValue(name: "alerts_detail")]
        let mb = MenuBarView(menuLabels: labels)
        mb.textFont = UIFont.regularFont(16*factor)
        mb.customDelegate = self
        return mb
    }()
    func menuBarView(collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = NSIndexPath(item: indexPath.row, section: 0)
        collectionviews.scrollToItem(at: i as IndexPath, at: .left, animated: true)
    }
    
    var collectionviews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionview.isPagingEnabled = true
        
        collectionview.showsHorizontalScrollIndicator = false
        return collectionview
    }()
    
    func scrollToMenuIndex(menuIndex: Int){
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionviews.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    //Add child Controller to each collection View cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
        if indexPath.row == 0{
            addChildViewController(childViewController: gerneralController,cell:cell)
            return cell
        } else if indexPath.row == 1{
            addChildViewController(childViewController: transactionHistoryController,cell:cell)
            return cell
        } else if indexPath.row == 2{
            addChildViewController(childViewController: alertControllers,cell:cell)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containterController", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 2{
            if !alertGetStatus{
                if !firstTime{
                    alertControllers.getNotification()
                    firstTime = true
                }
                alertGetStatus = true
            }
            
            if indexPath.row == 2{
                cell.addSubview(safeAreaView)
                if #available(iOS 11.0, *) {
                    safeAreaView.topAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
                    safeAreaView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true
                    safeAreaView.widthAnchor.constraint(equalToConstant: cell.frame.width).isActive = true
                } else {
                    
                }
                if loginStatus{
                    safeAreaView.backgroundColor = ThemeColor().blueColor()
                }else{
                    safeAreaView.backgroundColor = ThemeColor().themeColor()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 2{
            alertGetStatus = false
            //            alertSendStatus = false
            //            alertControllers.sendNotification()
            
        }
        
        if indexPath.row == 2{
            //            safeAreaView.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    var safeAreaView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().blueColor()
        return view
    }()
    
}
