//
//  DefaultViewController.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 22/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class DefaultViewController: UIViewController {
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = 380
        view.backgroundColor = .orange
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(container)
        let vc = CandleStickChartViewController()
        
        vc.willMove(toParentViewController: self)
        container.addSubview(vc.view)
        self.addChildViewController(vc)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.frame.size.height = container.frame.size.height
        
        NSLayoutConstraint(item: vc.view, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .width, relatedBy: .equal, toItem: container, attribute: .width, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .height, relatedBy: .equal, toItem: container, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: container, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.size.width).isActive = true
        NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 380).isActive = true
        
        vc.coinSymbol = "LTC"
        vc.didMove(toParentViewController: self)
    }
}
