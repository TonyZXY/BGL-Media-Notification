//
//  BGLCommunityController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 15/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import SafariServices

class BGLCommunityController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var titles:[String]{
        get{
            return [textValue(name: "weibo_community"),textValue(name: "wechat_community"),textValue(name: "twitter_community"),textValue(name: "facebook_community"),textValue(name: "youtube_community")]
        }
    }
    
    var logoItems = ["weibo.png","wechat.png","twitter.png","facebook.png","youtube.png"]
    
    var itemsUrl = ["https://m.weibo.cn/u/5410971155",
                    "https://mp.weixin.qq.com/s?__biz=MzA5Mjg3OTcyOQ==&mid=2659941256&idx=3&sn=79046f324e1be54d0344731320e240f5&chksm=8b19b596bc6e3c80ef6116586c5797d03e9cf9e13b674d516eddadc52ca9c9bf3f0aeaba20c6&scene=21#wechat_redirect",
                    "https://twitter.com/blockchaingl",
                    "https://www.facebook.com/BlockchainGL/",
                    "https://www.youtube.com/channel/UCzKG8vKUKlTn88raV2W07Wg?view_as=subscriber",
                    "https://www.blockchainglobal.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let factor = view.frame.width/375
        let sectionView = UIView()
        sectionView.backgroundColor = ThemeColor().darkGreyColor()
        let sectionLabel = UILabel()
        sectionLabel.text = textValue(name: "community_setting")
        sectionLabel.textColor = ThemeColor().textGreycolor()
        sectionLabel.font = UIFont.regularFont(20*factor)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionView.addSubview(sectionLabel)
        
        NSLayoutConstraint(item: sectionLabel, attribute: .bottom, relatedBy: .equal, toItem: sectionView, attribute: .bottom, multiplier: 1, constant: -10*factor).isActive = true
        NSLayoutConstraint(item: sectionLabel, attribute: .left, relatedBy: .equal, toItem: sectionView, attribute: .left, multiplier: 1, constant: 10*factor).isActive = true
        //        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
        //        sectionView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70*view.frame.width/375
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let factor = view.frame.width/375
        let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell") as! communityCell
        cell.factor = factor
        cell.communityLabel.text = titles[indexPath.row]
        cell.communityImage.image = UIImage(named: logoItems[indexPath.row])
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.alpha = 0
    //        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
    //        cell.layer.transform = transform
    //        UIView.animate(withDuration: 1.0) {
    //            cell.alpha = 1.0
    //            cell.layer.transform = CATransform3DIdentity
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = itemsUrl[indexPath.row]
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            self.present(vc, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    lazy var communityTableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(communityCell.self, forCellReuseIdentifier: "communityCell")
        return tableView
    }()
    
    func setUpView(){
        let factor = view.frame.width/375
        communityTableView.rowHeight = 70*factor
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(communityTableView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(10*factor)-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityTableView]))
    }
    
}

class communityCell:UITableViewCell{
    var factor:CGFloat?{
        didSet{
            setupviews()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been completed")
    }
    
    lazy var cellView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().walletCellcolor()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 13 * factor!
        return view
    }()
    
    lazy var communityImage: UIImageView = {
        var imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 30*factor!, height: 30*factor!)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let communityLabel: UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupviews(){
        communityLabel.font = UIFont.regularFont(14*factor!)
        backgroundColor = ThemeColor().themeColor()
        addSubview(cellView)
        cellView.addSubview(communityImage)
        cellView.addSubview(communityLabel)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v0]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]-\(2*factor!)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cellView]))
        
        
        NSLayoutConstraint(item: communityImage, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
//        NSLayoutConstraint(item: communityLabel, attribute: .centerX, relatedBy: .equal, toItem: cellView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: communityLabel, attribute: .centerY, relatedBy: .equal, toItem: cellView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(15*factor!)-[v0(\(30*factor!))]-\(10*factor!)-[v1(\(80*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityImage,"v1":communityLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(30*factor!))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":communityImage,"v1":communityLabel]))
    }
}


