//
//  TimelineTableViewController.swift
//  news app for blockchain
//
//  Created by Sheng Li on 23/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class TimelineTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)
    var dictionary = [String:Int]()
    //    var resultsUpdated = false
    var changeLaugageStatus:Bool = false
    var displayNumber:Int = 0
    var loadMoreData:Bool = false
    var resultNumber: Int = 0
    var deleteCacheStatus:Bool = false
    
    //    var results:Results<NewsFlash>{
    //        get{
    //            let filterName = "languageTag = '" + self.defaultLanguage + "' "
    //            return try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false).filter(filterName)
    //        }
    //    }
    
    var sectionArray = [Int]()
    var dates = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.resultsUpdated = false
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        setUpView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCache), name: NSNotification.Name(rawValue: "deleteCache"), object: nil)
        
        //Prevent empty rows
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = ThemeColor().themeColor()
        self.tableView.separatorStyle = .none
        self.tableView.setContentOffset(.zero, animated: false)
        self.tableView.switchRefreshFooter(to: .removed)
        self.tableView.switchRefreshHeader(to: .refreshing)
        
        self.displayNumber += 5
        getNews(skip:0,limit: 5){ success in
            if success{
                self.tableView.reloadData()
                let footer = DefaultRefreshFooter.footer()
                footer.textLabel.textColor = ThemeColor().whiteColor()
                footer.tintColor = ThemeColor().whiteColor()
                footer.textLabel.backgroundColor = ThemeColor().themeColor()
                self.tableView.configRefreshFooter(with: footer, container: self, action: {
                    self.handleFooter()
                })
                
            } else {
                self.tableView.reloadData()
                let footer = DefaultRefreshFooter.footer()
                footer.textLabel.textColor = ThemeColor().whiteColor()
                footer.tintColor = ThemeColor().whiteColor()
                footer.textLabel.backgroundColor = ThemeColor().themeColor()
                self.tableView.configRefreshFooter(with: footer, container: self, action: {
                    self.handleFooter()
                })
            }
        }
        
    }
    
    @objc func deleteCache(){
        deleteCacheStatus = true
//        deleteCacheStatus = true
    }
    
    @objc func changeLanguage(){
//        changeLaugageStatus = true
        tableView.switchRefreshHeader(to: .removed)
        tableView.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
            self.handleRefresh(self.tableView)
        })
        let footer = DefaultRefreshFooter.footer()
        footer.textLabel.textColor = ThemeColor().whiteColor()
        footer.tintColor = ThemeColor().whiteColor()
        footer.textLabel.backgroundColor = ThemeColor().themeColor()
        tableView.switchRefreshFooter(to: .removed)
  
        tableView.configRefreshFooter(with:footer, container: self, action: {
             self.handleFooter()
        })
        tableView.switchRefreshHeader(to: .refreshing)
    }
    
    deinit {
        NotificationCenter.default.removeObserver("changeLanguage")
        NotificationCenter.default.removeObserver("deleteCache")
    }
    
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //        if self.resultsUpdated {
    //            self.tableView.reloadData()
    //            self.resultsUpdated = false
    //        }
    //
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        if deleteCacheStatus{
            tableView.reloadData()
            self.tableView.switchRefreshHeader(to: .refreshing)
            self.tableView.switchRefreshFooter(to: .normal)
            deleteCacheStatus = false
        }
//        if changeLaugageStatus || deleteCacheStatus{
//            if deleteCacheStatus{
//                self.tableView.reloadData()
//            }
//            tableView.switchRefreshHeader(to: .removed)
//            tableView.configRefreshHeader(with:addRefreshHeaser(), container: self, action: {
//                self.handleRefresh(self.tableView)
//            })
//            self.changeLaugageStatus = false
//            self.deleteCacheStatus = false
//            tableView.switchRefreshHeader(to: .refreshing)
//        }
    }
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    ////        getNews()
    //        self.tableView.reloadData()
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionArray = [Int](repeating: 0, count: dates.count)
        let resultSet = defaultLanguage == "CN" ? self.results : results.filter("languageTag='" + defaultLanguage + "'")
        for result in resultSet{
            let date = Extension.method.convertDateToString(date: result.dateTime).description.components(separatedBy: " ")[0]
            //get index of date in dates
            let sectionArrayIndex = dates.index(of: date)!
            sectionArray[sectionArrayIndex] += 1
        }
        return sectionArray[section]
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        dates = []
        let resultSet = defaultLanguage == "CN" ? self.results : results.filter("languageTag='" + defaultLanguage + "'")
        for result in resultSet{
            let timeArr = Extension.method.convertDateToString(date: result.dateTime).description.components(separatedBy: " ")
            if !dates.contains(timeArr[0]){
                dates.append(timeArr[0])
            }
        }
        return dates.count
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width =  tableView.frame.size.width
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: tableView.sectionHeaderHeight))
        sectionHeaderView.backgroundColor = ThemeColor().themeColor()
        tableView.scrollsToTop = true
        //        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: width-2*20, height: tableView.sectionHeaderHeight))
        
        label.font = UIFont.boldFont(15)
        label.textColor = ThemeColor().blueColor()
        label.textAlignment = .center
        label.text = convertDateForDisplay(convert: dates[section])
        label.layer.cornerRadius = tableView.sectionHeaderHeight/2
        label.clipsToBounds = true
        label.layer.borderWidth = 3
        label.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        
        
        sectionHeaderView.addSubview(label)
        return sectionHeaderView
    }
    
    private func convertDateForDisplay(convert date:String) -> String{
        let dateArr = date.components(separatedBy: "-")
        let year = "\(Int(dateArr[0])!)"
        let month = "\(Int(dateArr[1])!)"
        let day = "\(Int(dateArr[2])!)"
        let date2 = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        if dateFormatter.string(from: date2).components(separatedBy: " ")[0] == date{
            return textValue(name: "timeToday_flash") + month + textValue(name: "timeMonth_flash") + day + textValue(name: "timeDay_flash")
        }else{
            return year + textValue(name: "timeYear_flash") + month + textValue(name: "timeMonth_flash") + day + textValue(name: "timeDay_flash")
        }
    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        let numberOfSkips = sectionArray.prefix(indexPath.section).reduce(0,+)
        let resultSet = defaultLanguage == "CN" ? self.results : results.filter("languageTag='" + defaultLanguage + "'")
        let object = resultSet[indexPath.row + numberOfSkips]
        cell.likeButton.isHidden = true
        cell.shareButton.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
        
        let bglGreen = ThemeColor().blueColor()
        cell.timelinePoint = TimelinePoint(diameter: CGFloat(16.0), color: bglGreen, filled: false)
        cell.timelinePointInside = TimelinePoint(diameter: CGFloat(4.0), color: bglGreen, filled: true, insidePoint: true)
        cell.timeline.backColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        cell.titleLabel.text = Extension.method.convertTimetoLocalization(convert: dateFormatter.string(from: object.dateTime) )
        cell.txtTitleLabel.text = object.title
        cell.descriptionLabel.text = object.contents
        
        cell.object = object
        
        cell.sharesbutton.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
        return cell
    }
    //    print(UIImage(named:"shareImageHead.png")?.size)
    //    print(UIImage(named:"shareImageQRCode.png")?.size)
    //    print(UIScreen.main.bounds)
    //    print(textImage.size)
    
    @objc func shareButtonClicked(sender: UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 0, y: 0), to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: indexPath!)! as! TimelineTableViewCell
        //        let cellText = cell.descriptionLabel.text
        //        let size = cell.descriptionLabel.font.pointSize
        //        let textImage = self.textToImage(drawText: cellText!, inImage: cell.descriptionLabel.createImage!, atPoint: CGPoint(x:0, y:0), withSize:size)
        //
        ////        let topImage = combineLogoWithText(combine: UIImage(named: "bcg_logo.png")!, with: textImage)
        ////        let bottomImage = UIImage(named: "sample_qr_code.png")
        ////        let image = combineImageWithQRCode(combine: topImage, with: (bottomImage)!)
        //
        //        let image = generateImage(textImage: textImage)
        //
        //        let sharedImageVC = ShareImagePreViewController(image:image)
        //
        ////        sharedImageVC.parentView = self
        //
        //        self.present(sharedImageVC,animated: true, completion:nil)
        //
        //        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities:nil)
        //        activityVC.popoverPresentationController?.sourceView = self.view
        //        self.present(activityVC,animated: true, completion:nil)
        
        
        let shareView = ShareNewsFlashControllerV2()
        shareView.newsdate = cell.titleLabel.text!
        shareView.newsdescriptions = cell.descriptionLabel.text!
        shareView.newsTitle = cell.txtTitleLabel.text!
        present(shareView, animated: true, completion: nil)
    }
    
    
    
    
    func generateImage(textImage: UIImage)->UIImage{
        let topImage = UIImage(named:"shareImageHead")
        let bottomImage = UIImage(named:"shareImageQRCode")
        let width = UIScreen.main.bounds.width
        let height1 = (topImage?.size.height)!*width/(topImage?.size.width)!
        let height2 = (bottomImage?.size.height)!*width/(bottomImage?.size.width)!
        //now we have topImage, textImage and bottomImage - we have to combine them together
        //        let distance = (UIScreen.main.bounds.height - height1 - textImage.size.height - height2)/2
        
        let size = UIScreen.main.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let headerSpace = CGFloat(0)
        topImage?.draw(in: CGRect(x: 0, y: headerSpace, width: width, height: height1))
        let temp = height1 + headerSpace
        textImage.draw(in: CGRect(x: 5, y: temp, width: width-10, height: textImage.size.height))
        bottomImage?.draw(in: CGRect(x: 0, y: temp + textImage.size.height,  width: width, height: height2))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    func combineImageWithQRCode(combine topImage:UIImage, with bottomImage:UIImage)-> UIImage{
        let width = topImage.size.width
        let height = topImage.size.height * 2
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        topImage.draw(in: CGRect(x:0, y:0, width:width, height: height/2 ))
        bottomImage.draw(in: CGRect(x:(width-height/2)/2, y:height/2, width: height/2,  height:height/2 ))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Change UIImageView requirements here
        let mergeImageView = UIImageView(frame: CGRect(x:0, y: 200, width: 30, height: 20))
        
        //Combine images into a single image view.
        mergeImageView.image = newImage
        return mergeImageView.image!
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, withSize size: CGFloat) -> UIImage {
        let textColor = UIColor.black
        
        let textFont = UIFont.systemFont(ofSize: size)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func combineLogoWithText(combine topImage:UIImage, with bottomImage:UIImage)-> UIImage{
        let width = bottomImage.size.width
        let height = bottomImage.size.height * 2
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        topImage.draw(in: CGRect(x:(width-height/2)/2, y:0, width:height/2, height: height/2 ))
        bottomImage.draw(in: CGRect(x:0, y:height/2, width: width,  height:height/2 ))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Change UIImageView requirements here
        let mergeImageView = UIImageView(frame: CGRect(x:0, y: 200, width: 30, height: 20))
        
        //Combine images into a single image view.
        mergeImageView.image = newImage
        return mergeImageView.image!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
    }
    
    
    
    //        Alamofire.request("http://10.10.6.111:3000/api/flash?languageTag=EN&languageTag=CN", method: .get).validate().responseJSON { response in
    
    
    func getNews(skip:Int,limit:Int,completion:@escaping (Bool)->Void){
        URLServices.fetchInstance.passServerData(urlParameters: ["api","getFlashWithLan?languageTag=EN&skip=" + String(skip) + "&limit=" + String(limit)], httpMethod: "GET", parameters: [String:Any]()) { (response, success) in
            if success{
                self.resultNumber = response.count
                self.JSONtoData(json: response)
                DispatchQueue.main.async {
                    self.results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)//.filter("languageTag='" + self.defaultLanguage + "'")
                    //                    self.resultsUpdated = true
                    completion(true)
                }
            } else{
                completion(false)
            }
        }
        
        
        //        APIService.shardInstance.fetchFlashNews(language:defaultLanguage) { (searchResult) in
        //            self.JSONtoData(json: searchResult)
        //            DispatchQueue.main.async {
        ////                let filterName = "languageTag = '" + self.defaultLanguage + "' "
        //                self.results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)//.filter("languageTag='" + self.defaultLanguage + "'")
        //                self.resultsUpdated = true
        ////                print(self.results)
        //                self.tableView.reloadData()
        ////                print(self.results.count)
        //            }
        //        }
    }
    
    private func JSONtoData(json: JSON) {
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        realm.beginWrite()
        if let collection = json.array {
            for item in collection {
                //                dateFormatter.timeZone = TimeZone.current
                let date = Extension.method.convertStringToDate(date: item["publishedTime"].string ?? "")
                let id = "\(item["_id"].string!)"
                let toSent = item["toSent"].bool ?? false
                let title = item["title"].string ?? ""
                if realm.object(ofType: NewsFlash.self, forPrimaryKey: id) == nil {
                    realm.create(NewsFlash.self, value: [id, date, item["shortMassage"].string!,"EN",toSent,title])
                } else {
                    //                    print("updating")
                    realm.create(NewsFlash.self, value: [id, date, item["shortMassage"].string!,"EN",toSent,title], update: true)
                }
            }
        }
        try! realm.commitWrite()
    }
    
    //    lazy var refresher: UIRefreshControl = {
    //        let refreshControl = UIRefreshControl()
    //        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
    //        refreshControl.tintColor = UIColor.gray
    //
    //        return refreshControl
    //    }()
    
    func cleanOldNewsFlash() {
        //        let oneWeekBefore = Date.init(timeIntervalSinceNow: -(86400*7))
        //                let oldObjects = realm.objects(NewsFlash.self)
        //        //
        //
        //                try! realm.write {
        //                    realm.delete(oldObjects)
        //                }
    }
    
    
    @objc func handleRefresh(_ tableView: UITableView) {
        getNews(skip: 0, limit: 5){ success in
            if success{
                self.tableView.reloadData()
                self.displayNumber = 5
                tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    func handleFooter(){
        if displayNumber <= results.count{
            self.displayNumber += 5
            if displayNumber != 0{
                getNews(skip: displayNumber-5, limit: 5){ success in
                    if success{
                        //                        DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.switchRefreshFooter(to: .normal)
                        //                            self.refresher.endRefreshing()
                        //                        }
                    }
                }
            }
        }
        print(resultNumber)
        if self.displayNumber >= self.results.count {
            self.tableView.switchRefreshFooter(to: .normal)
            
        }
        if resultNumber < 5 {
            self.tableView.switchRefreshFooter(to: .noMoreData)
        }
    }
    
    
    func setUpView(){
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        tableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(self.tableView)
        })
        
        let footer = DefaultRefreshFooter.footer()
        footer.textLabel.textColor = ThemeColor().whiteColor()
        footer.tintColor = ThemeColor().whiteColor()
        footer.textLabel.backgroundColor = ThemeColor().themeColor()
        tableView.configRefreshFooter(with: footer, container: self, action: {
            self.handleFooter()
        })
    }
}

extension UIView {
    var createImage : UIImage? {
        
        let rect = CGRect(x:0, y:0, width:bounds.size.width, height:bounds.size.height)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        UIColor.white.set()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
}

extension UIImage {
    func resizeImage(_ newSize: CGSize) -> UIImage? {
        func isSameSize(_ newSize: CGSize) -> Bool {
            return size == newSize
        }
        
        func scaleImage(_ newSize: CGSize) -> UIImage? {
            func getScaledRect(_ newSize: CGSize) -> CGRect {
                let ratio   = max(newSize.width / size.width, newSize.height / size.height)
                let width   = size.width * ratio
                let height  = size.height * ratio
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
            
            func _scaleImage(_ scaledRect: CGRect) -> UIImage? {
                UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
                draw(in: scaledRect)
                let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
                UIGraphicsEndImageContext()
                return image
            }
            return _scaleImage(getScaledRect(newSize))
        }
        
        return isSameSize(newSize) ? self : scaleImage(newSize)!
    }
}



