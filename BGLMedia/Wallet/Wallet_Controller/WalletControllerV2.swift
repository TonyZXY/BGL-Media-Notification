//
//  WalletControllerV2.swift
//  BGLMedia
//
//  Created by Bruce Feng on 29/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class WalletControllerV2: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sdf")
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    lazy var CoinListTableView:UITableView = {
        var tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    


}
