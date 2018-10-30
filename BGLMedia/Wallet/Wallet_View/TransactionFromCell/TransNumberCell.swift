//
//  TransNumberCell.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 26/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class TransNumberCell:UITableViewCell, UITextFieldDelegate {
    
    var isGameMode = false
    var gameUser: GameUser?
    var newTransaction: EachTransactions?
    var balance: Double = 0
    var price: Double?
    let sliderStep: Float = 10
    var coinName = "" {
        didSet {
            balance = 0
            gameUser?.coins.forEach({ (coin) in
                if coin.name == coinName {
                    balance = coin.amount
                }
            })
            let showingBalance = (coinName == "AUD") ? Extension.method.scientificMethod(number: balance) : "\(balance)"
            balanceLabel.text = "\(coinName) \(textValue(name: "balance")): \(showingBalance)"
            calculateCoinAmount()
        }
    }
    
    var factor:CGFloat?{
        didSet{
            setupviews()
//            _ = createKeyboarddonebutton()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    lazy var numberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBoldFont(15*factor!)
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
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([flexible,flexible,donebutton], animated: false)
        textfield.inputAccessoryView = toolbar
        textfield.addTarget(self, action: #selector(numberTextFieldDidChange), for: .editingChanged)
        return textfield
    }()
    
    lazy var slider: SUISlider = {
        let slider = SUISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        return slider
    }()

    private lazy var percentageTextField: SUITextField = {
        let textField = SUITextField()
        textField.text = "0"
        textField.textColor = ThemeColor().whiteColor()
        textField.textAlignment = .center
        textField.backgroundColor = ThemeColor().greyColor()
        textField.addTarget(self, action: #selector(percentageTextFieldDidChange), for: .editingChanged)
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
    
    private let transactionFeeLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.text = textValue(name: "transactionFee") + ": 0.2%"
        label.textAlignment = .right
        return label
    }()
    
    private lazy var balanceAndTansactionFeeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [balanceLabel, transactionFeeLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
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
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        //backgroundColor = .yellow
//        layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 2)
//        layer.shadowOpacity = 1
//        layer.shadowRadius = 0
//        layer.masksToBounds = false
        
        if isGameMode {
            let contentStackView: UIStackView = {
                let stackView = UIStackView(arrangedSubviews: [numberLabel, number, sliderStackView, balanceAndTansactionFeeStackView])
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.distribution = .fillEqually
                stackView.axis = .vertical
                stackView.spacing = 8
                return stackView
            }()
            
            addSubview(contentStackView)
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        } else {
            addSubview(numberLabel)
            addSubview(number)
            
            NSLayoutConstraint(item: numberLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -5*factor!).isActive = true
            NSLayoutConstraint(item: number, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 5*factor!).isActive = true
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(16*factor!)-[v1]-\(16*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":numberLabel,"v1":number]))
        }
    }
    
    func calculateCoinAmount() {
        if let coinPrice = price {
            var amount = 0.0
            if coinName == "AUD" {
                //for buying
                let limit = 100000000.0  //determine decimal pplaces
                amount = balance * Double(slider.value) / 100 / coinPrice
                amount = (amount * limit).rounded(.down) / limit
            } else {
                //for selling
                    amount = balance * Double(slider.value) / 100
                if slider.value == 100 {
                    amount = balance
                }else{
                    amount = amount.floorTo(decimalLimit: 8)
                }
            }

            number.text = "\(amount)"
            newTransaction?.amount = amount
        }
    }
    
    @objc private func sliderValueDidChange(_ slider: UISlider)
    {
        if sliderStep > 0 {
            let roundedStepValue = round(slider.value / sliderStep) * sliderStep
            slider.value = roundedStepValue
        }
        slider.value = (slider.value * 100).rounded() / 100
        percentageTextField.text = "\(slider.value)"
        calculateCoinAmount()
    }
    
    @objc private func percentageTextFieldDidChange(_ textField: UITextField) {
        //make sure the textField no more than 5 charactors
        if let text = textField.text?.suffix(5) {
            if let percentage = Float(text) {
                if percentage > 100 {
                    textField.text = "100"
                } else {
                    textField.text = String(text)
                }
                slider.value = percentage
            } else {
                slider.value = 0
                textField.text = String(text)
            }
            calculateCoinAmount()
        }
    }
    
    @objc private func numberTextFieldDidChange(_ textField: UITextField) {
        if let coinPrice = price,
            var value = textField.text {
            //1.2345678901234568e+16 if the number too big like this, it will cause problem
            let decimalLimit = 8
            
            //apply decimal limit
            if let amount = Double(value) {
                let split = String(amount).components(separatedBy: ".")
                let integer = split.first ?? ""
                let decimal = (split.count == 2) ? (split.last ?? "") : ""
                if decimal.count > decimalLimit {
                    value = "\(integer).\(decimal.prefix(decimalLimit))"
                    textField.text = value
                }
            }
            
            if coinName == "AUD" {
                //for buying
                slider.value = Float((Double(value) ?? 0) * coinPrice * 100 / balance)
                percentageTextField.text = "\(slider.value)"
                
                if (Double(value) ?? 0) > (balance / coinPrice) {
                    calculateCoinAmount()
                }
            } else {
                //for selling
                slider.value = Float((Double(value) ?? 0) * 100 / balance)
                percentageTextField.text = "\(slider.value)"
                
                if (Double(value) ?? 0) > balance {
                    calculateCoinAmount()
                }
            }
        }
    }
    
//    func createKeyboarddonebutton()->UIToolbar {
////        let toolbar = UIToolbar()
////        toolbar.sizeToFit()
////        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(doneclick))
////        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
////        toolbar.setItems([flexible,flexible,donebutton], animated: false)
////        number.inputAccessoryView = toolbar
////        return toolbar
//    }
    
    @objc func doneclick(){
        self.endEditing(true)
    }
}
