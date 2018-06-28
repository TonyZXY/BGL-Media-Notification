//
//  AboutUsViewController.swift
//  news app for blockchain
//
//  Created by Rock on 21/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        // Do any additional setup after loading the view.
        let label00 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label00.textAlignment = .center
        label00.textColor = UIColor.white
        label00.text = textValue(name: "title_about")
        self.navigationItem.titleView = label00
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView(){
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(introduceLabel)
        scrollView.addSubview(introDescription)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
        
//        scrollView.addConstraintsWithFormat(format: "H:|-10-[v0(\(view.frame.width-20))]-10-|", views: imageView)
        scrollView.addConstraintsWithFormat(format: "V:|-2-[v0(200)]", views: imageView)
        NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: view.frame.width-20).isActive = true
//        NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 200).isActive = true
        
        NSLayoutConstraint(item: introduceLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: introduceLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        scrollView.addConstraintsWithFormat(format: "V:[v1]-10-[v0]", views: introduceLabel,imageView)
        
       
        NSLayoutConstraint(item: introDescription, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: introDescription, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: imageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0).isActive = true
        scrollView.addConstraintsWithFormat(format: "V:[v1]-20-[v0]|", views: introDescription,introduceLabel)
        
        introduceLabel.text = textValue(name: "introduction_about")
        introDescription.text = textValue(name: "description_about")
    }
    
    func setUpCn(){
        
    }

    var scrollView:UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = ThemeColor().walletCellcolor()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var imageView:UIImageView = {
        var imageView = UIImageView(image: UIImage(named: "bcg_new_white01.png"))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var introduceLabel:UILabel={
        var label = UILabel()
        label.textColor = ThemeColor().bglColor()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var introDescription:UILabel={
        var label = UILabel()
        label.textColor = UIColor.white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    bcg_new_white01
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
