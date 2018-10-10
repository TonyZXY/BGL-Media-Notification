//
//  PopoverController.swift
//  workDictionary
//
//  Created by Fan Wu on 9/12/18.
//  Copyright © 2018 8184. All rights reserved.
//

import UIKit

//button struct for the popover
struct PopoverButton {
    let title: String
    let titleColor: UIColor
    let image: UIImage?
    let bgColor: UIColor?
    let cornerRadius: CGFloat
    
    init(_ title: String, titleColor: UIColor = .black, image: UIImage? = nil, bgColor: UIColor? = nil, cornerRadius: CGFloat = 0) {
        self.title = title
        self.titleColor = titleColor
        self.image = image
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
    }
}

protocol PopoverControllerDelegate { func popoverButtonAction(sender: UIButton) }

class PopoverController: UIViewController {
    
    //arrangeSubview will be added to Content View if it is setted
    var arrangeSubview: UIView?
    //get the bar button item from presented view controller so that we can set things on it in here
    var popoverBarButtonItem: UIBarButtonItem?
    var delegate: PopoverControllerDelegate?
    //buttons will be added to Content View if it is setted
    var buttons = [PopoverButton]()
    
    // MARK: Popover Contentview
    lazy var contentView: UIStackView = {
        //set up buttons
        let arrangedSubviews = buttons.map({ (item) -> UIButton in
            let button = UIButton()
            button.setTitle(item.title, for: .normal)
            button.setTitleColor(item.titleColor, for: .normal)
            button.setImage(item.image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.backgroundColor = item.bgColor
            button.layer.cornerRadius = item.cornerRadius
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            return button
        })

        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        if let arrSubview = arrangeSubview {
            stackView.addArrangedSubview(arrSubview)
        }

        //STACK VIEW SETTING
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        //add padding
        let padding: CGFloat = 8
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        //enable autolayout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //adjust the size of popover view
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = contentView.sizeThatFits(UILayoutFittingCompressedSize)
    }
    
    @objc func buttonAction(sender: UIButton) {
        popoverBarButtonItem?.title = sender.currentTitle
        popoverBarButtonItem?.image = sender.currentImage
        presentingViewController?.dismiss(animated: true)
        delegate?.popoverButtonAction(sender: sender)
    }
}

