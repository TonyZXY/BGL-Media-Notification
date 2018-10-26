//
//  StopLossSettingView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 10/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class StopLossSettingView : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    var popWindowController : PopWindowController?
    var gameGeneralController: GameGerneralController?
    
    enum Mode{
        case SET,EDIT
    }
    // default using Set mode
    var mode : Mode = Mode.SET{
        didSet{
            if mode == Mode.SET{
                // remove all target
                setSLButton.removeTarget(nil, action: nil, for: .touchUpInside)
                setSLButton.setTitle(textValue(name: "stopLoss_setButton"), for: .normal)
                setSLButton.addTarget(self, action: #selector(sendStopLossSetting), for: .touchUpInside)
            }else if mode == Mode.EDIT{
                setSLButton.removeTarget(nil, action: nil, for: .touchUpInside)
                setSLButton.setTitle(textValue(name: "stopLoss_editButton"), for: .normal)
                setSLButton.addTarget(self, action: #selector(sendStopLossEditing), for: .touchUpInside)
            }
        }
    }
    
    var coinDetail:GameCoin?{
        didSet{
            coinNameLabel.text = coinDetail?.name ?? "--"
            coinAmountLabel.text = "\(coinDetail?.amount ?? 0)"
            coinSinglePriceLabel.text = "\(coinDetail?.price.floorTo(decimalLimit: 8) ?? 0)"
            coinBoughtAvgLabel.text = "Bought average : \(coinDetail?.avgOfBuyPrice.floorTo(decimalLimit: 8) ?? 0)"
//            expectProfitLabel.text = String(format: "+%@", coinDetail?.name ?? "--")
//            expectLossLabel.text = String(format: "-%@", coinDetail?.name ?? "--")
            calculateExpectLoss()
            calculateExpectProfit()
        }
    }
    
    var stopLossObject : StopLossObject?{
        didSet{
            priceLowerTextField.text = "\(stopLossObject?.price_lower ?? 0)"
            priceUpperTextField.text = "\(stopLossObject?.price_greater ?? 0)"
            amountTextField.text = "\(stopLossObject?.amount ?? 0)"
            calculateExpectProfit()
            calculateExpectLoss()
        }
    }
    
    // Stop loss info section
    private lazy var coinNameFixed:UILabel = UILabel(text: textValue(name: "coin_name"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var coinAmountFixed:UILabel = UILabel(text: textValue(name: "amount"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var expectLossFixed:UILabel = UILabel(text: textValue(name: "expected_loss"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var expectProfitFixed:UILabel = UILabel(text: textValue(name: "expected_profit"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    
    lazy var coinBoughtAvgLabel:UILabel = UILabel(text: String(format: "%@ : %@", "Bought average", "--"), font: UIFont.semiBoldFont(12*factor), textColor: ThemeColor().textGreycolor())
    lazy var coinSinglePriceLabel:UILabel = UILabel(text: "--", font: UIFont.regularFont(25*factor), textColor: ThemeColor().darkBlackColor())
    lazy var coinNameLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    lazy var coinAmountLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    lazy var expectLossLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().redColor())
    lazy var expectProfitLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().greenColor())
    
    // stop loss section
    lazy var priceLowerTextField : StopLossTextField = {
        let textfield = StopLossTextField()
        textfield.titleLabel.text = textValue(name: "stopLoss_soldWhenLesser")
        textfield.addTarget(self, action: #selector(priceLowerEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(priceLowerEditingDidEnd), for: .editingDidEnd)
        return textfield
    }()
    
    
    lazy var priceUpperTextField : StopLossTextField = {
        let textfield = StopLossTextField()
        textfield.titleLabel.text = textValue(name: "stopLoss_soldWhenGreater")
        textfield.addTarget(self, action: #selector(priceUpperEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(priceUpperEditingDidEnd), for: .editingDidEnd)
        return textfield
    }()
    
    // amount section
    lazy var amountTextField: StopLossTextField = {
        let textfield = StopLossTextField()
        textfield.titleLabel.text = textValue(name: "amountSoldForm")
        textfield.addTarget(self, action: #selector(amountEditingChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(amountEditingDidEnd), for: .editingDidEnd)
        return textfield
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
        textField.addTarget(self, action: #selector(percentEditingChanged), for: .editingChanged)
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
        button.setTitle(textValue(name: "stopLoss_setButton"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18 * factor)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(sendStopLossSetting), for: .touchUpInside)
        button.backgroundColor = ThemeColor().themeWidgetColor()
//        button.layer.cornerRadius = 8.5
        return button
    }()
    
    // actions!!!!!
    
    @objc func priceLowerEditingChanged(_ textField: UITextField){
        if var value = textField.text {
            //apply decimal limit
            if var amount = Double(value) {
                let decimalLimit = 8
                let split = String(amount).components(separatedBy: ".")
                let integer = split.first ?? ""
                let decimal = (split.count == 2) ? (split.last ?? "") : ""
                if decimal.count > decimalLimit {
                    value = "\(integer).\(decimal.prefix(decimalLimit))"
                    amount = amount.floorTo(decimalLimit: decimalLimit)
                }
            }
            // set contents
            textField.text = value
            calculateExpectLoss()
        }
    }
    
    @objc func priceLowerEditingDidEnd(_ textField: UITextField){
        if validatePriceLow() {
            calculateExpectLoss()
        }
    }
    
    private func validatePriceLow()->Bool{
        let textField = priceLowerTextField
        let errLabel = priceLowerTextField.errorLabel
        
        if var value = textField.text {
            
            let decimalLimit = 8
            if var amount = Double(value){
                // apply upper bound limit
                if amount > coinDetail!.price{
                    amount = coinDetail!.price.floorTo(decimalLimit: decimalLimit)
                    value = String(format: "%.8f", amount)
                }
                if amount < 0{
                    amount = 0
                    value = "0"
                }
                textField.text = value
                errLabel.text = ""
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
                return true
            }else{
                errLabel.text = textValue(name: "textfield_err_invalidFormat")
                textField.layer.borderWidth = 1.8
                textField.layer.borderColor = ThemeColor().redColor().cgColor
                return false
            }
        }
        return false
    }

    @objc func priceUpperEditingChanged(_ textField: UITextField){
        if var value = textField.text {
            //apply decimal limit
            if var amount = Double(value) {
                let decimalLimit = 8
                let split = String(amount).components(separatedBy: ".")
                let integer = split.first ?? ""
                let decimal = (split.count == 2) ? (split.last ?? "") : ""
                if decimal.count > decimalLimit {
                    value = "\(integer).\(decimal.prefix(decimalLimit))"
                    amount = amount.floorTo(decimalLimit: decimalLimit)
                }
            }
            // set contents
            textField.text = value
            calculateExpectProfit()
        }
    }
    
    
    @objc func priceUpperEditingDidEnd(_ textField: UITextField){
        if validatePriceUp() {
            calculateExpectProfit()
        }
    }
    
    private func validatePriceUp()->Bool{
        let textField = priceUpperTextField
        let errLabel = priceUpperTextField.errorLabel
        
        if var value = textField.text {
            
            let decimalLimit = 8
            if var amount = Double(value){
                // apply upper bound limit
                if amount < coinDetail!.price{
                    amount = coinDetail!.price.ceilTo(decimalLimit: decimalLimit)
                    value = String(format: "%.8f", amount)
                }
                if amount < 0{
                    amount = 0
                    value = "0"
                }
                textField.text = value
                errLabel.text = ""
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
                return true
            }else{
                errLabel.text = textValue(name: "textfield_err_invalidFormat")
                textField.layer.borderWidth = 1.8
                textField.layer.borderColor = ThemeColor().redColor().cgColor
                return false
            }
        }
        return false
    }
    @objc func amountEditingChanged(_ textField: UITextField){
        
        // check format
//        if validateTextField(textField: textField, errLabel: amountTextField.errorLabel){}
        
        if var value = textField.text {
            
            let decimalLimit = 8
            
            //apply decimal limit
            if var amount = Double(value) {
                let split = String(amount).components(separatedBy: ".")
                let integer = split.first ?? ""
                let decimal = (split.count == 2) ? (split.last ?? "") : ""
                if decimal.count > decimalLimit {
                    value = "\(integer).\(decimal.prefix(decimalLimit))"
                    amount = amount.floorTo(decimalLimit: decimalLimit)
                }
            }
            
            // set contents
            textField.text = value
            calculateExpectProfit()
            calculateExpectLoss()

            slider.value = Float((Double(value) ?? 0) * 100 / coinDetail!.amount)
            percentageTextField.text = "\(slider.value)"
        }
    }
    @objc func amountEditingDidEnd(_ textField: UITextField){
        if validateAmount(){
            calculateExpectProfit()
            calculateExpectLoss()
            if let value = textField.text{
                slider.value = Float((Double(value) ?? 0) * 100 / coinDetail!.amount)
                percentageTextField.text = "\(slider.value)"
            }
        }
    }
    
    private func validateAmount()->Bool{
        let textField = amountTextField
        let errLabel = amountTextField.errorLabel
        
        if var value = textField.text {
            
            if var amount = Double(value){
                // apply limit
                if amount > coinDetail!.amount{
                    amount = coinDetail!.amount
                    value = String(amount)
                }
                if amount < 0{
                    amount = 0
                    value = "0"
                }
                textField.text = value
                errLabel.text = ""
                textField.layer.borderWidth = 0
                textField.layer.borderColor = UIColor.clear.cgColor
                return true
            }else{
                errLabel.text = textValue(name: "textfield_err_invalidFormat")
                textField.layer.borderWidth = 1.8
                textField.layer.borderColor = ThemeColor().redColor().cgColor
                return false
            }
        }
        return false
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
        if slider.value == 100 {
            amountTextField.text = "\(coinDetail?.amount ?? 0)"
        }else{
            amountTextField.text = "\(amountValue.floorTo(decimalLimit: 8))"
        }

        calculateExpectProfit()
        calculateExpectLoss()
        // change the border of amountTextField to normal
        amountTextField.errorLabel.text = ""
        amountTextField.layer.borderWidth = 0
        amountTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    @objc func percentEditingChanged(_ textField: UITextField){
        
        // check format
//        if validateTextField(textField: textField, errLabel: amountTextField.errorLabel){}
        
        if var value = textField.text {

            if var percentage = Double(value) {
                // limitation
                if percentage > 100 {
                    value = "100"
                    percentage = 100
                }else{
                    // limit decimal
                    let decimalLimit = 3
                    let split = String(percentage).components(separatedBy: ".")
                    let integer = split.first ?? ""
                    let decimal = (split.count == 2) ? (split.last ?? "") : ""
                    if decimal.count > decimalLimit {
                        value = "\(integer).\(decimal.prefix(decimalLimit))"
                        percentage = percentage.floorTo(decimalLimit: decimalLimit)
                    }
                }
                
                
                // set up field
                textField.text = value
                slider.value = Float(percentage)
                let amountValue = percentage/100 * (coinDetail?.amount ?? 0)
                if percentage == 100{
                    amountTextField.text = "\(coinDetail?.amount ?? 0))"
                }else{
                    amountTextField.text = "\(amountValue.floorTo(decimalLimit: 8))"
                }
                calculateExpectProfit()
                calculateExpectLoss()
                
                // change the border of amountTextField to normal
                amountTextField.errorLabel.text = ""
                amountTextField.layer.borderWidth = 0
                amountTextField.layer.borderColor = UIColor.clear.cgColor
                
            }
        }
    }
    
    private func calculateExpectProfit(){
        if let text = priceUpperTextField.text, let amountText = amountTextField.text{
            if let value = Double(text), let amount = Double(amountText){
                let diff = value - coinDetail!.price
                let cost = diff * amount
                expectProfitLabel.text = String(format: "A$%.2f", cost)
            }else{
                expectProfitLabel.text = "--"
            }
        }
    }
    
    private func calculateExpectLoss(){
        if let text = priceLowerTextField.text, let amountText = amountTextField.text{
            if let value = Double(text), let amount = Double(amountText){
                let diff = value - coinDetail!.price
                let cost = diff * amount
                expectLossLabel.text = String(format: "A$%.2f", cost)
            }else{
                expectLossLabel.text = "--"
            }
        }
    }
    
    
    
    @objc func sendStopLossSetting(){
        let upValid = validatePriceUp()
        let amountValid = validateAmount()
        let lowValid = validatePriceLow()
        
        if upValid && lowValid && amountValid{
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = textValue(name: "Setting Up")
            hud.backgroundColor = ThemeColor().progressColor()
            hud.show(in: self)
            
            let coinAbbr = coinDetail!.abbrName.lowercased()
            let priceGreater = Double(priceUpperTextField.text!)!
            let priceLower = Double(priceLowerTextField.text!)!
            let amount = Double(amountTextField.text!)!
            
            let api = StopLossApiService()
//            print("userID : \(api.user_id)")
//            print("token : \(api.token)")
//            print("email : \(api.email)")
//            print("coin : \(coinAbbr)")
//            print("price> : \(priceGreater)")
//            print("price< : \(priceLower)")
//            print("amount : \(amount)")
            api.setStopLoss(coinAbbr: coinAbbr, priceGreater: priceGreater, priceLower: priceLower, amount: amount, completion: {(success, err) in
                if success {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = textValue(name: "success_success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                        self.popWindowController?.dismiss(animated: true, completion: nil)
                        self.gameGeneralController?.refreshStopLossData()
                    }
                }else{
                    if err == "450" {
                        // due to limitation
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "stopLoss_err_limitation")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }else if err == "500" {
                        // unknown request
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }else if err == "510" {
                        //database error
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }else {
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }
                }
            })
        }
    }
    
    @objc func sendStopLossEditing(){
        let upValid = validatePriceUp()
        let amountValid = validateAmount()
        let lowValid = validatePriceLow()
        
        if upValid && lowValid && amountValid{
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = textValue(name: "Setting Up")
            hud.backgroundColor = ThemeColor().progressColor()
            hud.show(in: self)
            
            let set_id = stopLossObject!.set_id
            let coinAbbr = coinDetail!.abbrName.lowercased()
            let priceGreater = Double(priceUpperTextField.text!)!
            let priceLower = Double(priceLowerTextField.text!)!
            let amount = Double(amountTextField.text!)!
            
            let api = StopLossApiService()
            //            print("userID : \(api.user_id)")
            //            print("token : \(api.token)")
            //            print("email : \(api.email)")
            //            print("coin : \(coinAbbr)")
            //            print("price> : \(priceGreater)")
            //            print("price< : \(priceLower)")
            //            print("amount : \(amount)")
            api.editStopLoss(set_id: set_id, coinAbbr: coinAbbr, priceGreater: priceGreater, priceLower: priceLower, amount: amount, completion: {(success, err) in
                if success {
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = textValue(name: "success_success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                        self.popWindowController?.dismiss(animated: true, completion: nil)
                        self.gameGeneralController?.refreshStopLossData()
                    }
                }else{
                    if err == "500" {
                        // unknown request
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }else if err == "510" {
                        //database error
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }else {
                        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }
                }
            })
        }
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
        container.addSubview(priceLowerTextField)
    
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: priceLowerTextField)
        container.addConstraint(NSLayoutConstraint(item: priceLowerTextField, attribute: .top, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 3 * factor))
    
        priceLowerTextField.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        return container
    }
    
    private func setupTakeProfitView()->UIView{
        let container = UIView()
        container.addSubview(priceUpperTextField)
        
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: priceUpperTextField)
        container.addConstraint(NSLayoutConstraint(item: priceUpperTextField, attribute: .top, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 3 * factor))
        
        priceUpperTextField.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        return container
    }
    
    private func setupAmountView()->UIView{
        let container = UIView()
        container.addSubview(amountTextField)
        container.addSubview(sliderStackView)

        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: amountTextField)
        container.addConstraintsWithFormat(format: "H:|-\(15*factor)-[v0]-\(15*factor)-|", views: sliderStackView)

        container.addConstraint(NSLayoutConstraint(item: amountTextField, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: -5*factor))
        container.addConstraint(NSLayoutConstraint(item: sliderStackView, attribute: .top, relatedBy: .equal, toItem: amountTextField, attribute: .bottom, multiplier: 1, constant: 3*factor))

        amountTextField.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true
        sliderStackView.heightAnchor.constraint(equalToConstant: 30*factor).isActive = true

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
    
//    convenience init(popWindowController : PopWindowController) {
//        self.init()
//        self.popWindowController = popWindowController
//        setupView()
//    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class StopLossTextField : LeftPaddedTextField{
    let factor = UIScreen.main.bounds.width/375
    
    lazy var titleLabel :UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = ""
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var errorLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor)
        label.text = ""
        label.textColor = ThemeColor().redColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func doneclick(){
        self.endEditing(true)
    }
    
    private func initSetup(){
        self.keyboardType = UIKeyboardType.decimalPad
        self.textColor = ThemeColor().whiteColor()
        self.tintColor = ThemeColor().whiteColor()
        self.frame = CGRect(x:0, y: 0, width: 200*factor, height: 30*factor)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.attributedPlaceholder = NSAttributedString(string:textValue(name: "amountPlaceholder"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13*factor), NSAttributedStringKey.foregroundColor: ThemeColor().grayPlaceHolder()])
        self.backgroundColor = ThemeColor().greyColor()
        self.layer.cornerRadius = 8*factor
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexible,flexible,donebutton], animated: false)
        self.inputAccessoryView = toolbar
    }
 
    
    private func setupView(){
        self.addSubview(titleLabel)
        self.addSubview(errorLabel)
        
        self.addConstraint(NSLayoutConstraint(item: errorLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -3 * factor))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: -3 * factor))
        self.addConstraint(NSLayoutConstraint(item: errorLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -3 * factor))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: -3 * factor))
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        initSetup()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

