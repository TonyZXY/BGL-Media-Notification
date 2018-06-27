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
    
    @IBOutlet weak var newsFlashLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = ThemeColor().themeColor()
    }
}
