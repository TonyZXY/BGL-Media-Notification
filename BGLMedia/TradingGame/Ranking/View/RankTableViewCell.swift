//
//  RankTableViewCell.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankTableViewTopCell: UITableViewCell{

    public static let registerID = "rankTableViewTopCell"
    // needed to perform on click action
    var tableController : RankTableViewController?
    
    // should a size 3 array
    var viewModels = [RankObjectViewModel](){
        didSet{
            viewModels.sort(by: ({$0.ranknumber < $1.ranknumber}))
            var i = 0
            for model in viewModels{
                if i < 3 {
                    changeContent(container: topRankContainers[i], viewModel: model)
                }else{
                    break
                }
                i += 1
            }
        }
    }
    private func changeContent(container: TopRankContainer, viewModel : RankObjectViewModel?){
        if viewModel != nil{
            container.nicknameLabel.text = viewModel?.nickname ?? ""
            container.statLabel.text = viewModel?.statString ?? ""
        }
    }
    
    let baseView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = ThemeColor().walletCellcolor()
//        view.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()
    
    var topRankContainers : [TopRankContainer] = {
        var gold = TopRankContainer(imageName: "first")
        var silver = TopRankContainer(imageName: "second")
        var bronze = TopRankContainer(imageName: "third")
        return [gold,silver,bronze]
    }()

    func setupView(){
        backgroundColor = ThemeColor().themeColor()
        let factor = UIScreen.main.bounds.width/414
        addSubview(baseView)
        addConstraintsWithFormat(format: "H:|-\(3*factor)-[v0]-\(3*factor)-|", views: baseView)
        addConstraintsWithFormat(format: "V:|-\(2*factor)-[v0]-\(2*factor)-|", views: baseView)
        
        for container in topRankContainers{
            baseView.addSubview(container)
        }
        
        let goldContainer = topRankContainers[0]
        let silverContainer = topRankContainers[1]
        let bronzeContainer = topRankContainers[2]
        
        goldContainer.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 1/3).isActive = true
        silverContainer.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 1/3).isActive = true
        bronzeContainer.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 1/3).isActive = true
        baseView.addConstraintsWithFormat(format: "H:|-0-[v0]-0-[v1]-0-[v2]", views: silverContainer,goldContainer,bronzeContainer)
        baseView.addConstraintsWithFormat(format: "V:|[v0]|", views: silverContainer)
        baseView.addConstraintsWithFormat(format: "V:|[v0]|", views: goldContainer)
        baseView.addConstraintsWithFormat(format: "V:|[v0]|", views: bronzeContainer)
        
//        // container width
//        let cWidth = baseView.frame.width / 3
        
        silverContainer.changeImageSize(size: CGSize(width: 80*factor, height: 80*factor))
        goldContainer.changeImageSize(size: CGSize(width: 100*factor, height: 100*factor))
        bronzeContainer.changeImageSize(size: CGSize(width: 60*factor, height: 60*factor))
        
//        print(goldContainer.frame.width)
//        goldContainer.changeImageSize(size: CGSize(width: goldContainer.frame.width*0.8,height : goldContainer.frame.width*0.8))
//        silverContainer.changeImageSize(size: CGSize(width: silverContainer.frame.width*0.6,height : silverContainer.frame.width*0.6))
//        bronzeContainer.changeImageSize(size: CGSize(width: bronzeContainer.frame.width*0.5,height : bronzeContainer.frame.width*0.5))
        
        // setup vertical constrainte for contents inside container
        silverContainer.addConstraintsWithFormat(format: "V:|-\(20*factor)-[v0]-0-[v1]-0-[v2]", views: silverContainer.medalImageView,silverContainer.nicknameLabel,silverContainer.statLabel)
        goldContainer.addConstraintsWithFormat(format: "V:|-\(10*factor)-[v0]-0-[v1]-0-[v2]", views: goldContainer.medalImageView,goldContainer.nicknameLabel,goldContainer.statLabel)
        bronzeContainer.addConstraintsWithFormat(format: "V:|-\(30*factor)-[v0]-0-[v1]-0-[v2]", views: bronzeContainer.medalImageView,bronzeContainer.nicknameLabel,bronzeContainer.statLabel)
        
        //setup click action
        containerTapSetting()
    }
    
    private func containerTapSetting(){
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.goldAction))
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.silverAction))
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.bronzeAction))
        let gestures = [gesture,gesture2,gesture3]
        var i = 0
        for g in gestures{
            topRankContainers[i].addGestureRecognizer(g)
            i += 1
        }
    }
    
    @objc func goldAction(sender : UITapGestureRecognizer) {
        tableController?.presentPopWindow(viewModel: viewModels[0])
    }
    @objc func silverAction(sender : UITapGestureRecognizer) {
        tableController?.presentPopWindow(viewModel: viewModels[1])
    }
    @objc func bronzeAction(sender : UITapGestureRecognizer) {
        tableController?.presentPopWindow(viewModel: viewModels[2])
    }
    
    class TopRankContainer : UIView{
        // set up image from init
        var medalImageView = UIImageView()
        
        var nicknameLabel : UILabel = {
            var label = UILabel()
            //            label.textColor = ThemeColor().whiteColor()
            label.numberOfLines =  1
            label.textColor = .white
            label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
            label.text = ""
            return label
        }()
        
        var statLabel: UILabel = {
            var label = UILabel()
            //            label.textColor = ThemeColor().whiteColor()
            label.numberOfLines =  1
            label.textColor = .white
            label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
            label.text = ""
            return label
        }()
        
        private func setupImage(imageName:String){
            medalImageView.contentMode = .scaleAspectFit
            medalImageView.image = UIImage(named: imageName)
        }
        
        func changeImageSize(size: CGSize){
            medalImageView.image = medalImageView.image?.resizeImage(size)
            medalImageView.layer.cornerRadius = 0.5 * size.width
            medalImageView.clipsToBounds = true
        }
        
        
        // vertical constratints is setted out side in parent class
        func setupView(){
            backgroundColor = ThemeColor().walletCellcolor()
            addSubview(medalImageView)
            addSubview(nicknameLabel)
            addSubview(statLabel)
            
            medalImageView.translatesAutoresizingMaskIntoConstraints = false
            nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
            statLabel.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraint(NSLayoutConstraint(item: medalImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: nicknameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: statLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            
//            medalImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
//            medalImageView.image = medalImageView.image?.resizeImage(CGSize(width: medalImageView.frame.width, height: medalImageView.frame.height))
        }
        
        convenience init(imageName:String){
            self.init()
            setupImage(imageName: imageName)
            setupView()
        }
    }
}


class RankTableViewBottomCell : UITableViewCell{
    public static let registerID = "rankTableViewBottomCell"
    
    var rankViewModel : RankObjectViewModel?{
        didSet{
            self.nicknameLabel.text = rankViewModel?.nickname ?? ""
            self.rankNumberLabel.text = rankViewModel?.ranknumberString ?? ""
            self.statLabel.text = rankViewModel?.statString ?? ""
        }
    }
    
    let baseView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = ThemeColor().walletCellcolor()
//        view.layer.shadowColor = ThemeColor().darkBlackColor().cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()
    
    var rankNumberLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.text = ""
        return label
    }()
    
    var nicknameLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.text = ""
        return label
    }()
    
    var statLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.text = ""
        return label
    }()
    
    func setupView(){
        backgroundColor = ThemeColor().themeColor()
        
        let factorNumber = UIScreen.main.bounds.width/414
        
        addSubview(baseView)
        addConstraintsWithFormat(format: "H:|-\(3*factorNumber)-[v0]-\(3*factorNumber)-|", views: baseView)
        addConstraintsWithFormat(format: "V:|-\(2*factorNumber)-[v0]-\(2*factorNumber)-|", views: baseView)
        
        baseView.addSubview(rankNumberLabel)
        baseView.addSubview(nicknameLabel)
        baseView.addSubview(statLabel)
        
        // center alignment for vertical direction
        addConstraint(NSLayoutConstraint(item: rankNumberLabel, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: nicknameLabel, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: statLabel, attribute: .centerY, relatedBy: .equal, toItem: baseView, attribute: .centerY, multiplier: 1, constant: 0))
        
        let factor = self.frame.width/414
        
        baseView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]-(\(10 * factor))-[v1]", views: rankNumberLabel,nicknameLabel)
        baseView.addConstraintsWithFormat(format: "H:[v0]-(\(10 * factor))-|", views: statLabel)
    }
}


class RankPopWindowContentView : UIStackView{
    
//    var stackView : UIStackView = {
//        var stack = UIStackView()
//        return stack
//    }()
    var weeklyView : UIView = {
        var view = UIView()
        return view
    }()
    
    var totalView : UIView = {
        var view = UIView()
        return view
    }()
    
    // fixed label
    var weeklyLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.text = textValue(name: "rankPopWindow_Weekly")
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    var totalLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.text = textValue(name: "rankPopWindow_Total")
        label.textColor = .white
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    // data label
    var weeklyRank : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    var weeklyStat : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(15)
        return label
    }()

    var totalRank : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    var totalStat : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .white
        label.font = UIFont.semiBoldFont(15)
        return label
    }()
    
    private func setupContent(rankViewModel : RankObjectViewModel?){
        self.weeklyRank.text = "Rank: \(rankViewModel?.pop_weeklyRank ?? "")"
        self.weeklyStat.text = rankViewModel?.pop_weeklyStat ?? ""
        self.totalRank.text = "Rank: \(rankViewModel?.pop_totalRank ?? "")"
        self.totalStat.text = rankViewModel?.pop_totalStat ?? ""
    }
    
    func setupView(){
        let factor = UIScreen.main.bounds.width/414
        addSubview(weeklyView)
        addSubview(totalView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: weeklyView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: totalView)
        
        weeklyView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        totalView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        weeklyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        totalView.topAnchor.constraint(equalTo: weeklyView.bottomAnchor).isActive = true
        
        weeklyView.addSubview(weeklyLabel)
        weeklyView.addSubview(weeklyRank)
        weeklyView.addSubview(weeklyStat)

        weeklyView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]", views: weeklyLabel)
        weeklyView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: weeklyRank)
        weeklyView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: weeklyStat)
        addConstraint(NSLayoutConstraint(item: weeklyLabel, attribute: .centerY, relatedBy: .equal, toItem: weeklyView, attribute: .centerY, multiplier: 1, constant: 0))
        weeklyView.addConstraintsWithFormat(format: "V:|-(\(10 * factor))-[v0]-(\(10 * factor))-[v1]", views: weeklyRank,weeklyStat)

        totalView.addSubview(totalLabel)
        totalView.addSubview(totalRank)
        totalView.addSubview(totalStat)

        totalView.addConstraintsWithFormat(format: "H:|-(\(20 * factor))-[v0]", views: totalLabel)
        totalView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: totalRank)
        totalView.addConstraintsWithFormat(format: "H:[v0]-(\(20 * factor))-|", views: totalStat)
        addConstraint(NSLayoutConstraint(item: totalLabel, attribute: .centerY, relatedBy: .equal, toItem: totalView, attribute: .centerY, multiplier: 1, constant: 0))
        totalView.addConstraintsWithFormat(format: "V:|-(\(10 * factor))-[v0]-(\(10 * factor))-[v1]", views: totalRank,totalStat)
        
    }
    
    convenience init(rankViewModel : RankObjectViewModel?){
        self.init()
        self.axis = .vertical
        self.spacing = 0
        setupView()
        setupContent(rankViewModel: rankViewModel)
    }
}
