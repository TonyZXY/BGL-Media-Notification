//
//  TransNumberCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransNumberCell:UITableViewCell, UITextFieldDelegate{
    var factor:CGFloat?{
        didSet{
            setupviews()
            _ = createKeyboarddonebutton()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    lazy var numberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBoldFont(18*factor!)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var number: LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
        //            textfield.resignFirstResponder()
        textfield.textColor = ThemeColor().whiteColor()
        textfield.tintColor = ThemeColor().whiteColor()
        textfield.frame = CGRect(x:0, y: 0, width: 200*factor!, height: 30*factor!)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string:textValue(name: "amountPlaceholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13*factor!), NSAttributedStringKey.foregroundColor: ThemeColor().grayPlaceHolder()])
//        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
//        textfield.leftViewMode = .always
//        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
//        textfield.rightViewMode = .always
//        textfield.clipsToBounds = false
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.layer.cornerRadius = 8*factor!
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(numberLabel)
        addSubview(number)
//        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0
//        layer.masksToBounds = false
        
       

        
        NSLayoutConstraint(item: numberLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -5*factor!).isActive = true
        NSLayoutConstraint(item: number, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 5*factor!).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v1]-\(16*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
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
