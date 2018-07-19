//
//  LaunchScreen.swift
//  BGLMedia
//
//  Created by Bruce Feng on 18/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import RevealingSplashView

class LaunchScreenViewController: UIViewController {

    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "bcg_logo"), iconInitialSize: CGSize(width: 200, height: 200), backgroundColor:UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        view.addSubview(revealingSplashView)
        revealingSplashView.animationType = .heartBeat
        revealingSplashView.startAnimation(nil)
        // Do any additional setup after loading the view.
    }
}

class LaunchScreen: UIView {
    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "bcg_logo"), iconInitialSize: CGSize(width: 200, height: 200), backgroundColor:UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(revealingSplashView)
        revealingSplashView.animationType = .heartBeat
        revealingSplashView.startAnimation(nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

