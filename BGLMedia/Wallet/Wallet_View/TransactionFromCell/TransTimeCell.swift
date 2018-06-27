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
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let time: UITextField = {
        let textfield:UITextField = UITextField()
        textfield.textColor = UIColor.white
        textfield.keyboardType = UIKeyboardType.default
        textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(timeLabel)
        addSubview(time)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
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
