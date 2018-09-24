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

import Kingfisher
extension NewsV2Controller : TableCellForSliderDelegate,TableCellForSliderDataSource{
    
    // change first row's height and remain the same for other
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            // 200 is eaqual to the total height of the cell
            // make sure total view height in tablecell not >200
            return 200 * view.frame.width/414
        }
        return 120 * view.frame.width/414
    }
    
    func tableCellForSlider(tableCell: UITableViewCell, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsSliderCollectionViewCell.registerID, for: indexPath) as! NewsSliderCollectionViewCell
        let tableC = tableCell as! TableCellForSlider
        cell.width = tableC.width
        if(genuineNewsObjects.count > 0){
            cell.genuineNews = genuineNewsObjects[indexPath.row]
        }
        return cell
    }
    
    func tableCellForSlider(tableCell: UITableViewCell, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(genuineNewsObjects.count >= 5){
            return 5
        }
        return genuineNewsObjects.count
    }
    
    func tableCellForSlider(tableCell: UITableViewCell, didSelect collectionView: UICollectionView, itemAt indexPath: IndexPath) {
        let url = genuineNewsObjects[indexPath.row].url
        
        if url!.isValidURL(){
            if openURL(urlString: url!){
                collectionView.deselectItem(at: indexPath, animated: true)
            }else{
                //failed to open url
                print("failed to Open URL: " + url!)
            }
        }else{
            print("Invalid Url")
        }
        
    }
    
    private func openURL(urlString: String) -> Bool{
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
            return true
        }else{
            return false
        }
    }
    
    //=====================data storing and getting==========
    var genuineNewsObjects:Results<GenuineNewsObject>{
        get{
            return try! Realm().objects(GenuineNewsObject.self).sorted(byKeyPath: "publishedTime", ascending: false)
        }
    }
    
    func getGenuineData(skip:Int,limit:Int,completion: @escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["api","getgenuine?languageTag=EN&skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()){ (res,pass) in
            if pass{
                //print("GET Genuine Data count: " + (JSON(res).array?.count.description)!)
                self.storeGenuineDataToRealm(res:res){success in
                    if success{
                        completion(true)
                    }
                }
            } else{
                completion(false)
            }
        }
    }
    
    func storeGenuineDataToRealm(res:JSON,completion: @escaping (Bool)->Void){
        let realm = try! Realm()
        realm.beginWrite()
        let removeResults = realm.objects(GenuineNewsObject.self)
        realm.delete(removeResults)
        
        if let collection = res.array {
            for result in collection{
                let id = result["_id"].string ?? "0"
                let author = result["author"].string ?? ""
                let title = result["title"].string ?? ""
                let genuineDescription = result["genuineDescription"].string ?? ""
                let imageURL = result["imageURL"].string ?? ""
                let url = result["url"].string ?? ""
                let genuineTag = result["genuineTag"].string ?? ""
                let publishedTime = Extension.method.convertStringToDate(date: result["publishedTime"].string ?? "")
                let languageTag = ""
                
                // if id is valid
                if(id != "0"){
                    // if object not stored
                    if(realm.object(ofType: GenuineNewsObject.self, forPrimaryKey: id) == nil){
                        realm.create(GenuineNewsObject.self, value: [id, title, author, genuineDescription, imageURL, url, genuineTag, publishedTime, languageTag])
                    } else {
                        realm.create(GenuineNewsObject.self, value: [id, title, author, genuineDescription, imageURL, url, genuineTag, publishedTime, languageTag], update:true)
                    }
                }
            }
            try! realm.commitWrite()
            completion(true)
        }
    }
    
}

class NewsSliderCollectionView: UICollectionView{
    
    public static let layout:UICollectionViewLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    public static let frame :CGRect = .zero
    
    func setup(){
        self.isPagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.alwaysBounceHorizontal = false
        self.backgroundColor = .white
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
    public static let registerID = "NewsSliderCell"
    
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
    
    var genuineNews: GenuineNewsObject?{
        didSet{
//            imageView.load(urlString: genuineNews?.imageURL ?? "")
//            if imageView.image == nil {imageView.image = UIImage(named: "notfound.png")}
            if genuineNews?.imageURL != nil {
                let url = URL(string: (genuineNews?.imageURL)!)
                imageView.kf.setImage(with: url)
            } else {
                imageView.image = UIImage(named: "notfound.png")
            }
            titleLabel.text = genuineNews?.title ?? "Missing Title"
            authorLabel.text = genuineNews?.author ?? "Unknown Author"
            publishedTimeLabel.text = Extension.method.convertDateToString(date: (genuineNews?.publishedTime)!)
            timeAgoLabel.text = genuineNews?.publishedTime.timeAgoDisplay()
        }
    }
    //========== image ===========
    lazy var imageView:UIImageView = {
        var image = UIImageView()
        //image.backgroundColor = UIColor.brown
        //image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = UIViewContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "notfound.png")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var infoView : UIView = {
        let infoView = UIView()
        infoView.backgroundColor = ThemeColor().darkGreyColor().withAlphaComponent(0.5)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        return infoView
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Missing Title"
        label.textColor = .white
        label.font = UIFont.ItalicFont(20*factorNumber!)
        label.numberOfLines = 1
        //label.backgroundColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var authorLabel : UILabel = {
        var author = UILabel()
        author.text = "Unknown Author"
        author.textColor = .white
        author.font = UIFont.ItalicFont(12*factorNumber!)
        author.translatesAutoresizingMaskIntoConstraints = false
        //author.backgroundColUICollectionViewFlowLayoutBreakForInvalidSizes or = .black
        return author
    }()
    
    lazy var publishedTimeLabel : UILabel = {
        var publishedTime = UILabel()
        publishedTime.text = "Publish Time Missing"
        publishedTime.textColor = .white
        publishedTime.font = UIFont.ItalicFont(12*factorNumber!)
        publishedTime.translatesAutoresizingMaskIntoConstraints = false
        //publishedTime.backgroundColor = .black
        return publishedTime
    }()
    
    
    lazy var timeAgoLabel : UILabel = {
        var timeAgo = UILabel()
        timeAgo.text = "Time ago missing"
        timeAgo.textColor = .white
        timeAgo.font = UIFont.ItalicFont(12*factorNumber!)
        timeAgo.translatesAutoresizingMaskIntoConstraints = false
        //timeAgo.backgroundColor = .black
        return timeAgo
    }()
    
    func setupView(){
        // add subview
        addSubview(imageView)
        addSubview(infoView)
        // set constraint
        addConstraintsWithFormat(format: "H:|[v0]|", views:imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views:infoView)
        addConstraintsWithFormat(format: "V:[v0(\(50*factorNumber!))]|", views: infoView)
        
        // set up constraint for texts
        infoView.addSubview(titleLabel)
        infoView.addSubview(authorLabel)
        infoView.addSubview(publishedTimeLabel)
        infoView.addSubview(timeAgoLabel)
        
        // set up description
        infoView.addConstraintsWithFormat(format: "H:|-\(10*factorNumber!)-[v0(\(390*factorNumber!))]", views: titleLabel)
        infoView.addConstraintsWithFormat(format: "V:[v0]-\(3*factorNumber!)-[v1]-\(5*factorNumber!)-|", views: titleLabel,authorLabel)
        infoView.addConstraintsWithFormat(format: "V:[v0]-\(3*factorNumber!)-[v1]-\(5*factorNumber!)-|", views: titleLabel,publishedTimeLabel)
        infoView.addConstraintsWithFormat(format: "V:[v0]-\(3*factorNumber!)-[v1]-\(5*factorNumber!)-|", views: titleLabel,timeAgoLabel)
        infoView.addConstraintsWithFormat(format: "H:|-\(10*factorNumber!)-[v0]-\(5*factorNumber!)-[v1]-\(5*factorNumber!)-[v2]", views: authorLabel,publishedTimeLabel,timeAgoLabel)
    }
}

/**
 first row of thw newsTableView
 also act as collection datasource
 */
class TableCellForSlider: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    
    public static let registerID = "TableCellForSlider"
    
    var customDelegate : TableCellForSliderDelegate?
    var customDataSource : TableCellForSliderDataSource?
    
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
    
    //===================slider collectionView=======
    var sliderView :NewsSliderCollectionView = {
        var slider = NewsSliderCollectionView(frame: NewsSliderCollectionView.frame,
                                              collectionViewLayout: NewsSliderCollectionView.layout)
        return slider
    }()
    
    /**
     number of sldiercell
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if(genuineNewsObjects.count > dis{playLimit){
        //            return displayLimit
        //        }else{
        //            return genuineNewsObjects.count
        //        }
        let cellNumber = (self.customDataSource?.tableCellForSlider(tableCell: self,collectionView: collectionView, numberOfItemsInSection: section)) ?? 0
        pageControl.numberOfPages = cellNumber
        return cellNumber
    }
    /**
     define slidercell type
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsSliderCollectionViewCell.registerID, for: indexPath) as! NewsSliderCollectionViewCell
        //        cell.width = self.width
        //        if(genuineNewsObjects.count > 0){
        //            cell.genuineNews = genuineNewsObjects[indexPath.row]
        //        }
        //        //cell.backgroundColor = .blue
        //        return cell
        return (self.customDataSource?.tableCellForSlider(tableCell: self,collectionView: collectionView ,cellForItemAt:indexPath))!
    }
    /**
     size of the slidercell
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: self.width!, height: floor(self.heightOfSlider * self.factorNumber!))
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    /**
     did select at row
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.customDelegate?.tableCellForSlider(tableCell: self, didSelect: collectionView, itemAt: indexPath)
    }
    
    //=====================page control==============
    lazy var pageControl: UIPageControl = {
        var pageC = UIPageControl()
        pageC.currentPage = 0
        pageC.numberOfPages = 0
        pageC.currentPageIndicatorTintColor = .white
        pageC.pageIndicatorTintColor = .gray
        pageC.backgroundColor = ThemeColor().darkGreyColor()
        pageC.isUserInteractionEnabled = false
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
}

protocol TableCellForSliderDelegate {
    
    /**
     did select at collectioncell inside table cell
     */
    func tableCellForSlider(tableCell: UITableViewCell,didSelect collectionView: UICollectionView,itemAt indexPath: IndexPath)
    
}

protocol TableCellForSliderDataSource {
    /**
     number of cell in tableViewcell.collectionView
     */
    func tableCellForSlider(tableCell: UITableViewCell, collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    
    /**
     cell type in tableViewCell.collectionView
     need to register cell for
     */
    
    func  tableCellForSlider(tableCell: UITableViewCell, collectionView: UICollectionView,cellForItemAt IndexPath: IndexPath)-> UICollectionViewCell
    
    
}
