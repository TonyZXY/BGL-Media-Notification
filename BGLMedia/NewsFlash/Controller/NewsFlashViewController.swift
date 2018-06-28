//
//  NewsFlashViewController.swift
//  news app for blockchain
//
//  Created by Sheng Li on 18/4/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class NewsFlashViewController: UIViewController {
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    @IBOutlet weak var timelineView: UIView!

    
    

    @IBAction func newsFlashSearchButton(_ sender: Any) {
        let searchController = FlashSearchController()
        navigationController?.pushViewController(searchController, animated: true)
    }
    

    @IBOutlet weak var newsFlashLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initLabel()
//        dateAndTimeLabel.removeFromSuperview()
        initView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func changeLanguage(){
        setUpNavigationTitle()
    }
    
    deinit {
              NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
    
    func initView(){
        view.backgroundColor = ThemeColor().themeColor()
        setUpNavigationTitle()
        navigationController?.navigationBar.barTintColor =  ThemeColor().themeColor()
        navigationController?.navigationBar.isTranslucent = false
        let navigationDoneButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchResult))
        self.navigationItem.setRightBarButton(navigationDoneButton, animated: true)

    }
    
    func setUpNavigationTitle(){
        let titleLabel = UILabel()
        titleLabel.text = textValue(name: "navigationTitle_flash")
        titleLabel.textColor = UIColor.white
        navigationItem.titleView = titleLabel
    }

    @objc func searchResult(){
        let search = SearchNewsFlashController()
        navigationController?.pushViewController(search, animated: true)
    }
    
    func initLabel(){
        if let label = dateAndTimeLabel {
            let formatter = DateFormatter()
            //formatter.dateStyle = .medium
            formatter.dateFormat = "M月d日 EEEE"
            // formatter.timeStyle = .medium
            formatter.locale = Locale(identifier: "zh_Hans")
            label.text = "今天" + formatter.string(from: Date())
            label.layer.cornerRadius = label.frame.height / 4
            label.clipsToBounds = true
            label.layer.borderWidth = 2
            label.layer.borderColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        }
    }
   
}
