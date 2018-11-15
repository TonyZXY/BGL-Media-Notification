//
//  RankTableViewControllerV2.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 1/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankTableViewControllerV2: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let factor = UIScreen.main.bounds.width/414
    
    var allRank = [RankObjectViewModel](){
        didSet{
            // sort the data and reload
            allRank.sort(by: ({$0.ranknumber < $1.ranknumber}))
            rankTableView.reloadData()
        }
    }
    
    lazy var rankTableView : UITableView = {
        var tv = UITableView()
        //        tv.bounces = false
        tv.backgroundColor = ThemeColor().themeColor()
        tv.separatorStyle = .none
        tv.register(RankTableViewCell.self, forCellReuseIdentifier: RankTableViewCell.registerID)
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    
    var rankInfoView : RankInfoView = {
        var view = RankInfoView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        return view
    }()
    
    let cellHeight:CGFloat = 75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.addSubview(rankTableView)
        view.addSubview(rankInfoView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: rankTableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: rankInfoView)
        view.addConstraintsWithFormat(format: "V:|-0-[v0]-0-[v1]|", views: rankInfoView, rankTableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankTableViewCell.registerID, for: indexPath) as! RankTableViewCell
        cell.selectionStyle = .none
        cell.setupView()
        cell.rankViewModel = allRank[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight * factor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath) as! RankTableViewCell
        let viewModel = cell.rankViewModel
        presentPopWindow(viewModel: viewModel)
    }
    
    func presentPopWindow(viewModel: RankObjectViewModel?){
        let header = PopWindowHeader(title: viewModel?.pop_title)

        let content = RankPopWindowContent(rankViewModel: viewModel)
        let view : UIView = {
            let view = UIView()
            view.heightAnchor.constraint(equalToConstant: 150*factor).isActive = true
            view.widthAnchor.constraint(equalToConstant: 260*factor).isActive = true
            view.addSubview(header)
            view.addSubview(content)
            view.addConstraintsWithFormat(format: "H:|[v0]|", views: header)
            view.addConstraintsWithFormat(format: "H:|[v0]|", views: content)
            view.addConstraintsWithFormat(format: "V:|-0-[v0(\(50*factor))]-0-[v1]|", views: header,content)
            return view
        }()
        let popWindowConttroller = PopWindowController(contentView: view)
        header.dismissButton.dismissController = popWindowConttroller
        self.present(popWindowConttroller, animated: true, completion: nil)
    }
}



class CompetitionTableViewControllerV2 : RankTableViewControllerV2{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get data from refresshing
        DispatchQueue.main.async {
            self.rankTableView.beginHeaderRefreshing()
        }
    }
    
    func handleRefresh(_ tableView: UITableView){
        let api = RankApiReader()
        api.getAllRankData(completion: { success in
            if success {
                self.allRank = api.getCompetitionViewModels()
                self.rankInfoView.rankViewModel = api.getUserCompetitionViewModel()
                self.rankInfoView.rankDetailModel = api.rankData.competition_detail
                tableView.reloadData()
                tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            }else{
                tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        })
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName : nibNameOrNil, bundle: nibBundleOrNil)
        // add refresh header
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        self.rankTableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(self.rankTableView)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TotalRankTableViewControllerV2 : RankTableViewControllerV2{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // get data from refresshing
        DispatchQueue.main.async {
            self.rankTableView.beginHeaderRefreshing()
        }
    }
    
    func handleRefresh(_ tableView: UITableView){
        let api = RankApiReader()
        api.getAllRankData(completion: { success in
            if success {
                self.allRank = api.getTotalViewModels()
                self.rankInfoView.rankViewModel = api.getUserTotalViewModel()
                self.rankInfoView.rankDetailModel = api.rankData.total_detail
                tableView.reloadData()
                tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            }else{
                tableView.switchRefreshHeader(to: .normal(.failure, 0.5))
            }
        })
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName : nibNameOrNil, bundle: nibBundleOrNil)
        // add refresh header
        let header = DefaultRefreshHeader.header()
        header.textLabel.textColor = ThemeColor().whiteColor()
        header.textLabel.font = UIFont.regularFont(12)
        header.tintColor = ThemeColor().whiteColor()
        header.imageRenderingWithTintColor = true
        self.rankTableView.configRefreshHeader(with:header, container: self, action: {
            self.handleRefresh(self.rankTableView)
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
