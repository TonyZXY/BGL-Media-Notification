//
//  AllEventViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 10/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class AllEventsViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate, PopoverControllerDelegate {
    
    var eventViewModels = [EventViewModel]()
    var groupedEvents = [[EventViewModel]]()
    let dayStr = "Day"
    let weekStr = "Week"
    let monthStr = "Month"
    let yearStr = "Year"
    let theBlockchainCentreStr = "The Blockchain Centre"
    let allHostStr = "All Hosts"
    
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
        label.layer.borderWidth = 1.2
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
        let factor = view.frame.width/414
        cell.factor = factor
        //let cell = EventListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "WalletCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let eventListTableViewCell = cell as! EventListTableViewCell
        eventListTableViewCell.eventViewModel = groupedEvents[indexPath.section][indexPath.row]
    }
    
    //there should be a better way to solve reuable cell problem
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventDetailVC = EventDetailViewController()
        eventDetailVC.eventViewModel = groupedEvents[indexPath.section][indexPath.row]
        eventDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(eventDetailVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
        URLServices.fetchInstance.passServerData(urlParameters: ["api","eventAll"], httpMethod: "GET", parameters: [String:Any]()) { (response, success) in
            //print(response)
            
            let allEventViewModels = response.arrayValue.map({ (item) -> EventViewModel in
                return EventViewModel(event: Event(item))
            })
            
            //only get the events after today & remove title == "null"
            allEventViewModels.forEach({ (eventViewModel) in
                if eventViewModel.eventStartTime >= Date() && eventViewModel.title != "null" {
                    self.eventViewModels.append(eventViewModel)
                }
            })
            

            DispatchQueue.main.async {
                self.updateGroupedEventsAndTableView(self.eventViewModels)
            }
        }
    }
    
    func updateGroupedEventsAndTableView(_ eventViewModels: [EventViewModel]) {
        groupedEvents.removeAll()
        
        let groupedE = Dictionary(grouping: eventViewModels, by: { (eventViewModel) -> String in
            return eventViewModel.dateFilter
        })
        
        groupedE.keys.sorted().forEach({ (key) in
            if let values = groupedE[key] {
                self.groupedEvents.append(values)
            }
        })
        
        listTableView.reloadData()
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(listTableView)
        listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        let hostFilterBarButtonItem = UIBarButtonItem(title: allHostStr, style: .done, target: self, action: #selector(hostFilter))
        self.navigationItem.leftBarButtonItem  = hostFilterBarButtonItem
        
        //the default value of dateFilter in EventViewModel is day value so that the title should be dayStr
        let dateFilterBarButtonItem = UIBarButtonItem(title: dayStr, style: .done, target: self, action: #selector(dateFilter))
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
        pc.delegate = self
        pc.buttons = [PopoverButton(theBlockchainCentreStr), PopoverButton(allHostStr)]
        return pc
        }()
    
    lazy var datePopoverController: PopoverController = {
        [unowned self] in
        let pc = PopoverController()
        //popover setting
        pc.modalPresentationStyle = .popover
        pc.delegate = self
        pc.buttons = [PopoverButton(dayStr), PopoverButton(weekStr), PopoverButton(monthStr), PopoverButton(yearStr)]
        return pc
        }()
    
    @objc func dateFilter(_ sender: UIBarButtonItem){
        //need to set up popover delegate here
        datePopoverController.popoverPresentationController?.delegate = self
        //tell the popover where to point
        datePopoverController.popoverPresentationController?.barButtonItem = sender
        datePopoverController.popoverBarButtonItem = sender
        self.present(datePopoverController, animated: true)
    }
    
    @objc func hostFilter(_ sender: UIBarButtonItem){
        //need to set up popover delegate here
        hostPopoverController.popoverPresentationController?.delegate = self
        //tell the popover where to point
        hostPopoverController.popoverPresentationController?.barButtonItem = sender
        hostPopoverController.popoverBarButtonItem = sender
        self.present(hostPopoverController, animated: true)
    }
    
    func updateDateFilterValue(_ filterValue: String) -> [EventViewModel] {
        for (index, _) in eventViewModels.enumerated() {
            switch filterValue {
            case dayStr:
                eventViewModels[index].dateFilter = eventViewModels[index].dayOfEventStartTime
            case weekStr:
                eventViewModels[index].dateFilter = eventViewModels[index].weekOfEventStartTime
            case monthStr:
                eventViewModels[index].dateFilter = eventViewModels[index].monthOfEventStartTime
            case yearStr:
                eventViewModels[index].dateFilter = eventViewModels[index].yearOfEventStartTime
            default: break
            }
        }
        return eventViewModels
    }
    
    //a function of PopoverControllerDelegate
    func popoverButtonAction(sender: UIButton) {
        var newEventViewModels = eventViewModels
        if sender.currentTitle == theBlockchainCentreStr {
            newEventViewModels = eventViewModels.filter { $0.host == theBlockchainCentreStr }
        } else {
            if let filter = sender.currentTitle {
                newEventViewModels = updateDateFilterValue(filter)
            }
        }
        updateGroupedEventsAndTableView(newEventViewModels)
    }
    
    //a function of UIPopoverPresentationControllerDelegate to make sure the iphone also shows the view as a popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


//Cell View
class EventListTableViewCell:UITableViewCell{
    
    var eventViewModel: EventViewModel? {
        didSet {
            updateUI()
        }
    }
    
    var factor:CGFloat? {
        didSet{
            setUpView()
            setUpSubView()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    func setUpView(){
        selectionStyle = .none
        backgroundColor = ThemeColor().darkGreyColor()
        addSubview(cellView)
        
//        cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
//        cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        addConstraintsWithFormat(format: "H:|[v0]|", views: cellView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: cellView)
    }
    
    func setUpSubView(){
        cellView.addSubview(titleLabel)
        cellView.addSubview(imgView)
        cellView.addSubview(hostLabel)
        cellView.addSubview(addressLabel)
        cellView.addSubview(timeLabel)
        
//        cellView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
//        cellView.addConstraintsWithFormat(format: "V:|-8-[v0(40)]", views: titleLabel)
        cellView.addConstraintsWithFormat(format: "H:|-\(16*factor!)-[v0(\(55*factor!))]-\(15*factor!)-[v1]-\(14*factor!)-|", views: imgView, titleLabel)
        cellView.addConstraintsWithFormat(format: "V:|-\(10*factor!)-[v0(\(45*factor!))]", views: titleLabel)
        cellView.addConstraintsWithFormat(format: "V:|-\(16*factor!)-[v0(\(55*factor!))]-\(5*factor!)-[v1]-\(5*factor!)-|", views: imgView,hostLabel)
        
        cellView.addConstraintsWithFormat(format: "H:|-\(16*factor!)-[v0(\(80*factor!))]", views: hostLabel)
        
        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14*factor!).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: hostLabel.trailingAnchor, constant: 10*factor!).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: -5*factor!).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: 18*factor!).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 2*factor!).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor, constant: 0).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor, constant: 0).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 18*factor!).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    func updateUI() {
        titleLabel.text = eventViewModel?.title
        hostLabel.text = eventViewModel?.hostLabel
        addressLabel.text = eventViewModel?.address
        timeLabel.text = eventViewModel?.startTimeLabel
    }
    
    var titleLabel: UILabel = {
        var label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 0
//        label.font = UIFont.boldFont(CGFloat(fontSize + 3))
        label.font = UIFont.semiBoldFont(CGFloat(fontSize + 2))
        label.text = "Title"
        return label
    }()
    
    var hostLabel: UILabel = {
        var label = UILabel()
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().whiteColor()
        label.numberOfLines = 0
        label.font = UIFont.regularFont(CGFloat(fontSize-3))
        label.text = "Host"
        return label
    }()
    
    var addressLabel:UILabel = {
        var label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
//        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(CGFloat(fontSize - 2))
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
//        label.backgroundColor = ThemeColor().greyColor()
        label.font = UIFont.regularFont(CGFloat(fontSize - 2))
        label.textColor = ThemeColor().textGreycolor()
        label.text = "Time"
        return label
    }()
    
    var imgView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    lazy var cellView:UIView = {
//        let stackView = UIStackView(arrangedSubviews: [titleLabel, hostLabel, addressLabel, timeLabel])
//        stackView.distribution = .fillProportionally
//        stackView.axis = .vertical
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
        
        let view = UIView()
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
}



