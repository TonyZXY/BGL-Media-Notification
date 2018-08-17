//
//  FAQViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var helpTableView:UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.bounces = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        tableView.separatorStyle = .singleLineEtched
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    var questions:[String]? {
        get{
            return [
                    textValue(name: "q1"),
                    textValue(name: "q2"),
                    textValue(name: "q3"),
                    textValue(name: "q4"),
                    textValue(name: "q5"),
                    textValue(name: "q6"),
                    textValue(name: "q7"),
                    textValue(name: "q8"),
                    textValue(name: "q9")
                    ]
        }
    }
    
    var answers:[ExpandableAnswers] =  [
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a1")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a2")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a3")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a4")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a5")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a6")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a7")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a8")),
                ExpandableAnswers(isExpandabed: false, answer: textValue(name: "a9"))

        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        setupView()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
            let button = UIButton(type: .system)
            let width = view.frame.width/375
            
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.layer.masksToBounds = true
            image.frame = CGRect(x: 0, y: 0, width: 22 * width, height: 22 * width)
            image.image = UIImage(named: "question")
            button.addSubview(image)
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10 * width).isActive = true
            image.widthAnchor.constraint(equalToConstant: 25 * width).isActive = true
            image.heightAnchor.constraint(equalToConstant: 25 * width).isActive = true
            //        button.setTitle("\(questions![section]) Open", for: .normal)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = questions?[section]
            label.textColor = ThemeColor().whiteColor()
            label.font = UIFont.semiBoldFont(16)
            label.textAlignment = .left
            button.addSubview(label)
            label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 15 * width).isActive = true
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: 280 * width).isActive = true
            label.heightAnchor.constraint(equalToConstant: 30 * width).isActive = true
            
            
            let image2 = UIImageView()
            image2.translatesAutoresizingMaskIntoConstraints = false
            image2.contentMode = .scaleAspectFit
            image2.layer.masksToBounds = true
            image2.frame = CGRect(x: 0, y: 0, width: 17 * width, height: 17 * width)
            image2.image = UIImage(named: "arrow")
        
            let isExpanded = answers[section].isExpandabed
            if isExpanded{
                image2.transform = image2.transform.rotated(by: -CGFloat(Double.pi/2))
            } else {
                image2.transform = image2.transform.rotated(by: CGFloat(Double.pi/2))
            }
            button.addSubview(image2)
            image2.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            image2.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -14 * width).isActive = true
            image2.widthAnchor.constraint(equalToConstant: 17 * width).isActive = true
            image2.heightAnchor.constraint(equalToConstant: 17 * width).isActive = true
            button.addTarget(self, action: #selector(collapse), for: .touchUpInside)
            button.tag = section
        
            let emptyLabel = UILabel()
            button.addSubview(emptyLabel)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyLabel.backgroundColor = UIColor.lightGray
            emptyLabel.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            emptyLabel.leftAnchor.constraint(equalTo: button.leftAnchor).isActive = true
            emptyLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
            emptyLabel.rightAnchor.constraint(equalTo: button.rightAnchor).isActive = true
            return button
        
        
    }
    
    
    @objc func collapse(sender: UIButton){
        let section = sender.tag

        let isExpanded = answers[section].isExpandabed
        answers[section].isExpandabed = !isExpanded
        let indexPath = IndexPath(row: 0, section: section)
        if isExpanded{
            helpTableView.deleteRows(at: [indexPath], with: .fade)
            UIView.animate(withDuration: 0.25, animations: {
                sender.subviews[2].transform = sender.subviews[2].transform.rotated(by: -CGFloat(Double.pi))
            })
        } else {
            helpTableView.insertRows(at: [indexPath], with: .fade)
            UIView.animate(withDuration: 0.25, animations: {
                sender.subviews[2].transform = sender.subviews[2].transform.rotated(by: CGFloat(Double.pi))
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !answers[section].isExpandabed {
            return 0
        } else {
            return 1
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (questions?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * view.frame.width/375
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
        cell.textLabel?.text = answers[indexPath.section].answer
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.regularFont(16)
        cell.backgroundColor = ThemeColor().greyColor()
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "help_FAQ")
        navigationItem.titleView = titleLabel
    }
    func setupView(){
        titleLabel.text = textValue(name: "help_FAQ")
        navigationItem.titleView = titleLabel
        
        view.addSubview(helpTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":helpTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":helpTableView]))
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }
}



struct ExpandableAnswers {
    var isExpandabed : Bool
    let answer: String
}














