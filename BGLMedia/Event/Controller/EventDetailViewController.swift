//
//  EventDetailViewController.swift
//  BGLMedia
//
//  Created by Fan Wu on 9/20/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    private var eventImageView:UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFit
        return uiImageView
    }()
    
    private var eventDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = ThemeColor().themeColor()
        textView.textColor = ThemeColor().whiteColor()
        textView.font = UIFont.regularFont(CGFloat(fontSize))
        return textView
    }()
    
    var eventViewModel: EventViewModel? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(cellView)
        cellView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        cellView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        cellView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        cellView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    lazy var cellView:UIView = {
        let stackView = UIStackView(arrangedSubviews: [eventImageView, eventDescriptionTextView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func updateUI() {
        if let imgUrlStr = eventViewModel?.imageUrlStr {
            eventImageView.setImage(urlString: imgUrlStr)
        }
        
        print(eventViewModel?.description ?? ".....")
        if let description = eventViewModel?.description {
            eventDescriptionTextView.text = description
        }
    }
}
