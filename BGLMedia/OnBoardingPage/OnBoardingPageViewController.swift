//
//  OnBoardingPageViewController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class OnBoardingPageViewController: UIViewController {
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(logOutUser), name: NSNotification.Name(rawValue: "logOut"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logInUser), name: NSNotification.Name(rawValue: "logIn"), object: nil)

    }
    
    @objc func logInUser() {
        registerButton.removeFromSuperview()
        loginButton.removeFromSuperview()
        view.addSubview(signOutButton)
    }
    
    @objc func logOutUser() {
//        print("received logout request")
        signOutButton.removeFromSuperview()
        view.addSubview(registerButton)
        view.addSubview(loginButton)
    }
    
    var button = UIButton()
    var registerButton = UIButton()
    var loginButton = UIButton()
    var signOutButton = UIButton()
    var exitButton = UIButton()
    
    func createLabel(text: String){
        let offset = 5
        label.frame = CGRect(x: CGFloat(offset), y: UIScreen.main.bounds.height*3/5, width: UIScreen.main.bounds.width-CGFloat(offset*2), height: UIScreen.main.bounds.height/2)
        label.text = text
        label.textColor = .white
        label.clipsToBounds = true
        label.numberOfLines = 0
        self.view.addSubview(label)
    }
    
    let logoImageView: UIImageView = {
        
        let image = UIImage(named: "bcg_logo")
        
        let width = (image?.size.width)! * 0.5
        let height = (image?.size.height)! * 0.5
        let bounds = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(bounds, false, 0.0)
        image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: bounds))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return UIImageView(image: newImage)
        
    }()
    
    func createImage(from pid: Int){
        var image: UIImage!
//        if pid != 1 {
            image = UIImage(named: "\(pid).png")
//
//        } else {
//            image = UIImage(named: "bcg_logo.png")
//        }
        let width = 335
        let height = 410
        let bounds = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(bounds, false, 0.0)
        image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: bounds))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: newImage)
        let distanceToTop = 80
        let width_ = UIScreen.main.bounds.width
        let imageFrame = CGRect(origin: CGPoint(x: (width_-newImage.size.width)/2, y: CGFloat(distanceToTop)), size: newImage.size)
        imageView.frame = imageFrame
        view.addSubview(imageView)
    }
    
    func createButton(from pid:Int){
        if pid != 6 {//create skip button
            button.setTitle("SKIP THESE", for: .normal)
            button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 10)
            button.titleLabel?.textColor = .white
            button.backgroundColor = .lightGray
            button.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
            let buttonFrame = CGRect(x: (UIScreen.main.bounds.width-CGFloat(100))/2, y: UIScreen.main.bounds.height*3/5 + CGFloat(50), width: CGFloat(100), height: CGFloat(50))
            button.frame = buttonFrame
            view.addSubview(button)
        } else{
            registerButton.setTitle("Register", for: .normal)
            registerButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
            registerButton.titleLabel?.textColor = .white
            registerButton.backgroundColor = .lightGray
            registerButton.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
            let registerButtonFrame = CGRect(x: CGFloat(50), y: UIScreen.main.bounds.height*3/5 + CGFloat(50), width: CGFloat(100), height: CGFloat(50))
            registerButton.frame = registerButtonFrame
            
            loginButton.setTitle("Login", for: .normal)
            loginButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
            loginButton.titleLabel?.textColor = .white
            loginButton.backgroundColor = .lightGray
            loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
            let loginButtonFrame = CGRect(x: UIScreen.main.bounds.width - CGFloat(150), y: UIScreen.main.bounds.height*3/5 + CGFloat(50), width: CGFloat(100), height: CGFloat(50))
            loginButton.frame = loginButtonFrame
            
            signOutButton.setTitle("Sign Out", for: .normal)
            signOutButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
            signOutButton.titleLabel?.textColor = .white
            signOutButton.backgroundColor = .lightGray
            signOutButton.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
            let signOutButtonFrame = CGRect(x: UIScreen.main.bounds.width - CGFloat(150), y: UIScreen.main.bounds.height*3/5 + CGFloat(50), width: CGFloat(100), height: CGFloat(50))
            signOutButton.frame = signOutButtonFrame
            
            exitButton.setTitle("Got it. ", for: .normal)
            exitButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
            exitButton.titleLabel?.textColor = .blue
            
            exitButton.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
            let buttonFrame = CGRect(x: UIScreen.main.bounds.width/2 - CGFloat(50), y: UIScreen.main.bounds.height*3/5 + CGFloat(110), width: 100, height: 50)
            exitButton.frame = buttonFrame
            view.addSubview(exitButton)
            
            if UserDefaults.standard.bool(forKey: "isLoggedIn"){
                view.addSubview(signOutButton)
            }else{
                view.addSubview(registerButton)
                view.addSubview(loginButton)
            }
            
        }
        
    }
    
    
    @objc func registerButtonClicked(sender: UIButton){
        let register = RegisterationPageViewController()
        self.present(register,animated: true, completion: nil)
    }
    
    @objc func loginButtonClicked(sender: UIButton){
        let login = LoginPageViewController()
        self.present(login,animated: true, completion: nil)
    }
    
    
    
    @objc func signOutButtonClicked(sender: UIButton){
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
//        print("User is now signed out")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logOut"), object: nil)
        
    
    }
    
    @objc func skipButtonClicked(sender: UIButton){
        let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        
        
        vc.modalTransitionStyle = .flipHorizontal
//        vc.modalTransitionStyle = .crossDissolve // another form of animations

        
        self.present(vc, animated: true, completion: nil)
        
    }
    

        
    init(backgroundColor: UIColor, text: String, pid: Int){
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = backgroundColor
        createLabel(text: text)
        createImage(from: pid)
        createButton(from: pid)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
