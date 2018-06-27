//
//  VideoCell.swift
//  news app for blockchain
//
//  Created by Xuyang Zheng on 8/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCell: BaseCell {
    weak var homeViewController: NewsHomeViewController?

    // set up content
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            timeLabel.text = video?.publishedTime
            authorLabel.text = video?.author
            if video?.imageURL != nil {
                imageView.setImage(urlString: (video?.imageURL)!)
            }
        }
    }


    let view: UIView = {
        let view = UIView()
        return view
    }()

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let imageContainer: UIView = {
        let iv = UIView()
        return iv
    }()

    let titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .left
        tl.font = tl.font.withSize(15)
        tl.textColor = UIColor.white
        return tl
    }()

    let timeLabel: UILabel = {
        let tl = UILabel()
        tl.font = tl.font.withSize(12)
        tl.textAlignment = .left
        tl.textColor = UIColor.gray
        return tl
    }()

    let authorLabel: UILabel = {
        let al = UILabel()
        al.font = al.font.withSize(12)
        al.textAlignment = .left
        al.textColor = UIColor.gray
        return al
    }()

    override func setupViews() {
        super.setupViews()
        setupRootView()
        setupSubViews()
    }

    func setupRootView() {
        addSubview(view)
        addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: view)
        addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: view)
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
    }

    // constraints of the view
    func setupSubViews() {
        view.addSubview(imageContainer)
        imageContainer.clipsToBounds = true
        imageContainer.addSubview(imageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(authorLabel)
        let height = (frame.width - 30) * 9 / 16

        addConstraintsWithFormat(format: "H:|-10-[v0(90)]", views: authorLabel, timeLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0(\(frame.width-30))]-10-|", views: imageContainer)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0(\(height))]-5-[v1(25)]-5-[v2(15)]", views: imageContainer, titleLabel, authorLabel)

        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 15))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .left, relatedBy: .equal, toItem: authorLabel, attribute: .right, multiplier: 1, constant: 5))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 200))
    }
}
