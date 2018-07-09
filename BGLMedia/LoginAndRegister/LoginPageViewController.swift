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
    
    let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Click here to register"
        label.textColor = .white
        label.font = UIFont(name: "Helvetica-Bold", size: 15)
        return label
    }()
    
    @objc func tapRigsterLabel(sender:UITapGestureRecognizer) {
        print("tap working")
        
        let register = RegisterationPageViewController()
        
        self.present(register,animated: true, completion: nil)
    }
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRigsterLabel))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(tap)
        
        
        view.addSubview(logoImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(cancelButton)
        view.addSubview(notificationLabel)
        view.addSubview(registerLabel)
        
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
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        registerLabel.translatesAutoresizingMaskIntoConstraints = false
        registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5).isActive = true
        registerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        registerLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        registerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closePage(sender: UIButton){

        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func login(sender: UIButton){
        NetworkManager.isReachable { networkManagerInstance in
            print("Network is available")
            if (self.emailTextField.text?.isEmpty)! || (self.passwordTextField.text?.isEmpty)!{
                self.notificationLabel.text = "Please provide username and password."
                self.notificationLabel.isHidden = false
            }else{
                let un = self.emailTextField.text!
                let pw = self.passwordTextField.text!
                let (message, success) = self.checkUsernameAndPassword(username: un, password: pw)
                if success{
                    self.loginRequestToServer(username: un, password: pw){(res,pass) in
                        if pass {
                            let token = res["token"].string!
                            UserDefaults.standard.set(token, forKey: "CertificateToken")
                            UserDefaults.standard.set(un.lowercased(), forKey: "UserEmail")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.set(false, forKey: "SendDeviceToken")
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logIn"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                        } else{
                            self.notificationLabel.text = "Error code \(res["code"])"
                            self.notificationLabel.isHidden = false
                        }
                    }
                } else{
                    self.notificationLabel.text = message
                    self.notificationLabel.isHidden = false
                }
            }

        }
        
        NetworkManager.isUnreachable { networkManagerInstance in
            print("Network is Unavailable")
            self.displayAlert(title:"Error", message:"Network Unavailable", buttonText:"OK")
        }
    }
    
    func checkUsernameAndPassword(username: String, password: String) -> (String?, Bool) {
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
    }
    
    func loginRequestToServer(username: String,password: String,completion:@escaping (JSON, Bool)->Void){
        let parameters = ["email": username.lowercased(), "password":password]
        let url = URL(string: "http://10.10.6.18:3030/userLogin/login")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        urlRequest.httpBody = httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        urlRequest.setValue("gmail.com",email)
        
        Alamofire.request(urlRequest).response { (response) in
            if let data = response.data{
                var res = JSON(data)
                if res == nil {
                    completion(["code":"Server not available"],false)
                } else if res["success"].bool!{
                    completion(res,true)
                    }else {
                        completion(res,false)
                    }
            }
        }
    }

}

extension UIViewController {
    func displayAlert(title:String, message:String, buttonText:String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        // add an action (button)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: nil))
        // show the alert
        self.present(alert, animated: true, completion: nil)
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

