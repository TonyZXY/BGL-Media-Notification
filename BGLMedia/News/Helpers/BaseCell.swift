//
//  BaseCell.swift
//  NewsApp4
//
//  Created by Xuyang Zheng on 2/5/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
