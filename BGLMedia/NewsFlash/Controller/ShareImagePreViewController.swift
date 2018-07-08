//
//  ShareImagePreViewController.swift
//  BGLMedia
//
//  Created by Victor Ma on 6/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class ShareImagePreViewController: UIViewController {
    
    var sharedImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        button.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        button.addTarget(self, action: #selector(cancelPage), for: .touchUpInside)
        return button
    }()
    
 
    
    @objc func cancelPage(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareImage(sender: UIButton){
        let activityVC = UIActivityViewController(activityItems: [sharedImageView.image], applicationActivities:nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    

    

    
    func setup(){
        view.addSubview(sharedImageView)
        view.addSubview(cancelButton)
        view.addSubview(shareButton)
        view.backgroundColor = .white
        
        sharedImageView.translatesAutoresizingMaskIntoConstraints = false
        sharedImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        sharedImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        sharedImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        sharedImageView.heightAnchor.constraint(equalToConstant: sharedImageView.bounds.size.height).isActive = true
        
        sharedImageView.frame = CGRect(x: 0, y: 0, width: sharedImageView.bounds.width , height: sharedImageView.bounds.height)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 5).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant:10).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant:-10).isActive = true
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor,constant: -15).isActive = true
        shareButton.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10).isActive = true
        shareButton.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(image: UIImage){
        super.init(nibName: nil, bundle: nil)
        sharedImageView.image = image
        sharedImageView = UIImageView(image: image)
        print("done")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

}
