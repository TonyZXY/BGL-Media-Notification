//
//  LoginViewController.swift
//  Registration
//
//  Created by ZHANG ZEYAO on 20/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class LoginController: UIViewController {
    
    var getDeviceToken:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "getDeviceToken")
        }
    }
    
    let logoImage: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "bcg_logo"))
        return logo
    }()
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*email@email.com", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(checkEmail), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*Password", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.addTarget(self, action: #selector(checkPassword), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN",for: .disabled)
        button.setTitle("LOGIN",for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP",for: .disabled)
        button.setTitle("SIGN UP",for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        button.backgroundColor = ThemeColor().redColor()
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("SKIP >",for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.backgroundColor = ThemeColor().themeColor()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        setUp()
        // Do any additional setup after loading the view.
    }
    
    @objc func checkEmail(_ textField: UITextField){
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        let trimmedEmail = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if trimmedEmail == "" || !emailPredicate.evaluate(with: textField.text){
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            emailLabel.text = "Invalid Email"
            emailLabel.textColor = ThemeColor().redColor()
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            emailLabel.text = "Email"
            emailLabel.textColor = ThemeColor().whiteColor()
        }
        
    }
    
    @objc func checkPassword(_ textField: UITextField) {
        if (textField.text?.count)! < 8{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            passwordLabel.text = "Invalid Password"
            passwordLabel.textColor = ThemeColor().redColor()
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            passwordLabel.text = "Password"
            passwordLabel.textColor = ThemeColor().whiteColor()
        }
    }
    
    @objc func checkValuesAndChangeButton(sender: UITextField){
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if emailPredicate.evaluate(with: emailTextField.text) &&
            (passwordTextField.text?.count)! >= 8 {
            //            loginButton.backgroundColor = ThemeColor().themeWidgetColor()
            loginButton.backgroundColor = ThemeColor().themeWidgetColor()
            loginButton.isEnabled = true
        }else{
            loginButton.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
            loginButton.isEnabled = false
        }
    }
    
    @objc func login(sender: UIButton){
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Signing In"
        hud.backgroundColor = ThemeColor().progressColor()
        hud.show(in: self.view)
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        //            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        //            hud.textLabel.text = "Success"
        //            hud.detailTextLabel.text = "Email or Password invalid"
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        //            let registerViewController = ViewController()
        //            self.present(registerViewController,animated: true, completion: nil)
        //            }
        //        }
        
        let un = self.emailTextField.text!
        let pw = self.passwordTextField.text!
        let parameter = ["email":un.lowercased(),"password":pw]
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","login"], httpMethod: "POST", parameters: parameter, completion: { (response, success) in
            if success {
                let loginsuccess = response["success"].bool ?? true // Question
                if  loginsuccess {
                    let token = response["token"].string ?? ""
                    UserDefaults.standard.set(token, forKey: "CertificateToken")
                    UserDefaults.standard.set(un.lowercased(), forKey: "UserEmail")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    
                    if !self.getDeviceToken{
                        let deviceTokenString = UserDefaults.standard.string(forKey: "UserToken")!
                        let sendDeviceTokenParameter = ["email":self.emailTextField.text!.lowercased(),"token":token,"deviceToken":deviceTokenString]
                        URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","addIOSDevice"], httpMethod: "POST", parameters: sendDeviceTokenParameter, completion: { (response, success) in
                            if success{
                                UserDefaults.standard.set(true, forKey: "SendDeviceToken")
                            }
                        })
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logIn"), object: nil)
                    
                    
                    
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = "Success"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        hud.dismiss()
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    let loginfailure = response["message"].string ?? "Login Error"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = loginfailure
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        hud.dismiss()
                        self.passwordTextField.layer.borderWidth = 1.8
                        self.passwordTextField.layer.borderColor = ThemeColor().redColor().cgColor
                        
                        self.passwordLabel.text = "Password"
                        self.passwordLabel.textColor = ThemeColor().redColor()
                        
                        self.emailTextField.layer.borderWidth = 1.8
                        self.emailTextField.layer.borderColor = ThemeColor().redColor().cgColor
                        
                        self.emailLabel.text = "Invalid Email"
                        self.emailLabel.textColor = ThemeColor().redColor()
                        
                    }
                }
                
            } else {
                let manager = NetworkReachabilityManager()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                if !(manager?.isReachable)! {
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = "No Network" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        hud.dismiss()
                    }
                    
                } else {
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = "Time Out" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                        hud.dismiss()
                    }
                    
                }
            }
            
        })
        
        
        
        
    }
    
    @objc func register(sender: UIButton){
        let registerViewController = RegisterController()
        self.present(registerViewController,animated: true, completion: nil)
        
    }
    @objc func closePage(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUp(){
        
        view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant:150).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant:300).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant:300).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant:200).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant:200).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo:signUpButton.bottomAnchor , constant: 100).isActive = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
    }
    
}
