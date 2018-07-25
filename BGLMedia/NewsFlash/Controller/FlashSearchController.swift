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
        cell.detailLabel.text = "scddsdcscsdcdscsdcsdcdsccdscsdcsdcdscdscdscdscdscdscdscdcdcdcdcdscdcdcdscdscdscdscdscdscdscdscdscdscdscdscdcdscdscdscdcdcdscdcdscdscdcdscdcdcdscdscdsc"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchFlashNewsTableView.estimatedRowHeight = 100
        //        tableView.rowHeight = 100
        searchFlashNewsTableView.rowHeight = UITableViewAutomaticDimension
    }

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
////        tableView.estimatedRowHeight = 80.0
////        tableView.rowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(FlashNewsResultCell.self, forCellReuseIdentifier: "searchResultCell")
        return tableView
    }()

    
    
}

class FlashNewsResultCell:UITableViewCell{

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    
    }
    
    func setUpView(){
        addSubview(cellView)
        cellView.addSubview(detailLabel)
        cellView.addSubview(dateLabel)
        cellView.addSubview(shareButton)
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-9-[v0(300)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v2]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-5-[v2(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-5-[v3(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView,"v1":dateLabel,"v2":detailLabel,"v3":shareButton]))
        
        
//        NSLayoutConstraint(item: cellView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: cellView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: cellView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: cellView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
//
//        NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30).isActive = true
//
//        NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: detailLabel, attribute: .left, relatedBy: .equal, toItem: dateLabel, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: detailLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: detailLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 200).isActive = true
//
//        NSLayoutConstraint(item: shareButton, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: shareButton, attribute: .right, relatedBy: .equal, toItem: dateLabel, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: shareButton, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 50).isActive = true
        
        
        
        
        
        
        
//        NSLayoutConstraint(item: shareButton, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
//        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v2]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
//        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    var cellView:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dateLabel:UILabel = {
       var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "pppp"
        label.backgroundColor = UIColor.red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = UIColor.green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var shareButton:UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = UIColor.yellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

