//
//  FontController.swift
//  BGLMedia
//
//  Created by Fan Wu on 9/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import JGProgressHUD

class FontController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var storeData = [15,13,11]
    var fonts:[String]{
        get{
            return [textValue(name: "font_size") + " 1",
                    textValue(name: "font_size") + " 2",
                    textValue(name: "font_size") + " 3"]
        }
    }
    
    
    let rowNumber = ["15":0,"13":1,"11":2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        communityTableView.selectRow(at: IndexPath(row: rowNumber["\(fontSize)"] ?? 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        let cell = tableView.dequeueReusableCell(withIdentifier: "fontCell") as! fontCell
        cell.factor = factor
        cell.fontLabel.text = fonts[indexPath.row]
        cell.fontLabel.font = UIFont.regularFont(CGFloat(storeData[indexPath.row]))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let str = storeData[indexPath.row]
        fontSize = str
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeFontSize"), object: nil)
        let selectedCell = tableView.cellForRow(at: indexPath)! as! fontCell

        
        
        selectedCell.isSelected = true
        //        let backItem = UIBarButtonItem()
        //        backItem.title = textValue(name: "back_button")
        //        backItem.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.regularFont(12)], for: .normal)
        //        backItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor()], for: .normal)
        //        self.navigationController?.navigationBar.backItem?.backBarButtonItem = backItem
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: (self.parent?.view)!)
        
        //        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        //        hud.textLabel.text = "Success"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            hud.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)! as! fontCell
        selectedCell.isSelected = false
    }
    
    lazy var communityTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40*view.frame.width/375
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(fontCell.self, forCellReuseIdentifier: "fontCell")
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        let sectionLabel = UILabel()
        sectionLabel.text = textValue(name: "flashNews_font")
        sectionLabel.textColor = ThemeColor().textGreycolor()
        sectionLabel.font = UIFont.regularFont(18*factor)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(sectionLabel)
        
        NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -10*factor).isActive = true
        NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10*factor).isActive = true
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60*view.frame.width/375
    }
    
    func setUpView(){
        let factor = view.frame.width/375
        communityTableView.rowHeight = 70*factor
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(communityTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
    }
    
}

class fontCell:UITableViewCell{
    var factor:CGFloat?{
        didSet{
            setupviews()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    lazy var cellView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var fontLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.regularFont(14*factor!)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            fontLabel.textColor = isSelected ? ThemeColor().themeColor() : UIColor.white
            cellView.backgroundColor = isSelected ? UIColor.white : ThemeColor().walletCellcolor()
        }
    }
    
    func setupviews(){
        selectionStyle = .none
        backgroundColor = ThemeColor().themeColor()
        addSubview(cellView)
        cellView.addSubview(fontLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        NSLayoutConstraint(item: fontLabel, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        fontLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10).isActive = true
        
    }
}
