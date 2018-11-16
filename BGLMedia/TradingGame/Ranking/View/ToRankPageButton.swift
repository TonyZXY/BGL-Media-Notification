//
//  ToRankPageButton.swift
//  BGLMedia
//
//  Created by Jia YI Bai on 3/10/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import Foundation
import UIKit

class ToRankPageButton : UIButton{
    
    let defaultWidth:CGFloat = 50
    let defaultHeight:CGFloat = 50
    
    var parentViewController : UIViewController?
    let rankController = RankViewControllerV2()
    
    func initSetup (width: CGFloat,height:CGFloat,parentController:UIViewController){
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.imageView?.contentMode = .scaleAspectFit
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
        self.setImage(UIImage(named: "trophy")?.reSizeImage(reSize: CGSize(width: width, height: height)), for: .normal)
        self.clipsToBounds = true
        
        self.parentViewController = parentController
        self.addTarget(self, action: #selector(goToRankPage), for: .touchUpInside)
    }
    
    @objc func goToRankPage(){
        //        self.parentViewController?.present(rankController, animated: true, completion: nil)
        rankController.hidesBottomBarWhenPushed = true
        self.parentViewController?.navigationController?.pushViewController(rankController, animated: true)
        
    }
    
    convenience init(width:CGFloat?,height:CGFloat?,parentController:UIViewController) {
        self.init(type: .custom)
        initSetup(width: width ?? defaultWidth, height: height ?? defaultHeight,parentController: parentController)
    }
}
