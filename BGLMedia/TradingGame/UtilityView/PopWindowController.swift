//
//  RankInfoPopView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 5/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit
/**
    utility pop window can customize content inside with constructor
 */
class PopWindowController : UIViewController{
    
    // default value
    var windowSize = CGSize(width: 300, height: 200)
    
    var rootView : UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
       return view
    }()
    
    var stackView : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.spacing = 0
        return  stackView
    }()
    
    var headerView: UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        return view
    }()
    
    var contentView : UIView = {
        var view = UIView()
        return view
    }()

    
    var titleLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        let factor = view.frame.width/414
        
        let dissmissButton = DismissButton(width: 30*factor, height: 30*factor, dismissController: self)
        
        view.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat(format: "H:[v0(\(windowSize.width))]", views: rootView)
        view.addConstraintsWithFormat(format: "V:[v0(\(windowSize.height))]", views: rootView)
        view.addConstraint(NSLayoutConstraint(item: rootView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: rootView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        
        rootView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraintsWithFormat(format: "H:|[v0]|", views: stackView)
        rootView.addConstraintsWithFormat(format: "V:|[v0]|", views: stackView)

        stackView.addSubview(headerView)
        stackView.addSubview(contentView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addConstraintsWithFormat(format: "H:|[v0]|", views: headerView)
        stackView.addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        stackView.addConstraintsWithFormat(format: "V:|-0-[v0(\(50*factor))]-0-[v1]|", views: headerView, contentView)
        
        headerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: headerView, attribute: .centerX, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0))


        headerView.addSubview(dissmissButton)
        headerView.addConstraint(NSLayoutConstraint(item: dissmissButton, attribute: .centerY, relatedBy: .equal, toItem: headerView, attribute: .centerY, multiplier: 1, constant: 0))
        headerView.addConstraintsWithFormat(format: "H:[v0]-(\(5*factor))-|", views: dissmissButton)
        
    }
    
    convenience init(windowSize:CGSize?=nil, title: String?=nil,contentView : UIView?=nil){
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        self.contentView = contentView ?? self.contentView
        self.titleLabel.text = title ?? "Title"
        self.windowSize = windowSize ?? self.windowSize
    }
}


class DismissButton : UIButton{
    
    let defaultWidth:CGFloat = 50
    let defaultHeight:CGFloat = 50
    
    var dismissViewController : UIViewController?
    
    func initSetup (width: CGFloat,height:CGFloat,dismissController:UIViewController){
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.setImage(UIImage(named: "back_button")?.reSizeImage(reSize: CGSize(width: width, height: height)), for: .normal)
        self.clipsToBounds = true
        
        self.dismissViewController = dismissController
        self.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView(){
        self.dismissViewController?.dismiss(animated: true, completion: nil)
    }
    
    convenience init(width:CGFloat?,height:CGFloat?,dismissController:UIViewController) {
        self.init(type: .custom)
        initSetup(width: width ?? defaultWidth, height: height ?? defaultHeight,dismissController: dismissController)
    }
}
