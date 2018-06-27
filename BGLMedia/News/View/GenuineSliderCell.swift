//
//  GenuineSliderCell.swift
//  news app for blockchain
//
//  Created by Xuyang Zheng on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class GenuineSliderCell: BaseCell {

    // set up content
    var newsContent: Genuine? {
        didSet {
            textView.text = newsContent?.title
            if (newsContent != nil) {
                image.setImage(urlString: (newsContent?.imageURL)!)
            }
        }
    }

    override func setupViews() {
        super.setupViews()
        setupRootView()
        setupSubViews()
        backgroundColor = ThemeColor().themeColor()
    }

    let view: UIView = {
        let vi = UIView()
        vi.backgroundColor = ThemeColor().walletCellcolor()
        vi.layer.cornerRadius = 4
        vi.layer.masksToBounds = true
        return vi
    }()

    let imageContainer: UIView = {
        let iv = UIView()
        return iv
    }()

    func setupRootView() {
        contentView.addSubview(view)
        addConstraintsWithFormat(format: "H:|-3-[v0]-3-|", views: view)
        addConstraintsWithFormat(format: "V:|-2-[v0]-2-|", views: view)
    }

    let image: UIImageView = {
        let iv = UIImageView()
        // REVIEW: use contentMode to stop scaling of the image -Johnny Lin
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    let textView: UILabel = {
        let tv = UILabel()
        tv.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        tv.textColor = UIColor.white
        return tv
    }()

    // constraints 
    func setupSubViews() {
        view.addSubview(imageContainer)
        imageContainer.addSubview(image)
        imageContainer.clipsToBounds = true
        addConstraintsWithFormat(format: "H:|-3-[v0]-3-|", views: imageContainer)
        addConstraintsWithFormat(format: "V:|-3-[v0]-3-|", views: imageContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: image)
        addConstraintsWithFormat(format: "V:|[v0]|", views: image)
        image.addSubview(textView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: textView)
        addConstraintsWithFormat(format: "V:|-195-[v0]|", views: textView)
    }


}

