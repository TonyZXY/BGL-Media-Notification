//
//  NewsTableViewCell.swift
//  BGLMedia
//
//  Created by Xuyang Zheng on 25/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    var width:CGFloat?{
        didSet{
            factorNumber = width!/414
            setupView()
        }
    }
    
    var news:NewsObject? {
        didSet{
            titleLabel.text = news?.title!
            publishTimeLabel.text = Extension.method.convertDateToString(date: (news?.publishedTime)!)
            timeLabel.text = news?.publishedTime.timeAgoDisplay()
            // source text and source pic need to be implement
            sourceLabel.text = news?.source!
//            logoImageView.image = ??
        }
    }

    
   
    
    var factorNumber:CGFloat?
    
    let rootView:UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()

    let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = ThemeColor().walletCellcolor()
        return view
    }()
    
    lazy var logoView:UIView = {
        let frame = CGRect(x: 0, y: 0, width: 40*factorNumber!, height: 40*factorNumber!)
        let view = UIView(frame: frame)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var logoImageView:UIImageView = {
        let frame = CGRect(x: 0, y: 0, width: 40*factorNumber!, height: 40*factorNumber!)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.white
        label.font = UIFont.ItalicFont(8*factorNumber!)
        label.numberOfLines = 3
//        label.text = "Business Insider(UK)"
//        label.text = "CryptoNewsReview"
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .white
        label.font = UIFont.semiBoldFont(16*factorNumber!)
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    lazy var publishTimeLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .white
        label.font = UIFont.lightFont(12*factorNumber!)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .white
        label.textColor = .white
        label.font = UIFont.ThinFont(10*factorNumber!)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    func setupView(){
        // add Root View
        backgroundColor = ThemeColor().themeColor()
        addSubview(rootView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: rootView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: rootView)
        
        // set up cell view into root view
        rootView.addSubview(cellView)
        rootView.addConstraintsWithFormat(format: "H:|-\(3*factorNumber!)-[v0]-\(3*factorNumber!)-|", views: cellView)
        rootView.addConstraintsWithFormat(format: "V:|-\(2*factorNumber!)-[v0]-\(2*factorNumber!)-|", views: cellView)
        
        //add and set up logo
        cellView.addSubview(logoView)
        cellView.addConstraintsWithFormat(format: "H:|-\(15*factorNumber!)-[v0(\(40*factorNumber!))]", views: logoView)
        cellView.addConstraintsWithFormat(format: "V:|-\(25*factorNumber!)-[v0(\(40*factorNumber!))]", views: logoView)
        logoView.addSubview(logoImageView)
        logoView.addConstraintsWithFormat(format: "H:|[v0]|", views: logoImageView)
        logoView.addConstraintsWithFormat(format: "V:|[v0]|", views: logoImageView)
        
        // add source label
        cellView.addSubview(sourceLabel)
        cellView.addConstraintsWithFormat(format: "H:|-\(15*factorNumber!)-[v0(\(40*factorNumber!))]", views: sourceLabel)
        addConstraint(NSLayoutConstraint(item: sourceLabel, attribute: .top, relatedBy: .equal, toItem: logoView, attribute: .bottom, multiplier: 1, constant: 5*factorNumber!))
        addConstraint(NSLayoutConstraint(item: sourceLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 32*factorNumber!))
        
        // add title label
        cellView.addSubview(titleLabel)
        cellView.addConstraintsWithFormat(format: "V:|-\(8*factorNumber!)-[v0(\(60*factorNumber!))]", views: titleLabel)
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: logoView, attribute: .trailing, multiplier: 1, constant: 20*factorNumber!))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 310*factorNumber!))
        
        cellView.addSubview(timeLabel)
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 5*factorNumber!))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 12*factorNumber!))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 90*factorNumber!))
        
        cellView.addSubview(publishTimeLabel)
        addConstraint(NSLayoutConstraint(item: publishTimeLabel, attribute: .leading, relatedBy: .equal, toItem: timeLabel, attribute: .leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: publishTimeLabel, attribute: .top, relatedBy: .equal, toItem: timeLabel, attribute: .bottom, multiplier: 1, constant: 5*factorNumber!))
        addConstraint(NSLayoutConstraint(item: publishTimeLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 14*factorNumber!))
        addConstraint(NSLayoutConstraint(item: publishTimeLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 120*factorNumber!))
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
