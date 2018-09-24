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
    
    var dictionary = [String:Int]()
    //    var resultsUpdated = false
    var changeLaugageStatus:Bool = false
    var displayNumber:Int = 0
    var loadMoreData:Bool = false
    var resultNumber: Int = 0
    var deleteCacheStatus:Bool = false
    var deletedNumber: Int = 0;
    var testNumber: Int = 0
    var times: Int = 0
    

    
    var sectionArray = [Int]()
    var dates = [String]()
    var newsFlashArray = [NewsFlash]()
    var results:Results<NewsFlash>{
        get{
            
            return try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)
        }
    }
    var resultNew = [Int:[NewsFlash]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.resultsUpdated = false
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: nil)
        self.tableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "TimelineTableViewCell")
        setUpView()

        
        //Prevent empty rows
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = ThemeColor().themeColor()
        self.tableView.separatorStyle = .none
        self.tableView.autoresizingMask = .flexibleHeight
        self.tableView.switchRefreshFooter(to: .removed)
        
        DispatchQueue.main.async(execute: {
            self.tableView.switchRefreshHeader(to: .refreshing)
        })
        
        self.displayNumber += 5
        getNews(skip:0,limit: 5){ success in
            if success{
                self.tableView.reloadData()
                let footer = DefaultRefreshFooter.footer()
                footer.textLabel.textColor = ThemeColor().whiteColor()
                footer.tintColor = ThemeColor().whiteColor()
                footer.textLabel.backgroundColor = ThemeColor().themeColor()
                self.tableView.configRefreshFooter(with: footer, container: self, action: {
                    self.times = 0
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
        
        if results.count != 0 {
            resultNew.removeAll()
            var indexx = 0
            for i in 0...(results.count < 5 ? results.count-1 : 4){
                if i == 0{
                    self.resultNew[0] = [NewsFlash]()
                    self.resultNew[0]?.append(self.results[0])
                } else{
                    let timeArray:[String] = Extension.method.convertDateToString(date: self.results[i-1].dateTime).description.components(separatedBy: " ")
                    let timeArray2:[String] = Extension.method.convertDateToString(date: self.results[i].dateTime).description.components(separatedBy: " ")
                    
                    if timeArray2[0] == timeArray[0]{
                        self.resultNew[indexx]?.append(self.results[i])
                    } else{
                        indexx += 1
                        self.resultNew[indexx] = [NewsFlash]()
                        self.resultNew[indexx]?.append(self.results[i])
                    }
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCache), name: NSNotification.Name(rawValue: "deleteCache"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeFontSize), name: NSNotification.Name(rawValue: "changeFontSize"), object: nil)
        
    }
    
    @objc func deleteCache(){
        self.resultNew.removeAll()
        self.tableView.switchRefreshFooter(to: .normal)
        deleteCacheStatus = true
        
    }
    
    @objc func changeLanguage(){
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
        
        tableView.reloadData()
    }
    
    @objc func changeFontSize(){
        self.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver("changeLanguage")
        NotificationCenter.default.removeObserver("changeFontSize")
        NotificationCenter.default.removeObserver("deleteCache")
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
        return cell.bounds.height
    }

    

    
    override func viewWillAppear(_ animated: Bool) {
        if deleteCacheStatus{
                tableView.reloadData()
                tableView.switchRefreshHeader(to: .refreshing)
                self.tableView.switchRefreshFooter(to: .normal)
                self.deleteCacheStatus = false

        }
    }
    
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !resultNew.isEmpty && !(resultNew[section]?.isEmpty)!{
            return (resultNew[section]?.count)!
        } else {
            return 0
        }

    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("hhahhah")
//    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("hhahhah")
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("sfsdfdsfs")
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !resultNew.isEmpty{
            return (resultNew.keys.count)
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let width =  tableView.frame.size.width
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 20, width: 200, height: 80))
        sectionHeaderView.backgroundColor = ThemeColor().themeColor()
        let label = UILabel(frame: CGRect(x: 20, y: 10, width: width-2*20, height: 20))
        
        label.font = UIFont.boldFont(15)
        label.textColor = ThemeColor().blueColor()
        label.textAlignment = .center
        if results.count != 0 {
            let currentDay = resultNew[section]![0].dateTime
            let timeArr = Extension.method.convertDateToString(date: currentDay).description.components(separatedBy: " ")
            label.text = convertDateForDisplay(convert: timeArr[0])
        }
        let currentDay = resultNew[section]![0].dateTime
        let timeArr = Extension.method.convertDateToString(date: currentDay).description.components(separatedBy: " ")
        label.text = convertDateForDisplay(convert: timeArr[0])
        label.layer.cornerRadius = 8
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
        
        
        let identifier = "TimelineTableViewCell"
        var cell:TimelineTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TimelineTableViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "TimelineTableViewCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = TimelineTableViewCell(style:UITableViewCellStyle.default,reuseIdentifier:"TimelineTableViewCell")
        }

        if results.count != 0 {
            let object = resultNew[indexPath.section]![indexPath.row]
                cell.likeButton.isHidden = true
                cell.shareButton.isHidden = true
            
                let formatter = DateFormatter()
                if defaultLanguage == "CN"{
                    formatter.locale = Locale(identifier: "zh")
                }else{
                    formatter.locale = Locale(identifier: "en")
                }

            
                formatter.dateStyle = .long
                formatter.timeStyle = .short

            
                let bglGreen = ThemeColor().blueColor()
                cell.timelinePoint = TimelinePoint(diameter: CGFloat(16.0), color: bglGreen, filled: false)
                cell.timelinePointInside = TimelinePoint(diameter: CGFloat(4.0), color: bglGreen, filled: true, insidePoint: true)
                cell.timeline.backColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
                cell.titleLabel.text = formatter.string(from: object.dateTime)
                cell.titleLabel.numberOfLines = 1
                cell.txtTitleLabel.text = object.title
                cell.descriptionLabel.text = object.contents
            
                cell.object = object
                cell.likesButton.setTitle(Extension.method.scientificMethodInLike(number: object.like), for: .normal)
            
                let imageOfLike = UIImage(named: "likeButton")
                let tintedImage = imageOfLike?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                cell.likesButton.setImage(tintedImage, for: .normal)
            if object.checked{
                cell.likesButton.tintColor = ThemeColor().redColor()
            } else{
                cell.likesButton.tintColor = ThemeColor().whiteColor()
            }
                cell.likesButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
                cell.sharesbutton.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
           
        }
         return cell
        
    }

    @objc func likeButtonClicked(sender: UIButton){
        if !UserDefaults.standard.bool(forKey: "isLoggedIn"){
            let login = LoginController(usedPlace: 0)
            self.present(login, animated: true, completion: nil)
        } else {
            let buttonPosition:CGPoint = sender.convert(CGPoint(x: 0, y: 0), to:self.tableView)
            let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
            let cell = tableView.cellForRow(at: indexPath!)! as! TimelineTableViewCell
            sender.loadingIndicator(true)
            
            changelikeNumberAndcheck(object: cell.object!) { success in
                sender.loadingIndicator(false)
                sender.setTitle(Extension.method.scientificMethodInLike(number: (cell.object?.like)!), for: .normal)
                sender.sizeToFit()
                let imageOfLike = UIImage(named: "likeButton")
                let tintedImage = imageOfLike?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                sender.setImage(tintedImage, for: .normal)
                if success {
                    sender.tintColor = sender.tintColor == ThemeColor().whiteColor() ? ThemeColor().redColor() : ThemeColor().whiteColor()
                }
            }
        }
    }
    
    func changelikeNumberAndcheck(object: NewsFlash ,completion:@escaping (Bool)->Void){
        let realm = try! Realm()
        let body = ["email":UserDefaults.standard.string(forKey: "UserEmail")!,"token": UserDefaults.standard.string(forKey: "CertificateToken")!, "newsID": object.id]
        
        
//            self.realm.beginWrite()
            if object.checked {
                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","unlike"], httpMethod: "POST", parameters: body,
                                                         completion: { (response, success) in
                                                            if success{
//                                                                print(response)
                                                                if response["success"].bool! {
                                                                    try! realm.write {
                                                                        object.like = response["data"]["likes"].int ?? 0
                                                                        object.checked = !object.checked
                                                                    }
                                                                    
//                                                                    try! self.realm.commitWrite()
                                                                    completion(true)
                                                                } else{
//                                                                    try! self.realm.commitWrite()
                                                                    completion(false)
                                                                }

                                                            } else{
                                                                try! realm.commitWrite()
                                                                completion(false)
                                                            }
                })
            } else{
                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","like"], httpMethod: "POST", parameters: body,
                                                         completion: { (response, success) in
                    if success{
//                        print(response)
                        if response["success"].bool! {
                             try! realm.write {
                                object.like = response["data"]["likes"].int ?? 0
                                object.checked = !object.checked
                            }
                       
//                        try! self.realm.commitWrite()
                        completion(true)
                        } else {
//                            try! self.realm.commitWrite()
                            completion(false)
                        }
                    } else{
//                        try! self.realm.commitWrite()
                        completion(false)
                    }
                })
                
            }

        
        
        
    }
    
    
    
    @objc func shareButtonClicked(sender: UIButton){
        
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 0, y: 0), to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: indexPath!)! as! TimelineTableViewCell
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
//                print(response)
                self.resultNumber = response.count
                self.JSONtoData(json: response){ success in
                    completion(true)
                }
            } else{
                completion(false)
            }
        }
    }
    
    private func JSONtoData(json: JSON,completion:@escaping (Bool)->Void) {
        let realm = try! Realm()
        deletedNumber = 0
        realm.beginWrite()
        if let collection = json.array {
            for item in collection {
                //                dateFormatter.timeZone = TimeZone.current
                let date = Extension.method.convertStringToDate(date: item["publishedTime"].string ?? "")
                let id = "\(item["_id"].string!)"
                let toSent = item["toSent"].bool ?? false
                let title = item["title"].string ?? ""
                let availabilty = item["available"].bool ?? true
                let like = item["like"].int ?? 0
                if realm.object(ofType: NewsFlash.self, forPrimaryKey: id) == nil {
                    if availabilty{
                        realm.create(NewsFlash.self, value: [id, date, item["shortMassage"].string ?? "","EN",toSent,title,like])
                    } else{
                        deletedNumber += 1
                    }
                } else {
                                        print("updating")
                    if !availabilty {
                        realm.delete(realm.objects(NewsFlash.self).filter("id = %@",id))
                    }else{
                        realm.create(NewsFlash.self, value: [id, date, item["shortMassage"].string ?? "","EN",toSent,title, like], update: true)
                    }
                }
            }
        }
        try! realm.commitWrite()
        completion(true)
    }
    
    
    
    @objc func handleRefresh(_ tableView: UITableView) {
        getNews(skip: 0, limit: 5){ success in
            if success{
                self.displayNumber = 5
                self.resultNew.removeAll()
                var indexx = 0
                if self.results.count != 0{
                    for i in 0...(self.results.count < 5 ? self.results.count-1 : 4){
                        if i == 0{
                            self.resultNew[0] = [NewsFlash]()
                            self.resultNew[0]?.append(self.results[0])
                        } else{
                            let timeArray:[String] = Extension.method.convertDateToString(date: self.results[i-1].dateTime).description.components(separatedBy: " ")
                            let timeArray2:[String] = Extension.method.convertDateToString(date: self.results[i].dateTime).description.components(separatedBy: " ")
                            
                            if timeArray2[0] == timeArray[0]{
                                self.resultNew[indexx]?.append(self.results[i])
                            } else{
                                indexx += 1
                                self.resultNew[indexx] = [NewsFlash]()
                                self.resultNew[indexx]?.append(self.results[i])
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    
    func handleFooter(){
        print("\(displayNumber)+VS+\(results.count)")
                if displayNumber != 0{
                    self.displayNumber += 5
                    getNews(skip: displayNumber-5, limit: 5){ success in
                        if success{
                            
                            var indexx = self.resultNew.keys.count - 1
                            var startNumber = 0
                            for a in 0...indexx{
                                startNumber += (self.resultNew[a]?.count)!
                            }
                            startNumber -= 1
                            print(startNumber)
                            if(self.resultNumber != 0){
                                var addNumber = 5
                                if self.resultNumber < 5{
                                    addNumber = self.resultNumber
                                }
                                
                                for i in startNumber+1...startNumber+addNumber{
                                    let timeArray:[String] = Extension.method.convertDateToString(date: self.results[i-1].dateTime).description.components(separatedBy: " ")
                                    let timeArray2:[String] = Extension.method.convertDateToString(date: self.results[i].dateTime).description.components(separatedBy: " ")
                                    
                                    if timeArray2[0] == timeArray[0]{
                                        self.resultNew[indexx]?.append(self.results[i])
                                    } else{
                                        indexx += 1
                                        self.resultNew[indexx] = [NewsFlash]()
                                        self.resultNew[indexx]?.append(self.results[i])
                                    }
                                }
                            }
                            
                            self.tableView.reloadData()
                            self.tableView.switchRefreshFooter(to: .normal)
    
                            if self.displayNumber >= self.results.count{
                                self.tableView.switchRefreshFooter(to: .normal)
                                
                            }
                            if self.resultNumber < 5 {
                                self.tableView.switchRefreshFooter(to: .noMoreData)
                            }
                        } else {
                            if self.displayNumber >= self.results.count{
                                self.tableView.switchRefreshFooter(to: .normal)
                                
                            }
                        }
                    }
                }
                if self.resultNumber < 5 {
                    self.tableView.switchRefreshFooter(to: .noMoreData)
                }
        
//        }
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
    
    }
    
    
    func countTotalRows(currentSection: Int)-> Int{
        var totalRows: Int = 0
        for i in 0..<(currentSection+1){
            totalRows = totalRows + tableView.numberOfRows(inSection: i)
        }
        return totalRows
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



