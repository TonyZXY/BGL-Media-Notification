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

    let revealingSplashView = RevealingSplashView(iconImage:UIImage(named: "CryptoGeekLogo2")!, iconInitialSize: CGSize(width: 200, height: 200), backgroundColor:ThemeColor().logoBackgroundColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().logoBackgroundColor()
        view.addSubview(revealingSplashView)
        revealingSplashView.animationType = .heartBeat
        getData()
        // Do any additional setup after loading the view.
    }
    
    func getData(){
        revealingSplashView.startAnimation()
            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            APIServices.fetchInstance.writeJsonExchange(){ success in
                if success{
                    print("success")
                     dispatchGroup.leave()
                } else{
                     dispatchGroup.leave()
                }
            }

            dispatchGroup.enter()
            URLServices.fetchInstance.getCoinList(){ success in
                if success{
                    print("success")
                    dispatchGroup.leave()
                } else{
                    dispatchGroup.leave()
                }
            }
        
            dispatchGroup.enter()
            URLServices.fetchInstance.getGlobalAverageCoinList(){ success in
            if success{
               
                dispatchGroup.leave()
            } else{
                dispatchGroup.leave()
            }
            }
        
        

            dispatchGroup.notify(queue:.main){
                if  UserDefaults.standard.bool(forKey: "launchedBefore"){
                    let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
                    // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                    self.revealingSplashView.heartAttack = true
                    
                    //                vc.modalTransitionStyle = .flipHorizontal
                    //        vc.modalTransitionStyle = .crossDissolve // another form of animations
                    
                    self.present(vc, animated: true, completion: nil)
                } else{
                    let mainViewController = OnBoardingUIPageViewController()
                    self.present(mainViewController, animated: true, completion: nil)
                }
            }
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

