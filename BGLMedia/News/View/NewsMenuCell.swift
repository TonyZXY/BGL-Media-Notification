//
//  MenuCell.swift
//  NewsApp4
//
//  Created by Xuyang Zheng on 2/5/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class NewsMenuCell: BaseCell {

    lazy var textView: UILabel = {
        let tv = UILabel()
        tv.textColor = UIColor.rgb(red: 103, green: 179, blue: 183)
        tv.textAlignment = .center
        return tv
    }()

    override var isHighlighted: Bool {
        didSet {
            textView.textColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 103, green: 179, blue: 183)
        }
    }

    override var isSelected: Bool {
        didSet {
            textView.textColor = isSelected ? UIColor.white : UIColor.rgb(red: 103, green: 179, blue: 183)
        }
    }

    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addConstraintsWithFormat(format: "H:[v0(50)]", views: textView)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: textView)
        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
