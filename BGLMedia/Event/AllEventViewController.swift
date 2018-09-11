//
//  AllEventViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 10/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class AllEventViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = ThemeColor().whiteColor()
        label.text = "2018-03-04"
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventList") as! EventListTableViewCell
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    func setUpView(){
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(listTableView)
        listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    lazy var listTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: "EventList")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().darkGreyColor()
        return tableView
    }()
    
    
    

}

class EventListTableViewCell:UITableViewCell{
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    
    func setUpView(){
        selectionStyle = .none
        backgroundColor = ThemeColor().darkGreyColor()
        addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        cellView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
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
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 2
        label.text = "The Future of Blockchain, Digital Assets & Interoperability"
        return label
    }()
    
    
}


