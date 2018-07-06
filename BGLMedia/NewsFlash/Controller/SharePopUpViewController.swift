//
//  SharePopUpViewController.swift
//  BGLMedia
//
//  Created by Victor Ma on 6/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//  Customized share pop up view. 

import UIKit

class SharePopUpViewController: UIViewController {

    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateImageView(image: UIImage){
        previewImageView.image = image
    }
    
    init(text: String?, preview: UIImage){
        super.init(nibName: nil, bundle: nil)
        updateImageView(image: preview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
