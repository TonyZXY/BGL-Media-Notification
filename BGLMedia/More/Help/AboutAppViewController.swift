//
//  AboutAppViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 8.5
        image.setImage(urlString: "CryptoGeekAppIcon")
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
    }
    

}
