//
//  StopLossCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 21/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit
//class StopLossObject: Object {
//    @objc dynamic var set_id : String = "0"
//    @objc dynamic var user_id: String = "0"
//    @objc dynamic var coinAbbrName: String = ""
//    @objc dynamic var price_greater : Double = 0
//    @objc dynamic var price_lower : Double = 0
//    @objc dynamic var amount : Double = 0
//
//    /** if actived = false, means this stop loss is successfully proceed, and complete_date is the time that this stop loss complete. */
//    @objc dynamic var actived : Bool = true
//    @objc dynamic var complete_date: Date = Date()
//    /** if code = 400, means this stop loss failed due to insufficient amount.  empty string means server return nil */
//    @objc dynamic var code : String?
//
//    override class func primaryKey() -> String {
//        return "set_id"
//    }
//}
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
                self.status = .Completed
            }
            if stopLossObject?.code == "400"{
                self.status = .Failed
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
        case Actived, Failed, Completed
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
            let stack = UIStackView(arrangedSubviews: [statusFixed,statusLabel,completeDateLabel])
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
            let stack = UIStackView.stackView(firstView: priceStack, restSubviews: [(amountStack,1),(statusStack,1.3)], axis: .horizontal)
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
