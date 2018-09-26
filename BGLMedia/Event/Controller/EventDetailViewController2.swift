//
//  EventDetailViewController.swift
//  BGLMedia
//
//  Created by Fan Wu on 9/20/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import SafariServices
import EventKitUI

//Even Detai View Version 2
//In case one day we need to use it so that I keep in here
class EventDetailViewController2: UIViewController {
    
    let eventLinkButtonTitle = "Event Link"
    let hostPageButtonTitle = "Host Page"
    
    private var eventImageView:SUIImageView = {
        let uiImageView = SUIImageView()
        uiImageView.contentMode = .scaleAspectFit
        uiImageView.clipsToBounds = true
        return uiImageView
    }()
    
    private var titleLabel: SUILabel = {
        var label = SUILabel()
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 2
        label.font = UIFont.boldFont(CGFloat(fontSize + 3))
        label.textAlignment = .center
        return label
    }()
    
    private var timeLabel: SUILabel = {
        let label = SUILabel()
        label.textColor = ThemeColor().whiteColor()
        label.backgroundColor = ThemeColor().themeColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.textAlignment = .center
        return label
    }()
    
    private var addressLabel:SUILabel = {
        var label = SUILabel()
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 0
        label.backgroundColor = ThemeColor().themeColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var urlButton: SUIButton = {
        let button = SUIButton()
        button.setTitle(eventLinkButtonTitle, for: .normal)
        let tintedImage = UIImage(named: "link")?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15)
        button.tintColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1), for: .normal)
        //button.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var hostPageButton: SUIButton = {
        let button = SUIButton()
        button.setTitle(hostPageButtonTitle, for: .normal)
        let tintedImage = UIImage(named: "link")?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15)
        button.tintColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        button.setTitleColor(#colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1), for: .normal)
        //button.backgroundColor = ThemeColor().darkBlackColor()
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    lazy private var buttonsStack: SUIStackView = {
        let stackView = SUIStackView(arrangedSubviews: [hostPageButton, urlButton])
        stackView.distribution = .fillEqually
        let padding: CGFloat = 8
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy private var eventDescriptionTextView: SUITextView = {
        let textView = SUITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.backgroundColor = ThemeColor().themeColor()
        textView.textColor = ThemeColor().whiteColor()
        textView.font = UIFont.regularFont(CGFloat(fontSize))
        //textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        return textView
    }()
    
    lazy var contentView:UIView = {
        //set the Proportions for each Stack Subviews
        titleLabel.height = 2.0
        eventImageView.height = 8.0
        addressLabel.height = 1.0
        timeLabel.height = 1.0
        eventDescriptionTextView.height = 24.0
        buttonsStack.height = 2.0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, eventImageView, addressLabel, timeLabel, eventDescriptionTextView, buttonsStack])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        view.addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        let addToCalendarBarButtonItem = UIBarButtonItem(image: UIImage(named: "calendar"), style: .done, target: self, action: #selector(addToCalendar))
        self.navigationItem.rightBarButtonItem  = addToCalendarBarButtonItem
    }
    
    func updateUI() {
        if let imgUrlStr = eventViewModel?.imageUrlStr {
            eventImageView.setImage(urlString: imgUrlStr)
        }
        titleLabel.text = eventViewModel?.title
        if let startTime = eventViewModel?.startTimeLabel,
            let endTime = eventViewModel?.endTimeLabel {
            timeLabel.text = "Start: \(startTime)   End: \(endTime)"
        }
        if let address = eventViewModel?.address {
            addressLabel.text = "Address: " + address
        }
        eventDescriptionTextView.text = eventViewModel?.description
    }
    
    @objc func buttonAction(sender: UIButton) {
        var urlString = ""
        if sender.currentTitle == eventLinkButtonTitle {
            urlString = eventViewModel?.urlStr ?? ""
        } else {
            urlString = eventViewModel?.hostPage ?? ""
        }
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            if #available(iOS 11.0, *) {
                vc.dismissButtonStyle = .close
            }
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            present(vc, animated: true)
        }
    }
    
    @objc func addToCalendar() {
        if let title = eventViewModel?.title,
            let startTime = eventViewModel?.eventStartTime,
            let endTime = eventViewModel?.eventEndTime,
            let description = eventViewModel?.address {
            addEventToCalendar(title: title, description: "Address: " + description, startDate: startTime, endDate: endTime) { (success, error) in
                if success {
                    let alert = UIAlertController(title: "Success!", message: "This Event has been added to your Calendar!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Fail!", message: "Sorry, it was fail to add this Event to your Calendar!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: "Fail!", message: "Sorry, fail to get the details of Event", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    private func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { () -> Void in
            let eventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                } else {
                    completion?(false, error as NSError?)
                }
            })
        }
    }
}
