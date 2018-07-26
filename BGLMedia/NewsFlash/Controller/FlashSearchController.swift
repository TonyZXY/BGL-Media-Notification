//
//  FlashSearchController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 6/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class FlashSearchController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchFlashNewsTableView.dequeueReusableCell(withIdentifier: "searchResultCell") as! FlashNewsResultCell
        if indexPath.row == 0{
              cell.detailLabel.text = "scddsdcscsdcdscsdcsdcdsccdscsdcsdcdscdscdscdscdscdscdscdcdcdcdcdscdcdcdscdscdscdscdscdscdscdscdscdscdscdscdcdscdscdscdcdcdscdcdscdscdcdscdcdcdscdscdsc"
           
        } else{
             cell.detailLabel.text = "scddsdcscsdcdscsdcsdc"
        }
      
        cell.object = "food"
        return cell
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
        view.addSubview(searchFlashNewsTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchFlashNewsTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchFlashNewsTableView]))
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

    
    
}

class FlashNewsResultCell:UITableViewCell{
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    
    }
    
    var object:String?{
        didSet{
            print("dateLabel.frame.height")
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
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-5-[v3]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    var cellView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dateLabel:InsetLabel = {
       var label = InsetLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "sdsfsfsdf"
        label.font = UIFont.semiBoldFont(18)
        label.textColor = ThemeColor().whiteColor()
        label.backgroundColor = ThemeColor().darkBlackColor()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        var button = UIButton(type: .system)
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

