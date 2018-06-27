//
//  TransNumberCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransNumberCell:UITableViewCell, UITextFieldDelegate{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) 
        setupviews()
        _ = createKeyboarddonebutton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let numberLabel:UILabel = {
        let label = UILabel()
        label.text = "购买数量"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let number: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
        //            textfield.resignFirstResponder()
        textfield.textColor = UIColor.white
        textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(numberLabel)
        addSubview(number)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1(30)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
    }
    
    func createKeyboarddonebutton()->UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(doneclick))
        toolbar.setItems([donebutton], animated: false)
        number.inputAccessoryView = toolbar
        return toolbar
    }
    
    @objc func doneclick(){
        self.endEditing(true)
    }
}
