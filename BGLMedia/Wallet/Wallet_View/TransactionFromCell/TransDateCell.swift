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
        label.font = label.font.withSize(18)
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let date: UITextField = {
        let textfield = UITextField()
        //            textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.textColor = UIColor.white
        textfield.font = textfield.font?.withSize(15)
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.tintColor = .clear
        textfield.autocorrectionType = .yes
        
        let rightview = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textfield.frame.height))
        let label = UILabel()
        label.text = "▼"
        label.font = label.font.withSize(15)
        label.textColor = ThemeColor().whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        rightview.addSubview(label)
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: rightview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: rightview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftViewMode = .always
        textfield.rightView = rightview
        textfield.rightViewMode = .always
        textfield.clipsToBounds = false
        textfield.layer.cornerRadius = 8
        return textfield
    }()
    
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(dateLabel)
        addSubview(date)
        NSLayoutConstraint(item: dateLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: date, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-10-[v1(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":date]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":dateLabel,"v1":date]))
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
