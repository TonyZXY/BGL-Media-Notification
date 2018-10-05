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
    var dayStr = ""
    var weekStr = ""
    var monthStr = ""
    var yearStr = ""
    let theBlockchainCentreStr = "The Blockchain Centre"
    let sydneyBlockchainCentreStr = "Sydney Blockchain Centre"
    var otherHosts = ""
    var allHostStr = ""
    lazy var hostBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(popHost))
    lazy var dateBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(popDate))
    
    lazy var listTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(EventListTableViewCell.self, forCellReuseIdentifier: "EventList")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = ThemeColor().darkGreyColor()
        
        //for refresh
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        tableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(tableView)
        })
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupPopButtonsName()
        self.listTableView.switchRefreshHeader(to: .refreshing)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    private func setUpView(){
        view.backgroundColor = ThemeColor().darkGreyColor()
        view.addSubview(listTableView)
        listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        self.navigationItem.leftBarButtonItem  = hostBarButtonItem
        self.navigationItem.rightBarButtonItem  = dateBarButtonItem
    }
    
    private func setupPopButtonsName() {
        dayStr = textValue(name: "day")
        weekStr = textValue(name: "week")
        monthStr = textValue(name: "month")
        yearStr = textValue(name: "year")
        otherHosts = textValue(name: "otherHosts")
        allHostStr = textValue(name: "allHostStr")
        
        //default setting
        hostBarButtonItem.title = allHostStr
        dateBarButtonItem.title = dayStr
        
        //In order to match the button titles, need to reset the table when the language is changed
        let hostButton = UIButton()
        hostButton.setTitle(allHostStr, for: .normal)
        let dateButton = UIButton()
        dateButton.setTitle(dayStr, for: .normal)
        popoverButtonAction(sender: hostButton)
        popoverButtonAction(sender: dateButton)
    }
    
    private func getDataFromServer(completion: ((Bool) -> Void)?) {
        URLServices.fetchInstance.passServerData(urlParameters: ["api","eventAll"], httpMethod: "GET", parameters: [String:Any]()) { (response, success) in
            //print(response)
            
            if success {
                let allEventViewModels = response.arrayValue.map({ (item) -> EventViewModel in
                    return EventViewModel(event: Event(item))
                })
                
                //only get the events after today
                allEventViewModels.forEach({ (eventViewModel) in
                    if eventViewModel.eventStartTime >= Date() {
                        if !self.eventViewModels.contains(where: { (exist) -> Bool in exist.id == eventViewModel.id }) {
                            self.eventViewModels.append(eventViewModel)
                        }
                    }
                })
                
                //set the models base on the buttons values
                if let hostBarButtonValue = self.hostBarButtonItem.title,
                    let dateBarButtonValue = self.dateBarButtonItem.title {
                    self.changeEventViewModelDateGroupTypeAndHostFilter(hostBarButtonValue)
                    self.changeEventViewModelDateGroupTypeAndHostFilter(dateBarButtonValue)
                }
                
                DispatchQueue.main.async {
                    self.updateGroupedEventsAndTableView()
                }
            }
            completion?(success)
        }
    }
    
    private func updateGroupedEventsAndTableView() {
        groupedEvents.removeAll()
        
        var newEventViewModels = eventViewModels
        if let hostFilter = newEventViewModels.first?.hostFilter {
            switch hostFilter {
            case theBlockchainCentreStr:
                newEventViewModels = eventViewModels.filter { $0.host == theBlockchainCentreStr }
            case sydneyBlockchainCentreStr:
                newEventViewModels = eventViewModels.filter { $0.host == sydneyBlockchainCentreStr }
            case otherHosts:
                newEventViewModels = eventViewModels.filter { $0.host != theBlockchainCentreStr && $0.host != sydneyBlockchainCentreStr  }
            default: break
            }
        }
        let groupedE = Dictionary(grouping: newEventViewModels, by: { (eventViewModel) -> String in
            return eventViewModel.dateGroupType
        })
        
        groupedE.keys.sorted().forEach({ (key) in
            if let values = groupedE[key] {
                let sortedV = values.sorted { $0.eventStartTime < $1.eventStartTime }
                self.groupedEvents.append(sortedV)
            }
        })
        
        listTableView.reloadData()
    }
    
    @objc func handleRefresh(_ tableView: UITableView) {
        getDataFromServer { sccuess in
            if sccuess{
                tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            } else{
                tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        }
    }
    
    @objc func changeLanguage(){
        setupPopButtonsName()
    }
    
    @objc func popDate(_ sender: UIBarButtonItem){
        let datePopoverController = PopoverController()
        datePopoverController.modalPresentationStyle = .popover
        datePopoverController.popoverPresentationController?.delegate = self
        datePopoverController.delegate = self
        //tell the popover where to point
        datePopoverController.popoverPresentationController?.barButtonItem = sender
        datePopoverController.buttons = [PopoverButton(dayStr), PopoverButton(weekStr), PopoverButton(monthStr), PopoverButton(yearStr)]
        datePopoverController.popoverBarButtonItem = sender
        self.present(datePopoverController, animated: true)
    }
    
    @objc func popHost(_ sender: UIBarButtonItem){
        let hostPopoverController = PopoverController()
        hostPopoverController.modalPresentationStyle = .popover
        hostPopoverController.popoverPresentationController?.delegate = self
        hostPopoverController.delegate = self
        //tell the popover where to point
        hostPopoverController.popoverPresentationController?.barButtonItem = sender
        hostPopoverController.buttons = [PopoverButton(theBlockchainCentreStr), PopoverButton(sydneyBlockchainCentreStr), PopoverButton(otherHosts), PopoverButton(allHostStr)]
        hostPopoverController.popoverBarButtonItem = sender
        self.present(hostPopoverController, animated: true)
    }
    
    //a function of PopoverControllerDelegate
    func popoverButtonAction(sender: UIButton) {
        guard let value = sender.currentTitle else { return }
        changeEventViewModelDateGroupTypeAndHostFilter(value)
    }
    
    func changeEventViewModelDateGroupTypeAndHostFilter(_ setting: String) {
        for (index, _) in eventViewModels.enumerated() {
            switch setting {
            case dayStr:
                eventViewModels[index].dateGroupType = eventViewModels[index].dayOfEventStartTime
            case weekStr:
                eventViewModels[index].dateGroupType = eventViewModels[index].weekOfEventStartTime
            case monthStr:
                eventViewModels[index].dateGroupType = eventViewModels[index].monthOfEventStartTime
            case yearStr:
                eventViewModels[index].dateGroupType = eventViewModels[index].yearOfEventStartTime
            default:
                eventViewModels[index].hostFilter = setting
            }
        }
        updateGroupedEventsAndTableView()
    }
    
    //a function of UIPopoverPresentationControllerDelegate to make sure the iphone also shows the view as a popover
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: Table Setup
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
            label.text = firstEventInSection.dateGroupType
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
        if let host = eventViewModel?.host {
            imgView.image = UIImage(named: host)
        }
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
    
    var imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
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
