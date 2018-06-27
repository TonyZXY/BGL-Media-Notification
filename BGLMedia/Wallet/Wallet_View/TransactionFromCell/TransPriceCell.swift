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

class TransPriceCell:UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate{

    
    let items = ["单价","总额"]
    let pickerview = UIPickerView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
        createpricedonebutton()
        setPriceTypebutton()
        pricetypedoneclick()
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
//        textfield.placeholder = "输入买入价格"
        textfield.tintColor = UIColor.white
        textfield.textColor = UIColor.white
////        var myMutableStringTitle = NSMutableAttributedString(string:"Name", attributes: [kCTFontAttributeName as NSAttributedStringKey:UIFont(name: "Georgia", size: 20.0)!]) // Font
////        myMutableStringTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range:NSRange(location:0,length:Name.characters.count))
//
////        textfield.attributedPlaceholder = NSAttributedString(string:"Enter Title", attributes: [kCTForegroundColorAttributeName as NSAttributedStringKey: UIColor.white])
//        textfield.attributedPlaceholder = NSAttributedString(string: "good", attributes: [NSAttributedString:UIColor.white])
        
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    let priceType: UITextField = {
        let textfield = UITextField()
        textfield.textColor = UIColor.white
        textfield.layer.cornerRadius = 8;
        textfield.tintColor = .clear
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.layer.borderWidth = 1
        // Create a padding view for padding on left
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.rightViewMode = .always
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(priceLabel)
        addSubview(price)
        addSubview(priceType)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1(30)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v1]-5-[v3(100)]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(==v1)]", options: .alignAllCenterX, metrics: nil, views: ["v0":priceLabel,"v1":price,"v3":priceType]))
        let myLabelverticalConstraint = NSLayoutConstraint(item: priceType, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: price, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([myLabelverticalConstraint])
    }
    
    func createpricedonebutton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(pricedoneclick))
        toolbar.setItems([donebutton], animated: false)
        price.inputAccessoryView = toolbar
    }
    
    func setPriceTypebutton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(pricetypedoneclick))
        toolbar.setItems([donebutton], animated: false)
        priceType.inputAccessoryView = toolbar
        priceType.inputView = pickerview
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.selectRow(0, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @objc func pricetypedoneclick(){
        let row = pickerview.selectedRow(inComponent: 0)
        priceType.text = items[row] + "  ▼"
//        priceType.text = items[row]
        self.endEditing(true)
    }
    
    @objc func pricedoneclick(){
        self.endEditing(true)
    }
}
