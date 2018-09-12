//
//  NewsSliderCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2018/9/9.
//  Copyright © 2018年 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit

//import SwiftyJSON
//import SafariServices
//import RealmSwift

extension NewsV2Controller{
    
    // change first row's height and remain the same for other
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            // make ure change of row height when anything changed
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
    
    //========== image ===========
    var imageView:UIImageView = {
        var image = UIImageView()
        image.backgroundColor = UIColor.brown
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    //========== description =======
    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.text = "Missing Description"
        //auto resize off
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.gray
        return label
    }()
    
    /**
     view format "H:|[image]|" and "H:|[description]"
     "V:|[image]|" and "H:[description]|"
     */
    func setupView(){
        // add subview
        addSubview(imageView)
        addSubview(descriptionLabel)
        // set constraint
        addConstraintsWithFormat(format: "H:|-\(timesFactor(value: 10))-[v0]-\(timesFactor(value: 10))-|", views:imageView)
        addConstraintsWithFormat(format: "V:|-\(timesFactor(value: 10))-[v0]-\(timesFactor(value: 10))-|", views: imageView)
        addConstraintsWithFormat(format: "H:|-\(timesFactor(value: 10))-[v0]-\(timesFactor(value: 10))-|", views:descriptionLabel)
        addConstraintsWithFormat(format: "V:[v0]|", views: descriptionLabel)
    }
    /**
        return value * factorNumber
     */
    private func timesFactor(value :CGFloat) -> CGFloat{
        return value * self.factorNumber!
    }
}

/**
 first row of thw newsTableView
 also act as collection datasource
 */
class TableCellForSlider: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    
    open static let registerID = "TableCellForSlider"
    
    // factor Number is used to calculate height and constraint
    var factorNumber:CGFloat?
    var width:CGFloat?{
        didSet{
            // change factorNumber as width change and reset view
            factorNumber = width!/414
            setupView()
            print("this has been changed")
        }
    }
    
    let heightOfSlider: CGFloat = 180
    let heightOfPageControl : CGFloat = 20
    
    //===================slider collectionView=======
    let sliderView :NewsSliderCollectionView = {
        var slider = NewsSliderCollectionView(frame: NewsSliderCollectionView.frame,
        collectionViewLayout: NewsSliderCollectionView.layout)
        return slider
    }()
    
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
        cell.width = self.width
        cell.backgroundColor = .blue
        return cell
    }
    /**
     size of the slidercell
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        return CGSize(width: self.width!, height: self.heightOfSlider * self.factorNumber!)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
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
        sliderView.dataSource = self
        sliderView.delegate = self
        addSubview(sliderView)
        addSubview(pageControl)
        addConstraintsWithFormat(format: "H:|[v0]|", views: sliderView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: pageControl)
        addConstraintsWithFormat(format: "V:|[v0(\(heightOfSlider * factorNumber!))]-0-[v1(\(heightOfPageControl * factorNumber!))]|", views: sliderView,pageControl)
    }
    
    //=====================data storing and getting==========
    
//    var NewsSliderObjects:Results<NewsSliderObject>{
//        get{
//            return try! Realm().objects(NewsSliderObject.self).sorted(byKeyPath: "publishedTime", ascending: false)
//        }
//    }
    
//    func getData(genuineTag: String,skip:Int,limit:Int,completion: @escaping (Bool)->Void){
//        URLServices.fetchInstance.passServerData(urlParameters: ["api","getgenuine?genuineTag=" + genuineTag + "&languageTag=EN&skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
//            if pass{
////                self.resultNumber = res.count
////                self.storeDataToRealm(res:res){success in
////                    if success{
////                        completion(true)
////                    }
////                }
//                self.parseData(json: res)
//                completion(true)
//            } else{
//                completion(false)
//            }
//        }
//    }
//
//    func parseData(json:JSON){
//        print(json.array?.count)
//    }
    
    
//    func storeDataToRealm(res:JSON,completion: @escaping (Bool)->Void){
//        let realm = try! Realm()
//        realm.beginWrite()
//        if let collection = res.array {
//            for result in collection{
//
//            }
//        }
////        realm.beginWrite()
////        if let collection = res.array{
////            for result in collection{
////                let id = result["_id"].string ?? "0"
////                let title = result["title"].string ?? ""
////                let newsDescription = result["newsDescription"].string ?? ""
////                let imageURL = result["imageURL"].string ?? ""
////                let url = result["url"].string ?? ""
////                let publishedTime = Extension.method.convertStringToDate(date: result["publishedTime"].string ?? "")
////                let author = result["author"].string ?? ""
////                let localeTag = result["localeTag"].string ?? ""
////                let lanugageTag = result["languageTag"].string ?? ""
////                let source = result["source"].string ?? ""
////                let contentTagResult = result["contentTag"].array ?? [""]
////                let contentTag = List<String>()
////                for result in contentTagResult{
////                    contentTag.append(result.string!)
////                }
////
////                if id != "0" {
////                    if realm.object(ofType: NewsObject.self, forPrimaryKey: id) == nil {
////                        realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, lanugageTag,source,contentTag])
////                    } else {
////                        realm.create(NewsObject.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag,lanugageTag,source,contentTag], update: true)
////                    }
////                }
////            }
////            try! realm.commitWrite()
////            completion(true)
////        }
//    }
}
