//
//  SearchNewsController.swift
//  BGL-MediaApp
//
//  Created by Bruce Feng on 6/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class SearchNewsController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,UICollectionViewDelegateFlowLayout{
    var searchNewsObject = [SearchObject]()
    var searchGennieObject = [SearchObject]()
    var searchVideoObject = [SearchObject]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let total = searchNewsObject.count + searchGennieObject.count + searchVideoObject.count
        if total == 0{
             searchCount.text = textValue(name: "searchNull_news")
        }else {
            searchCount.text =  textValue(name: "searchLabel_news") + String(total) + textValue(name: "searchResult_news")
        }
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if searchNewsObject.count > indexPath.row{
            if indexPath.row == 0{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCell
                cell.sectionLabel.text = textValue(name: "news_searchNews")
                cell.backgroundColor = ThemeColor().bglColor()
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
                let news = News()
                let searhResult = searchNewsObject[indexPath.row]
                news.author = searhResult.author
                news.title = searhResult.title
                news.newsDescription = searhResult.description
                news.url = searhResult.url
                news.imageURL = searhResult.imageURL
                news.publishedTime = searhResult.publishedTime
                cell.news = news
                return cell
            }
        } else if (searchGennieObject.count + searchNewsObject.count) > indexPath.row {
            if indexPath.row == (searchNewsObject.count) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCell
                cell.sectionLabel.text = textValue(name: "origin_searchNews")
                cell.backgroundColor = ThemeColor().bglColor()
                return cell
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genuineCell", for: indexPath) as! GenuineCell
                let genuine = Genuine()
                let searhResult = searchGennieObject[indexPath.row-(searchNewsObject.count)]
                genuine.author = searhResult.author
                genuine.title = searhResult.title
                genuine.genuineDescription = searhResult.description
                genuine.url = searhResult.url
                genuine.imageURL = searhResult.imageURL
                genuine.publishedTime = searhResult.publishedTime
                cell.genuine = genuine
                return cell
            }
        } else if (searchGennieObject.count + searchNewsObject.count + searchVideoObject.count) > indexPath.row{
            if indexPath.row == (searchNewsObject.count + searchGennieObject.count) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionCell
                cell.sectionLabel.text = textValue(name: "video_searchNews")
                cell.backgroundColor = ThemeColor().bglColor()
                return cell
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
                let video = Video()
                let searhResult = searchVideoObject[indexPath.row-(searchNewsObject.count + searchGennieObject.count)]
                video.author = searhResult.author
                video.title = searhResult.title
                video.videoDescription = searhResult.description
                video.url = searhResult.url
                video.imageURL = searhResult.imageURL
                video.publishedTime = searhResult.publishedTime
                cell.video = video
                return cell
            }
        } else {
            return UICollectionViewCell()
        }
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var objects = [SearchObject]()
        for value in searchNewsObject{
            objects.append(value)
        }
        for value in searchGennieObject{
            objects.append(value)
        }
        for value in searchVideoObject{
            objects.append(value)
        }
        let object = objects[indexPath.row]
        
        
        if object.type != "section"{
            if object.type == "video"{
                let videoDetailViewController = VideoDetailViewController()
                let video = Video()
                video.author = object.author
                video.title = object.title
                video.url = object.url
                video.videoDescription = object.description
                video.publishedTime = object.publishedTime
                videoDetailViewController.video = video
                navigationController?.pushViewController(videoDetailViewController, animated: true)
            } else {
                let newController = NewsDetailWebViewController()
                newController.news = (object.title, object.url) as? (title: String, url: String)
                navigationController?.pushViewController(newController, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize
        if collectionView == self.cellListView {
            if searchNewsObject.count > indexPath.row{
                if indexPath.row == 0{
                    size = CGSize(width: cellListView.frame.width, height: 30)
                    return size
                } else{
                    size = CGSize(width: cellListView.frame.width, height: 110)
                    return size
                }
            } else if (searchGennieObject.count + searchNewsObject.count) > indexPath.row {
                if indexPath.row == searchNewsObject.count{
                    size = CGSize(width: cellListView.frame.width, height: 30)
                    return size
                } else{
                    size = CGSize(width: cellListView.frame.width, height: 110)
                    return size
                }
            } else if (searchGennieObject.count + searchNewsObject.count + searchVideoObject.count) > indexPath.row{
                if indexPath.row == (searchNewsObject.count+searchGennieObject.count){
                    size = CGSize(width: cellListView.frame.width, height: 30)
                    return size
                } else{
                    let height = (view.frame.width - 30) * 9 / 16 + 75
                    size = CGSize(width: cellListView.frame.width, height: height)
                    return size
                }
            }
        }
        return CGSize()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            isSearching = false
            view.endEditing(true)
            self.searchNewsObject.removeAll()
            self.searchGennieObject.removeAll()
            self.searchVideoObject.removeAll()
            cellListView.reloadData()
        } else{
            isSearching = true
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            APIService.shardInstance.fetchSearchNews(keyword: searchBar.text!,language: defaultLanguage) { (searchResult) in
                self.searchNewsObject.removeAll()
                if searchResult.count != 0{
                    let section = SearchObject()
                    section.type = "section"
                    self.searchNewsObject.append(section)
                    for value in searchResult{
                        value.type = "news"
                        self.searchNewsObject.append(value)
                    }
                }
                print(self.searchNewsObject.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            APIService.shardInstance.fetchSearchGenuine(keyword: searchBar.text!,language: defaultLanguage) { (searchResult) in
                self.searchGennieObject.removeAll()
                if searchResult.count != 0{
                    let section = SearchObject()
                    section.type = "section"
                    self.searchGennieObject.append(section)
                    for value in searchResult{
                        value.type = "origin"
                        self.searchGennieObject.append(value)
                    }
                }
                print(self.searchGennieObject.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            APIService.shardInstance.fetchSearchVideo(keyword: searchBar.text!,language: defaultLanguage) { (searchResult) in
                self.searchVideoObject.removeAll()
                if searchResult.count != 0{
                    let section = SearchObject()
                    section.type = "section"
                    self.searchVideoObject.append(section)
                    for value in searchResult{
                        value.type = "video"
                        self.searchVideoObject.append(value)
                    }
                }
                print(self.searchVideoObject.count)
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue:.main){
                self.cellListView.reloadData()
            }
        }
    }
    
    func setupView(){
        view.backgroundColor = ThemeColor().themeColor()
        view.addSubview(searchBar)
        view.addSubview(cellListView)
        view.addSubview(searchCount)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":searchCount]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-0-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchBar,"v1":searchCount]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchCount,"v1":cellListView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-5-[v1]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":searchCount,"v1":cellListView]))
    }
    
    var searchCount:paddingLabel = {
        var label = paddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.backgroundColor = ThemeColor().bglColor()
        label.insetEdge = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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
    
    lazy var cellListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 5
        cv.backgroundColor = ThemeColor().themeColor()
        cv.register(NewsCell.self, forCellWithReuseIdentifier: "newsCell")
        cv.register(GenuineCell.self,forCellWithReuseIdentifier:"genuineCell")
        cv.register(VideoCell.self,forCellWithReuseIdentifier:"videoCell")
        cv.register(SectionCell.self, forCellWithReuseIdentifier: "sectionCell")
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
}

class SectionCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        addSubview(sectionLabel)
        NSLayoutConstraint(item: sectionLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sectionLabel]))
    }
    
    var sectionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
