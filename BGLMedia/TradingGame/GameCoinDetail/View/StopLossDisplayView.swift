//
//  StopLossCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 21/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit
class StopLossDisplayView : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    var stopLossObject : StopLossObject?{
        didSet{
            priceUpperLabel.text = "\(stopLossObject!.price_greater.floorTo(decimalLimit: 8))"
            priceLowerLabel.text = "\(stopLossObject!.price_lower.floorTo(decimalLimit: 8))"
            amountLabel.text = "\(stopLossObject!.amount.floorTo(decimalLimit: 8))"
            
            if stopLossObject!.actived {
                self.status = .Actived
            }else{
                // well, only actived will be shown now since some logic applied
                if stopLossObject?.code == "400"{
                    self.status = .Failed
                }
                if stopLossObject?.code == "500"{
                    self.status = .Cancelled
                }else{
                    // this will not show at the moment since logic is changed
                    self.status = .Completed
                }
            }

        }
    }
    
    private lazy var priceLowerFixed:UILabel = UILabel(text: textValue(name: "stop_loss"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var priceUpperFixed:UILabel = UILabel(text: textValue(name: "take_profit"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var amountFixed:UILabel = UILabel(text: textValue(name: "amount"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    private lazy var statusFixed:UILabel = UILabel(text: textValue(name: "status"), font: UIFont.semiBoldFont(14*factor), textColor: ThemeColor().textGreycolor())
    
    private lazy var priceLowerLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(12*factor), textColor: .white)
    private lazy var priceUpperLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(12*factor), textColor: .white)
    private lazy var amountLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(12*factor), textColor: .white)
    private lazy var statusLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(12*factor), textColor: .white)
    private lazy var completeDateLabel:UILabel = UILabel(text: "--", font: UIFont.semiBoldFont(12*factor), textColor: .white)
    
    enum Status{
        case Actived, Failed, Completed, Cancelled
    }
    
    var status : Status?{
        didSet{
            completeDateLabel.text = ""
            
            if status == Status.Actived{
                statusLabel.text = textValue(name: "stopLoss_status_active")
                statusLabel.textColor = ThemeColor().greenColor()
            }else if status == Status.Failed{
                statusLabel.text = textValue(name: "stopLoss_status_fail")
                statusLabel.textColor = ThemeColor().redColor()
            }else if status == Status.Completed{
                statusLabel.text = textValue(name: "stopLoss_status_completed")
                statusLabel.textColor = ThemeColor().greenColor()
                completeDateLabel.text = Extension.method.convertDateToString(date: stopLossObject?.complete_date ?? Date())
            }else if status == Status.Cancelled{
                statusLabel.text = textValue(name: "stopLoss_status_fail")
                statusLabel.textColor = ThemeColor().redColor()
            }else{
                //default
                statusLabel.text = "--"
                statusLabel.textColor = .white
            }
        }
    }
    
    private func setupView(){
        
        let priceStack : UIStackView = {
            let stack = UIStackView(arrangedSubviews: [priceLowerFixed,priceLowerLabel,priceUpperFixed,priceUpperLabel])
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fillEqually
            return stack
        }()
        
        let amountStack : UIStackView = {
            let stack = UIStackView(arrangedSubviews: [amountFixed,amountLabel])
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fillEqually
            return stack
        }()
        
        let statusStack : UIStackView = {
//            let stack = UIStackView(arrangedSubviews: [statusFixed,statusLabel,completeDateLabel])
            let stack = UIStackView(arrangedSubviews: [statusFixed,statusLabel])
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fillEqually
            return stack
        }()
        
//        priceLowerFixed.addSubview(priceLowerLabel)
//
//        priceLowerFixed.addConstraintsWithFormat(format: "H:|-[v0]", views: priceLowerLabel)
//        priceLowerLabel.topAnchor.constraint(equalTo: priceLowerFixed.bottomAnchor, constant: 3*factor).isActive = true
//        priceLowerLabel.text = "213123"
//
//        priceUpperFixed.addSubview(priceUpperLabel)
//        priceUpperFixed.addConstraintsWithFormat(format: "H:|-[v0]", views: priceUpperLabel)
//        priceUpperLabel.topAnchor.constraint(equalTo: priceUpperFixed.bottomAnchor, constant: 3*factor).isActive = true
//
//        amountFixed.addSubview(amountLabel)
//        statusFixed.addSubview(statusLabel)
//        statusFixed.addSubview(completeDateLabel)
        
        let stack : UIStackView = {
            let stack = UIStackView.stackView(firstView: priceStack, restSubviews: [(amountStack,1),(statusStack,0.7)], axis: .horizontal)
            stack.alignment = .center
            return stack
        }()
        
        self.addSubview(stack)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: stack)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: stack)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
