//
//  CoinImageSetter.swift
//  news app for blockchain
//
//  Created by Sheng Li on 10/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIImageView {
    func coinImageSetter(coinName: String, width: CGFloat = 50, height: CGFloat = 50, fontSize: CGFloat = 20) {
        self.image = nil
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        let icon: UIButton = {
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: width, height: width)
            button.layer.cornerRadius = width / 2
            button.backgroundColor = #colorLiteral(red: 0.2, green: 0.2039215686, blue: 0.2235294118, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(coinName, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = button.titleLabel?.font.withSize(fontSize)
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleEdgeInsets.left = 0
            button.titleEdgeInsets.right = 0
            button.titleEdgeInsets.top = 0
            button.titleEdgeInsets.bottom = 0
            return button
        }()
        self.addSubview(icon)
        
        var constraints = [NSLayoutConstraint]()
        
        let centerXConstraints = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
        
        let centerYConstraints = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)
        
        let widthContraints =  NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        let heightContraints = NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        
        constraints.append(centerXConstraints)
        constraints.append(centerYConstraints)
        constraints.append(widthContraints)
        constraints.append(heightContraints)
        
        NSLayoutConstraint.activate(constraints)
        
        let realm = try! Realm()
        let result = realm.objects(CoinList.self).filter("coinSymbol = %@", coinName)
        if result.count == 1 {
            let coin = result[0]
            let url = URL(string: "https://www.cryptocompare.com" + coin.logoUrl)
            self.kf.setImage(with: url, completionHandler: {
                (image, error, cacheType, imageUrl) in
                if error == nil {
                    icon.removeFromSuperview()
                }
            })
        }
    }
}
