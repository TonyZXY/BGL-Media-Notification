//
//  TimelineTableViewCell.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit

open class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak open var historyView: UIView!

    //Buy table view cell xib
    @IBOutlet weak var SinglePrice: UILabel!
    @IBOutlet weak var SinglePriceResult: UILabel!
    @IBOutlet weak var tradingPairs: UILabel!
    @IBOutlet weak var tradingPairsResult: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var amountResult: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var costResult: UILabel!
    @IBOutlet weak var worth: UILabel!
    @IBOutlet weak var worthResult: UILabel!
    @IBOutlet weak var delta: UILabel!
    @IBOutlet weak var deltaResult: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var buyDeleteButton: UIButton!
    @IBOutlet weak var buyMarket: UILabel!
    

    //Sell table view Cell xib
    @IBOutlet weak var sellPrice: UILabel!
    @IBOutlet weak var sellPriceResult: UILabel!
    @IBOutlet weak var sellTradingPairs: UILabel!
    @IBOutlet weak var sellTradingPairResult: UILabel!
    @IBOutlet weak var sellProceedsResult: UILabel!
    @IBOutlet weak var sellProceeds: UILabel!
    @IBOutlet weak var sellAmountResult: UILabel!
    @IBOutlet weak var sellAmount: UILabel!
    @IBOutlet weak var sellDateLabel: UILabel!
    @IBOutlet weak var sellDeleteButton: UIButton!
    @IBOutlet weak var sellMarket: UILabel!
    open var timelinePoint = HistoryPoint()
    open var timeline = HistoryLine()
    
    open var labelPoint:UILabel = {
        var label = UILabel()
        label.layer.borderWidth = 0
        label.layer.cornerRadius = 15
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        setUpLabelPoint()
        setUpTheme()
    }
    
    
    override open func draw(_ rect: CGRect) {
        timelinePoint.position = CGPoint(x: timeline.leftMargin + timeline.width / 2, y: timelinePoint.lineWidth)
        timeline.start = CGPoint(x: timeline.leftMargin + timeline.width / 2 + 15, y: timelinePoint.lineWidth + 30)
        timeline.end = CGPoint(x: timeline.start.x, y: self.bounds.size.height)
        timeline.backColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        timeline.draw(view: self.contentView)
    }
    
    func setUpTheme(){
        historyView.backgroundColor = ThemeColor().walletCellcolor()
    }
    
    func buyLanguage(){
        SinglePrice.text = textValue(name: "buyPirce")
        tradingPairs.text = textValue(name: "buyTradingPair")
        amount.text = textValue(name: "boughtAmount")
        cost.text = textValue(name: "buyCost")
        worth.text = textValue(name: "buyWorth")
        delta.text = textValue(name: "buyDelta")
    }
    
    func sellLanguage(){
        sellPrice.text = textValue(name: "sellPirce")
        sellAmount.text = textValue(name: "soldAmount")
        sellProceeds.text = textValue(name: "Proceeds")
        sellTradingPairs.text = textValue(name: "sellTradingPair")
    }
    
    func setUpLabelPoint(){
        addSubview(labelPoint)
        NSLayoutConstraint(item: labelPoint, attribute: .leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: timeline.leftMargin + timeline.width / 2).isActive = true
        NSLayoutConstraint(item: labelPoint, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: timelinePoint.lineWidth).isActive = true
        NSLayoutConstraint(item: labelPoint, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 30).isActive = true
         NSLayoutConstraint(item: labelPoint, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 30).isActive = true
    }
}
