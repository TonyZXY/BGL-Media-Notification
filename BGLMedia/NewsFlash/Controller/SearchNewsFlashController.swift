//
//  SearchNewsFlashController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 14/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import RealmSwift

class SearchNewsFlashController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    let realm = try! Realm()
    var results = try! Realm().objects(NewsFlash.self).sorted(byKeyPath: "dateTime", ascending: false)
    var newsFlashResult = [NewsFlash]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let timelineTableViewCellNib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle(for: TimelineTableViewCell.self))
        self.flashTableView.register(timelineTableViewCellNib, forCellReuseIdentifier: "flashNews")
        setupView()
        searchBar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if tableView == flashTableView{
            if newsFlashResult.count == 0{
                 searchCount.text = textValue(name: "searchNull_flash")
            } else {
                searchCount.text = textValue(name: "searchLabel_flash") + " " + String(newsFlashResult.count) + " " + textValue(name: "searchResult_flash")
            }
            searchCount.backgroundColor = ThemeColor().bglColor()
            return newsFlashResult.count
            
           } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == flashTableView{
            
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "flashNews", for: indexPath) as! TimelineTableViewCell
        let object = newsFlashResult[indexPath.row]
//        print(object.id)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:ma"
            cell.backgroundColor = ThemeColor().themeColor()
        cell.timelinePoint = TimelinePoint(diameter: CGFloat(16.0), color: #colorLiteral(red: 0, green: 0, blue: 0.7294117647, alpha: 0), filled: false)
        cell.timelinePointInside = TimelinePoint(diameter: CGFloat(4.0), color: #colorLiteral(red: 0, green: 0, blue: 0.7294117647, alpha: 0), filled: false, insidePoint: false)
        cell.timeline.backColor = #colorLiteral(red: 0, green: 0, blue: 0.7294117647, alpha: 0)
        cell.titleLabel.text = dateFormatter.string(from: object.dateTime)
        cell.descriptionLabel.text = object.contents
        cell.object = object
        cell.shareButton.addTarget(self, action: #selector(shareButtonClicked), for: .touchUpInside)
        return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @objc func shareButtonClicked(sender: UIButton){
        let buttonPosition:CGPoint = sender.convert(CGPoint(x: 0, y: 0), to:self.flashTableView)
        let indexPath = self.flashTableView.indexPathForRow(at: buttonPosition)
        let cell = flashTableView.cellForRow(at: indexPath!)! as! TimelineTableViewCell
        let cellText = cell.descriptionLabel.text
        let size = cell.descriptionLabel.font.pointSize
        let textImage = self.textToImage(drawText: cellText!, inImage: cell.descriptionLabel.createImage!, atPoint: CGPoint(x:0, y:0), withSize:size)
        
        let topImage = combineLogoWithText(combine: UIImage(named: "bcg_logo.png")!, with: textImage)
        let bottomImage = UIImage(named: "sample_qr_code.png")
        let image = combineImageWithQRCode(combine: topImage, with: (bottomImage)!)
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities:nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC,animated: true, completion:nil)
    }
    
    func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint, withSize size: CGFloat) -> UIImage {
        let textColor = UIColor.black
        
        let textFont = UIFont.systemFont(ofSize: size)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: textFont,
            NSAttributedStringKey.foregroundColor: textColor,
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func combineImageWithQRCode(combine topImage:UIImage, with bottomImage:UIImage)-> UIImage{
        let width = topImage.size.width
        let height = topImage.size.height * 2
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        topImage.draw(in: CGRect(x:0, y:0, width:width, height: height/2 ))
        bottomImage.draw(in: CGRect(x:(width-height/2)/2, y:height/2, width: height/2,  height:height/2 ))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Change UIImageView requirements here
        let mergeImageView = UIImageView(frame: CGRect(x:0, y: 200, width: 30, height: 20))
        
        //Combine images into a single image view.
        mergeImageView.image = newImage
        return mergeImageView.image!
    }
    
    func combineLogoWithText(combine topImage:UIImage, with bottomImage:UIImage)-> UIImage{
        let width = bottomImage.size.width
        let height = bottomImage.size.height * 2
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        topImage.draw(in: CGRect(x:(width-height/2)/2, y:0, width:height/2, height: height/2 ))
        bottomImage.draw(in: CGRect(x:0, y:height/2, width: width,  height:height/2 ))
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Change UIImageView requirements here
        let mergeImageView = UIImageView(frame: CGRect(x:0, y: 200, width: 30, height: 20))
        
        //Combine images into a single image view.
        mergeImageView.image = newImage
        return mergeImageView.image!
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            view.endEditing(true)
            newsFlashResult.removeAll()
            flashTableView.reloadData()
        } else{
            APIService.shardInstance.fetchSearchFlash(keyword: searchBar.text!,language: defaultLanguage) { (searchResult) in
                self.newsFlashResult.removeAll()
//                print(searchResult.count)
                if searchResult.count != 0{
                    for value in searchResult{
                        self.newsFlashResult.append(value)
                    }
                    self.flashTableView.reloadData()
                }
            }
        }
    }

    
    func setupView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(searchBar)
        view.addSubview(searchCount)
        view.addSubview(flashTableView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":searchCount]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-0-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":searchCount]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchCount,"v1":flashTableView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-5-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchCount,"v1":flashTableView]))
    }
    
    var searchCount:paddingLabel = {
       var label = paddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.insetEdge = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//        label.frame = UIEdgeInsetsMake(0, 20, 0, 20)
//        label.layer.backgroundColor = ThemeColor().bglColor() as! CGColor
        return label
    }()
    
    lazy var searchBar:UISearchBar={
        var searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.barTintColor = ThemeColor().walletCellcolor()
        searchBar.tintColor = ThemeColor().themeColor()
        searchBar.backgroundColor = ThemeColor().fallColor()
        return searchBar
    }()
    
    lazy var flashTableView:UITableView={
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ThemeColor().themeColor()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
}

class paddingLabel:UILabel{
    open var insetEdge:UIEdgeInsets!
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insetEdge))
    }
}
