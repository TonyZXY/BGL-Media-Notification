//
//  OnBoardingPageViewController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 21/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit

class OnBoardingPageViewController: UIViewController {
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
//        NotificationCenter.default.addObserver(self, selector: #selector(logOutUser), name: NSNotification.Name(rawValue: "logOut"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(logInUser), name: NSNotification.Name(rawValue: "logIn"), object: nil)

    }
    
//    @objc func logInUser() {
//        setupAdminButtons()
//    }
//
//    @objc func logOutUser() {
////        print("received logout request")
//        setupAdminButtons()
//
////        signOutButton.removeFromSuperview()
////        view.addSubview(registerButton)
////        view.addSubview(loginButton)
//    }
    
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        let offset = 5
        label.textColor = .white
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.font = UIFont.semiBoldFont(15)
        label.textAlignment = .center
        return label
    }()

    let instructionImageView:UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let skipButton:UIButton = {
        let button = UIButton()
        button.setTitle(textValue(name: "skip"), for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(15)
        button.titleLabel?.textColor = ThemeColor().whiteColor()
        button.backgroundColor = ThemeColor().blueColor()
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(skipButtonClicked), for: .touchUpInside)
        return button
    }()
    
//    let registerButton:UIButton = {
//        let button = UIButton()
//        button.setTitle("Register", for: .normal)
//        button.titleLabel?.font = UIFont.semiBoldFont(15)
//        button.titleLabel?.textColor = ThemeColor().whiteColor()
//        button.backgroundColor = ThemeColor().blueColor()
//        button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
//        return button
//    }()
//
//    let loginButton:UIButton = {
//        let button = UIButton()
//        button.setTitle("Log In", for: .normal)
//        button.titleLabel?.font = UIFont.semiBoldFont(15)
//        button.titleLabel?.textColor = ThemeColor().whiteColor()
//        button.backgroundColor = ThemeColor().blueColor()
//        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
//        return button
//    }()
//
//    let signOutButton:UIButton = {
//        let button = UIButton()
//        button.setTitle("Sign Out", for: .normal)
//        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 15)
//        button.titleLabel?.textColor = .white
//        button.backgroundColor = ThemeColor().blueColor()
//        button.addTarget(self, action: #selector(signOutButtonClicked), for: .touchUpInside)
//        return button
//    }()
    let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor().themeColor()
        return view
    }()
    
    
//    @objc func registerButtonClicked(sender: UIButton){
//        let register = RegisterController()
//        self.present(register,animated: true, completion: nil)
//    }
//
//    @objc func loginButtonClicked(sender: UIButton){
//        let login = LoginController()
//        self.present(login,animated: true, completion: nil)
//    }
    
    
    
//    @objc func signOutButtonClicked(sender: UIButton){
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
//
////        print("User is now signed out")
//
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logOut"), object: nil)
//
//
//    }
    
    @objc func skipButtonClicked(sender: UIButton){
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        
        vc.navigationController?.awakeFromNib()
        vc.modalTransitionStyle = .flipHorizontal
//        vc.modalTransitionStyle = .crossDissolve // another form of animations
        self.present(vc, animated: true){
//            self.removeFromParentViewController()
        }
    }
    

        
    init(backgroundColor: UIColor, text: String, pid: Int){
        super.init(nibName: nil, bundle: nil)
//        self.view.backgroundColor = backgroundColor
        descriptionLabel.text = text
        setupImage(from:pid)
//        if pid == 6 {
//            setupAdminButtons()
//        }
        setupDescriptionLabel()
        setupSkipButton()
    }
    
    
    
    
    func setupImage(from pid:Int){
        let factor = view.frame.width/414
        
        let image = UIImage(named: "\(pid).png")
        let imageWidth = image?.size.width
        let imageHeight = image?.size.height
        let drawWidth = UIScreen.main.bounds.size.width
        let drawHeight = drawWidth * imageHeight! / imageWidth!
        let bounds = CGSize(width: drawWidth, height: drawHeight)
        UIGraphicsBeginImageContextWithOptions(bounds, false, 0.0)
        image?.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: bounds))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        view.addSubview(instructionImageView)
        instructionImageView.image = newImage
        instructionImageView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            instructionImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:30*factor).isActive = true
        } else {
            instructionImageView.topAnchor.constraint(equalTo: view.topAnchor,constant:30*factor).isActive = true
        }
//        instructionImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        instructionImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        instructionImageView.heightAnchor.constraint(equalToConstant: (view.frame.width-20)*1.2).isActive = true
        
        
        instructionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        instructionImageView.widthAnchor.constraint(equalToConstant:imageWidth! * factor).isActive = true
        instructionImageView.heightAnchor.constraint(equalToConstant:imageHeight! * factor).isActive = true
        
        
        
    }
    
//    func setupAdminButtons(){
//
//        if UserDefaults.standard.bool(forKey: "isLoggedIn"){
//            if registerButton.isDescendant(of: view){
//                registerButton.removeFromSuperview()
//                loginButton.removeFromSuperview()
//            }
//            view.addSubview(signOutButton)
//            signOutButton.translatesAutoresizingMaskIntoConstraints = false
//            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//            signOutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//            signOutButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//            signOutButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -20).isActive = true
//        } else {
//            if signOutButton.isDescendant(of: view){
//                signOutButton.removeFromSuperview()
//            }
//            view.addSubview(registerButton)
//            view.addSubview(loginButton)
//
//
//            registerButton.translatesAutoresizingMaskIntoConstraints = false
//            registerButton.topAnchor.constraint(equalTo: instructionImageView.bottomAnchor, constant: 10).isActive = true
//            registerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
//            registerButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//            registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//            loginButton.translatesAutoresizingMaskIntoConstraints = false
//            loginButton.topAnchor.constraint(equalTo: instructionImageView.bottomAnchor, constant: 10).isActive = true
//            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
//            loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//            loginButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//
//        }
//
//    }
    
    func setupSkipButton(){
        let factor = view.frame.width/414
        let factor2 = view.frame.height/736

        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 40 * factor).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 150 * factor).isActive = true
        if #available(iOS 11.0, *) {
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10 * factor2).isActive = true
        } else {
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5 * factor2).isActive = true
        }

    }

    func setupDescriptionLabel() {
        let factor = view.frame.width/414
        let factor2 = view.frame.height/736

        view.addSubview(emptyView)

        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 5)

        
        descriptionLabel.topAnchor.constraint(equalTo: instructionImageView.bottomAnchor, constant: 17 * factor2).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 28 * factor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28 * factor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 65 * factor2).isActive = true
        
//        emptyView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        emptyView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        emptyView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
//        emptyView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 100.isActive = true
        
    }
    
//    var instructionImage:UIImageView = {
//       var imageView = UIImageView()
//
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
