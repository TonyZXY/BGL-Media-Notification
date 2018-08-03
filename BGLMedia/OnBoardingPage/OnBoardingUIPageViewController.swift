//
//  OnBoardingUIPageViewController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class OnBoardingUIPageViewController: UIPageViewController{
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()

    let allPages: [UIViewController] = {
        var pages = [UIViewController]()
        var onboardingString = ["","","",""]
        let locale = Locale.current
        let languageCode = locale.languageCode
        if languageCode == "zh"{
            onboardingString[0] = "添加你的数字货币交易记录来追踪他们"
            onboardingString[1] = "收藏你喜欢的市场的货币交易信息以便随时查看"
            onboardingString[2] = "阅读各种数字货币的新闻。与他人分享"
            onboardingString[3] = "在设置中开启通知选项。随时掌握一手信息"
        } else {
            onboardingString[0] = "Add record of your cryptocurrency to keep track of them"
            onboardingString[1] = "Save your favorite market into watchlist and come back later"
            onboardingString[2] = "Read all kinds of cryptocurrency news. Share them with your business partners"
            onboardingString[3] = "Turn on the alert functions. You won't miss any latest information"
        }
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: onboardingString[0] , pid:2))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: onboardingString[1] , pid:3))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: onboardingString[2], pid:4))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: onboardingString[3] ,pid:5))
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn"){
            
        } else {
            pages.append(LoginController(usedPlace: 1))
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        return pages
    }()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super .init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
//        self.view.backgroundColor = ThemeColor().themeColor()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createGradientLayer() {
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [ThemeColor().themeColor().cgColor, ThemeColor().navigationBarColor().cgColor]
        
        
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setViewControllers([allPages[0]], direction: .forward, animated: true, completion: nil)
        createGradientLayer()
        self.delegate = self
        configurePageControl()
    
    }
    
    var pageControl = UIPageControl()
    func configurePageControl() {
        let factor = view.frame.width / 414
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 120 * factor,width: UIScreen.main.bounds.width,height: 20 * factor))
        self.pageControl.numberOfPages = allPages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = ThemeColor().greyColor()
        self.pageControl.pageIndicatorTintColor = ThemeColor().greyColor()
        self.pageControl.currentPageIndicatorTintColor = ThemeColor().whiteColor()
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
    }
}

extension OnBoardingUIPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

//        let index = allPages.index(of: viewController as! OnBoardingPageViewController)
////        print("index in -before-: \(index)")
//        return  index! > 0 ? allPages[index! - 1] : nil
        guard let viewControllerIndex = allPages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
//            return allPages.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard allPages.count > previousIndex else {
            return nil
        }
        
        return allPages[previousIndex]

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        let index = allPages.index(of: viewController as! OnBoardingPageViewController)
////        print("index in -after-: \(index)")
//        return  index! < allPages.count - 1 ? allPages[index! + 1] : nil
        guard let viewControllerIndex = allPages.index(of: viewController ) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = allPages.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
//            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return allPages[nextIndex]

    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = allPages.index(of: pageContentViewController)!
    }
    
}
