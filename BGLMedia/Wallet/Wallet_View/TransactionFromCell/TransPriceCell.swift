//
//  TransPriceCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

protocol TestField {
    func getField()->String
}

class TransPriceCell:UITableViewCell{
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
        createpricedonebutton()
//        setPriceTypebutton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let priceLabel:UILabel = {
        let label = UILabel()
        label.text = "买入价格"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let price: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
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
    
    
    
    let priceType: InsetLabel = {
        let label = InsetLabel()
        label.layer.backgroundColor = ThemeColor().greyColor().cgColor
        label.layer.cornerRadius = 8
        label.textColor = ThemeColor().whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(priceLabel)
        addSubview(price)
        addSubview(priceType)
        
        
        price.attributedPlaceholder = NSAttributedString(string:textValue(name: "pricePlaceholder"), attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: ThemeColor().whiteColor()])
        
        NSLayoutConstraint(item: priceLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: price, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: priceType, attribute: .centerY, relatedBy: .equal, toItem: priceLabel, attribute: .centerY, multiplier: 1, constant: 5).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-5-[v3]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
    }
    
    func createpricedonebutton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(pricedoneclick))
        toolbar.setItems([donebutton], animated: false)
        price.inputAccessoryView = toolbar
    }

    
    @objc func pricedoneclick(){
        self.endEditing(true)
    }
}
