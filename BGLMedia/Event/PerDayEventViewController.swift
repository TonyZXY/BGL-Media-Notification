//
//  PerDayEventViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 10/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class PerDayEventViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "perdayTableView") as! EventPerDayTableViewCell
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    func setUpView(){
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(dateView)
        view.addSubview(perdayTableView)
        dateView.addSubview(dateTextField)
        dateView.addSubview(previousArrow)
        dateView.addSubview(nextArrow)
        
        dateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        dateView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        dateView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        dateView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dateTextField.centerXAnchor.constraint(equalTo: dateView.centerXAnchor, constant: 0).isActive = true
        dateTextField.centerYAnchor.constraint(equalTo: dateView.centerYAnchor, constant: 0).isActive = true
        dateTextField.topAnchor.constraint(equalTo: dateView.topAnchor, constant: 5).isActive = true
        dateTextField.bottomAnchor.constraint(equalTo: dateView.bottomAnchor, constant: -5).isActive = true
        dateTextField.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        previousArrow.rightAnchor.constraint(equalTo: dateTextField.leftAnchor, constant: -10).isActive = true
        previousArrow.centerYAnchor.constraint(equalTo: dateTextField.centerYAnchor, constant: 0).isActive = true
        previousArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        previousArrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        nextArrow.leftAnchor.constraint(equalTo: dateTextField.rightAnchor, constant: 10).isActive = true
        nextArrow.centerYAnchor.constraint(equalTo: dateTextField.centerYAnchor, constant: 0).isActive = true
        nextArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextArrow.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        perdayTableView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 10).isActive = true
        perdayTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        perdayTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        perdayTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
    var dateView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dateTextField:UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "2018-09-12"
        textField.layer.cornerRadius = 8
        textField.backgroundColor = ThemeColor().blueColor()
        textField.tintColor = .clear
        textField.textAlignment = .center
        return textField
    }()
    
    var previousArrow:UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("◀", for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        button.setTitleColor(ThemeColor().darkBlackColor(), for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    var nextArrow:UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("▶", for: .normal)
        button.backgroundColor = ThemeColor().blueColor()
        button.setTitleColor(ThemeColor().darkBlackColor(), for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var perdayTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventPerDayTableViewCell.self, forCellReuseIdentifier: "perdayTableView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = ThemeColor().darkGreyColor()
        tableView.separatorStyle = .none
        return tableView
    }()
    

}

class EventPerDayTableViewCell:UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    func setUpView(){
        selectionStyle = .none
        backgroundColor = ThemeColor().darkGreyColor()
        addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(addressLabel)
        cellView.addSubview(phoneNumber)
        
        
        cellView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        cellView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        
        
        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        
        phoneNumber.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5).isActive = true
        phoneNumber.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 10).isActive = true
        phoneNumber.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        phoneNumber.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5).isActive = true
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
        label.text = "The Future of Blockchain, Digital Assets & Interoperability"
        label.numberOfLines = 2
        return label
    }()
    
    var addressLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.text = "Address: 8 HAHAHA Sreet, Melbourne, Victoria, 3000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var phoneNumber:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.text = "Phone: 0403123456"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
}


