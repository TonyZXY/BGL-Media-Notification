//
//  RegisterCell.swift
//  RegisterV2
//
//  Created by ZHANG ZEYAO on 29/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class RegisterCellA: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "firstName")
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let contentTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*" + textValue(name: "firstName"), attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    func setupviews(){
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        contentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        // Add First Name Text field
        addSubview(contentTextField)
        contentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        contentTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}





















class RegisterCellB: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "lastName")
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "title")
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let lastNameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*" + textValue(name: "lastName"), attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let titleTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        let label = UITextView()
        textField.inputView = label
        textField.tintColor = .clear
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: textValue(name: "title"), attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    func setupviews(){
        // Add Last Name Text Field
        addSubview(lastNameLabel)
        addSubview(lastNameTextField)
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        //Add Last Name Label
        
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.centerXAnchor.constraint(equalTo: lastNameTextField.centerXAnchor).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        addSubview(titleLabel)
        addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Add Title Label
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor).isActive = true
    }
}

class LeftPaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7);
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
}
