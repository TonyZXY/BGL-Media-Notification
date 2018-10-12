//
//  StopLossSettingView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 10/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class StopLossSetView : UIStackView{
    let factor = UIScreen.main.bounds.width/375
    
    lazy var priceUpperLabel :UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = textValue(name: "amountSoldForm")
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLowerLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = textValue(name: "amountSoldForm")
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLowerTextField : LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.textColor = ThemeColor().whiteColor()
        textfield.tintColor = ThemeColor().whiteColor()
        textfield.frame = CGRect(x:0, y: 0, width: 200*factor, height: 30*factor)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string:textValue(name: "amountPlaceholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13*factor), NSAttributedStringKey.foregroundColor: ThemeColor().grayPlaceHolder()])
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.layer.cornerRadius = 8*factor
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexible,flexible,donebutton], animated: false)
        textfield.inputAccessoryView = toolbar
        //        textfield.addTarget(self, action: #selector(numberTextFieldDidChange), for: .editingChanged)
        return textfield
    }()
    
    lazy var priceUpperTextField : LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.textColor = ThemeColor().whiteColor()
        textfield.tintColor = ThemeColor().whiteColor()
        textfield.frame = CGRect(x:0, y: 0, width: 200*factor, height: 30*factor)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string:textValue(name: "amountPlaceholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13*factor), NSAttributedStringKey.foregroundColor: ThemeColor().grayPlaceHolder()])
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.layer.cornerRadius = 8*factor
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexible,flexible,donebutton], animated: false)
        textfield.inputAccessoryView = toolbar
        //        textfield.addTarget(self, action: #selector(numberTextFieldDidChange), for: .editingChanged)
        return textfield
    }()
    
    lazy var amountLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = textValue(name: "amountSoldForm")
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var amountTextField: LeftPaddedTextField = {
        let textfield = LeftPaddedTextField()
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.textColor = ThemeColor().whiteColor()
        textfield.tintColor = ThemeColor().whiteColor()
        textfield.frame = CGRect(x:0, y: 0, width: 200*factor, height: 30*factor)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.attributedPlaceholder = NSAttributedString(string:textValue(name: "amountPlaceholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13*factor), NSAttributedStringKey.foregroundColor: ThemeColor().grayPlaceHolder()])
        textfield.backgroundColor = ThemeColor().greyColor()
        textfield.layer.cornerRadius = 8*factor
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexible,flexible,donebutton], animated: false)
        textfield.inputAccessoryView = toolbar
//        textfield.addTarget(self, action: #selector(numberTextFieldDidChange), for: .editingChanged)
        return textfield
    }()
    //-------------------Slider Stack---------------
    lazy var slider: SUISlider = {
        let slider = SUISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
//        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()
    
    private lazy var percentageTextField: SUITextField = {
        let textField = SUITextField()
        textField.text = "0"
        textField.textColor = ThemeColor().whiteColor()
        textField.textAlignment = .center
        textField.backgroundColor = ThemeColor().greyColor()
//        textField.addTarget(self, action: #selector(percentageTextFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let percentageLabel: SUILabel = {
        let label = SUILabel()
        label.text = " %"
        label.textColor = ThemeColor().textGreycolor()
        return label
    }()
    
    private let paddingView: SUIView = {
        let view = SUIView()
        return view
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        return label
    }()
    
    private lazy var sliderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [slider, paddingView, percentageTextField, percentageLabel])
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        //set up their proportions
        slider.width = 40
        paddingView.width = 2
        percentageTextField.width = 10
        percentageLabel.width = 4
        return stackView
    }()
    
    @objc func doneclick(){
        self.endEditing(true)
    }
    
    func setupView(){
        self.addArrangedSubview(priceUpperLabel)
        self.addArrangedSubview(priceUpperTextField)
        self.addArrangedSubview(priceLowerLabel)
        self.addArrangedSubview(priceLowerTextField)
        self.addArrangedSubview(amountLabel)
        self.addArrangedSubview(amountTextField)
        self.addArrangedSubview(sliderStackView)
        
//        addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3(\(30*factor))]-[v4]", views: priceUpperLabel,priceLowerLabel,amountLabel,amountTextField,sliderStackView)
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        self.distribution = .fillEqually
        self.axis = .vertical
        self.spacing = 8
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
