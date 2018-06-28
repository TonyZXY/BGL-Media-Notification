//
//  OnBoardingUIPageViewController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class OnBoardingUIPageViewController: UIPageViewController{
    let allPages: [OnBoardingPageViewController] = {
        var pages = [OnBoardingPageViewController]()
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "Welcome To Blockchain Global. Sign in or Register to access the full features of this app. ", pid:1))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "You can add transactions and monitor your digital wallet here.", pid:2))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "Save your favourite /marketName/ into watchlist and come back later.", pid:3))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "You can read all kinds of news. Share them with your business partners. ", pid:4))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "Turn on the alert functions in settings. You will get notificaitons of the latest information. ",pid:5))
        return pages
    }()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super .init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
        self.view.backgroundColor = ThemeColor().themeColor()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([allPages[0]], direction: .forward, animated: true, completion: nil)
    
    }
}

extension OnBoardingUIPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = allPages.index(of: viewController as! OnBoardingPageViewController)
//        print("index in -before-: \(index)")
        return  index! > 0 ? allPages[index! - 1] : nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = allPages.index(of: viewController as! OnBoardingPageViewController)
//        print("index in -after-: \(index)")
        return  index! < allPages.count - 1 ? allPages[index! + 1] : nil
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return allPages.count// number of onboarding pages
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
