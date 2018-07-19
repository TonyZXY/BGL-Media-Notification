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

    
    var sendDeviceTokenStatus:Bool{
        get{
             return UserDefaults.standard.bool(forKey: "SendDeviceToken")
        }
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
//        NSLayoutConstraint(item: logoImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 80)
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: 80).isActive = true
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
                let (message, success) = Extension.method.checkUsernameAndPassword(username: un, password: pw)
                if success{
                    let parameter = ["email":self.emailTextField.text!.lowercased(),"password":self.passwordTextField.text!]
                    URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","login"], httpMethod: "POST", parameters: parameter, completion: { (response, success) in
                        if success {
                            let token = response["token"].string ?? ""
                            UserDefaults.standard.set(token, forKey: "CertificateToken")
                            UserDefaults.standard.set(un.lowercased(), forKey: "UserEmail")
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            
        
                            
                            if !self.sendDeviceTokenStatus{
                                let deviceTokenString = UserDefaults.standard.string(forKey: "UserToken")!
                                let sendDeviceTokenParameter = ["email":self.emailTextField.text!.lowercased(),"token":token,"deviceToken":deviceTokenString]
                                URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","addIOSDevice"], httpMethod: "POST", parameters: sendDeviceTokenParameter, completion: { (response, success) in
                                    if success{
                                        UserDefaults.standard.set(true, forKey: "SendDeviceToken")
                                    }
                                })
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logIn"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                        } else{
                            print(response)
                            self.notificationLabel.text = "Error code \(response["code"])"
                            self.notificationLabel.isHidden = false
                        }
                    })
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

