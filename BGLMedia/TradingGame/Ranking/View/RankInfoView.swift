//
//  RankInfoView.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 13/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class RankInfoView : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    let nickNameAttributes : [NSAttributedString.Key:Any] = [NSAttributedStringKey.font: UIFont.semiBoldFont(CGFloat(fontSize+9)),
                                                     NSAttributedStringKey.foregroundColor: UIColor.white,
                                                     NSAttributedStringKey.strokeWidth : -3.0,
                                                     NSAttributedStringKey.strokeColor : ThemeColor().themeWidgetColor(),
                                                     NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                                     NSAttributedStringKey.underlineColor : ThemeColor().themeWidgetColor()]
    
    var rankViewModel : RankObjectViewModel?{
        didSet{
            var rankText = "\(textValue(name: "rank_userRank")) : "
            rankText += "\(rankViewModel?.ranknumber ?? 0)"
            selfRankLabel.text = rankText
            selfStatLabel.text = rankViewModel?.statString ?? "--"
            
            selfNickNameLabel.attributedText =  NSAttributedString(string: rankViewModel?.nickname ?? "--", attributes: nickNameAttributes)
        }
    }
    
    var rankDetailModel : RankDetailModel?{
        didSet{
            var text = "\(textValue(name: "rank_updatedTime")) : "
            if let time = rankDetailModel?.time{
                text += Extension.method.convertDateToString(date: time)
            }else{
                text += "--"
            }
            updatedTimeLabel.text = text
        }
    }
    
    lazy var backgroundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "trophy")?.alpha(0.1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var updatedTimeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.textColor = .white
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var selfNickNameLabel : UILabel = {
        let label = UILabel()
//        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
//        label.textColor = .white
//        label.text = "Rank--"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var selfRankLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.textColor = .white
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var selfStatLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.semiBoldFont(CGFloat(fontSize+4))
        label.textColor = .white
        label.text = "--"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    func setupView(){
        self.clipsToBounds = true
        self.heightAnchor.constraint(equalToConstant: 100*factor).isActive = true
        addSubview(backgroundImage)
        backgroundImage.heightAnchor.constraint(equalToConstant: 170*factor).isActive = true
        backgroundImage.widthAnchor.constraint(equalToConstant: 170*factor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: self.rightAnchor,constant: -20*factor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: self.bottomAnchor,constant: -20*factor).isActive = true
        
        let userInfoStack : UIStackView = {
            let stack = UIStackView(arrangedSubviews: [selfRankLabel,selfStatLabel])
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .fillEqually
            stack.spacing = 20 * factor
            return stack
        }()
        
        let rankInfoStack : UIStackView = {
            let stack = UIStackView(arrangedSubviews: [updatedTimeLabel,selfNickNameLabel,userInfoStack])
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fillEqually
            return stack
        }()
        
        self.addSubview(rankInfoStack)
        self.addConstraintsWithFormat(format: "H:|[v0]|", views: rankInfoStack)
        self.addConstraintsWithFormat(format: "V:|[v0]|", views: rankInfoStack)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
