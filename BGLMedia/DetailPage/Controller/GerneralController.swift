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
        scrollView.addSubview(FirstView)
        scrollView.addSubview(SecondView)
        scrollView.addSubview(ImageView)
        scrollView.addSubview(LastView)

        FirstView.addSubview(spinner)
        FirstView.addSubview(totalNumber)
        FirstView.addSubview(totalRiseFall)
        FirstView.addSubview(totalRiseFallPercent)

        SecondView.addSubview(market)
        SecondView.addSubview(tradingPairs)
        SecondView.addSubview(edit)
        
        
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: mainViews)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: mainViews)
        
        //ScrollView Constraint
        mainViews.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        mainViews.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)

        //Frist View constraint
        scrollView.addConstraintsWithFormat(format: "H:|[v0]|", views: FirstView)
        scrollView.addConstraintsWithFormat(format: "V:|-10-[v0(80)]", views: FirstView)
        NSLayoutConstraint(item: FirstView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        

        //Second View constraint
        scrollView.addConstraintsWithFormat(format: "H:|[v1]|", views: FirstView,SecondView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-5-[v1(50)]", views: FirstView,SecondView)
        NSLayoutConstraint(item: SecondView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true

        //Image View constraint
        ImageView.frame.size.width = view.frame.size.width-20
        scrollView.addConstraintsWithFormat(format: "H:[v1(\(view.frame.size.width-20))]", views: SecondView,ImageView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-5-[v1(200)]", views: SecondView,ImageView)
        NSLayoutConstraint(item: ImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
//         NSLayoutConstraint(item: ImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true

        //Last View constraint
        scrollView.addConstraintsWithFormat(format: "H:|-10-[v1]-10-|", views: ImageView,LastView)
        scrollView.addConstraintsWithFormat(format: "V:[v0]-10-[v1(120)]|", views: ImageView,LastView)
        NSLayoutConstraint(item: LastView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: mainViews, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true

        //First View TotalNumebr Label Constraint
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalNumber, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.height, multiplier: 1/2, constant: 0).isActive = true
//
//
        //First View TotalRiseFall Label Constraint
        NSLayoutConstraint(item: totalRiseFall, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: totalRiseFall, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFall, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.height, multiplier: 1/2, constant: 0).isActive = true

        //First View TotalRiseFallPercent Label Constraint
        NSLayoutConstraint(item: totalRiseFallPercent, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: totalRiseFall, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: totalRiseFallPercent, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: totalRiseFall, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10).isActive = true
        
        //First View Spinnner
        NSLayoutConstraint(item: spinner, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: spinner, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: FirstView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -15).isActive = true
//
        //Second View market Label Constraint
        NSLayoutConstraint(item: market, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: market, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.width, multiplier: 1/3, constant: -5).isActive = true
        NSLayoutConstraint(item: market, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: market, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.height, multiplier: 1/2, constant: 0).isActive = true

        //Second View tradingPairs Label Constraint
        NSLayoutConstraint(item: tradingPairs, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.width, multiplier: 1/3, constant: -5).isActive = true
        NSLayoutConstraint(item: tradingPairs, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: tradingPairs, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.height, multiplier: 1/2, constant: 0).isActive = true
        NSLayoutConstraint(item: tradingPairs, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: market, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 5).isActive = true
//
//        //Second View edit button Constraint
        NSLayoutConstraint(item: edit, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.width, multiplier: 1/3, constant: -5).isActive = true
        NSLayoutConstraint(item: edit, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: edit, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: edit, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: SecondView, attribute: NSLayoutAttribute.height, multiplier: 1/2, constant: 0).isActive = true
        NSLayoutConstraint(item: edit, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: tradingPairs, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 5).isActive = true
//
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var mainViews:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = ThemeColor().walletCellcolor()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var FirstView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var SecondView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var ImageView:UIView = {
        var imageView = UIView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.height = 200
        //        imageView.frame.size.width = 300
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    var LastView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var totalNumber:UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white
        label.text = "0"
        label.font = label.font.withSize(30)
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
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.8
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tradingPairs:UILabel = {
        var label = UILabel()
        label.text = "0"
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.8
        label.textAlignment = .center
        label.textColor = UIColor.white
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
        label.text = "市场总值"
        label.font = label.font.withSize(18)
        label.textColor = UIColor.white
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
        label.text = "24小时成交量"
        label.font = label.font.withSize(18)
        label.textColor = UIColor.white
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
        label.text = "流动供给"
        label.font = label.font.withSize(18)
        label.textColor = UIColor.white
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
        label.textColor = UIColor.white
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
