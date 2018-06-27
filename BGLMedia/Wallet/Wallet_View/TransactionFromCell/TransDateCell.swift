//
//  TransDateCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransDateCell:UITableViewCell,UITextFieldDelegate {
    let datepicker = UIDatePicker()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
        date.delegate = self
        createdatepicker()
        doneclick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.text = "购买日期"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let date: UITextField = {
        let textfield = UITextField()
        //            textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textColor = UIColor.white
        return textfield
    }()
    
    
    
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(dateLabel)
        addSubview(date)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":date]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":date]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1(30)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":date]))
    }
    
    func createdatepicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let done = UIBarButtonItem(barButtonSystemItem:.done, target: self, action:#selector(doneclick))
        toolbar.setItems([done], animated: false)
        datepicker.datePickerMode = .date
        date.inputAccessoryView = toolbar
        date.inputView = datepicker
    }
    
    @objc func doneclick(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dataString = formatter.string(from: datepicker.date)
        date.text = "\(dataString)"
        self.endEditing(true)
    }
}
