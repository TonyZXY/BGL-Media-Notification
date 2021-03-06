//
//  EventDetailViewController.swift
//  BGLMedia
//
//  Created by Fan Wu on 9/20/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import EventKitUI
import WebKit

class EventDetailViewController: UIViewController, WKNavigationDelegate {
    
    var eventViewModel: EventViewModel?
    var webProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        progressView.tintColor = .blue
        progressView.isHidden = true
        return progressView
    }()
    
    private lazy var eventWebView: WKWebView = {
        let webView = WKWebView()
        if let urlStr = eventViewModel?.urlStr,
        let webUrl = URL(string: urlStr) {
            webView.load(URLRequest(url: webUrl))
        }
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webProgressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webProgressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webProgressView.isHidden = true
        let alert = UIAlertController(title: textValue(name: "alertFail"), message: textValue(name: "alertFailMsg3"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        eventWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    deinit {
        webProgressView.isHidden = true
        //remove all observers
        eventWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            webProgressView.progress = Float(eventWebView.estimatedProgress)
        }
    }
    
    private func setUpView(){
        view.addSubview(eventWebView)
        eventWebView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        eventWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        eventWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        eventWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //add progressbar to the Navigation Bar
        navigationController?.navigationBar.addSubview(webProgressView)
        let navigationBarBounds = self.navigationController?.navigationBar.bounds
        webProgressView.frame = CGRect(x: 0, y: navigationBarBounds!.size.height - 4, width: navigationBarBounds!.size.width, height: 2)

        //add a Bar Button
        let addToCalendarBarButtonItem = UIBarButtonItem(image: UIImage(named: "calendar"), style: .done, target: self, action: #selector(popAlert))
        self.navigationItem.rightBarButtonItem  = addToCalendarBarButtonItem
    }
    
    @objc func popAlert() {
        let alert = UIAlertController(title: textValue(name: "popAlertTitle"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: textValue(name: "alertNo"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: textValue(name: "alertYes"), style: .default, handler: { act in self.addToCalendar() }))
        self.present(alert, animated: true)
    }
    
    private func addToCalendar() {
        if let title = eventViewModel?.title,
            let startTime = eventViewModel?.eventStartTime,
            let endTime = eventViewModel?.eventEndTime,
            let description = eventViewModel?.address {
            addEventToCalendar(title: title, description: textValue(name: "eventAddress") + description, startDate: startTime, endDate: endTime) { (success, error) in
                if success {
                    let alert = UIAlertController(title: textValue(name: "alertSuccess"), message: textValue(name: "alertSuccessMsg"), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: textValue(name: "alertFail"), message: textValue(name: "alertFailMsg"), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            }
        } else {
            let alert = UIAlertController(title: textValue(name: "alertFail"), message: textValue(name: "alertFailMsg2"), preferredStyle: .alert)
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
