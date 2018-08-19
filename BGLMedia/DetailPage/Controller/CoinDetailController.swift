//
//  CoinDetailController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 23/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class CoinDetailController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    var observer:NSObjectProtocol?
    var observer1:NSObject?
    var alertGetStatus:Bool = false
//    var alertSendStatus:Bool = false
    var firstTime:Bool = false
    let gerneralController = GerneralController()
    let transactionHistoryController = TransactionsHistoryController()
    let alertControllers = AlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if alertGetStatus{
            alertControllers.getNotification()
        }
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//
////        if alertSendStatus{
////            self.alert.sendNotification()
////        }
//    }
    
    func setUpView(){
//        view.backgroundColor = ThemeColor().blueColor()
        let factor = view.frame.width/375
        //Menu Bar
        menuBar.factor = factor
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
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collectionviews,"v1":menuBar]))
        collectionviews.backgroundColor = ThemeColor().themeColor()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x/3
    }
    
    func  scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexpath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexpath as IndexPath, animated: true, scrollPosition:[])
    }
    
    lazy var menuBar: DetailMenuBar = {
        let mb = DetailMenuBar()
        mb.detailController = self
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
            addChildViewController(childViewControllers: gerneralController,cell:cell)
            return cell
        } else if indexPath.row == 1{
            addChildViewController(childViewControllers: transactionHistoryController,cell:cell)
            return cell
        } else if indexPath.row == 2{
            addChildViewAlertController(childViewControllers: alertControllers,cell:cell)
            cell.backgroundColor = ThemeColor().blueColor()
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 2{
            alertGetStatus = false
//            alertSendStatus = false
//            alertControllers.sendNotification()

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addChildViewAlertController(childViewControllers:UIViewController,cell:UICollectionViewCell){
        addChildViewController(childViewControllers)
        cell.contentView.addSubview(childViewControllers.view)
        childViewControllers.view.frame = view.bounds
        childViewControllers.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewControllers.didMove(toParentViewController: self)
        
        //Constraints
        childViewControllers.view.translatesAutoresizingMaskIntoConstraints = false
        childViewControllers.view.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        childViewControllers.view.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        childViewControllers.view.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        if #available(iOS 11.0, *) {
            childViewControllers.view.bottomAnchor.constraint(equalTo: cell.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            childViewControllers.view.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        }
        //        childViewControllers.view.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
    }
    
    
}
