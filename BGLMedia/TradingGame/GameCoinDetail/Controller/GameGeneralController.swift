//
//  GameGeneralController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 10/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GameGerneralController: UIViewController {
    var observer:NSObjectProtocol?
    var generalData = generalDetail()
    let realm = try! Realm()
    let vc = CandleStickChartViewController()
    
    var candleChartDatas:candleChartData?{
        didSet{
            setUpView()
        }
    }
    
    var factor:CGFloat?{
        didSet{
            //            setUpView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func addChildViewControllers(childViewControllers:UIViewController,views:UIView){
        addChildViewController(childViewControllers)
        views.addSubview(childViewControllers.view)
        childViewControllers.view.frame = views.bounds
        childViewControllers.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewControllers.didMove(toParentViewController: self)
        
        //Constraints
        childViewControllers.view.translatesAutoresizingMaskIntoConstraints = false
        childViewControllers.view.topAnchor.constraint(equalTo: views.topAnchor).isActive = true
        childViewControllers.view.leftAnchor.constraint(equalTo: views.leftAnchor).isActive = true
        childViewControllers.view.widthAnchor.constraint(equalTo: views.widthAnchor).isActive = true
        childViewControllers.view.heightAnchor.constraint(equalTo: views.heightAnchor).isActive = true
    }
    
    func setUpView(){
        
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(mainViews)
        
        mainViews.addSubview(scrollView)
        scrollView.addSubview(graphLabel)
        scrollView.addSubview(globalMarketLabel)
        scrollView.addSubview(secondView)
        scrollView.addSubview(firstView)
        scrollView.addSubview(ImageView)
        scrollView.addSubview(LastView)
        scrollView.addSubview(stopLossLabel)
        scrollView.addSubview(stopLossSetView)
        
        secondView.addSubview(spinner)
        secondView.addSubview(totalNumber)
        //        FirstView.addSubview(defaultCurrencyLable)
        secondView.addSubview(totalRiseFall)
        secondView.addSubview(totalRiseFallPercent)
        
        firstView.addSubview(exchangeButton)
        firstView.addSubview(tradingPairButton)
        
        stopLossSetView.backgroundColor = .red
        
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: mainViews)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: mainViews)
        
        //ScrollView Constraint
        mainViews.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        mainViews.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
        
        // horizontal constraints for scroll view
        scrollView.addConstraintsWithFormat(format: "H:|-\(15*factor!)-[v0]-\(15*factor!)-|", views: firstView)
        scrollView.addConstraintsWithFormat(format: "H:|-\(15*factor!)-[v0]-\(15*factor!)-|", views: secondView)
        scrollView.addConstraintsWithFormat(format: "H:[v0(\(view.frame.size.width-30*factor!))]", views: ImageView)
        scrollView.addConstraintsWithFormat(format: "H:|-\(15*factor!)-[v0]-\(15*factor!)-|", views: LastView)
        scrollView.addConstraintsWithFormat(format: "H:|-\(15*factor!)-[v0]-\(15*factor!)-|", views: stopLossSetView)
        
        // vertical constraints for scroll view
        scrollView.addConstraintsWithFormat(format: "V:|-\(5*factor!)-[v0(\(50*factor!))]", views: firstView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(5*factor!)-[v1(\(100*factor!))]", views: firstView,secondView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(10*factor!)-[v1]", views: secondView,graphLabel)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(5*factor!)-[v1(\(200*factor!))]", views: graphLabel,ImageView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(10*factor!)-[v1]", views: ImageView,globalMarketLabel)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(10*factor!)-[v1(\(120*factor!))]", views: globalMarketLabel,LastView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(10*factor!)-[v1]", views: LastView,stopLossLabel)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(5*factor!)-[v1(\(300*factor!))]|", views: stopLossLabel,stopLossSetView)
        
        // inside firstview (trading pair and exchange)
        NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: exchangeButton, attribute: .left, relatedBy: .equal, toItem: firstView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: exchangeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 30*factor!).isActive = true
        NSLayoutConstraint(item: exchangeButton, attribute: .bottom, relatedBy: .equal, toItem: firstView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tradingPairButton, attribute: .right, relatedBy: .equal, toItem: firstView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradingPairButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 30*factor!).isActive = true
        NSLayoutConstraint(item: tradingPairButton, attribute: .bottom, relatedBy: .equal, toItem: firstView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        // inside second view (price display)
        NSLayoutConstraint(item: secondView, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: .bottom, relatedBy: .equal, toItem: secondView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: .centerX, relatedBy: .equal, toItem: secondView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFall, attribute: .top, relatedBy: .equal, toItem: secondView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFall, attribute: .centerX, relatedBy: .equal, toItem: secondView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFallPercent, attribute: .top, relatedBy: .equal, toItem: totalRiseFall, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFallPercent, attribute: .centerX, relatedBy: .equal, toItem: secondView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .right, relatedBy: .equal, toItem: secondView, attribute: .right, multiplier: 1, constant: -10*factor!).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: secondView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        //Graph
        NSLayoutConstraint(item: graphLabel, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        ImageView.frame.size.width = view.frame.size.width-30*factor!
        NSLayoutConstraint(item: ImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        //Global Market

        NSLayoutConstraint(item: globalMarketLabel, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: LastView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        
        let stack2 = setUpStackView(view: [setUpStackView(view: [volume,volumeResult], spacing: 0, axis: .vertical),setUpStackView(view: [circulatingSupply,circulatingSupplyResult], spacing: 0, axis: .vertical)], spacing: 5*factor!, axis: .horizontal)
        
        let totalStack = setUpStackView(view: [setUpStackView(view: [marketCap,marketCapResult], spacing: 0, axis: .vertical),stack2], spacing: 5*factor!, axis: .vertical)
        
        LastView.addSubview(totalStack)
        LastView.addConstraintsWithFormat(format: "H:|-\(10*factor!)-[v0]-\(10*factor!)-|", views: totalStack)
        LastView.addConstraintsWithFormat(format: "V:|[v0]|", views: totalStack)
        
        // Stop Loss
        NSLayoutConstraint(item: stopLossLabel, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stopLossSetView, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        // set up contents for each views
        vc.willMove(toParentViewController: self)
        ImageView.addSubview(vc.view)
        self.addChildViewController(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.frame.size.height = ImageView.frame.size.height
        vc.view.frame.size.width = ImageView.frame.size.width
        
        NSLayoutConstraint(item: vc.view, attribute: .centerX, relatedBy: .equal, toItem: ImageView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .centerY, relatedBy: .equal, toItem: ImageView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .width, relatedBy: .equal, toItem: ImageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .height, relatedBy: .equal, toItem: ImageView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        vc.coinSymbol = candleChartDatas
        vc.didMove(toParentViewController: self)
        marketCap.text = textValue(name: "marketCap_detail")
        volume.text = textValue(name: "volume_detail")
        circulatingSupply.text = textValue(name: "circulatingSupply_detail")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var exchangeButton:UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1 * factor!
        button.layer.borderColor = ThemeColor().blueColor().cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(ThemeColor().blueColor(), for: .normal)
        button.layer.cornerRadius = 5*factor!
        button.titleLabel?.font = UIFont.semiBoldFont(15*factor!)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10*factor!, 0, 10*factor!)
        return button
    }()
    
    lazy var tradingPairButton:UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1*factor!
        button.layer.borderColor = ThemeColor().blueColor().cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(ThemeColor().blueColor(), for: .normal)
        button.layer.cornerRadius = 5*factor!
        button.titleLabel?.font = UIFont.semiBoldFont(15*factor!)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10*factor!, 0, 10*factor!)
        return button
    }()
    
    var mainViews:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = ThemeColor().darkGreyColor()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var secondView:UIView = {
        var views = UIView()
        views.backgroundColor = ThemeColor().greyColor()
        views.layer.cornerRadius = 8 * factor!
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    var firstView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().darkGreyColor()
        //        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var graphLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = UIFont.semiBoldFont(15*factor!)
        label.text = textValue(name: "titleGraphs_details")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var globalMarketLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = UIFont.semiBoldFont(15*factor!)
        label.text = textValue(name: "titleGlobal_details")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ImageView:UIView = {
        var imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.height = 200
        //        imageView.frame.size.width = 300
        //        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = 8*factor!
        return imageView
    }()
    
    lazy var LastView:UIView = {
        var views = UIView()
        views.backgroundColor = ThemeColor().greyColor()
        views.layer.cornerRadius = 8 * factor!
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    lazy var totalNumber:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.text = "0"
        label.font = UIFont.regularFont(25*factor!)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    lazy var defaultCurrencyLable:UILabel = {
    //        var label = UILabel()
    //        label.textColor = UIColor.white
    //        label.font = label.font.withSize(30*factor!)
    //        label.textColor = ThemeColor().bglColor()
    //        label.sizeToFit()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
    lazy var totalRiseFall:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.font = UIFont.regularFont(17*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalRiseFallPercent:UILabel = {
        var label = UILabel()
        label.font = UIFont.regularFont(17*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    
    lazy var marketCap:UILabel = {
        var label = UILabel()
        label.font = UIFont.regularFont(13*factor!)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var marketCapResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = UIFont.regularFont(15*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    var marketRiseFall:UILabel = {
    //        var label = UILabel()
    //        label.text = "0"
    //        label.textColor = UIColor.white
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    //
    //    var marketRiseFallResult:UILabel = {
    //        var label = UILabel()
    //        label.text = "0"
    //        label.textColor = UIColor.white
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
    lazy var volume:UILabel = {
        var label = UILabel()
        label.font = UIFont.regularFont(13*factor!)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var spinner:UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    lazy var volumeResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = UIFont.regularFont(15*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var circulatingSupply:UILabel = {
        var label = UILabel()
        label.font = UIFont.regularFont(13*factor!)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var circulatingSupplyResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = UIFont.regularFont(15*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    var low:UILabel = {
    //        var label = UILabel()
    //        label.text = "0"
    //        label.textColor = ThemeColor().textGreycolor()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    //
    //    var lowResult:UILabel = {
    //        var label = UILabel()
    //        label.text = "0"
    //        label.textColor = UIColor.white
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
    //    var high:UILabel = {
    //        var label = UILabel()
    //        label.text = "0"
    //        label.textColor = UIColor.white
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    //
    //    var highResult:UILabel = {
    //        var label = UILabel()
    //        label.text = "0"
    //        label.textColor = UIColor.white
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        return label
    //    }()
    
    
    // stop and loss section
    lazy var stopLossLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = UIFont.semiBoldFont(15*factor!)
        label.text = textValue(name: "titleGraphs_details")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stopLossSetView = StopLossSetView()
    
    func setUpStackView(view:[UIView],spacing:CGFloat,axis:UILayoutConstraintAxis)-> UIStackView{
        let stackView = UIStackView(arrangedSubviews: view)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .fillEqually
        return stackView
    }
    
}