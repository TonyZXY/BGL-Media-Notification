//
//  WebDetailViewController.swift
//  news app for blockchain
//
//  Created by Rock on 15/5/18.
//  Copyright © 2018 Sheng Li. All rights reserved.
//

import UIKit
import WebKit

class WebDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    let titles = ["微博","微信","Twitter","Facebook","Youtube"]
    
    var str:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let label010 = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        label010.textAlignment = .center
        label010.textColor = UIColor.white
        
        switch str {
        case "Weibo":
            let url = URL(string: "https://m.weibo.cn/u/5410971155")
            let request = URLRequest(url: url!)
            webView.load(request)
            label010.text = titles[0]
            self.navigationItem.titleView = label010
        case "Wechat":
            let url = URL(string: "https://mp.weixin.qq.com/s?__biz=MzA5Mjg3OTcyOQ==&mid=2659941256&idx=3&sn=79046f324e1be54d0344731320e240f5&chksm=8b19b596bc6e3c80ef6116586c5797d03e9cf9e13b674d516eddadc52ca9c9bf3f0aeaba20c6&scene=21#wechat_redirect")
            let request = URLRequest(url: url!)
            webView.load(request)
            label010.text = titles[1]
            self.navigationItem.titleView = label010
        case "Twitter":
            let url = URL(string: "https://twitter.com/blockchaingl")
            let request = URLRequest(url: url!)
            webView.load(request)
            label010.text = titles[2]
            self.navigationItem.titleView = label010
        case "Facebook":
            let url = URL(string: "https://www.facebook.com/BlockchainGL/")
            let request = URLRequest(url: url!)
            webView.load(request)
            label010.text = titles[3]
            self.navigationItem.titleView = label010
        case "Youtube":
            let url = URL(string: "https://www.youtube.com/channel/UCzKG8vKUKlTn88raV2W07Wg?view_as=subscriber")
            let request = URLRequest(url: url!)
            webView.load(request)
            label010.text = titles[4]
            self.navigationItem.titleView = label010
        default:
            let url = URL(string: "https://www.blockchainglobal.com")
            let request = URLRequest(url: url!)
            webView.load(request)
            
        }
        
        var prefersStatusBarHidden: Bool {
            return true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
