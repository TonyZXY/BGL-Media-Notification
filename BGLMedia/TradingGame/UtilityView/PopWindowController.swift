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
    let factor = UIScreen.main.bounds.width/375
    
    var headerTitle : String = "Title"
    
    // default value
    var windowSize = CGSize(width: 300, height: 200)
    
    var rootView : UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().whiteColor()
        view.layer.cornerRadius = 15
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
    
    private let title_linebreak : UIView = {
        let linebreak = UIView()
        linebreak.backgroundColor = ThemeColor().themeWidgetColor()
        linebreak.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return linebreak
    }()
    
    private lazy var dismissButton : DismissButton = {
        let button = DismissButton(width: 30*factor, height: 30*factor, dismissController: self)
        button.backgroundColor = ThemeColor().themeWidgetColor()
        button.layer.cornerRadius = 3
        button.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        return button
    }()
    
    lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    lazy var headerView: UIView = {
        var view = UIView()
        self.setUpDefaultHeader(headerview: view)
        return view
    }()
    
    lazy var contentView : UIView = {
        var view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
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
        
    }
    
    private func setUpDefaultHeader(headerview : UIView){
        headerview.addSubview(titleLabel)
        headerview.addSubview(dismissButton)
        headerview.addSubview(title_linebreak)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        headerview.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: headerview, attribute: .centerX, multiplier: 1, constant: 0))
        headerview.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: headerview, attribute: .centerY, multiplier: 1, constant: 0))
        
        headerview.addConstraint(NSLayoutConstraint(item: dismissButton, attribute: .centerY, relatedBy: .equal, toItem: headerview, attribute: .centerY, multiplier: 1, constant: 0))
        headerview.addConstraintsWithFormat(format: "H:[v0]-(\(15*factor))-|", views: dismissButton)
        headerview.addConstraintsWithFormat(format: "H:|[v0]|", views: title_linebreak)
        headerview.addConstraintsWithFormat(format: "V:[v0]|", views: title_linebreak)
    }
    
    convenience init(windowSize:CGSize?=nil,title: String?=nil,headerView : UIView?=nil, contentView : UIView?=nil){
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        // set tilte before headerview so defaultHeader can dispaly it
        self.headerView = headerView ?? self.headerView
        self.titleLabel.text = title ?? "Title"
        self.contentView = contentView ?? self.contentView
        self.windowSize = windowSize ?? self.windowSize
    }
}


class DismissButton : UIButton{
    
    let defaultWidth:CGFloat = 50
    let defaultHeight:CGFloat = 50
    let defaultImageName : String = "close_button"
    var dismissViewController : UIViewController?
    
    private func initSetup (width: CGFloat,height:CGFloat,imageName: String,dismissController:UIViewController){
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.setImage(UIImage(named: imageName)?.reSizeImage(reSize: CGSize(width: width, height: height)), for: .normal)
        self.clipsToBounds = true
        
        self.dismissViewController = dismissController
        self.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc func dismissView(){
        self.dismissViewController?.dismiss(animated: true, completion: nil)
    }
    
    convenience init(width:CGFloat?=nil,height:CGFloat?=nil,imageName : String?=nil,dismissController:UIViewController) {
        self.init(type: .custom)
        initSetup(width: width ?? defaultWidth, height: height ?? defaultHeight,imageName : imageName ?? defaultImageName,dismissController: dismissController)
    }
}
