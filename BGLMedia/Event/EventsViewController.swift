//
//  EventsViewController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 6/9/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    var firstPage:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addViewControllerAsChildViewController(childViewControllers: perdayEventViewController, view: view)
        // Do any additional setup after loading the view.
    }
    

    func setUpView(){
   let reSizeMain = CGSize(width: 20, height: 20)
        let btn1 = UIButton(type: .system)
        btn1.layer.borderColor = ThemeColor().whiteColor().cgColor
        btn1.layer.cornerRadius = 8
        btn1.layer.borderWidth = 2
        btn1.setImage(UIImage(named: "alarm")?.reSizeImage(reSize: reSizeMain), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(modeChange), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        
        
        
        view.backgroundColor = ThemeColor().darkGreyColor()
//        view.addSubview(segmentButton)
//        segmentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        segmentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }

    @objc func modeChange(){
        if firstPage{
//            addViewControllerAsChildViewController(childViewControllers: allEventViewController, view: view)
            
            cycleFromViewController(oldViewController: perdayEventViewController, toViewController: allEventViewController){success in
                if success{
                     self.firstPage = false
                }
            }
            
//            removeViewControllerAsChildViewController(childViewController: perdayEventViewController)
           
        }else{
            
            cycleFromViewController(oldViewController: allEventViewController, toViewController: perdayEventViewController){success in
                if success{
                    self.firstPage = true
                }
            }
//            addViewControllerAsChildViewController(childViewControllers: perdayEventViewController, view: view)
//            removeViewControllerAsChildViewController(childViewController: allEventViewController)
            
        }
    }
    
    lazy var perdayEventViewController:PerDayEventViewController = {
       var perdayEventViewControllers = PerDayEventViewController()
       return perdayEventViewControllers
    }()
    
    lazy var allEventViewController:AllEventViewController = {
        var allEventViewControllers = AllEventViewController()
        return allEventViewControllers
    }()
    
    private func removeViewControllerAsChildViewController(childViewController:UIViewController){
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
    
    private func addViewControllerAsChildViewController(childViewControllers:UIViewController,view:UIView){
        addChildViewController(childViewControllers)
        view.addSubview(childViewControllers.view)
        childViewControllers.view.frame = view.bounds
        childViewControllers.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        childViewControllers.didMove(toParentViewController: self)
        
        //Constraints
        childViewControllers.view.translatesAutoresizingMaskIntoConstraints = false
        childViewControllers.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childViewControllers.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childViewControllers.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        childViewControllers.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController,completion:@escaping (Bool)->Void) {
        oldViewController.willMove(toParentViewController: nil)
        
        view.addSubview(newViewController.view)
        newViewController.view.frame = view.bounds
        newViewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        newViewController.didMove(toParentViewController: self)
        
        //Constraints
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        newViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        newViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        newViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
//        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
//        self.addChildViewController(newViewController)
//        self.view.addSubview(subView: newViewController.view, toView:self.containerView)
        
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.modeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveLinear, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
//            newViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI))
//            oldViewController.view.transform = CGAffineTransform(rotationAngle: CGFloat(180 * M_PI))
//            newViewController.view.transform = CGAffineTransform(scaleX: 1.25, y: 0.75)
        }) { (finished) in
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
            newViewController.didMove(toParentViewController: self)
            completion(true)
        }
    }
    
    var modeButton:UIButton = {
        var button = UIButton(type: .system)
        button.layer.borderColor = ThemeColor().whiteColor().cgColor
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        let reSizeMain = CGSize(width: 20, height: 20)
        button.setImage(UIImage(named: "alarm")?.reSizeImage(reSize: reSizeMain), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(modeChange), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
}
