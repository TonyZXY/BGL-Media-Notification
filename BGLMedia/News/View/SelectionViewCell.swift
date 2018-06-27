//
//  SelectionViewCell.swift
//  NewsApp4
//
//  Created by Xuyang Zheng on 3/5/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class SelectionViewCell: BaseCell {
    override func setupViews() {
        super.setupViews()
        setupRootView()

    }

    lazy var view: UIView = {
        var view = UIView()
        return view
    }()

    // constraints of the view
    func setupRootView() {
        addSubview(view)
        addConstraintsWithFormat(format: "H:|[v0]|", views: view)
        addConstraintsWithFormat(format: "V:|[v0]|", views: view)
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(textLabel)
        textLabel.layer.cornerRadius = 5
        textLabel.layer.masksToBounds = true
        textLabel.textColor = UIColor.rgb(red: 103, green: 179, blue: 183)
        addConstraintsWithFormat(format: "H:|[v0]|", views: textLabel)
        addConstraintsWithFormat(format: "V:|-3-[v0]-3-|", views: textLabel)
    }

    override var isHighlighted: Bool {
        didSet {
            textLabel.textColor = isHighlighted ? UIColor.gray : UIColor.rgb(red: 103, green: 179, blue: 183)
            textLabel.backgroundColor = isHighlighted ? UIColor.rgb(red: 228, green: 228, blue: 228) : UIColor.darkGray
        }
    }

    override var isSelected: Bool {
        didSet {
            textLabel.textColor = isSelected ? UIColor.gray : UIColor.rgb(red: 103, green: 179, blue: 183)
            textLabel.backgroundColor = isSelected ? UIColor.rgb(red: 228, green: 228, blue: 228) : UIColor.darkGray
        }
    }

    lazy var textLabel: UILabel = {
        var tx = UILabel()
        tx.backgroundColor = .darkGray
        tx.textColor = UIColor.white
        tx.textAlignment = .center
        tx.font = tx.font.withSize(15)
        return tx
    }()
}
