//
//  GerneralController.swift
//  news app for blockchain
//
//  Created by Bruce Feng on 21/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import RealmSwift
class GerneralController: UIViewController {
    var observer:NSObjectProtocol?
    var generalData = generalDetail()
    let realm = try! Realm()
    let vc = CandleStickChartViewController()
    var coinSymbol:String = ""
    
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
        scrollView.addSubview(FirstView)
        scrollView.addSubview(SecondView)
        scrollView.addSubview(ImageView)
        scrollView.addSubview(LastView)

        FirstView.addSubview(spinner)
        FirstView.addSubview(totalNumber)
//        FirstView.addSubview(defaultCurrencyLable)
        FirstView.addSubview(totalRiseFall)
        FirstView.addSubview(totalRiseFallPercent)

        
        
        SecondView.addSubview(market)
        SecondView.addSubview(tradingPairs)
        SecondView.addSubview(edit)
        SecondView.addSubview(exchangeButton)
        SecondView.addSubview(tradingPairButton)
        
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: mainViews)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: mainViews)
        
        //ScrollView Constraint
        mainViews.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        mainViews.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)

        //Market View constraint
        scrollView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: SecondView)
        scrollView.addConstraintsWithFormat(format: "V:|-5-[v0(50)]", views: SecondView)
        NSLayoutConstraint(item: SecondView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        //Market View
        NSLayoutConstraint(item: market, attribute: .bottom, relatedBy: .equal, toItem: SecondView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradingPairs, attribute: .top, relatedBy: .equal, toItem: SecondView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: market, attribute: .centerX, relatedBy: .equal, toItem: SecondView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradingPairs, attribute: .centerX, relatedBy: .equal, toItem: SecondView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: edit, attribute: .right, relatedBy: .equal, toItem: SecondView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: edit, attribute: .centerY, relatedBy: .equal, toItem: SecondView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        
        
        NSLayoutConstraint(item: exchangeButton, attribute: .left, relatedBy: .equal, toItem: SecondView, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: exchangeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 30).isActive = true
        NSLayoutConstraint(item: exchangeButton, attribute: .bottom, relatedBy: .equal, toItem: SecondView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: tradingPairButton, attribute: .right, relatedBy: .equal, toItem: SecondView, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradingPairButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 30).isActive = true
        NSLayoutConstraint(item: tradingPairButton, attribute: .bottom, relatedBy: .equal, toItem: SecondView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        
        
        //Price View constraint
        scrollView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: FirstView)
        scrollView.addConstraintsWithFormat(format: "V:[v1]-5-[v0(80)]", views: FirstView,SecondView)
        NSLayoutConstraint(item: FirstView, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: .bottom, relatedBy: .equal, toItem: FirstView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: .centerX, relatedBy: .equal, toItem: FirstView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFall, attribute: .top, relatedBy: .equal, toItem: FirstView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFallPercent, attribute: .top, relatedBy: .equal, toItem: FirstView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFall, attribute: .right, relatedBy: .equal, toItem: FirstView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFallPercent, attribute: .left, relatedBy: .equal, toItem: FirstView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
         NSLayoutConstraint(item: spinner, attribute: .right, relatedBy: .equal, toItem: FirstView, attribute: .right, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: FirstView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        //Graph
        scrollView.addConstraintsWithFormat(format: "V:[v0]-10-[v1]", views: FirstView,graphLabel)
        NSLayoutConstraint(item: graphLabel, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        ImageView.frame.size.width = view.frame.size.width-30
        scrollView.addConstraintsWithFormat(format: "H:[v1(\(view.frame.size.width-30))]", views: SecondView,ImageView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-5-[v1(200)]", views: graphLabel,ImageView)
        NSLayoutConstraint(item: ImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        
        //Global Market
        scrollView.addConstraintsWithFormat(format: "V:[v0]-10-[v1]", views: ImageView,globalMarketLabel)
        NSLayoutConstraint(item: globalMarketLabel, attribute: .centerX, relatedBy: .equal, toItem: mainViews, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        scrollView.addConstraintsWithFormat(format: "H:|-15-[v1]-15-|", views: globalMarketLabel,LastView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-10-[v1(120)]|", views: globalMarketLabel,LastView)
        NSLayoutConstraint(item: LastView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        

        let stack2 = setUpStackView(view: [setUpStackView(view: [volume,volumeResult], spacing: 0, axis: .vertical),setUpStackView(view: [circulatingSupply,circulatingSupplyResult], spacing: 0, axis: .vertical)], spacing: 5, axis: .horizontal)

        let totalStack = setUpStackView(view: [setUpStackView(view: [marketCap,marketCapResult], spacing: 0, axis: .vertical),stack2], spacing: 5, axis: .vertical)

        LastView.addSubview(totalStack)
        LastView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: totalStack)
        LastView.addConstraintsWithFormat(format: "V:|[v0]|", views: totalStack)
        
        
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
        vc.coinSymbol = coinSymbol
        vc.didMove(toParentViewController: self)
        
        marketCap.text = textValue(name: "marketCap_detail")
        volume.text = textValue(name: "volume_detail")
        circulatingSupply.text = textValue(name: "circulatingSupply_detail")
        globalMarketLabel.text = textValue(name: "titleGraphs_details")
        graphLabel.text = textValue(name: "titleGlobal_details")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var exchangeButton:UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = ThemeColor().blueColor().cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(ThemeColor().blueColor(), for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = button.titleLabel?.font.withSize(15)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        return button
    }()
    
    var tradingPairButton:UIButton = {
        var button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = ThemeColor().blueColor().cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(ThemeColor().blueColor(), for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = button.titleLabel?.font.withSize(15)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
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
    
    var FirstView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var SecondView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().darkGreyColor()
//        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var graphLabel:UILabel = {
       var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var globalMarketLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ImageView:UIView = {
        var imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.height = 200
//        imageView.frame.size.width = 300
//        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    var LastView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().greyColor()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalNumber:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.text = "0"
        label.font = label.font.withSize(25)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var defaultCurrencyLable:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.font = label.font.withSize(30)
        label.textColor = ThemeColor().bglColor()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalRiseFall:UILabel = {
        var label = UILabel()
        label.text = "--"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var totalRiseFallPercent:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var market:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = label.font.withSize(15)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tradingPairs:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textAlignment = .center
        label.font = label.font.withSize(13)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var edit:UIButton = {
        var button = UIButton(type:.system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var marketCap:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var marketCapResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = label.font.withSize(15)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var marketRiseFall:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var marketRiseFallResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var volume:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var spinner:UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    var volumeResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = label.font.withSize(15)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var circulatingSupply:UILabel = {
        var label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var circulatingSupplyResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = label.font.withSize(15)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var low:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lowResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var high:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var highResult:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpStackView(view:[UIView],spacing:CGFloat,axis:UILayoutConstraintAxis)-> UIStackView{
        let stackView = UIStackView(arrangedSubviews: view)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .fillEqually
        return stackView
    }
    
}
