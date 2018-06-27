//
//  NewsDetailWebViewController.swift
//  news app for blockchain
//
//  Created by Xuyang Zheng on 18/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailWebViewController: UIViewController, WKNavigationDelegate {

    // set up content of the view
    var news: (title: String, url: String)? {
        didSet {
            if news != nil {
                let urlRequest: URLRequest = URLRequest(url: URL(string: news!.url)!)
                titleLabel.text = news?.title
                webView.load(urlRequest)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = titleLabel
        setupViews()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        tabBarController?.tabBar.isHidden = true
    }

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Blockchain Global"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }


    func setupViews() {
        view.addSubview(webView)
        view.backgroundColor = UIColor.white
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    @objc func handleShare() {
        let activityController = UIActivityViewController(activityItems: [news?.title as Any,news?.url as Any], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

    let webView: WKWebView = {
        let view = WKWebView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


}
