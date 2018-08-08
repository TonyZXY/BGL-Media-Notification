//
//  ShareNewsFlashControllerV2.swift
//  BGLMedia
//
//  Created by Bruce Feng on 23/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class ShareNewsFlashControllerV2: UIViewController {
    var newsdate:String = ""
    var newsdescriptions: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        shareButton.addTarget(self, action: #selector(createImage), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelView), for: .touchUpInside)
        dateLabel.text = newsdate
        flashNewsDescription.text = newsdescriptions
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func createImage(){
//        let ss = UIImage.imageWithView(view: shareImage)
        
        let activityVC = UIActivityViewController(activityItems: [self.imageWithView(view: shareImage) as Any], applicationActivities:nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        
        activityVC.completionWithItemsHandler = {
            (activityType, completed, items, error) in
            
            guard completed else {
//                print("User cancelled.")
                return
                //                if user cancels activityVC preview can also be dismissed
                //            self.dismiss(animated: true, completion: nil)
            }
            
//            print("Completed With Activity Type: \(activityType)")
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
        self.present(activityVC,animated:true,completion:nil)
    }
    
    @objc func cancelView(){
        dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        let factor = view.frame.width/375
        view.backgroundColor = ThemeColor().whiteColor()
        view.addSubview(scrollView)
        scrollView.addSubview(shareImage)
        shareImage.addSubview(mainLogoImage)
        shareImage.addSubview(clockImage)
        shareImage.addSubview(dateLabel)
        shareImage.addSubview(flashNewsDescription)
        shareImage.addSubview(downloadAppImage)
        view.addSubview(selectBarView)
        selectBarView.addSubview(shareButton)
        selectBarView.addSubview(cancelButton)
//        if #available(iOS 11.0, *) {
//            mainLogoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        } else {
//            // Fallback on earlier versions
//        }
        
//        NSLayoutConstraint(item: mainLogoImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mainLogoImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mainLogoImage, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mainLogoImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150).isActive = true
        
        let reSizeMain = CGSize(width: view.frame.width, height: 200*factor)
        let reSizeDownLoadApp = CGSize(width: view.frame.width, height: 150*factor)
//        shareImage.frame = CGRect(x: 0, y: 0, width: view.frame.width,height: 800)
        
        mainLogoImage.image = UIImage(named: "cryptogeek_flash_news_top")?.reSizeImage(reSize: reSizeMain)
        downloadAppImage.image = UIImage(named: "cryptogeek_flash_news_bottom")?.reSizeImage(reSize: reSizeDownLoadApp)
//
//        if #available(iOS 11.0, *) {
//            scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//            scrollView.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
//            scrollView.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//            scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: selectBarView.safeAreaLayoutGuide.topAnchor).isActive = true
//            selectBarView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//            selectBarView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
////            scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
////            scrollView.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
////            scrollView.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        } else {
//            // Fallback on earlier versions
//        }
//
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrollView,"v1":selectBarView]))
        
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":scrollView,"v1":selectBarView]))
        
        
        selectBarView.topAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        selectBarView.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        if #available(iOS 11.0, *) {
            selectBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            selectBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0(\(view.frame.width))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareImage]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v0(\(view.frame.height))]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareImage]))
        
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "v:|[v0(300)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareImage]))
        
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(\(200*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        
        
//        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage,"v4":clockImage]))
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(10*factor)-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage,"v4":clockImage]))
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-\(10*factor)-[v4(\(20*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage,"v4":clockImage]))
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(20*factor)-[v4(\(20*factor))]-5-[v1]-\(20*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage,"v4":clockImage]))
//        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
         NSLayoutConstraint(item: clockImage, attribute: .centerY, relatedBy: .equal, toItem: dateLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(20*factor)-[v2]-\(20*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-\(20*factor)-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v3(\(150*factor))]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(80)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":selectBarView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":selectBarView]))
//        NSLayoutConstraint(item: shareButton, attribute: .centerY, relatedBy: .equal, toItem: selectBarView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
         NSLayoutConstraint(item: shareButton, attribute: .top, relatedBy: .equal, toItem: selectBarView, attribute: .top, multiplier: 1, constant: 10*factor).isActive = true
//        NSLayoutConstraint(item: shareButton, attribute: .bottom, relatedBy: .equal, toItem: selectBarView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: shareButton, attribute: .right, relatedBy: .equal, toItem: selectBarView, attribute: .right, multiplier: 1, constant: -10*factor).isActive = true
//        NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: selectBarView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .left, relatedBy: .equal, toItem: selectBarView, attribute: .left, multiplier: 1, constant: 10*factor).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: selectBarView, attribute: .top, multiplier: 1, constant: 10*factor).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: selectBarView, attribute: .top, multiplier: 1, constant: 10*factor).isActive = true
//        NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: selectBarView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    var shareImage:UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeColor().whiteColor()
//        view.frame = CGRect(x: 0, y: 0, width: view.frame.width,height: 300)
        return view
    }()

    var mainLogoImage:UIImageView = {
       var imageView = UIImageView()
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 150)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "bcgflashnews2")
        return imageView
    }()
    
    lazy var dateLabel:UILabel = {
        let factor = view.frame.width/375
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().darkBlackColor()
        label.font = UIFont.semiBoldFont(17*factor)
        return label
    }()
    
    lazy var clockImage:UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "alarm")
        return imageView
    }()
    
    lazy var flashNewsDescription:UILabel = {
       var label = UILabel()
        label.font = UIFont.regularFont(17*view.frame.width/375)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = ThemeColor().darkBlackColor()
        return label
    }()
    
    var downloadAppImage:UIImageView = {
        var imageView = UIImageView()
        //        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 150)
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "downloadapp")
        return imageView
    }()
    
    lazy var shareButton:UIButton = {
        var button = UIButton()
        button.setTitle(textValue(name: "share_flash"), for: .normal)
        button.titleLabel?.font = UIFont.regularFont(20*view.frame.width/375)
        button.setTitleColor(ThemeColor().darkGreyColor(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton:UIButton = {
        var button = UIButton()
        button.setTitle(textValue(name: "cancel_flash"), for: .normal)
        button.titleLabel?.font = UIFont.regularFont(20*view.frame.width/375)
        button.setTitleColor(ThemeColor().darkGreyColor(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var selectBarView:UIView = {
        var view = UIView()
        view.backgroundColor = ThemeColor().whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.showsVerticalScrollIndicator = true
//        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
//    var testImages:UIImage = {
//        var image = UIImage()
//        return image
//    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
