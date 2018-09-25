//
//  File.swift
//  workDictionary
//
//  Created by Fan Wu on 9/24/18.
//  Copyright © 2018 8184. All rights reserved.
//

import Foundation
import UIKit

//UIStackView Tricks: Proportional Custom UIViews with ‘Fill Proportionally’
//see example in: https://spin.atomicobject.com/2017/02/07/uistackviev-proportional-custom-uiviews/

class SUIView: UIView {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUILabel: UILabel {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUIButton: UIButton {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUIStackView: UIStackView {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUITextView: UITextView {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUItable: UITableView {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUICollectionView: UICollectionView {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}

class SUIImageView: UIImageView {
    var height = 1.0
    var width = 1.0
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
}
