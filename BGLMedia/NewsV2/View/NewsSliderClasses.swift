//
//  NewsSliderCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 2018/9/9.
//  Copyright © 2018年 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit

import SwiftyJSON
import SafariServices
import RealmSwift

extension NewsV2Controller : TableCellForSliderDelegate{
    
    // change first row's height and remain the same for other
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            // make ure change of row height when anything changed
            return 200 * view.frame.width/414
        }
        return 120 * view.frame.width/414
    }
    
    func didTryToOpenURL(sliderView: UICollectionView, urlString: String) {
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            print(vc.description)
            if #available(iOS 11.0, *) {
                vc.dismissButtonStyle = .close
            } else {
                
            }
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            self.present(vc, animated: true, completion: nil)
        }else{
            print("selected url invalid")
        }
    }
}

class NewsSliderCollectionView: UICollectionView{
    
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
    
    var customDelegate : TableCellForSliderDelegate?
    
    // factor Number is used to calculate height and constraint
    var factorNumber:CGFloat?
    var width:CGFloat?{
        didSet{
            // change factorNumber as width change and reset view
            factorNumber = width!/414
            setupView()
            setupSliderContent()
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
        if(genuineNewsObject.count > displayLimit){
            return displayLimit
        }else{
            return genuineNewsObject.count
        }
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
    /**
     did select at row
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genuine = genuineNewsObject[indexPath.row]
        let urlString = genuine.url
        
        self.customDelegate?.didTryToOpenURL(sliderView: collectionView, urlString: urlString!)
    }
    
    //=====================page control==============
    lazy var pageControl: UIPageControl = {
        var pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.numberOfPages = {
            if(genuineNewsObject.count > displayLimit){
                return displayLimit
            }else{
                return genuineNewsObject.count
            }
        }()
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
        addConstraintsWithFormat(format: "V:|[v0(\(heightOfSlider * factorNumber!))]-0-[v1(\(heightOfPageControl * factorNumber!))]", views: sliderView,pageControl)
    }
    
    //=====================data storing and getting==========
    
    var genuineNewsObject:Results<GenuineNewsObject>{
        get{
            return try! Realm().objects(GenuineNewsObject.self).sorted(byKeyPath: "publishedTime", ascending: false)
        }
    }
    
    let displayLimit = 10
    
    @objc func setupSliderContent(){
        getData(skip: 0, limit: displayLimit){ success in
            if success {
                // thing to do if successfully get data
                print("got data")
            }else{
                // thing to do if fail to load data
                print("failed to get data")
            }
        }
    }
    
    func getData(skip:Int,limit:Int,completion: @escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["api","getgenuine?languageTag=EN&skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
            if pass{
                self.storeDataToRealm(res:res){success in
                    if success{
                        completion(true)
                    }
                }
            } else{
                completion(false)
            }
        }
    }
    
    func storeDataToRealm(res:JSON,completion: @escaping (Bool)->Void){
        let realm = try! Realm()
        realm.beginWrite()
        if let collection = res.array {
            for result in collection{
                let id = result["_id"].string ?? "0"
                let author = result["author"].string ?? ""
                let genuineDescription = "genuineDescription"
                let imageURL = result["imageURL"].string ?? ""
                let url = result["url"].string ?? ""
                let genuineTag = result["genuineTag"].string ?? ""
                let publishedTime = Extension.method.convertStringToDate(date: result["publishedTime"].string ?? "")
                let languageTag = ""
                
                // if id is valid
                if(id != "0"){
                    // if object not stored
                    if(realm.object(ofType: GenuineNewsObject.self, forPrimaryKey: id) == nil){
                        realm.create(GenuineNewsObject.self, value: [id, author, genuineDescription, imageURL, url, genuineTag, publishedTime, languageTag])
                    } else {
                        realm.create(GenuineNewsObject.self, value: [id, author, genuineDescription, imageURL, url, genuineTag, publishedTime, languageTag], update:true)
                    }
                }
            }
            try! realm.commitWrite()
            completion(true)
        }
    }
}

protocol TableCellForSliderDelegate {
    /**
     try to open url for selected slider News
     */
    func didTryToOpenURL(sliderView: UICollectionView,urlString:String)
}
