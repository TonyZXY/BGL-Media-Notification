//
//  APIService.swift
//  news app for blockchain
//
//  Created by Xuyang Zheng on 9/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import Alamofire
import Realm
import SwiftyJSON
import Alamofire
import RealmSwift

class APIService: NSObject {
    static let shardInstance = APIService()

    let realm = try! Realm()

    //Connection Strings
    let urlString = "http://10.10.6.111:3000/api/"
    let localNews = "getNewsLocaleOnly"
    let contentNews = "getNewsContentOnly"
    let contentGenuine = "getgenuine"
    let video = "videos"
    let newsLocaleQuery = "localeTag"
    let newsContentQuery = "contentTag"
    let genuineQuery = "genuineTag"
    let languageQuery = "languageTag"
    let english = "EN"
    let chinese = "CN"
    let searchNews = "searchnews"
    let searchGenuine = "searchgenuine"
    let searchVideo = "searchvideo"
    
    // fetch Offline News data (from database)
    func fetchNewsOffline(contentType: String, completion: @escaping (Results<News>) -> ()) {
        switch contentType {
        case "国内", "国际":
            DispatchQueue.main.async {
                let result = try! Realm().objects(News.self).sorted(byKeyPath: "_id", ascending: false).filter("\(self.newsLocaleQuery) = %@", contentType)
                completion(result)
            }
        default:
            DispatchQueue.main.async {
                let result = try! Realm().objects(News.self).sorted(byKeyPath: "_id", ascending: false).filter("\(self.newsContentQuery) = %@", contentType)
                completion(result)
            }
        }
    }

    // fetch Offline Genuine data (from database)
    func fetchGenuineOffline(contentType: String, completion: @escaping (Results<Genuine>) -> ()) {
        DispatchQueue.main.async {
            let result = try! Realm().objects(Genuine.self).sorted(byKeyPath: "_id", ascending: false).filter("\(self.genuineQuery) = %@", contentType)
            completion(result)
        }
    }

    // fetch Offine Video data (from database)
    func fetchVideoOffline(completion: @escaping (Results<Video>) -> ()) {
        DispatchQueue.main.async {
            let result = try! Realm().objects(Video.self).sorted(byKeyPath: "_id", ascending: false)
            completion(result)
        }
    }

    // Fetch News data from API
    func fetchNewsData(contentType: String, currentNumber: Int, completion: @escaping (Results<News>) -> ()) {
        switch contentType { // switch locale tag
        case "国内", "国际":
            let url = URL(string: urlString + localNews)
            
            let para = [newsLocaleQuery: contentType, "skip": currentNumber, languageQuery: [english,chinese]] as [String: Any]
            
//            let para = [newsLocaleQuery: contentType, "skip": currentNumber] as [String: Any]
            Alamofire.request(url!, parameters: para).responseJSON { (responsein) in
                switch responsein.result {
                case .success(let value):
                    let json = JSON(value)
                    self.decodeNewsJSON(json: json) // sent to RealmSwift to store into database
                    DispatchQueue.main.async { // get data from database
                        let result = try! Realm().objects(News.self).sorted(byKeyPath: "_id", ascending: false).filter("\(self.newsLocaleQuery) = %@", contentType)
                        completion(result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        default: // if content tag
            let url = URL(string: urlString + contentNews)
             let para = [newsContentQuery: contentNews, "skip": currentNumber, languageQuery: [english,chinese]] as [String: Any]
//            let para = [newsContentQuery: contentNews, "skip": currentNumber] as [String: Any]
            Alamofire.request(url!, parameters: para).responseJSON { (responsion) in
                switch responsion.result {
                case .success(let value):
                    let json = JSON(value)
                    self.decodeNewsJSON(json: json) // send to database
                    DispatchQueue.main.async { // get data form database
                        let result = try! Realm().objects(News.self).sorted(byKeyPath: "_id", ascending: false).filter("\(self.newsContentQuery) = %@", contentType)
                        completion(result)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    // get Genuine data from API
    func fetchGenuineData(contentType: String, currentNumber: Int, completion: @escaping (Results<Genuine>) -> ()) {
        let url = URL(string: urlString + contentGenuine)
         let para = [genuineQuery: contentType, "skip": currentNumber, languageQuery: [english,chinese]] as [String: Any]
//        let para = [genuineQuery: contentType, "skip": currentNumber] as [String: Any]
        Alamofire.request(url!, parameters: para).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.decodeGenuineJSON(json: json) // store data into database
                DispatchQueue.main.async { // get data from database
                    let result = try! Realm().objects(Genuine.self).sorted(byKeyPath: "_id", ascending: false).filter("\(self.genuineQuery) = %@", contentType)
                    completion(result)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // get Video data from API
    func fetchVideoData(currentNumber: Int, completion: @escaping (Results<Video>) -> ()) {
        let url = URL(string: urlString + video)
           let para = ["skip": currentNumber, languageQuery: [english,chinese]] as [String: Any]
//        let para = ["skip": currentNumber] as [String: Any]
        Alamofire.request(url!, parameters: para).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.decodeVideoJSON(json: json) // store data into database
                DispatchQueue.main.async { // get data from database
                    let result = try! Realm().objects(Video.self).sorted(byKeyPath: "_id", ascending: false)
                    completion(result)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // decode JSON and store into database
    func decodeNewsJSON(json: JSON) {
        realm.beginWrite()
        if let collection = json.array {
            for item in collection {
                let id = item["_id"].string!
                let title = item["title"].string!
                let newsDescription = item["newsDescription"].string!
                let imageURL = item["imageURL"].string!
                let url = item["url"].string!
                let publishedTime = item["publishedTime"].string!.timeFormatter()
                let author = item["author"].string!
                let localeTag = item["localeTag"].string!
                let contentTag = item["contentTag"].string!

                if realm.object(ofType: News.self, forPrimaryKey: id) == nil {
                    realm.create(News.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, contentTag])
                } else {
                    realm.create(News.self, value: [id, title, newsDescription, imageURL, url, publishedTime, author, localeTag, contentTag], update: true)
                }
            }
        }
        try! realm.commitWrite()
    }

    func decodeGenuineJSON(json: JSON) {
        realm.beginWrite()
        if let collection = json.array {
            for item in collection {
                let id = item["_id"].string!
                let title = item["title"].string!
                let genuineDescription = item["genuineDescription"].string!
                let imageURL = item["imageURL"].string!
                let url = item["url"].string!
                let publishedTime = item["publishedTime"].string!.timeFormatter()
                let author = item["author"].string!
                let genuineTag = item["genuineTag"].string!

                if realm.object(ofType: Genuine.self, forPrimaryKey: id) == nil {
                    realm.create(Genuine.self, value: [id, title, genuineDescription, imageURL, url, publishedTime, author, genuineTag])
                } else {
                    realm.create(Genuine.self, value: [id, title, genuineDescription, imageURL, url, publishedTime, author, genuineTag], update: true)
                }
            }
        }
        try! realm.commitWrite()
    }

    func decodeVideoJSON(json: JSON) {
        realm.beginWrite()
        if let collection = json.array {
            for item in collection {
                let id = item["_id"].string!
                let title = item["title"].string!
                let videoDescription = item["videoDescription"].string!
                let imageURL = item["imageURL"].string!
                let url = item["url"].string!
                let publishedTime = item["publishedTime"].string!.timeFormatter()
                let author = item["author"].string!
                let localeTag = item["localeTag"].string!
                let typeTag = item["typeTag"].string!

                if realm.object(ofType: Video.self, forPrimaryKey: id) == nil {
                    realm.create(Video.self, value: [id, title, videoDescription, imageURL, url, publishedTime, author, localeTag, typeTag])
                } else {
                    realm.create(Video.self, value: [id, title, videoDescription, imageURL, url, publishedTime, author, localeTag, typeTag], update: true)
                }
            }
        }
        try! realm.commitWrite()
    }

    
    func fetchSearchNews(keyword:String, completion: @escaping ([SearchObject]) -> ()) {
        let url = URL(string: urlString + searchNews)
        let para = ["patten": keyword, languageQuery: [english,chinese]] as [String: Any]
        Alamofire.request(url!, parameters: para).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var searchArrayObject = [SearchObject]()
                if let collection = json.array {
                    for item in collection {
                        let searchObject = SearchObject()
                        searchObject.type = "news"
                        searchObject.author = item["author"].string!
                        searchObject.title = item["title"].string!
                        searchObject.imageURL = item["imageURL"].string!
                        searchObject.publishedTime = item["publishedTime"].string!
                        searchObject.url = item["url"].string!
                        searchObject.description = item["newsDescription"].string!
                        searchArrayObject.append(searchObject)
                        print(searchArrayObject[0].imageURL!+"fdsafsf")
                    }
                }
                DispatchQueue.main.async {
                    completion(searchArrayObject)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSearchGenuine(keyword:String, completion: @escaping ([SearchObject]) -> ()) {
        let url = URL(string: urlString + searchGenuine)
        let para = ["patten": keyword, languageQuery: [english,chinese]] as [String: Any]
        Alamofire.request(url!, parameters: para).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var searchArrayObject = [SearchObject]()
                if let collection = json.array {
                    for item in collection {
                        let searchObject = SearchObject()
                        searchObject.type = "genuine"
                        searchObject.author = item["author"].string!
                        searchObject.title = item["title"].string!
                        searchObject.imageURL = item["imageURL"].string!
                        searchObject.publishedTime = item["publishedTime"].string!
                        searchObject.url = item["url"].string!
                        searchObject.description = item["genuineDescription"].string!
                        searchArrayObject.append(searchObject)
                    }
                }
                DispatchQueue.main.async {
                    completion(searchArrayObject)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchSearchVideo(keyword:String, completion: @escaping ([SearchObject]) -> ()) {
        let url = URL(string: urlString + searchVideo)
        let para = ["patten": keyword, languageQuery: [english,chinese]] as [String: Any]
        Alamofire.request(url!, parameters: para).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var searchArrayObject = [SearchObject]()
                if let collection = json.array {
                    for item in collection {
                        let searchObject = SearchObject()
                        searchObject.type = "video"
                        searchObject.author = item["author"].string!
                        searchObject.title = item["title"].string!
                        searchObject.imageURL = item["imageURL"].string!
                        searchObject.publishedTime = item["publishedTime"].string!
                        searchObject.url = item["url"].string!
                        searchObject.description = item["videoDescription"].string!
                        searchArrayObject.append(searchObject)
                    }
                }
                DispatchQueue.main.async {
                    completion(searchArrayObject)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
