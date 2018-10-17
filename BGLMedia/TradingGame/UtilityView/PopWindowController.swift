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
    
    var rootView : UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().whiteColor()
        view.layer.cornerRadius = 15
        view.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
       return view
    }()
    
    var contentView : UIView = {
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
        view.addConstraint(NSLayoutConstraint(item: rootView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: rootView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))

        rootView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: rootView, attribute: .centerX, multiplier: 1, constant: 0))
        rootView.addConstraint(NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: rootView, attribute: .centerY, multiplier: 1, constant: 0))
        // rootview should resize depends on contentView
        rootView.matchAllAnchors(height:contentView.heightAnchor, width: contentView.widthAnchor)
        
    }
    
    /**
        pop out a window in the middle of the screen and size depends on content size
        - Parameters:
            - contentView : content in side window, xwindow size will depends on content size
     */
    convenience init(contentView : UIView?=nil){
        self.init()
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.contentView = contentView ?? self.contentView
        setUpView()
    }
    
}

class PopWindowHeader : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    private let title_linebreak : UIView = {
        let linebreak = UIView()
        linebreak.backgroundColor = ThemeColor().themeWidgetColor()
        linebreak.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return linebreak
    }()
    
    lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    lazy var dismissButton : DismissButton = {
        // dismissController need to be setted outSide now
        let button = DismissButton(width: 30*factor, height: 30*factor)
        button.backgroundColor = ThemeColor().themeWidgetColor()
        button.layer.cornerRadius = 3
        button.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        return button
    }()
    
    private func setupView(){
        
//        self.heightAnchor.constraint(equalToConstant: 50*factor)
        
        self.addSubview(titleLabel)
        self.addSubview(dismissButton)
        self.addSubview(title_linebreak)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: dismissButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        self.addConstraintsWithFormat(format: "H:[v0]-(\(15*factor))-|", views: dismissButton)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: title_linebreak)
        self.addConstraintsWithFormat(format: "V:[v0]|", views: title_linebreak)
    }
    
    convenience init(title : String?=nil,dismissContorller: UIViewController?=nil){
        self.init()
        self.dismissButton.dismissController = dismissContorller
        self.titleLabel.text = title ?? "Title"
        self.setupView()
        
    }
}


class DismissButton : UIButton{
    
    let defaultWidth:CGFloat = 50
    let defaultHeight:CGFloat = 50
    let defaultImageName : String = "close_button"
    var dismissController : UIViewController?
    
    private func initSetupWithImage (width: CGFloat,height:CGFloat,imageName: String,dismissController:UIViewController?){
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.setImage(UIImage(named: imageName)?.reSizeImage(reSize: CGSize(width: width, height: height)), for: .normal)
        self.clipsToBounds = true
        
        self.dismissController = dismissController
        self.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    
    @objc func dismissView(){
        self.dismissController?.dismiss(animated: true, completion: nil)
    }
    
    convenience init(width:CGFloat?=nil,height:CGFloat?=nil,imageName : String?=nil,dismissController:UIViewController?=nil) {
        self.init(type: .custom)
        initSetupWithImage(width: width ?? defaultWidth, height: height ?? defaultHeight,imageName : imageName ?? defaultImageName,dismissController: dismissController)
    }
}
