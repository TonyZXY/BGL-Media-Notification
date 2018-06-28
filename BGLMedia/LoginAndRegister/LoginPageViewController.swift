//
//  LoginViewController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 22/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginPageViewController: UIViewController {

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
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "test string"
        label.textColor = UIColor.red
        label.font = UIFont(name: "Helvetica-Bold", size: 15)
        label.isHidden = true
        return label
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter email"
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    //hide keyboard when touch somewhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        notificationLabel.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }

    func setUp(){
        self.view.backgroundColor = ThemeColor().themeColor()
        
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(cancelButton)
        view.addSubview(notificationLabel)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 80).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5).isActive = true
        notificationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closePage(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func login(sender: UIButton){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!{
            notificationLabel.text = "Please provide username and password."
            notificationLabel.isHidden = false
        }else{
            let un = emailTextField.text!
            let pw = passwordTextField.text!
            let (message, success) = checkUsernameAndPassword(username: un, password: pw)
            if success{
                loginRequestToServer(username: un, password: pw){(res,pass) in
                    if pass {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logIn"), object: nil)
                        self.cancelButton.setTitle("Close", for: .normal)
                        self.notificationLabel.textColor = UIColor.lightGray
                        self.notificationLabel.text = "Login successfull, press close below."
                        self.notificationLabel.isHidden = false
                    } else{
                        self.notificationLabel.text = "Login failed. Error code \(res["code"])"
                        self.notificationLabel.isHidden = false
                    }
                }
            } else{
                self.notificationLabel.text = message
                self.notificationLabel.isHidden = false
            }
        }
    }
    
    func checkUsernameAndPassword(username: String, password: String) -> (String?, Bool) {
//        print(username)
//        print(password)
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if emailPredicate.evaluate(with: username){
            let passwordFormat = "^((?!.*[\\s])(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$&*])(?=.*\\d).{8,15})$"
            let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
            if passwordPredicate.evaluate(with: password){
                return (nil,true)
            }else{
                return ("Wrong password format", false)
            }
        } else{
            return ("Wrong email format", false)
        }
        return ("should not be displaying this", false)
    }
    
    func loginRequestToServer(username: String,password: String,completion:@escaping (JSON, Bool)->Void){
        
        
        let parameters = ["username": username, "password":password]
        let url = URL(string: "http://10.10.6.218:3030/userLogin/login")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        urlRequest.setValue("gmail.com",email)
        
        Alamofire.request(urlRequest).response { (response) in
            if let data = response.data{
                let res = JSON(data)
                if res["success"].bool!{
                    completion(res,true)
                }else {
                    completion(res,false)
                }
            }
        }
    }

}



class LeftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}

