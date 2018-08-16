//
//  FAQSubViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 14/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class FAQSubViewController: UIViewController {
    
    lazy var iconImage: UIImageView = {
        let width = view.frame.width/375
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 30
        image.frame = CGRect(x: 0, y: 0, width: 60 * width, height: 60 * width)
        image.image = UIImage(named: "CryptoGeekAppIcon")
        return image
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.semiBoldFont(16)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let answerText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.semiBoldFont(16)
        label.textColor = ThemeColor().greyColor()
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        setUpView()
    }
    
    init(label: String, text: String) {
        super.init(nibName: nil, bundle: nil)
        questionLabel.text = label
        answerText.text = text
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        
        let height = view.frame.height / 736
        let width = view.frame.width/375
        
        view.addSubview(questionLabel)
        view.addSubview(answerText)
        
        if #available(iOS 11.0, *) {
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50 * height).isActive = true
        } else {
            questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50 * height).isActive = true
        }
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        questionLabel.widthAnchor.constraint(equalToConstant: 200 * width).isActive = true
        questionLabel.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
        
        if #available(iOS 11.0, *) {
            answerText.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 50 * height).isActive = true
        } else {
            answerText.topAnchor.constraint(equalTo: view.topAnchor, constant: 50 * height).isActive = true
        }
        answerText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        answerText.widthAnchor.constraint(equalToConstant: 200 * width).isActive = true
        answerText.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
    }

    
}
