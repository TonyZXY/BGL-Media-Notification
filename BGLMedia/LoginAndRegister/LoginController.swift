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
    let resendVerifyEmailAlert = CustomAlertController()
    let resetPasswordAlert = CustomPasswordAlertController()
    
    
    var getDeviceToken:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "getDeviceToken")
        }
    }
    
    var usedPlace: Int = 0
    
    var sendDeviceToken:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "SendDeviceToken")
        }
    }

    let logoImage: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "CryptoGeekLogo2"))
        return logo
    }()
    
    var deviceToken:String{
        return UserDefaults.standard.string(forKey: "UserToken") ?? "null"
    }
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "email")
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "password")
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    var resetPasswordCountdownTimer: Timer?
    
    var resetPasswordRemainingSeconds: Int = 0 {
        willSet {
            resetPasswordAlert.sendEmailButton.setTitle(textValue(name: "checkSend_reset") + " (\(newValue)" + textValue(name: "second_reset") + ")", for: .normal)
            
            if newValue <= 0 {
                resetPasswordAlert.sendEmailButton.setTitle(textValue(name: "sendButton_reset"), for: .normal)
                resetPasswordIsCounting = false
            } 
        }
    }
    
    var resetPasswordIsCounting = false {
        willSet {
            if newValue {
                resetPasswordCountdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateResetPasswordTime(_:)), userInfo: nil, repeats: true)
                resetPasswordRemainingSeconds = 60
                resetPasswordAlert.sendEmailButton.backgroundColor = ThemeColor().textGreycolor()
            } else {
                resetPasswordCountdownTimer?.invalidate()
                resetPasswordCountdownTimer = nil
                resetPasswordAlert.sendEmailButton.backgroundColor = ThemeColor().blueColor()
            }
            resetPasswordAlert.sendEmailButton.isEnabled = !newValue
        }
    }
    
    
    var resendVerifyEmailCountdownTimer: Timer?
    
    var resendVerifyEmailRemainingSeconds: Int = 0 {
        willSet {
            resendVerifyEmailAlert.sendEmailButton.setTitle(textValue(name: "checkSend_resend") + " (\(newValue)" + textValue(name: "second_resend") + ")", for: .normal)
            
            if newValue <= 0 {
                resendVerifyEmailAlert.sendEmailButton.setTitle(textValue(name: "sendButton_resend"), for: .normal)
                resendVerifyEmailIsCounting = false
            }
        }
    }
    
    var resendVerifyEmailIsCounting = false {
        willSet {
            if newValue {
                resendVerifyEmailCountdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resendVerifyEmailUpdateTime(_:)), userInfo: nil, repeats: true)
                resendVerifyEmailRemainingSeconds = 60
                resendVerifyEmailAlert.sendEmailButton.backgroundColor = ThemeColor().textGreycolor()
            } else {
                resendVerifyEmailCountdownTimer?.invalidate()
                resendVerifyEmailCountdownTimer = nil
                resendVerifyEmailAlert.sendEmailButton.backgroundColor = ThemeColor().blueColor()
            }
            resendVerifyEmailAlert.sendEmailButton.isEnabled = !newValue
        }
    }
    
    @objc func resendVerifyEmailSendEmail() {
        resendVerifyEmailIsCounting = true
        if resendVerifyEmailIsCounting{
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = textValue(name: "Send Email")
            hud.backgroundColor = ThemeColor().progressColor()
            hud.show(in: self.view)
            URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","resendVerifyLink",self.emailTextField.text!], httpMethod: "GET", parameters: [String:Any]()) { (response, success) in
                print(response)
                if success{
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = textValue(name: "success_success")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    print(response)
                } else{
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = textValue(name: "error_error")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                }
            }
        }
    }
    
    @objc func resendVerifyEmailUpdateTime(_ timer: Timer) {
        resendVerifyEmailRemainingSeconds -= 1
    }
    
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "*email@email.com", attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 16)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(checkEmail), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.font = UIFont(name: "Montserrat-Light", size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: textValue(name: "needPassword"), attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 16)!])
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
        button.setTitle(textValue(name: "login"),for: .disabled)
        button.setTitle(textValue(name: "login"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(textValue(name: "signUp"),for: .disabled)
        button.setTitle(textValue(name: "signUp"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        button.backgroundColor = ThemeColor().redColor()
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle(textValue(name: "skip"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        button.backgroundColor = ThemeColor().themeColor()
        return button
    }()
    
    let resetPasswordButton:UIButton = {
        let button = UIButton()
//        button.setTitle(textValue(name: "resetPassword_login"), for: .normal)
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.semiBoldFont(15)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let myAttribute = [NSAttributedStringKey.font: UIFont.semiBoldFont(15), NSAttributedStringKey.foregroundColor: ThemeColor().whiteColor(),NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let myString = NSMutableAttributedString(string: textValue(name: "resetPassword_login"), attributes: myAttribute )
        
        button.setAttributedTitle(myString, for: .normal)
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CHeck HerE")
        print(usedPlace)
        view.backgroundColor = ThemeColor().themeColor()
        setUp()
        loginButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    @objc func checkEmail(_ textField: UITextField){
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        let trimmedEmail = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if trimmedEmail == "" || !emailPredicate.evaluate(with: textField.text){
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            emailLabel.text = textValue(name: "wrongEmail")
            emailLabel.textColor = ThemeColor().redColor()
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            emailLabel.text = textValue(name: "email")
            emailLabel.textColor = ThemeColor().whiteColor()
        }
        
    }
    
    @objc func checkPassword(_ textField: UITextField) {
        if (textField.text?.count)! < 8{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            passwordLabel.text = textValue(name: "wrongPassword")
            passwordLabel.textColor = ThemeColor().redColor()
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            passwordLabel.text = textValue(name: "password")
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
    
    init(usedPlace: Int) {
        super.init(nibName: nil, bundle: nil)
        self.usedPlace = usedPlace
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func login(sender: UIButton){
        if usedPlace == 1 {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = textValue(name: "signingIn")
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
                    
                    
                    if self.getDeviceToken{
                    if !self.sendDeviceToken{
                        let deviceTokenString = UserDefaults.standard.string(forKey: "UserToken")!
                        let sendDeviceTokenParameter = ["email":self.emailTextField.text!.lowercased(),"token":token,"deviceToken":deviceTokenString]
                        URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","addIOSDevice"], httpMethod: "POST", parameters: sendDeviceTokenParameter, completion: { (response, success) in
                            if success{
                                UserDefaults.standard.set(true, forKey: "SendDeviceToken")
                            }
                        })
                    }
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logIn"), object: nil)

                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = textValue(name: "successSigningIn")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                        if self.usedPlace == 1{
                            let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
                            // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                            
                            
                            vc.modalTransitionStyle = .flipHorizontal
                            //        vc.modalTransitionStyle = .crossDissolve // another form of animations
                            
                            
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                } else {
                    let loginCode = response["code"].int ?? 0
                    print(loginCode)
                    print(response)
                    if loginCode == 888{
                        self.resendVerifyEmailAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//                        vc.email = un
                        self.resendVerifyEmailAlert.cancelButton.addTarget(self, action: #selector(self.cancelResendVerifyEmailAlert), for: .touchUpInside)
                        self.resendVerifyEmailAlert.sendEmailButton.addTarget(self, action: #selector(self.resendVerifyEmailSendEmail), for: .touchUpInside)
                        self.addChildViewController(self.resendVerifyEmailAlert)
                        self.view.addSubview(self.resendVerifyEmailAlert.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    } else{
                        var loginfailure = response["message"].string ?? textValue(name: "errorLoginIn")
                        if loginfailure == "Email or Password Error"{
                            loginfailure = textValue(name: "errorHandle_login")
                        }
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.textLabel.text = textValue(name: "errorShow")
                        hud.detailTextLabel.text = loginfailure
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                            self.passwordTextField.layer.borderWidth = 1.8
                            self.passwordTextField.layer.borderColor = ThemeColor().redColor().cgColor
                            
                            self.passwordLabel.text = textValue(name: "wrongPassword")
                            self.passwordLabel.textColor = ThemeColor().redColor()
                            
                            self.emailTextField.layer.borderWidth = 1.8
                            self.emailTextField.layer.borderColor = ThemeColor().redColor().cgColor
                            
                            self.emailLabel.text = textValue(name: "wrongEmail")
                            self.emailLabel.textColor = ThemeColor().redColor()
                            
                        }
                    }
                }
                
            } else {
                let manager = NetworkReachabilityManager()
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                if !(manager?.isReachable)! {
                    hud.textLabel.text = textValue(name: "errorShow")
                    hud.detailTextLabel.text = textValue(name: "noNetwork") // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                } else {
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = textValue(name: "timeout") // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                }
            }
        })
    }
    
    @objc func register(sender: UIButton){
//        let vc = CustomAlertController()
//        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        vc.email = "lfsdfjkfsdksd"
//        self.addChildViewController(vc)
//        view.addSubview(vc.view)
        
        if usedPlace == 1 {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let registerViewController = RegisterController()
            self.present(registerViewController,animated: true, completion: nil)
            
        } else {
            let registerViewController = RegisterController()
            self.present(registerViewController,animated: true, completion: nil)
        }
        
        
    }
    @objc func closePage(sender: UIButton) {
        if usedPlace == 1{
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            let vc:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomePage") as UIViewController
            // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
            
            
            vc.modalTransitionStyle = .flipHorizontal
            //        vc.modalTransitionStyle = .crossDissolve // another form of animations
            
            
            self.present(vc, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        

    }
    
    func setUp(){
        
        let width = view.frame.width/375
        let height = view.frame.height/736
        print("width: \(width), height: \(height)")
        
        view.addSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.heightAnchor.constraint(equalToConstant: 150 * height).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant:250 * height).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80 * height).isActive = true
        
        
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant:200 * width).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 30 * height).isActive = true
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5 * height).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passwordLabel)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
        passwordLabel.widthAnchor.constraint(equalToConstant:200 * width).isActive = true
        passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30 * height).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5 * height).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 50 * height).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant:200 * width).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40 * height).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 50 * height).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant:200 * width).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20 * height).isActive = true
        
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
        resetPasswordButton.widthAnchor.constraint(equalToConstant:200 * width).isActive = true
        resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetPasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 25 * height).isActive = true
        
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo:signUpButton.bottomAnchor , constant: 95 * height).isActive = true
        if usedPlace == 1{
            skipButton.setTitle(textValue(name: "skip"),for: .normal)
            skipButton.layer.cornerRadius = 8.5
            skipButton.backgroundColor = ThemeColor().themeWidgetColor()
            skipButton.heightAnchor.constraint(equalToConstant: 40 * view.frame.width/414).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: 150 * view.frame.width/414).isActive = true

        } else {
            skipButton.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            skipButton.widthAnchor.constraint(equalToConstant: 80 * width).isActive = true
            skipButton.setTitle(textValue(name: "back"),for: .normal)
            skipButton.backgroundColor = ThemeColor().themeColor()
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func resetPassword(){
        resetPasswordAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        vc.email = un
        resetPasswordAlert.emailTextField.addTarget(self, action: #selector(checkAlertEmailTextFieldFormat), for: .allEditingEvents)
        resetPasswordAlert.cancelButton.addTarget(self, action: #selector(cancelResetPassportAlert), for: .touchUpInside)
        resetPasswordAlert.sendEmailButton.addTarget(self, action: #selector(sendResetPassword), for: .touchUpInside)
        self.addChildViewController(resetPasswordAlert)
        self.view.addSubview(resetPasswordAlert.view)
    }
    
    @objc func checkAlertEmailTextFieldFormat(){
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if emailPredicate.evaluate(with: resetPasswordAlert.emailTextField.text){
            if resetPasswordIsCounting != true{
               resetPasswordAlert.sendEmailButton.backgroundColor = ThemeColor().blueColor()
               resetPasswordAlert.sendEmailButton.isEnabled = true
            } else{
                resetPasswordAlert.sendEmailButton.backgroundColor = ThemeColor().textGreycolor()
                resetPasswordAlert.sendEmailButton.isEnabled = false
            }
        }else{
            resetPasswordAlert.sendEmailButton.backgroundColor =  ThemeColor().textGreycolor()
            resetPasswordAlert.sendEmailButton.isEnabled = false
        }
    }
    
    @objc func cancelResetPassportAlert(){
        resetPasswordAlert.removeFromParentViewController()
        resetPasswordAlert.view.removeFromSuperview()
    }
    
    @objc func cancelResendVerifyEmailAlert(){
        resendVerifyEmailAlert.removeFromParentViewController()
        resendVerifyEmailAlert.view.removeFromSuperview()
    }
    
    @objc func updateResetPasswordTime(_ timer: Timer) {
        resetPasswordRemainingSeconds -= 1
    }
    
    @objc func sendResetPassword() {
        resetPasswordIsCounting = true
        if resetPasswordIsCounting{
//            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = textValue(name: "Send Email")
            hud.backgroundColor = ThemeColor().progressColor()
            hud.show(in: self.view)
//            if emailPredicate.evaluate(with: vcs.emailTextField.text){
            print(resetPasswordAlert.emailTextField.text!)
                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","resetPassword",resetPasswordAlert.emailTextField.text!], httpMethod: "Get", parameters: [String:Any]()) { (response, success) in
                    print(response)
                    if success{
                        let request = response["success"].bool ?? false
                        
                        if request{
                            hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                            hud.textLabel.text = textValue(name: "success_success")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                hud.dismiss()
                            }
                        
                        } else{
                            let errorCode = response["code"].int ?? 0
                            if errorCode == 666{
                                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud.textLabel.text = textValue(name: "error_usernotfound")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    hud.dismiss()
                                }
                                self.resetPasswordIsCounting = false
                                self.resetPasswordRemainingSeconds = 0
                            } else if errorCode == 888{
                                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud.textLabel.text = textValue(name: "error_verifyEmail")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    hud.dismiss()
                                }
                                self.resetPasswordIsCounting = false
                                self.resetPasswordRemainingSeconds = 0
                            } else{
                                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                                hud.textLabel.text = textValue(name: "error_error")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    hud.dismiss()
                                }
                            }
                        }
                    } else{
                        hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        hud.textLabel.text = textValue(name: "error_error")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hud.dismiss()
                        }
                    }
                }
//            }
        }
    }
    
}
