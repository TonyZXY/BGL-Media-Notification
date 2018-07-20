//
//  NewsDetailtableView.swift
//  BGLMedia
//
//  Created by Bruce Feng on 9/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation

import UIKit

class NewsDetailTableViewCell:UITableViewCell{
    var coinNameItem = ["Bitcoin","CyberMiles"]
    
    var news: NewsObject? {
        didSet {
            newsTitle.text = news?.title
            if news?.imageURL != nil {
                let url = URL(string: (news?.imageURL)!)
                newsImage.kf.setImage(with: url, completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    if error == nil {
                        
                    }
                })
                newsImage.setImage(urlString: (news?.imageURL)!)
            }
            newsDescription.text = news?.newsDescription
            newsAuthor.text = news?.author
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    let cellView:UIView={
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let newsImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "navigation_arrow.png"))
        imageView.frame = CGRect(x: 0, y: 0, width: 120, height: 80)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let newsTitle:UILabel={
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         label.font = label.font.withSize(14)
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let newsDescription:UILabel={
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textColor = UIColor.gray
         label.font = label.font.withSize(12)
        return label
    }()
    
    let newsAuthor:UILabel={
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         label.font = label.font.withSize(10)
        label.textColor = UIColor.gray
        return label
    }()
    
    func setupView(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(cellView)
        cellView.addSubview(newsImage)
        cellView.addSubview(newsTitle)
        cellView.addSubview(newsDescription)
        cellView.addSubview(newsAuthor)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[v0]-5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-2-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        NSLayoutConstraint(item: newsImage, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(80)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsImage,"v1":newsTitle,"v2":newsDescription,"v3":newsAuthor]))
        cellView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0(120)]-5-[v1]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":newsImage,"v1":newsTitle,"v2":newsDescription,"v3":newsAuthor]))
        
//        
//        NSLayoutConstraint(item: newsImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: newsImage, attribute: .weight, relatedBy: .equal, toItem: nil, attribute: .weight, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: newsTitle, attribute: .top, relatedBy: .equal, toItem: newsImage, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newsTitle, attribute: .bottom, relatedBy: .equal, toItem: newsImage, attribute: .centerY, multiplier: 1/2, constant: 0).isActive = true
        
        NSLayoutConstraint(item: newsDescription, attribute: .top, relatedBy: .equal, toItem: newsImage, attribute: .centerY, multiplier: 1/2, constant: 0).isActive = true
        
        NSLayoutConstraint(item: newsDescription, attribute: .bottom, relatedBy: .equal, toItem: newsImage, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: newsDescription, attribute: .right, relatedBy: .equal, toItem: newsTitle, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newsDescription, attribute: .left, relatedBy: .equal, toItem: newsTitle, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newsAuthor, attribute: .bottom, relatedBy: .equal, toItem: cellView, attribute: .bottom, multiplier: 1, constant:-10).isActive = true
        NSLayoutConstraint(item: newsAuthor, attribute: .right, relatedBy: .equal, toItem: newsDescription, attribute: .right, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
}
