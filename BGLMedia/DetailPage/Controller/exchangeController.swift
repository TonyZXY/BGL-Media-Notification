////
////  exchangeController.swift
////  BGLMedia
////
////  Created by Bruce Feng on 22/7/18.
////  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
////
//
//import UIKit
//
//class exchangeController: UIViewController,UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "exchangeCell")
//        cell?.textLabel?.text = "hkhkhjkk"
//        return cell!
//    }
//    
//
////    override func loadView() {
////        view = exchangeTableView
////    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpView()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
////        indicatorView.center = view.center
//        preferredContentSize.height = exchangeTableView.contentSize.height
//    }
//
//    func setUpView(){
//        view.addSubview(exchangeTableView)
//        exchangeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "exchangeCell")
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":exchangeTableView]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":exchangeTableView]))
//    }
//    
//    lazy var exchangeTableView:UITableView = {
//        var tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "exchangeCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 50
//        return tableView
//    }()
//    
////    struct UI {
////        static let rowHeight = CGFloat(50)
////        static let separatorColor: UIColor = UIColor.lightGray.withAlphaComponent(0.4)
////    }
////
////
////    fileprivate lazy var exchangeTableView: UITableView = { [unowned self] in
////        $0.dataSource = self
////        $0.delegate = self
////        $0.rowHeight = UI.rowHeight
////        $0.separatorColor = UI.separatorColor
////        $0.bounces = true
////        $0.backgroundColor = nil
////        $0.tableFooterView = UIView()
////        $0.sectionIndexBackgroundColor = .clear
////        $0.sectionIndexTrackingBackgroundColor = .clear
////        return $0
////        }(UITableView(frame: .zero, style: .plain))
//}
