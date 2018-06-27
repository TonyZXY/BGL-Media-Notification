//
//  GenuineSliderViewCell.swift
//  news app for blockchain
//
//  Created by Xuyang Zheng on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class GenuineSliderViewCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    weak var homeViewController: NewsHomeViewController?
    let genuineDetailViewController = NewsDetailWebViewController()

    // reload data when any thing set the Genuine List
    var newsArrayList: [Genuine]? {
        didSet {
            sliderView.reloadData()
        }
    }

    override func setupViews() {
        super.setupViews()
        setupRootView()
    }

    lazy var rootView: UIView = {
        let view = UIView()
        return view
    }()

    // slider View configuration
    lazy var sliderView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cv.dataSource = self
        cv.delegate = self
        cv.bounces = false
        cv.alwaysBounceHorizontal = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(GenuineSliderCell.self, forCellWithReuseIdentifier: "Slider")
        return cv
    }()

    // page control
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
        return pc
    }()

    // conststaints of the slider view
    func setupRootView() {
        addSubview(rootView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: rootView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: rootView)
        backgroundColor = ThemeColor().themeColor()

        rootView.addSubview(sliderView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: sliderView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: sliderView)
        rootView.addSubview(pageControl)
        addConstraintsWithFormat(format: "H:|[v0]|", views: pageControl)
        addConstraintsWithFormat(format: "V:[v0(20)]-2-|", views: pageControl)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Slider", for: indexPath) as! GenuineSliderCell
        // to implement data load into cell
        cell.newsContent = newsArrayList?[indexPath.item]
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / rootView.frame.width)
    }

    // click action (push view controller)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        genuineDetailViewController.news = (newsArrayList?[indexPath.item].title, newsArrayList?[indexPath.item].url) as? (title: String, url: String)
        homeViewController?.navigationController?.pushViewController(genuineDetailViewController, animated: true)
    }
}
