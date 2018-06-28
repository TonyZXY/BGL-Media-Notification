//
//  ViewController.swift
//  NewsApp4
//
//  Created by Xuyang Zheng on 2/5/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

// REVIEW: class name perhaps can be BGLNewsHomeViewController -Johnny Lin
class NewsHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let genuineController = GenuineListViewController()
    let newsController = NewsListViewController()

    lazy var menuBar: NewsMenuBar = {
        let mb = NewsMenuBar()
        mb.homeController = self // REVIEW: homeController can be a generic delegate  -Johnny Lin
        return mb
    }()
    
    // set up view
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = ThemeColor().themeColor()
        navigationController?.navigationBar.backgroundColor = ThemeColor().themeColor()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.tintColor = .white
        // REVIEW: Can be in separate methods, such as registerCells -Johnny Lin
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: view.frame.height))
        titleLabel.text = "Blockchain Global"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    @objc func changeLanguage(){
        menuBar.collectionView.reloadData()
        newsController.fetchData()
        newsController.selectionView.reloadData()
        genuineController.fetchData()
        genuineController.cellListView.reloadData()
    }
    
    deinit {
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }

    lazy var selectView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = ThemeColor().themeColor()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    // constraints of the view
    func setupView() {
        let navigationSearchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchNews))
        self.navigationItem.setRightBarButton(navigationSearchButton, animated: true)
        
        view.addSubview(menuBar)
        view.addSubview(selectView)
        view.addConstraintsWithFormat(format: "V:[v0(40)]-0-[v1]|", views: menuBar, selectView)

        menuBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        menuBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        selectView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        selectView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        selectView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "containerCell")
        selectView.dataSource = self
        selectView.delegate = self
        selectView.isPagingEnabled = true
        selectView.showsHorizontalScrollIndicator = false
        selectView.bounces = false
        selectView.alwaysBounceHorizontal = false
    }

    
    @objc func searchNews(){
        let searchPage = SearchNewsController()
        navigationController?.pushViewController(searchPage, animated: true)
    }

    // two cell represent NEWS and GENUINE
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / selectView.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    // two cells 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "containerCell", for: indexPath)
        if (indexPath.item == 1) {
            addChildViewController(childViewControllers: genuineController, cell: cell)
            genuineController.homeViewController = self
        } else {
            addChildViewController(childViewControllers: newsController, cell: cell)
            newsController.homeViewController = self
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        selectView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
}




