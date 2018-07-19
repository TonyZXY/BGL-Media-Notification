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
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let number: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
        //            textfield.resignFirstResponder()
        textfield.textColor = ThemeColor().whiteColor()
        textfield.tintColor = ThemeColor().whiteColor()
        textfield.frame = CGRect(x:0, y: 0, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
//        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
//        textfield.leftViewMode = .always
//        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
//        textfield.rightViewMode = .always
//        textfield.clipsToBounds = false
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(numberLabel)
        addSubview(number)
        
        number.attributedPlaceholder = NSAttributedString(string:textValue(name: "amountPlaceholder"), attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white])
        

        
        NSLayoutConstraint(item: numberLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: number, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 5).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
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
