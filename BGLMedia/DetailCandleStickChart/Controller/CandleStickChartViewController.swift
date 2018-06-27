//
//  ViewController.swift
//  DetailCandleStickChart
//
//  Created by Sheng Li on 18/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class CandleStickChartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Instance variables
    
    private var fetcher = HistoricalDataFetcher()
    
    private var historicalDataStruct: HistoricalDataStruct? {
        didSet {
            spinner.stopAnimating()
            containerView.configure(historicalDataStruct: historicalDataStruct, xAxisHeight: xAxisHeight, marginUpperAndLowerChart: marginUpperAndLowerChart)
            chart.configure(historicalDataStruct: historicalDataStruct)
            yAxisLabelView.configure(historicalDataStruct: historicalDataStruct)
            xAxisLabelView.configure(historicalDataStruct: historicalDataStruct)
            if historicalDataStruct?.selectedData.count != 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setPriceChange"), object: nil)
            }
        }
    }
    
    var priceChange: Double? {
        get {
            if let data = historicalDataStruct {
                let lastIndex = data.selectedData.count
                if let last = data.selectedData[lastIndex - 1]?.close, let secondLast = data.selectedData[0]?.close
                {
                    return last - secondLast
                }
            }
            return nil
        }
    }
    
    var priceChangeRatio: Double? {
        get {
            if let data = historicalDataStruct {
                let lastIndex = data.selectedData.count
                if let last = data.selectedData[lastIndex - 1]?.close, let secondLast = data.selectedData[0]?.close
                {
                    return (last - secondLast) / last * 100.0
                }
            }
            return nil
        }
    }
    
    var coinSymbol: String? {
        didSet {
            setupNewChart()
        }
    }
    
    private static var selectedIntervalIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    
    
    // MARK: Layout constants and variables
    
    private let marginUpperAndLowerChart = CGFloat(15)
    private let intervalBarHeight = CGFloat(20)
    private var intervalBarWidth: CGFloat { return self.view.frame.width }
    private var chartHeight: CGFloat { return self.view.frame.size.height - xAxisHeight - intervalBarHeight - 2 * marginUpperAndLowerChart }
    private var chartWidth: CGFloat { return (self.view.frame.size.width * 0.85).rounded(.down) * CGFloat(Params.multipleData) }
    private var scrollViewHeight: CGFloat { return containerHeight}
    private var scrollViewWidth: CGFloat { return chartWidth / CGFloat(Params.multipleData) }
    private var containerHeight: CGFloat { return chartHeight + xAxisHeight + marginUpperAndLowerChart * 2 }
    private var containerWidth: CGFloat { return chartWidth }
    private let xAxisHeight = CGFloat(30)
    private var xAxisWidth: CGFloat { return chartWidth }
    private var yAxisHeight: CGFloat { return chartHeight }
    private var yAxisWidth: CGFloat { return self.view.frame.width - scrollViewWidth }
    
    
    
    // MARK: UI components
    
    lazy var intervalBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let bar = UICollectionView(frame: CGRect(x: 0, y: 0, width: intervalBarWidth, height: intervalBarHeight), collectionViewLayout: layout)
        bar.backgroundColor = ThemeColor().themeColor()
        bar.delegate = self
        bar.dataSource = self
        bar.register(IntervalBarCollectionViewCell.self, forCellWithReuseIdentifier: "IntervalBarCollectionViewCell")
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = scrollViewHeight
        view.frame.size.width = scrollViewWidth
        view.contentSize.height = containerHeight
        view.contentSize.width = containerWidth
        view.contentOffset.x = view.contentSize.width - view.frame.size.width
        view.bounces = false
        return view
    }()
    
    lazy var containerView: ContainerView = {
        let view = ContainerView()
        view.backgroundColor = .clear
        view.clearsContextBeforeDrawing = true
        view.frame.size.height = containerHeight
        view.frame.size.width = containerWidth
        return view
    }()
    
    lazy var chart: CandleStickChart = {
        let chart = CandleStickChart(frame: CGRect(x: 0, y: marginUpperAndLowerChart + intervalBarHeight, width: chartWidth, height: chartHeight))
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    lazy var xAxisLabelView: XAxisLabelView = {
        let view = XAxisLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = xAxisHeight
        view.frame.size.width = xAxisWidth
        return view
    }()
    
    lazy var yAxisLabelView: YAxisLabelView = {
        let view = YAxisLabelView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size.height = yAxisHeight
        view.frame.size.width = yAxisWidth
        return view
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        return spinner
    }()
    
    
    
    // MARK: Setup UI and its layout
    
    private func setupUI() {
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(intervalBarCollectionView)
        view.addSubview(spinner)
        containerView.addSubview(xAxisLabelView)
        containerView.addSubview(chart)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        view.addSubview(yAxisLabelView)
        
        // Constraints for Activity Indicator
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: chart, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        // Constraints for Interval Bar CollectionView
        NSLayoutConstraint(item: intervalBarCollectionView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: intervalBarCollectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: intervalBarCollectionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: intervalBarWidth).isActive = true
        NSLayoutConstraint(item: intervalBarCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: intervalBarHeight).isActive = true
        
        // Constraints for Candle Stick Chart
        NSLayoutConstraint(item: chart, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: chart, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: marginUpperAndLowerChart).isActive = true
        NSLayoutConstraint(item: chart, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: chartWidth).isActive = true
        NSLayoutConstraint(item: chart, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: chartHeight).isActive = true
        
        // Constraints for xAxisLabel View
        NSLayoutConstraint(item: xAxisLabelView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: xAxisLabelView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: xAxisLabelView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: xAxisWidth).isActive = true
        NSLayoutConstraint(item: xAxisLabelView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: xAxisHeight).isActive = true
        
        // Constraints for scrollView
        NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: intervalBarCollectionView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: scrollViewWidth).isActive = true
        NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: scrollViewHeight).isActive = true
        
        // Constraints for yAxisLabel View
        NSLayoutConstraint(item: yAxisLabelView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: yAxisLabelView, attribute: .top, relatedBy: .equal, toItem: intervalBarCollectionView, attribute: .bottom, multiplier: 1, constant: marginUpperAndLowerChart).isActive = true
        NSLayoutConstraint(item: yAxisLabelView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: yAxisWidth).isActive = true
        NSLayoutConstraint(item: yAxisLabelView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: yAxisHeight).isActive = true
    }
    
    
    
    // MARK: functions in ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intervalBarCollectionView.selectItem(at: CandleStickChartViewController.selectedIntervalIndexPath, animated: true, scrollPosition: [])
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        setupUI()
    }
    
    
    
    // MARK: CollectionViewDelegate for Interval Bar
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Params.intervalTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntervalBarCollectionViewCell", for: indexPath) as! IntervalBarCollectionViewCell
        cell.label.text = Params.intervalTexts[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Params.category = indexPath.row
        CandleStickChartViewController.selectedIntervalIndexPath = indexPath
        setupNewChart()
    }
    
    // CollectionViewDelegateFlowLayout for Interval Bar
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: intervalBarCollectionView.frame.width / CGFloat(Params.intervalTexts.count), height: intervalBarCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
    // MARK: Fetching data
    
    private func fetchData() {
        guard let coinSymbol = self.coinSymbol else { return }
        fetcher.fetcher(coinSymbol: coinSymbol) { [unowned self] in
            self.historicalDataStruct = self.fetcher.historicalDataStruct
        }
    }
    
    private func setupNewChart() {
        guard let _ = self.coinSymbol else { return }
        spinner.startAnimating()
        chart.subviews.forEach {
            $0.removeFromSuperview()
        }
        yAxisLabelView.subviews.forEach {
            $0.removeFromSuperview()
        }
        xAxisLabelView.subviews.forEach {
            $0.removeFromSuperview()
        }
        scrollView.contentOffset.x = scrollView.contentSize.width - scrollView.frame.size.width
        HistoricalDataFetcher.dataTask?.cancel()
        fetchData()
    }
}
