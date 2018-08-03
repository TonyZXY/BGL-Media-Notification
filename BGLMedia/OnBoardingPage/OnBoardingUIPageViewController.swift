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
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "You can add transactions and monitor your digital wallet here.", pid:2))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "Save your favourite market into watchlist and come back later.", pid:3))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "You can read all kinds of news. Share them with your business partners. ", pid:4))
        pages.append(OnBoardingPageViewController(backgroundColor: ThemeColor().themeColor(), text: "Turn on the alert functions in settings. You will get notificaitons of the latest information. ",pid:5))
        
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
