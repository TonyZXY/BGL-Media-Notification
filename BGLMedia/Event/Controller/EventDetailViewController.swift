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

class EventDetailViewController: UIViewController {
    
    let eventLinkButtonTitle = "Event Link"
    
    private var eventImageView:UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFit
        return uiImageView
    }()
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 2
        label.font = UIFont.boldFont(CGFloat(fontSize + 3))
        return label
    }()
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeColor().whiteColor()
        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        return label
    }()
    
    private var addressLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 0
        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        return label
    }()
    
    private lazy var urlButton: UIButton = {
        let button = UIButton()
        button.setTitle(eventLinkButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private var hostPageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    lazy private var LinksStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hostPageButton, urlButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy private var imageAndLabelsAndButtonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [eventImageView, LinksStack, titleLabel, addressLabel, timeLabel])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
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
    
    lazy var contentView:UIView = {
        let stackView = UIStackView(arrangedSubviews: [imageAndLabelsAndButtonsStack, eventDescriptionTextView])
        stackView.distribution = .fillEqually
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

        let addToCalendarBarButtonItem = UIBarButtonItem(title: "Add to Calendar", style: .done, target: self, action: #selector(addToCalendar))
        self.navigationItem.rightBarButtonItem  = addToCalendarBarButtonItem
    }
    
    func updateUI() {
        if let imgUrlStr = eventViewModel?.imageUrlStr {
            eventImageView.setImage(urlString: imgUrlStr)
        }
        titleLabel.text = eventViewModel?.title
        if let startTime = eventViewModel?.startTimeLabel,
            let endTime = eventViewModel?.endTimeLable {
            timeLabel.text = "Start: \(startTime)   End: \(endTime)"
        }
        addressLabel.text = eventViewModel?.address
        hostPageButton.setTitle(eventViewModel?.host, for: .normal)
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
                    let alert = UIAlertController(title: "Fail!", message: "Sorry, it is fail to add this Event to your Calendar!", preferredStyle: .alert)
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
