//
//  ExpensesCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransExpensesCell:UITableViewCell,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    var items = ["币种"]
    let pickerview = UIPickerView()
    var selectitems: String = ""
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
        createKeyboarddonebutton()
        setExpenseTypeButton()
        expensesTypedoneclick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
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
//        selectitems = items[row]
    }
    
    let expensesLabel:UILabel = {
        let label = UILabel()
        label.text = "交易费用"
        label.textColor = UIColor.init(red:187/255.0, green:187/255.0, blue:187/255.0, alpha:1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let expenses: UITextField = {
        let textfield = UITextField()
        textfield.textColor = UIColor.white
        textfield.layer.cornerRadius = 8;
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.layer.borderWidth = 1
        textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        
        // Create a padding view for padding on left
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.rightViewMode = .always
        textfield.clipsToBounds = false
        return textfield
    }()
    
    let expensesbutton: UITextField = {
        let textfield = UITextField()
        textfield.textColor = UIColor.white
        textfield.layer.cornerRadius = 8;
        textfield.tintColor = .clear
//        textfield.text = "%BTC  ▼"
        textfield.layer.borderColor = UIColor.white.cgColor
        textfield.layer.borderWidth = 1
        // Create a padding view for padding on left
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textfield.frame.height))
        textfield.rightViewMode = .always
        textfield.clipsToBounds = false
        //            textfield.frame = CGRect(x:50, y: 70, width: 200, height: 30)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(expensesLabel)
        addSubview(expenses)
        addSubview(expensesbutton)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":expensesLabel,"v1":expenses]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v1(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":expensesLabel,"v1":expenses]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-10-[v1(30)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":expensesLabel,"v1":expenses]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v3(110)]-16-|", options: .alignAllCenterY, metrics: nil, views: ["v0":expensesLabel,"v1":expenses,"v3":expensesbutton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(==v1)]", options: .alignAllCenterX, metrics: nil, views: ["v0":expensesLabel,"v1":expenses,"v3":expensesbutton]))
        let myLabelverticalConstraint = NSLayoutConstraint(item: expensesbutton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: expenses, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([myLabelverticalConstraint])
    }
    
    func createKeyboarddonebutton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(expensesdoneclick))
        toolbar.setItems([donebutton], animated: false)
        expenses.inputAccessoryView = toolbar
    }
    
    func setExpenseTypeButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done
            , target: self, action: #selector(expensesTypedoneclick))
        toolbar.setItems([donebutton], animated: false)
        expensesbutton.inputAccessoryView = toolbar
        expensesbutton.inputView = pickerview
        pickerview.delegate = self
        pickerview.dataSource = self
        pickerview.selectRow(0, inComponent: 0, animated: true)
    }
    
    @objc func expensesTypedoneclick(){
        if items == []{
            pickerview.selectedRow(inComponent: 0)
            self.endEditing(true)
        } else{
            let row = pickerview.selectedRow(inComponent: 0)
            expensesbutton.text = items[row] + "  ▼"
            self.endEditing(true)
        }
    }
    
    @objc func expensesdoneclick(){
        self.endEditing(true)
    }
    
    func changeText(first:[String],second:[String])-> Void{
        items.removeAll()
        for index in first{
            items.append(index)
        }
        for index in second{
            items.append(index)
        }
    }
}
