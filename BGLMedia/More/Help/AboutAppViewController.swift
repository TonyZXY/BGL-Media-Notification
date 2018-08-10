//
//  AboutAppViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var iconImage: UIImageView = {
        let width = view.frame.width/375
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 15
        image.frame = CGRect(x: 0, y: 0, width: 90 * width, height: 90 * width)
        image.image = UIImage(named: "CryptoGeekAppIcon")
        return image
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let versionNumber: Any? = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        let buildVersion: Any? = Bundle.main.infoDictionary!["CFBundleVersion"]
        label.textColor = ThemeColor().whiteColor()
        label.font = UIFont.semiBoldFont(14)
        label.textAlignment = .center
        label.text = "v"+(versionNumber as? String)! + "(" + (buildVersion as? String)! + ")"
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let supportLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        setUpView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    func setUpView(){
        let height = view.frame.height/736
        let width = view.frame.width/375
        titleLabel.text = textValue(name: "about_app")
        navigationItem.titleView = titleLabel
        view.addSubview(iconImage)
        view.addSubview(versionLabel)
        view.addSubview(companyLabel)
        view.addSubview(supportLabel)
        
        iconImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 40 * height ).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImage.widthAnchor.constraint(equalToConstant: 120 * width).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 120 * width).isActive = true
        
        versionLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 5 * height).isActive = true
        versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        versionLabel.widthAnchor.constraint(equalToConstant: 200 * width).isActive = true
        versionLabel.heightAnchor.constraint(equalToConstant: 30 * height).isActive = true
        
        
        

    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "about_app")
        navigationItem.titleView = titleLabel
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
}
