//
//  UpdateAlertViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 30/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class UpdateAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }

    func setUpView(){
        let factor = view.frame.width/375
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(alertView)
        alertView.addSubview(logoImage)
        logoImage.addSubview(logo)
        alertView.addSubview(cancelButton)
        alertView.addSubview(updateButton)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(40*factor)-[v0]-\(40*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: logoImage, attribute: .centerY, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: logoImage, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logo, attribute: .centerY, relatedBy: .equal, toItem: logoImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: logo, attribute: .centerX, relatedBy: .equal, toItem: logoImage, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logo]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(50*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logo]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoImage]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoImage]))
        
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: logoImage, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":titleLabel]))
        
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(10*factor)-[v0]-\(10*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":descriptionLabel]))
        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor)-[v0]-\(30*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":updateButton]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor)-[v0]-\(30*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cancelButton]))
        
        NSLayoutConstraint(item: updateButton, attribute: .top, relatedBy: .equal, toItem: descriptionLabel, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        
        
        NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: updateButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
    }
    
    var alertView:UIView = {
        var view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = ThemeColor().whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().darkBlackColor()
        label.font = UIFont.boldFont(18*view.frame.width/375)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.font = UIFont.regularFont(15*view.frame.width/375)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var updateButton:UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 8*view.frame.width/375
        button.backgroundColor = ThemeColor().blueColor()
        button.setTitle(textValue(name: "updateAlert_tab"), for: .normal)
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(15*view.frame.width/375)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton:UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 8*view.frame.width/375
        button.backgroundColor = ThemeColor().redColor()
        button.setTitle(textValue(name: "cancelAlert_tab"), for: .normal)
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(15*view.frame.width/375)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var logoImage:UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = ThemeColor().blueColor()
        imageView.layer.cornerRadius = 40*view.frame.width/375
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = ThemeColor().whiteColor().cgColor
        imageView.layer.borderWidth = 5*view.frame.width/375
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var logo:UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = ThemeColor().blueColor()
        imageView.layer.cornerRadius = 25*view.frame.width/375
        imageView.image = UIImage(named: "refresh-button")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


}
