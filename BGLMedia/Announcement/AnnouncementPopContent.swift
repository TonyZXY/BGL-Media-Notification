//
//  AnnouncementPopWindowController.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 14/11/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class AnnouncementPopContentView : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    private var announcementModels : [AnnouncementModel]?
    
    lazy var logoView : RoundView = {
        //        let innerRingWidth = 5 * factor
        let view = RoundView()
        view.layer.borderWidth = 5 * factor
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        view.backgroundColor = ThemeColor().logoBackgroundColor()
        
        var logoImage : UIImageView = {
            var image = UIImageView()
            image.contentMode = .scaleAspectFit
            image.image = UIImage(named: "cryptogeek_icon_")
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        
        view.addSubview(logoImage)
        logoImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier : 0.6).isActive = true
        logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier : 0.6).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        let attributes : [NSAttributedString.Key:Any] = [NSAttributedStringKey.font: UIFont.boldFont(CGFloat(fontSize+6)),
                                                                 NSAttributedStringKey.foregroundColor: UIColor.black,
                                                                 NSAttributedStringKey.strokeColor : UIColor.black,
                                                                 NSAttributedStringKey.strokeWidth : -4.0,
                                                                 NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                                                 NSAttributedStringKey.underlineColor : UIColor.black]
        label.attributedText = NSAttributedString(string: textValue(name: "announcement_title"), attributes: attributes)
        return label
    }()
    
    lazy var closeButton : DismissButton = {
        let button = DismissButton(dismissController: nil)
        button.layer.cornerRadius = 5 * factor
        button.clipsToBounds = true
        button.setTitle(textValue(name: "close"), for: .normal)
        button.backgroundColor = ThemeColor().redColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var scrollView : UIScrollView={
        let scroll = UIScrollView()
        scroll.bounces = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private func loadCellViews(){
        
        if let models = announcementModels{
            
            var cells = [AnnouncementCell]()
            for model in models{
                let cell = AnnouncementCell()
                cell.announcementModel = model
                cells.append(cell)
            }
            
            
            // for each cell add constraint
            for (index,cell) in cells.enumerated(){
                // add view all horizontal constraint should be the same
                scrollView.addSubview(cell)
                cell.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
                
                // vertical constraints
                if index == 0{
                    // first cell
                    scrollView.addConstraintsWithFormat(format: "V:|[v0]", views: cell)
                }else{
                    // add a line break between cell
                    let lineBreak = UIView()
                    lineBreak.backgroundColor = ThemeColor().themeWidgetColor()
                    scrollView.addSubview(lineBreak)
                    lineBreak.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
                    lineBreak.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
                    
                    if index == cells.count - 1{
                        // last cell
                        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(10*factor)-[v1(\(2*factor))]-\(10*factor)-[v2]-\(10*factor)-|", views: cells[index-1],lineBreak,cell)
                    }else{
                        scrollView.addConstraintsWithFormat(format: "V:[v0]-\(10*factor)-[v1(\(2*factor))]-\(10*factor)-[v2]", views: cells[index-1],lineBreak,cell)
                    }
                }
            }
        }
    }
    
    func setupView(){
//        self.heightAnchor.constraint(equalToConstant: 400*factor).isActive = true
        self.widthAnchor.constraint(equalToConstant: 330*factor).isActive = true
        
        self.addSubview(logoView)
        logoView.heightAnchor.constraint(equalToConstant: 110*factor).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 110*factor).isActive = true
        logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoView.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        self.addSubview(titleLabel)
        self.addSubview(scrollView)
        self.addSubview(closeButton)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 200*factor).isActive = true
        
        self.addConstraintsWithFormat(format: "H:|-\(20*factor)-[v0]-\(20*factor)-|", views: scrollView)
        self.addConstraintsWithFormat(format: "V:|-\(60*factor)-[v0]-\(20*factor)-[v1]-\(20*factor)-[v2]", views: titleLabel,scrollView,closeButton)
        
        scrollView.heightAnchor.constraint(equalToConstant: 250*factor).isActive = true
        self.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20*factor).isActive = true
    }
    
    
    convenience init(models : [AnnouncementModel]){
        self.init()
        announcementModels = models
        announcementModels?.sort(by: ({$0.publishedTime!.compare($1.publishedTime!) == .orderedDescending}))
        setupView()
        loadCellViews()
    }
    
}

class AnnouncementCell : UIView{
    let factor = UIScreen.main.bounds.width/375
    
    var announcementModel : AnnouncementModel? {
        didSet{
            titleLabel.text = announcementModel?.title ?? ""
            publishedTimeLabel.text = Extension.method.convertDateToString(date: announcementModel?.publishedTime ?? Date())
            shortMessageLabel.text = announcementModel?.shortMessage ?? ""
        }
    }
    
    lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.boldFont(14*factor)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var publishedTimeLabel :  UILabel = {
        var label = UILabel()
        label.font = UIFont.ItalicFont(12*factor)
        label.numberOfLines = 1
        label.textColor = ThemeColor().textGreycolor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var shortMessageLabel : UILabel = {
        var label = UILabel()
        label.font = UIFont.ItalicFont(13*factor)
        label.numberOfLines = 0
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView(){
        addSubview(titleLabel)
        addSubview(publishedTimeLabel)
        addSubview(shortMessageLabel)
        
        addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]-\(10*factor)-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]-\(10*factor)-|", views: publishedTimeLabel)
        addConstraintsWithFormat(format: "H:|-\(10*factor)-[v0]-\(10*factor)-|", views: shortMessageLabel)
        
        addConstraintsWithFormat(format: "V:|-\(5*factor)-[v0]-\(2*factor)-[v1]-\(3*factor)-[v2]", views: titleLabel,publishedTimeLabel,shortMessageLabel)
        
        self.bottomAnchor.constraint(equalTo: shortMessageLabel.bottomAnchor, constant : 10*factor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
