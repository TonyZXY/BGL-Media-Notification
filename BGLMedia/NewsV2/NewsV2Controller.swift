//
//  NewsV2Controller.swift
//  BGLMedia
//
//  Created by Bruce Feng on 9/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class NewsV2Controller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setUpView(){
        view.addSubview(newsTableView)
    }

    lazy var newsTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
}
