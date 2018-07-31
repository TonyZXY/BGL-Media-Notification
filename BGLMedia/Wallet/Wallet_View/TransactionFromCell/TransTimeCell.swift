//
//  TransTimeCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransTimeCell:UITableViewCell, UITextFieldDelegate{ 
    let datepicker = UIDatePicker()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
        time.delegate = self
        createdatepicker()
        doneclick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //            textField.resignFirstResponder()
        //            self.window?.endEditing(true)
        
        return true
    }
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.text = "购买时间"
        label.textColor = ThemeColor().textGreycolor()
        label.font = UIFont.semiBoldFont(18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let time: UITextField = {
        let textfield:UITextField = UITextField()
        textfield.textColor = UIColor.white
        textfield.keyboardType = UIKeyboardType.default
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.tintColor = .clear
        let rightview = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: textfield.frame.height))
        let label = UILabel()
        label.text = "▼"
        label.font = UIFont.regularFont(15)
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
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupviews(){
        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.masksToBounds = false
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(timeLabel)
        addSubview(time)
        
        NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: time, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-10-[v1(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
    }
    
    func createdatepicker(){
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button item
        let done = UIBarButtonItem(barButtonSystemItem:.done, target: self, action:#selector(doneclick))
        toolbar.setItems([done], animated: false)
        datepicker.datePickerMode = .time
        time.inputAccessoryView = toolbar
        time.inputView = datepicker
    }
    
    @objc func doneclick(){
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let dataString = formatter.string(from: datepicker.date)
        time.text = "\(dataString)"
        self.endEditing(true)
    }
}
