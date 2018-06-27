//
//  AdditionalCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransAdditionalCell:UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
        createKeyboarddonebutton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let additionalLabel:UILabel = {
        let label = UILabel()
        label.text = "附加信息"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let additional: UITextField = {
        let textfield = UITextField()
        textfield.textColor = UIColor.white
        //            textfield.leftView?.frame = CGRect(x:10, y: 10, width: 200, height: 30)
        //            textfield.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // Create a padding view for padding on left
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.rightViewMode = .always
        textfield.clipsToBounds = false
        
        //            let paddingView = UIView(frame: CGRect(x: 30, y: 0, width: 15, height: textfield.frame.height))
        
        textfield.layer.cornerRadius = 8;
        //            textfield.layer.masksToBounds = false;
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.layer.borderWidth = 1
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.keyboardType = UIKeyboardType.default
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(additionalLabel)
        addSubview(additional)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":additionalLabel,"v1":additional]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":additionalLabel,"v1":additional]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1(30)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":additionalLabel,"v1":additional]))
    }
    
    func createKeyboarddonebutton(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(doneclick))
        toolbar.setItems([donebutton], animated: false)
        additional.inputAccessoryView = toolbar
    }
    
    @objc func doneclick(){
        self.endEditing(true)
    }
}
