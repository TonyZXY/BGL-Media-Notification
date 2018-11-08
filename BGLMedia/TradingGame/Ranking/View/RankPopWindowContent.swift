//
//  RankPopWindowContent.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 11/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit
/**
    display by PopWindowController
 */
class RankPopWindowContent : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    lazy var statRank : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15*factor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var statNumber : UILabel = {
        var label = UILabel()
        label.numberOfLines =  1
        label.textColor = .black
        label.font = UIFont.semiBoldFont(15*factor)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupContent(rankViewModel : RankObjectViewModel?){
        self.statRank.text = "Rank: \(rankViewModel?.pop_rank ?? "")"
        self.statNumber.text = rankViewModel?.pop_stat ?? ""
    }
    
    func setupView(){
        
        self.addSubview(statRank)
        self.addSubview(statNumber)
        
        statRank.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        statNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        statRank.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: -10*factor).isActive = true
        statNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 10*factor).isActive = true
        
        
    }
    
    convenience init(rankViewModel : RankObjectViewModel?){
        self.init()
        setupView()
        setupContent(rankViewModel: rankViewModel)
    }
}
