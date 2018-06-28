//
//  priceNotificationCell.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 26/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import Foundation
import UIKit

class priceNotificationCell:UITableViewCell,UITextFieldDelegate{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        createKeyboarddonebutton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func setUpView(){
        selectionStyle = .none
        
        addSubview(priceTypeLabel)
        addSubview(priceTextField)
//        addSubview(dateLabel)
//        addSubview(coinDetailLabel)
        
//        NSLayoutConstraint(item: priceTypeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 80).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-30-[v0(50)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceTypeLabel,"v1":priceTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceTypeLabel,"v1":priceTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(40)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceTypeLabel,"v1":priceTextField]))
        

        NSLayoutConstraint(item: priceTypeLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: priceTypeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceTextField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10).isActive = true
//         NSLayoutConstraint(item: priceTextField, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: priceTypeLabel, attribute: .leading, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: dateLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-30-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceTypeLabel,"v1":priceTextField]))
//        NSLayoutConstraint(item: coinDetailLabel, attribute: .leading, relatedBy: .equal, toItem: compareLabel, attribute: .leading, multiplier: 1, constant: 0).isActive = true
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-5-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":coinDetailLabel,"v1":compareLabel]))
        
    }
    
    var priceTypeLabel:UILabel = {
        var label = UILabel()
//        label.layer.borderWidth = 3
        label.font = label.font.withSize(14)
//        label.layer.borderColor = UIColor.yellow.cgColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceTextField:UITextField = {
        var textField = UITextField()
        textField.keyboardType = UIKeyboardType.decimalPad
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textField.frame.height - 1, width: textField.frame.width, height: 3.0)
        bottomLine.backgroundColor = UIColor.red.cgColor
        textField.borderStyle = UITextBorderStyle.bezel
//        textField.layer.addSublayer(bottomLine)
        textField.translatesAutoresizingMaskIntoConstraints = false
//
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
//            , target: self, action: #selector(doneclick))
//        toolbar.setItems([donebutton], animated: false)
//        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    func createKeyboarddonebutton(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(doneclick))
        toolbar.setItems([donebutton], animated: false)
        priceTextField.inputAccessoryView = toolbar
     
    }
    
    @objc func doneclick(){
        self.endEditing(true)
    }
    
    //        let myTextField = UITextField()
    //        let bottomLine = CALayer()
    //        bottomLine.frame = CGRect(x: 0.0, y: myTextField.frame.height - 1, width: myTextField.frame.width, height: 1.0)
    //        bottomLine.backgroundColor = UIColor.white.cgColor
    //        myTextField.borderStyle = UITextBorderStyle.none
    //        myTextField.layer.addSublayer(bottomLine)
    
    
    var dateLabel:UILabel = {
        var label = UILabel()
        label.text = "haha"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var coinDetailLabel:UILabel = {
        var label = UILabel()
        label.text = "haha"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
}
