//
//  TransTimeCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransTimeCell:UITableViewCell, UITextFieldDelegate{
    var factor:CGFloat?{
        didSet{
            setupviews()
//            time.delegate = self
//            createdatepicker()
//            doneclick()
        }
    }
    
    let datepicker = UIDatePicker()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //            textField.resignFirstResponder()
        //            self.window?.endEditing(true)
        return true
    }
    
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = UIFont.semiBoldFont(15*factor!)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var time: UITextField = {
        let textfield:UITextField = UITextField()
        textfield.textColor = UIColor.white
        textfield.keyboardType = UIKeyboardType.default
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.frame = CGRect(x:50*factor!, y: 70*factor!, width: 200*factor!, height: 30*factor!)
        textfield.tintColor = .clear
//        let rightview = UIView(frame: CGRect(x: 0, y: 0, width: 30*factor!, height: textfield.frame.height))
//        let label = UILabel()
//        label.text = "▼"
//        label.font = UIFont.semiBoldFont(13*factor!)
//        label.textColor = ThemeColor().whiteColor()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        rightview.addSubview(label)
//        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: rightview, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: rightview, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
//        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15*factor!, height: textfield.frame.height))
//        textfield.leftViewMode = .always
//        textfield.rightView = rightview
//        textfield.rightViewMode = .always
        textfield.borderStyle = UITextBorderStyle.roundedRect
        textfield.textAlignment = .center
        textfield.clipsToBounds = false
        textfield.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textfield.minimumFontSize=14  //最小可缩小的字号
        textfield.layer.cornerRadius = 8*factor!
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupviews(){
//        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0
//        layer.masksToBounds = false
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(timeLabel)
        addSubview(time)
        
        NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: time, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v0]-\(10*factor!)-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":timeLabel,"v1":time]))
    }
    
//    func createdatepicker(){
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
//        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
//        let cancelbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelclick))
//        toolbar.setItems([cancelbutton,flexible,donebutton], animated: false)
//        toolbar.backgroundColor = ThemeColor().whiteColor()
////        datepicker.backgroundColor = ThemeColor().whiteColor()
//        datepicker.datePickerMode = .time
//        datepicker.maximumDate = Date()
//        time.inputAccessoryView = toolbar
//        time.inputView = datepicker
//    }
    
//    @objc func doneclick(){
//        let formatter = DateFormatter()
//        formatter.dateStyle = .none
//        formatter.timeStyle = .short
//        let dataString = formatter.string(from: datepicker.date)
//        time.text = "\(dataString)"
//        self.endEditing(true)
//    }
//
//    @objc func cancelclick(){
//        self.endEditing(true)
//    }
}
