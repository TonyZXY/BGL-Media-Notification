//
//  AllEventViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 10/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class AllEventViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate, PopoverControllerDelegate {
    
    var eventViewModels = [EventViewModel]()
    var groupedEvents = [[EventViewModel]]()
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.textColor = ThemeColor().whiteColor()
        label.backgroundColor = ThemeColor().darkGreyColor()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.layer.borderWidth = 3
        label.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        
        if let firstEventInSection = groupedEvents[section].first {
            label.text = firstEventInSection.dateFilter
        } else {
            label.text = "Unknown"
        }
        return label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedEvents.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedEvents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventList") as! EventListTableViewCell
        //let cell = EventListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "WalletCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let eventListTableViewCell = cell as! EventListTableViewCell
        eventListTableViewCell.eventViewModel = groupedEvents[indexPath.section][indexPath.row]
    }
    
    //there should be a better way to solve reuable cell problem
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()

        URLServices.fetchInstance.passServerData(urlParameters: ["api","eventAll"], httpMethod: "GET", parameters: [String:Any]()) { (response, success) in
            //print(response)
            self.eventViewModels = response.arrayValue.map({ (item) -> EventViewModel in
                return EventViewModel(event: Event(item))
            })
            
            let groupedE = Dictionary(grouping: self.eventViewModels, by: { (eventViewModel) -> String in
                return eventViewModel.dateFilter
            })
            
            groupedE.keys.sorted().forEach({ (key) in
                if let values = groupedE[key] {
                    self.groupedEvents.append(values)
                }
            })
            
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }

    func setUpView(){
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(listTableView)
        listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        let hostFilterBarButtonItem = UIBarButtonItem(title: "Host", style: .done, target: self, action: #selector(hostFilter))
        self.navigationItem.leftBarButtonItem  = hostFilterBarButtonItem
        
        let dateFilterBarButtonItem = UIBarButtonItem(title: "Date", style: .done, target: self, action: #selector(dateFilter))
        self.navigationItem.rightBarButtonItem  = dateFilterBarButtonItem
    }
    
     lazy var listTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: "EventList")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().darkGreyColor()
        return tableView
    }()
    
    lazy var hostPopoverController: PopoverController = {
        [unowned self] in
        let pc = PopoverController()
        //popover setting
        pc.modalPresentationStyle = .popover
        //pc.popoverPresentationController?.delegate = self
        pc.delegate = self
        pc.buttons = [PopoverButton("The Blockchain Centre"), PopoverButton("All")]
        return pc
        }()
    
    lazy var datePopoverController: PopoverController = {
        [unowned self] in
        let pc = PopoverController()
        //popover setting
        pc.modalPresentationStyle = .popover
        //pc.popoverPresentationController?.delegate = self
        pc.delegate = self
        pc.buttons = [PopoverButton("Day"), PopoverButton("Week"), PopoverButton("Month"), PopoverButton("Year")]
        return pc
        }()
    
    @objc func dateFilter(_ sender: UIBarButtonItem){
        //tell the popover where to point
        datePopoverController.popoverPresentationController?.delegate = self
        datePopoverController.popoverPresentationController?.barButtonItem = sender
        self.present(datePopoverController, animated: true)
    }
    
    @objc func hostFilter(_ sender: UIBarButtonItem){
        //tell the popover where to point
        hostPopoverController.popoverPresentationController?.delegate = self
        hostPopoverController.popoverPresentationController?.barButtonItem = sender
        self.present(hostPopoverController, animated: true)
    }
    
    //a function of PopoverControllerDelegate
    func popoverButtonAction(sender: UIButton) {
        var newEventViewModels = eventViewModels
        if sender.currentTitle == "Day" {
            for (index, _) in eventViewModels.enumerated() {
                eventViewModels[index].dateFilter = eventViewModels[index].dayOfEventStartTime
            }
        } else if sender.currentTitle == "Week" {
            for (index, _) in eventViewModels.enumerated() {
                eventViewModels[index].dateFilter = eventViewModels[index].weekOfEventStartTime
            }
        } else if sender.currentTitle == "Month" {
            for (index, _) in eventViewModels.enumerated() {
                eventViewModels[index].dateFilter = eventViewModels[index].monthOfEventStartTime
            }
        } else if sender.currentTitle == "Year" {
            for (index, _) in eventViewModels.enumerated() {
                eventViewModels[index].dateFilter = eventViewModels[index].yearOfEventStartTime
            }
        } else if sender.currentTitle == "The Blockchain Centre" {
            newEventViewModels = eventViewModels.filter { $0.host == "The Blockchain Centre" }
        }
        let groupedE = Dictionary(grouping: newEventViewModels, by: { (eventViewModel) -> String in
            return eventViewModel.dateFilter
        })
        
        groupedEvents.removeAll()
        groupedE.keys.sorted().forEach({ (key) in
            if let values = groupedE[key] {
                self.groupedEvents.append(values)
            }
        })
        
        listTableView.reloadData()
    }
    
    //a function of UIPopoverPresentationControllerDelegate to make sure the iphone also shows the view as a popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

class EventListTableViewCell:UITableViewCell{
    
    var eventViewModel: EventViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    
    func setUpView(){
        selectionStyle = .none
        backgroundColor = ThemeColor().darkGreyColor()
        addSubview(cellView)

//        cellView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
//        cellView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func updateUI() {
        titleLabel.text = eventViewModel?.title
        hostLabel.text = eventViewModel?.host
        addressLabel.text = eventViewModel?.address
        if let time = eventViewModel?.timeOfEventStartTime,
            let day = eventViewModel?.dayOfEventStartTime {
            timeLabel.text = "\(day) \(time)"
        } else {
            timeLabel.text = "Unkown"
        }

    }
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 2
        label.text = "Title"
        return label
    }()

    var hostLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 1
        label.text = "Host"
        return label
    }()

    var addressLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(15)
        label.textColor = ThemeColor().textGreycolor()
        label.text = "Address"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var timeLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 1
        label.text = "Time"
        return label
    }()
    
    lazy var cellView:UIView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, hostLabel, addressLabel, timeLabel])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //        var view = UIView()
        //        view.backgroundColor = ThemeColor().greyColor()
        //        view.layer.cornerRadius = 8
        //        view.clipsToBounds = true
        //        view.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}


