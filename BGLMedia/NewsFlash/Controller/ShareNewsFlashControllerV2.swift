//
//  ShareNewsFlashControllerV2.swift
//  BGLMedia
//
//  Created by Bruce Feng on 23/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class ShareNewsFlashControllerV2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        shareButton.addTarget(self, action: #selector(createImage), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func createImage(){
//        let ss = UIImage.imageWithView(view: shareImage)
        
        let activityVC = UIActivityViewController(activityItems: [self.imageWithView(view: shareImage)], applicationActivities:nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        
        activityVC.completionWithItemsHandler = {
            (activityType, completed, items, error) in
            
            guard completed else {
                print("User cancelled.")
                return
                //                if user cancels activityVC preview can also be dismissed
                //            self.dismiss(animated: true, completion: nil)
            }
            
            print("Completed With Activity Type: \(activityType)")
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
        self.present(activityVC,animated:true,completion:nil)
    }
    
    func setUpView(){
        view.backgroundColor = ThemeColor().whiteColor()
        view.addSubview(shareImage)
        shareImage.addSubview(mainLogoImage)
        shareImage.addSubview(dateLabel)
        shareImage.addSubview(flashNewsDescription)
        shareImage.addSubview(downloadAppImage)
        view.addSubview(shareButton)
//        if #available(iOS 11.0, *) {
//            mainLogoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        } else {
//            // Fallback on earlier versions
//        }
        
//        NSLayoutConstraint(item: mainLogoImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mainLogoImage, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mainLogoImage, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: mainLogoImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 150).isActive = true
        
        let reSizeMain = CGSize(width: view.frame.width, height: 180)
        let reSizeDownLoadApp = CGSize(width: view.frame.width, height: 150)
//        shareImage.frame = CGRect(x: 0, y: 0, width: view.frame.width,height: 800)
        
        mainLogoImage.image = UIImage(named: "bcgflashnews2")?.reSizeImage(reSize: reSizeMain)
        downloadAppImage.image = UIImage(named: "downloadapp")?.reSizeImage(reSize: reSizeDownLoadApp)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareImage]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "v:|[v0(300)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareImage]))
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(180)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-10-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v2]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v1]-10-[v2]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v3]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        shareImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v2]-30-[v3(180)]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":mainLogoImage,"v1":dateLabel,"v2":flashNewsDescription,"v3":downloadAppImage]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareButton]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":shareButton]))
    }
    
    var shareImage:UIView = {
       var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
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
    
    var dateLabel:UILabel = {
       var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ThemeColor().blueColor()
        label.font = label.font.withSize(18)
        label.text = "sdfdsff"
        return label
    }()
    
    var flashNewsDescription:UILabel = {
       var label = UILabel()
        label.font = label.font.withSize(15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sfdsfsfdsfdsffsfsdfdsfdsfsfsfsdf"
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
    
    var shareButton:UIButton = {
        var button = UIButton()
        button.backgroundColor = ThemeColor().blueColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
