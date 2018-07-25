//
//  RegisterController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 23/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD

class RegisterController: UIViewController {
    var getDeviceToken:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "getDeviceToken")
        }
    }
    
    let titleView: UIView = {
        let view = UIView()
        return view
    }()
    let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "SIGN UP"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    let navButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back_button"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20)
        button.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 10)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
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
    
    
    let conPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let firstNameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*First Name", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.addTarget(self, action: #selector(checkFirstName), for: .allEditingEvents)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let lastNameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*Last Name", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.addTarget(self, action: #selector(checkLastName), for: .allEditingEvents)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*Email", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(checkEmail), for: .allEditingEvents)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField! = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*8-20 Characters", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.addTarget(self, action: #selector(checkPassword), for: .allEditingEvents)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let conPasswordTextField: LeftPaddedTextField! = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*Confirm Your Password", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.addTarget(self, action: #selector(checkPasswordConfirmed), for: .allEditingEvents)
        textField.addTarget(self, action: #selector(keyboardShow), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(keyboardHide), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let titleTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        let label = UITextView()
        textField.inputView = label
        textField.tintColor = .clear
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "Title", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 16)!])
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        textField.addTarget(self, action: #selector(showSelection), for: .touchDown)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN UP",for: .disabled)
        button.setTitle("SIGN UP",for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        view.backgroundColor = ThemeColor().themeColor()
        setUp()
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        
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
    
    @objc func closePage(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkPassword(_ textField: UITextField) {
        if (textField.text?.count)! < 8{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            passwordLabel.text = "Password is too short"
            passwordLabel.textColor = ThemeColor().redColor()
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            passwordLabel.text = "Password"
            passwordLabel.textColor = ThemeColor().whiteColor()
        }
    }
    
    @objc func checkPasswordConfirmed(_ textField: UITextField){
        if (textField.text?.count)! < 8 || textField.text != passwordTextField.text{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            conPasswordLabel.text = "Invalid Confirmation"
            conPasswordLabel.textColor = ThemeColor().redColor()
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            conPasswordLabel.text = "Confirm Password"
            conPasswordLabel.textColor = ThemeColor().whiteColor()
        }
    }
    
    @objc func checkFirstName(_ textField: UITextField){
        let trimmedFirstName = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if textField.isTouchInside && trimmedFirstName == ""{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            firstNameLabel.text = "First Name Needed"
            firstNameLabel.textColor = ThemeColor().redColor()
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            firstNameLabel.text = "First Name"
            firstNameLabel.textColor = ThemeColor().whiteColor()
        }
    }
    
    
    @objc func checkLastName(_ textField: UITextField){
        let trimmedLastName = lastNameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if textField.isTouchInside && trimmedLastName == ""{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            lastNameLabel.text = "Last Name Needed"
            lastNameLabel.textColor = ThemeColor().redColor()
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            lastNameLabel.text = "Last Name"
            lastNameLabel.textColor = ThemeColor().whiteColor()
        }
    }
    
    @objc func register(sender: UIButton) {
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Registing"
        hud.backgroundColor = UIColor(displayP3Red: 191, green: 191, blue: 191, alpha: 0.5)
        hud.show(in: self.view)
        
        let parameter = ["email": self.emailTextField.text!.lowercased(), "firstName": self.firstNameTextField.text!, "lastName":self.lastNameTextField.text!,"title": self.titleTextField.text!, "password": self.passwordTextField.text!]
        
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","register"], httpMethod: "POST", parameters: parameter, completion: { (response, success) in
            if success{
                let registersuccess = response["success"].bool ?? true // Question
                if registersuccess{
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(self.emailTextField.text!.lowercased(), forKey: "UserEmail")
                    let token = response["token"].string!
                    UserDefaults.standard.set(token, forKey: "CertificateToken")
                    
                    print(token)
                    print(self.emailTextField.text!.lowercased())
                    
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                        if self.presentingViewController?.presentingViewController?.presentingViewController != nil{
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        } else {
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    let registerFailure = response["message"].string ?? "Register Error"
                    let code = response["err"].int ?? 0
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = registerFailure
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                        
                        if code == 23505{
                            self.emailTextField.layer.borderWidth = 1.8
                            self.emailTextField.layer.borderColor = ThemeColor().redColor().cgColor
                            
                            self.emailLabel.text = "Email Exists"
                            self.emailLabel.textColor = ThemeColor().redColor()
                        }
                    }
                }
                
                
            } else {
                let manager = NetworkReachabilityManager()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                if !(manager?.isReachable)! {
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = "No Network" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                } else {
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = "Time Out" // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                }
                
            }
        })
        
        
        
        
        //                } else{
        //                    self.notificationLabel.text = "Error code \(response["code"]): \(response["message"])"
        //                    self.notificationLabel.isHidden = false
        //                }
        //            })
    }
    
    @objc func checkValuesAndChangeButton(sender: UITextField){
        let trimmedFirstName = firstNameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let trimmedLastName = lastNameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if trimmedFirstName != "" &&
            trimmedLastName != "" &&
            emailPredicate.evaluate(with: emailTextField.text) &&
            (passwordTextField.text?.count)! >= 8 &&
            conPasswordTextField.text == passwordTextField.text {
            signUpButton.backgroundColor = ThemeColor().themeWidgetColor()
            signUpButton.isEnabled = true
        }else{
            signUpButton.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
            signUpButton.isEnabled = false
        }
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -40, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    @objc func showSelection(_ textField: UITextField){
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Title"
        let titles = [
            "Mr",
            "Ms",
            "Mrs",
            "Dr"
        ]
        let values = titles.map{ TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndex) in
            for i in selectedIndex {
                self.titleTextField.text = values[i].title
            }
        }
        picker.show()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    @objc func keyboardHide(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    func setUp(){
        
        // Add First Name Label
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        titleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        navTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        titleView.addSubview(navTitleLabel)
        navTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        navTitleLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        navTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        
        
        titleView.addSubview(navButton)
        navButton.translatesAutoresizingMaskIntoConstraints = false
//        navButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        navButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        navButton.leftAnchor.constraint(equalTo:view.leftAnchor,constant: 0).isActive = true
        navButton.centerYAnchor.constraint(equalTo:titleView.centerYAnchor).isActive = true
        
        
        
        view.addSubview(firstNameLabel)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 50).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        firstNameLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        firstNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Add First Name Text field
        view.addSubview(firstNameTextField)
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 5).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        firstNameTextField.widthAnchor.constraint(equalToConstant:300).isActive = true
        firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Add Last Name Text Field
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 5).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lastNameTextField.widthAnchor.constraint(equalToConstant:220).isActive = true
        //        lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 30).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: firstNameTextField.rightAnchor).isActive = true
        
        
        //Add Last Name Label
        
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        lastNameLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        lastNameLabel.centerXAnchor.constraint(equalTo: lastNameTextField.centerXAnchor).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20).isActive = true
        
        
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20).isActive = true
        
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
        
        view.addSubview(conPasswordLabel)
        conPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        conPasswordLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        conPasswordLabel.widthAnchor.constraint(equalToConstant:200).isActive = true
        conPasswordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        conPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        
        
        view.addSubview(conPasswordTextField)
        conPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        conPasswordTextField.topAnchor.constraint(equalTo: conPasswordLabel.bottomAnchor, constant: 5).isActive = true
        conPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        conPasswordTextField.widthAnchor.constraint(equalToConstant:300).isActive = true
        conPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Add Title Text Field
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant:60).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: firstNameTextField.leftAnchor).isActive = true
        
        // Add Title Label
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
        titleLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: titleTextField.centerXAnchor).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant:200).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: conPasswordTextField.bottomAnchor, constant: 40).isActive = true
        
    }
    
    
}

class LeftPaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7);
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

}
