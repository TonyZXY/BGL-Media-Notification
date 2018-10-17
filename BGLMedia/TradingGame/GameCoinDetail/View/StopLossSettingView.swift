//
//  StopLossSettingView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 10/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class StopLossSettingView : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    var coinDetail:GameCoin?{
        didSet{
            coinNameLabel.text = String(format: "%@", coinDetail?.name ?? "--")
            coinAmountLabel.text = "\(coinDetail?.amount ?? 0)"
            coinSinglePriceLabel.text = String(format: "%.8f", coinDetail?.price ?? "--")
            coinBoughtAvgLabel.text = String(format: "%@ : %.8f", "Bought average",coinDetail?.avgOfBuyPrice ?? "--")
//            expectProfitLabel.text = String(format: "+%@", coinDetail?.name ?? "--")
//            expectLossLabel.text = String(format: "-%@", coinDetail?.name ?? "--")
        }
    }
    // Stop loss info section
    private lazy var coinNameFixed:UILabel = UILabel(text: "Coin Name :", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var coinAmountFixed:UILabel = UILabel(text: "Amount :", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var expectLossFixed:UILabel = UILabel(text: "Expected Loss :", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var expectProfitFixed:UILabel = UILabel(text: "Expected Profit :", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    
    private lazy var coinBoughtAvgLabel:UILabel = UILabel(text: String(format: "%@ : %@", "Bought average", "--"), font: UIFont.semiBoldFont(12*factor), textColor: ThemeColor().textGreycolor())
    private lazy var coinSinglePriceLabel:UILabel = UILabel(text: "--", font: UIFont.regularFont(25*factor), textColor: ThemeColor().darkBlackColor())
    private lazy var coinNameLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var coinAmountLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var expectLossLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var expectProfitLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    // stop loss section
    lazy var priceLowerLabel:UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = textValue(name: "stopLoss_soldWhenGreater")
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
        textfield.addTarget(self, action: #selector(priceLowerEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var priceLowerErrLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = ""
        label.textColor = ThemeColor().redColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // take profit section
    lazy var priceUpperLabel :UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = textValue(name: "stopLoss_soldWhenLesser")
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        textfield.addTarget(self, action: #selector(priceUpperEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var priceUpperErrLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = ""
        label.textColor = ThemeColor().redColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // amount section
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
        textfield.addTarget(self, action: #selector(amountEditingChanged), for: .editingChanged)
        return textfield
    }()
    
    lazy var amountErrLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = ""
        label.textColor = ThemeColor().redColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //-------------------Slider Stack---------------
    lazy var slider: SUISlider = {
        let slider = SUISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
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
    
    // button to set stopLoss
    private lazy var setSLButton : SUIButton = {
        let button = SUIButton()
        button.setTitle(textValue(name: "signUp"),for: .disabled)
        button.setTitle(textValue(name: "signUp"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18 * factor)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sentStopLossSetting), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
//        button.layer.cornerRadius = 8.5
        return button
    }()
    
    // actions!!!!!
    @objc func doneclick(){
        self.endEditing(true)
    }
    
    @objc func priceLowerEditingChanged(_ textField: UITextField){
        // check value Format
        if let value = textField.text {
            if textField.text?.isValidNumber() == true{
                priceLowerErrLabel.text = ""
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            }else{
                priceLowerErrLabel.text = textValue(name: "textfield_err_invalidFormat")
                textField.layer.borderWidth = 1.8
                textField.layer.borderColor = ThemeColor().redColor().cgColor
            }
            
            //apply decimal limit
            if let amount = Double(value) {
                
                textField.text = "\(amount.limitDecimal(decimalLimit: 8))"
            }
            
        }
    }

    @objc func priceUpperEditingChanged(_ textField: UITextField){
        // check value Format
        if let value = textField.text {
            if value.isValidNumber() == true{
                priceUpperErrLabel.text = ""
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            }else{
                priceUpperErrLabel.text = textValue(name: "textfield_err_invalidFormat")
                textField.layer.borderWidth = 1.8
                textField.layer.borderColor = ThemeColor().redColor().cgColor
            }
            
            //apply decimal limit
            if let amount = Double(value) {
                textField.text = "\(amount.limitDecimal(decimalLimit: 8))"
            }
            
        }
    }
    @objc func amountEditingChanged(_ textField: UITextField){
        if let value = textField.text {
            // check format
            if value.isValidNumber() == true{
                priceUpperErrLabel.text = ""
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
            }else{
                amountErrLabel.text = textValue(name: "textfield_err_invalidFormat")
                textField.layer.borderWidth = 1.8
                textField.layer.borderColor = ThemeColor().redColor().cgColor
            }
            
            //apply decimal limit
            if let amount = Double(value) {
                textField.text = "\(amount.limitDecimal(decimalLimit: 8))"
            }
            
//            if coinName == "AUD" {
//                //for buying
//                slider.value = Float((Double(value) ?? 0) * coinPrice * 100 / balance)
//                percentageTextField.text = "\(slider.value)"
//
//                if (Double(value) ?? 0) > (balance / coinPrice) {
//                    calculateCoinAmount()
//                }
//            } else {
//                //for selling
//                slider.value = Float((Double(value) ?? 0) * 100 / balance)
//                percentageTextField.text = "\(slider.value)"
//
//                if (Double(value) ?? 0) > balance {
//                    calculateCoinAmount()
//                }
//            }
        }
    }
    
    @objc func sliderValueChanged(_ slider: UISlider){
        let sliderStep :Float = 10
        if sliderStep > 0 {
            let roundedStepValue = round(slider.value / sliderStep) * sliderStep
            slider.value = roundedStepValue
        }
        slider.value = (slider.value * 100).rounded() / 100
        // change percentage field value
        percentageTextField.text = "\(slider.value)"
        
        let amountValue = Double(slider.value/100) * (coinDetail?.amount ?? 0)
        amountTextField.text = "\(amountValue)"
    }
    
    @objc func sentStopLossSetting(){
        
    }
    
    private func setupInfoView()->UIView{
        let container = UIView()
        container.addSubview(coinNameFixed)
        container.addSubview(coinAmountFixed)
        container.addSubview(expectLossFixed)
        container.addSubview(expectProfitFixed)

        container.addSubview(coinBoughtAvgLabel)
        container.addSubview(coinSinglePriceLabel)
        container.addSubview(coinNameLabel)
        container.addSubview(coinAmountLabel)
        container.addSubview(expectLossLabel)
        container.addSubview(expectProfitLabel)
        
        // singlePrice will be centered and bought average under it
        container.addConstraint(NSLayoutConstraint(item: coinSinglePriceLabel, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0))
        container.addConstraint(NSLayoutConstraint(item: coinSinglePriceLabel, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: -8*factor))
        container.addConstraint(NSLayoutConstraint(item: coinBoughtAvgLabel, attribute: .top, relatedBy: .equal, toItem: coinSinglePriceLabel, attribute: .bottom, multiplier: 1, constant: 2*factor))
        container.addConstraint(NSLayoutConstraint(item: coinBoughtAvgLabel, attribute: .centerX, relatedBy: .equal, toItem: coinSinglePriceLabel, attribute: .centerX, multiplier: 1, constant: 0))
        
        // coin name will be placed at top left corner
        container.addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]", views: coinNameFixed)
        container.addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]", views: coinNameLabel)
        container.addConstraintsWithFormat(format: "V:|-\(10*factor)-[v0]-\(3*factor)-[v1]", views: coinNameFixed,coinNameLabel)
        
        // coin Amount will be placed at top right corner
        container.addConstraintsWithFormat(format: "H:[v0]-\(10*factor)-|", views: coinAmountFixed)
        container.addConstraintsWithFormat(format: "H:[v0]-\(10*factor)-|", views: coinAmountLabel)
        container.addConstraintsWithFormat(format: "V:|-\(10*factor)-[v0]-\(3*factor)-[v1]", views: coinAmountFixed,coinAmountLabel)
        
        // expected profit will placed on bottom left
        container.addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]", views: expectProfitFixed)
        container.addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]", views: expectProfitLabel)
        container.addConstraintsWithFormat(format: "V:[v0]-\(3*factor)-[v1]-\(10*factor)-|", views: expectProfitFixed,expectProfitLabel)
        
        // expected loss will placed at bottom right
        container.addConstraintsWithFormat(format: "H:[v0]-\(10*factor)-|", views: expectLossFixed)
        container.addConstraintsWithFormat(format: "H:[v0]-\(10*factor)-|", views: expectLossLabel)
        container.addConstraintsWithFormat(format: "V:[v0]-\(3*factor)-[v1]-\(10*factor)-|", views: expectLossFixed,expectLossLabel)
        return container
    }
    
    private func setupStopLossView()->UIView{
        let container = UIView()
        container.addSubview(priceLowerLabel)
        container.addSubview(priceLowerTextField)
        container.addSubview(priceLowerErrLabel)
    
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]", views: priceLowerLabel)
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: priceLowerTextField)
        container.addConstraint(NSLayoutConstraint(item: priceLowerLabel, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: -3 * factor))
        container.addConstraint(NSLayoutConstraint(item: priceLowerTextField, attribute: .top, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 3 * factor))
        
        container.addConstraintsWithFormat(format: "H:[v0]-\(15*factor)-|", views: priceLowerErrLabel)
        container.addConstraint(NSLayoutConstraint(item: priceLowerErrLabel, attribute: .bottom, relatedBy: .equal, toItem: priceLowerTextField, attribute: .top, multiplier: 1, constant: -3 * factor))
        
        priceLowerTextField.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        return container
    }
    
    private func setupTakeProfitView()->UIView{
        let container = UIView()
        container.addSubview(priceUpperLabel)
        container.addSubview(priceUpperTextField)
        container.addSubview(priceUpperErrLabel)

        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]", views: priceUpperLabel)
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: priceUpperTextField)
        container.addConstraint(NSLayoutConstraint(item: priceUpperLabel, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: -3 * factor))
        container.addConstraint(NSLayoutConstraint(item: priceUpperTextField, attribute: .top, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 3 * factor))

        container.addConstraintsWithFormat(format: "H:[v0]-\(10*factor)-|", views: priceUpperErrLabel)
        container.addConstraint(NSLayoutConstraint(item: priceUpperErrLabel, attribute: .bottom, relatedBy: .equal, toItem: priceUpperTextField, attribute: .top, multiplier: 1, constant: -3 * factor))
        priceUpperTextField.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        return container
//        priceUpperTextField.addSubview(priceUpperErrLabel)
//        priceUpperTextField.addConstraint(NSLayoutConstraint(item: priceUpperErrLabel, attribute: .bottom, relatedBy: .equal, toItem: priceUpperTextField, attribute: .top, multiplier: 1, constant: -3 * factor))
//        priceUpperTextField.addConstraint(NSLayoutConstraint(item: priceUpperErrLabel, attribute: .right, relatedBy: .equal, toItem: priceUpperTextField, attribute: .right, multiplier: 1, constant: -3 * factor))
//
//        let stack = UIStackView(arrangedSubviews: [priceUpperLabel,priceUpperTextField])
//        stack.axis = .vertical
//        stack.distribution = .fillEqually
//        stack.spacing = 8 * factor
//        return stack
    }
    
    private func setupAmountView()->UIView{
        let container = UIView()
        container.addSubview(amountLabel)
        container.addSubview(amountErrLabel)
        container.addSubview(amountTextField)
        container.addSubview(sliderStackView)

        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]", views: amountLabel)
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: amountTextField)
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: sliderStackView)

        container.addConstraint(NSLayoutConstraint(item: amountTextField, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0))
        container.addConstraint(NSLayoutConstraint(item: amountLabel, attribute: .bottom, relatedBy: .equal, toItem: amountTextField, attribute: .top, multiplier: 1, constant: -3*factor))
        container.addConstraint(NSLayoutConstraint(item: sliderStackView, attribute: .top, relatedBy: .equal, toItem: amountTextField, attribute: .bottom, multiplier: 1, constant: 3*factor))

        container.addConstraintsWithFormat(format: "H:[v0]-\(15*factor)-|", views: amountErrLabel)
        container.addConstraint(NSLayoutConstraint(item: amountErrLabel, attribute: .bottom, relatedBy: .equal, toItem: amountTextField, attribute: .top, multiplier: 1, constant: -3 * factor))
        
        amountTextField.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        sliderStackView.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        
//        let stack = UIStackView.stackView(firstView: amountLabel, restSubviews: [(amountTextField,1.2),(sliderStackView,1.5)], axis: .vertical)
//        stack.spacing = 3 * factor
//        return stack
//        container.addSubview(stack)
//        container.addConstraintsWithFormat(format: "H:|[v0]|", views: stack)
//        container.addConstraintsWithFormat(format: "V:|[v0]|", views: stack)
        return container
    }
    
    func setupView(){
        let infoView = setupInfoView()
        let stopLossView = setupStopLossView()
        let takeProfitView = setupTakeProfitView()
        let amountView = setupAmountView()
        let stack = UIStackView.stackView(firstView: infoView, restSubviews: [(stopLossView,0.4),(takeProfitView,0.4),(amountView,0.6),(setSLButton,0.3)], axis: .vertical)
        stack.spacing = 5 * factor
        
        addSubview(stack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: stack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: stack)
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

