//
//  FlashSearchController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 6/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class FlashSearchController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    let realm = try! Realm()
    var results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)
    var newsFlashResult = [NewsFlash]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchFlashNewsTableView{
            if newsFlashResult.count == 0{
                resultLabel.text = textValue(name: "searchNull_flash")
            } else {
                resultLabel.text = textValue(name: "searchLabel_flash") + " " + String(newsFlashResult.count) + " " + textValue(name: "searchResult_flash")
            }
            return newsFlashResult.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchFlashNewsTableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! FlashNewsResultCell
        let object = newsFlashResult[indexPath.row]
        //        print(object.id)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
        cell.factor = view.frame.width/375
        cell.dateLabel.text = Extension.method.convertTimetoLocalization(convert: dateFormatter.string(from: object.dateTime))
        
        cell.detailLabel.text = object.contents
        print(object.title)
        cell.titleLabel.text = object.title
        cell.shareButton.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    
    @objc func shareButtonClicked(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 0, y: 0), to:searchFlashNewsTableView)
        let indexPath = searchFlashNewsTableView.indexPathForRow(at: buttonPosition)
        let cell = searchFlashNewsTableView.cellForRow(at: indexPath!)! as! FlashNewsResultCell
        let shareView = ShareNewsFlashControllerV2()
        shareView.newsdate = cell.dateLabel.text!
        shareView.newsdescriptions = cell.detailLabel.text!
        present(shareView, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            view.endEditing(true)
            newsFlashResult.removeAll()
            searchFlashNewsTableView.reloadData()
        } else{
            storeData() { (response, success) in
                if success{
                    self.newsFlashResult.removeAll()
                    if response.count != 0{
                        for value in response{
                            self.newsFlashResult.append(value)
                        }
                    } else{
                        self.newsFlashResult.removeAll()
                    }
                    self.searchFlashNewsTableView.reloadData()
                    self.spinner.stopAnimating()
                } else{
                    self.spinner.stopAnimating()
                }
            }
        }
    }
    
    func storeData(completion:@escaping ([NewsFlash],Bool)->Void){
        resultLabel.text = "" 
        spinner.startAnimating()
        URLServices.fetchInstance.passServerData(urlParameters: ["api","searchFlash?patten=" + searchBar.text! + "&languageTag=EN"], httpMethod: "GET", parameters: [String:Any]()) { (response, success) in
            if success{
                let json = response
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                var searchArrayObject = [NewsFlash]()
                if let collection = json.array {
                    for item in collection {
                        let searchObject = NewsFlash()
                        searchObject.id = item["_id"].string!
                        searchObject.contents = item["shortMassage"].string!
                        searchObject.title = item["title"].string!
                        searchObject.dateTime = dateFormatter.date(from: item["publishedTime"].string!)!
                        searchArrayObject.append(searchObject)
                    }
                }
                completion(searchArrayObject,true)
            } else{
                completion([NewsFlash](),false)
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
 
//    override func viewWillAppear(_ animated: Bool) {
////        searchFlashNewsTableView.estimatedRowHeight = 100
////        //        tableView.rowHeight = 100
////        searchFlashNewsTableView.rowHeight = UITableViewAutomaticDimension
//    }
    
    func setUpView(){
        let factor = view.frame.width/375
        searchBar.becomeFirstResponder()
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(searchFlashNewsTableView)
        view.addSubview(searchBar)
        view.addSubview(resultLabel)
        resultLabel.addSubview(spinner)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchFlashNewsTableView,"v1":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]-\(5*factor)-[v2(\(30*factor))]-\(5*factor)-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchFlashNewsTableView,"v1":searchBar,"v2":resultLabel]))
        
        
        NSLayoutConstraint(item: resultLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: resultLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: resultLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchFlashNewsTableView,"v1":searchBar,"v2":resultLabel]))
        resultLabel.layer.cornerRadius = 15 * factor
    }
    
    
    lazy var searchFlashNewsTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = ThemeColor().darkGreyColor()
        tableView.separatorStyle = .none
        tableView.register(FlashNewsResultCell.self, forCellReuseIdentifier: "searchResultCell")
        return tableView
    }()
    
    var resultLabel:InsetLabel = {
        var label = InsetLabel()
        label.layer.backgroundColor = ThemeColor().blueColorTran().cgColor
        label.textColor = ThemeColor().whiteColor()
        label.layer.cornerRadius = 15
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.tintColor = ThemeColor().darkBlackColor()
        searchBar.barTintColor = ThemeColor().darkBlackColor()
        searchBar.layer.borderColor = ThemeColor().darkBlackColor().cgColor
        
        var searchTextField:UITextField? = searchBar.value(forKey: "searchField") as? UITextField
        if (searchTextField?.responds(to: #selector(getter: UITextField.attributedPlaceholder)))!{
            searchTextField!.attributedPlaceholder = NSAttributedString(string:textValue(name: "search_placeholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13), NSAttributedStringKey.foregroundColor: ThemeColor().textGreycolor()])
        }
        
        return searchBar
    }()
    
    var spinner:UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView()
        spinner.tintColor = UIColor.white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    
}

class FlashNewsResultCell:UITableViewCell{
    
    
    var factor:CGFloat?{
        didSet{
             setUpView()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    var object:String?{
        didSet{
          
//            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: detailLabel.frame.height + 200).isActive = true
            
//            self.frame =  CGRect(x: 0, y: 0, width: self.frame.width, height: dateLabel.frame.height + 200)
        }
    }
    
    func setUpView(){
        backgroundColor = ThemeColor().darkGreyColor()
        selectionStyle = .none
        addSubview(cellView)
        cellView.addSubview(dateLabel)
        cellView.addSubview(detailLabel)
        cellView.addSubview(shareButton)
        cellView.addSubview(titleLabel)
        
        
        cellView.layer.cornerRadius = 8 * factor!
        dateLabel.font = UIFont.semiBoldFont(18 * factor!)
        detailLabel.font = UIFont.regularFont(15 * factor!)
        titleLabel.font = UIFont.boldFont(16 * factor!)
        shareButton.layer.cornerRadius = 15 * factor!
        shareButton.contentEdgeInsets = UIEdgeInsetsMake(5 * factor!, 10 * factor!, 5 * factor!, 10 * factor!)
        shareButton.imageEdgeInsets = UIEdgeInsetsMake(20 * factor!, 0, 20 * factor!, 0)
        shareButton.titleLabel!.font =  UIFont.semiBoldFont(13 * factor!)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor!)-[v0]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(10*factor!)-[v0]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1(\(40*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor!)-[v4]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton,"v4":titleLabel]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor!)-[v2]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(10*factor!)-[v4]-\(8 * factor!)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton,"v4":titleLabel]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-\(5*factor!)-[v3]-\(10*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    var cellView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
//        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dateLabel:InsetLabel = {
       var label = InsetLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.semiBoldFont(18)
        label.textColor = ThemeColor().whiteColor()
        label.backgroundColor = ThemeColor().darkBlackColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 2
        return label
    }()
    
    var detailLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var shareButton:UIButton = {
        var button = UIButton()
        button.backgroundColor = ThemeColor().darkBlackColor()
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.layer.cornerRadius = 15
        button.imageView?.contentMode = .scaleAspectFit
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        button.imageEdgeInsets = UIEdgeInsetsMake(20, 0, 20, 0)
        button.titleLabel!.font =  UIFont.semiBoldFont(13)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share", for: .normal)
        button.setImage(UIImage(named: "share_.png"), for: .normal)
        return button
    }()
    
}

