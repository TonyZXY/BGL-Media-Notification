//
//  NewsSliderCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2018/9/9.
//  Copyright © 2018年 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit

extension NewsV2Controller : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    /**
     number of sldiercell
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collection = collectionView as! NewsSliderCollectionView
        return collection.cellNumber
    }
    /**
      define slidercell type
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsSliderCollectionViewCell.registerID, for: indexPath) as! NewsSliderCollectionViewCell
        cell.width = view.frame.width
        cell.backgroundColor = .blue
        return cell
    }
    /**
     size of the slidercell
    */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200*view.frame.width/414)
    }
    
    // add datasouce to the slider
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //identify the cell which is for Slider
        if let cell = cell as? TableCellForSlider {
            cell.sliderView.dataSource = self
            cell.sliderView.delegate = self
            cell.sliderView.reloadData()
        }
    }
    
    // change first row's height and remain the same for other
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 200 * view.frame.width/414
        }
        return 120 * view.frame.width/414
    }
    
}

class NewsSliderCollectionView: UICollectionView{
    
    @IBInspectable let cellNumber = 5
    
    open static let layout:UICollectionViewLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        return layout
    }()
    
    open static let frame :CGRect = .zero
    
    func setup(){
        self.isPagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = false
        // let register the cell here
        self.register(NewsSliderCollectionViewCell.self, forCellWithReuseIdentifier: NewsSliderCollectionViewCell.registerID)
        self.backgroundColor = .green
    }
    
    /**
      to create view please use NewsSliderCollectionView.frame
     and NewsSliderCollectionView.layout as input
    */
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NewsSliderCollectionViewCell : UICollectionViewCell{
    open static let registerID = "NewsSliderCell"
    
    /**
        factor Number is used to calculate height and constraint
     */
    var factorNumber:CGFloat?
    var width:CGFloat?{
        didSet{
            // change factorNumber as width change and reset view
            factorNumber = width!/414
            setupView()
        }
    }
    
    func setupView(){
        
    }
}

/**
    first row of thw newsTableView
    also act as collection datasource
 */
class TableCellForSlider: UITableViewCell{
    
    open static let registerID = "TableCellForSlider"
    
    // factor Number is used to calculate height and constraint
    var factorNumber:CGFloat?
    var width:CGFloat?{
        didSet{
            // change factorNumber as width change and reset view
            factorNumber = width!/414
            setupView()
        }
    }
    
    let heightOfSlider: CGFloat = 180
    let heightOfPageControl : CGFloat = 20
    
    /**
      formula (heightOfSlider+heightOfPageControl) * factorNumber!
    */
    func totalHeight()-> CGFloat {
        return (heightOfSlider+heightOfPageControl) * factorNumber!
    }
    //===================slider collectionView=======
    let sliderView = NewsSliderCollectionView(
            frame: NewsSliderCollectionView.frame,
            collectionViewLayout: NewsSliderCollectionView.layout)
    
    //=====================page control==============
    lazy var pageControl: UIPageControl = {
        var pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.numberOfPages = sliderView.cellNumber
        pageC.currentPageIndicatorTintColor = .white
        pageC.pageIndicatorTintColor = .gray
        return pageC
    }()
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / self.width!)
    }
    
    func setupView(){
        addSubview(sliderView)
        addSubview(pageControl)
        addConstraintsWithFormat(format: "H:|[v0]|", views: sliderView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: pageControl)
        addConstraintsWithFormat(format: "V:|[v0(\(heightOfSlider * factorNumber!))]-0-[v1(\(heightOfPageControl * factorNumber!))]|", views: sliderView,pageControl)
    }
}





//
//
//
//

//class NewsSliderController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
//
//    @IBInspectable let cellNumber = 5
//
//    //=============================slider Section===================
//    var sliderView:UICollectionView = {
//        //set layout
//        var layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        // create collections
//        let slider = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        slider.isPagingEnabled = true
//        slider.bounces = false
//        slider.showsHorizontalScrollIndicator = false
//        slider.alwaysBounceHorizontal = false
//        // registerCell
//        slider.register(NewsSliderViewCell.self, forCellWithReuseIdentifier: NewsSliderViewCell.registerID)
//
//        return slider
//    }()
//
//    // number of cell
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cellNumber
//    }
//    // define cell type
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = sliderView.dequeueReusableCell(withReuseIdentifier: NewsSliderViewCell.registerID, for: indexPath) as! NewsSliderViewCell
//        cell.backgroundColor = .green
//        return cell
//    }
//
//    /**
//     size of item
//     */
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width, height: 50)
//    }
//
//    //=====================page control section==============
//    lazy var pageControl: UIPageControl = {
//        var pageC = UIPageControl()
//        pageC.currentPage = 0
//        pageC.numberOfPages = cellNumber
//        pageC.currentPageIndicatorTintColor = .white
//        pageC.pageIndicatorTintColor = .gray
//        return pageC
//    }()
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let x = targetContentOffset.pointee.x
//        pageControl.currentPage = Int(x / view.frame.width)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//    }
//
//    func setupView(){
//        view.addSubview(sliderView)
//        sliderView.equalToAllAnchors(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
//    }
//}
