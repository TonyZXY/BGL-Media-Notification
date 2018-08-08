//
//  CustomAlertController.swift
//  BGLMedia
//
//  Created by Bruce Feng on 2/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit

class CustomPasswordAlertController: UIViewController,UITextFieldDelegate{
    var email:String = ""
//    var countdownTimer: Timer?
//    
//    var remainingSeconds: Int = 0 {
//        willSet {
//            sendEmailButton.setTitle("Send Again After (\(newValue))", for: .normal)
//            
//            if newValue <= 0 {
//                sendEmailButton.setTitle("Send Verify Email Again", for: .normal)
//                isCounting = false
//            }
//        }
//    }
//    
//    var isCounting = false {
//        willSet {
//            if newValue {
//                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime(_:)), userInfo: nil, repeats: true)
//                remainingSeconds = 60
//                sendEmailButton.backgroundColor = ThemeColor().textGreycolor()
//            } else {
//                countdownTimer?.invalidate()
//                countdownTimer = nil
//                sendEmailButton.backgroundColor = ThemeColor().blueColor()
//            }
//            sendEmailButton.isEnabled = !newValue
//        }
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
//        emailTextField.becomeFirstResponder()
    }
    
//    @objc func sendButtonClick() {
//        print(email)
//        isCounting = true
//        if isCounting{
//            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
//            if emailPredicate.evaluate(with: emailTextField.text){
//                URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","resetPassword",emailTextField.text!], httpMethod: "Get", parameters: [String:Any]()) { (response, success) in
//                    if success{
//                        print(response)
//                    }
//                }
//            }
//        }
//    }
    
    func setUpView(){
        let factor = view.frame.width/375
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(alertView)
        alertView.addSubview(logoImage)
        logoImage.addSubview(logo)
        alertView.addSubview(cancelButton)
        alertView.addSubview(sendEmailButton)
        alertView.addSubview(titleLabel)
        alertView.addSubview(descriptionLabel)
        alertView.addSubview(emailTextField)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(30*factor)-[v0]-\(30*factor)-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(250)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":alertView]))
        NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoImage, attribute: .centerY, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logoImage, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logo, attribute: .centerY, relatedBy: .equal, toItem: logoImage, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: logo, attribute: .centerX, relatedBy: .equal, toItem: logoImage, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(\(60*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logo]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(60*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logo]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoImage]))
        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(80*factor))]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":logoImage]))
        
//        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: logoImage, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
//        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":titleLabel]))
//
//        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":descriptionLabel]))
//
//        NSLayoutConstraint(item: descriptionLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
//        //        NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: sendEmailButton, attribute: .top, multiplier: 1, constant:-5).isActive = true
//
//
//
//
//        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cancelButton]))
//        //        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":cancelButton]))
//        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sendEmailButton]))
//        //        alertView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":sendEmailButton]))
//
//
//        NSLayoutConstraint(item: sendEmailButton, attribute: .top, relatedBy: .equal, toItem: alertView, attribute: .centerY, multiplier: 1, constant: 10).isActive = true
//        NSLayoutConstraint(item: sendEmailButton, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .centerY, multiplier: 3/2, constant: -5).isActive = true
//        NSLayoutConstraint(item: cancelButton, attribute: .top, relatedBy: .equal, toItem: sendEmailButton, attribute: .bottom, multiplier: 1, constant: 5).isActive = true
//        NSLayoutConstraint(item: cancelButton, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 5*factor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10*factor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10*factor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10*factor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10*factor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10*factor).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10*factor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 20*factor).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -20*factor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40*factor).isActive = true
        
        sendEmailButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10*factor).isActive = true
        sendEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendEmailButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 20*factor).isActive = true
        sendEmailButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -20*factor).isActive = true
        sendEmailButton.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: sendEmailButton.bottomAnchor, constant: 10*factor).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 20*factor).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -20*factor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50*factor).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10*factor).isActive = true
    }
    
    var alertView:UIView = {
        var view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = ThemeColor().whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(aNotification:NSNotification){
//        let userInfo = aNotification.userInfo!
//        let userInfo: NSDictionary? = aNotification.userInfo as! NSDictionary
//        let aValue: NSValue? = userInfo?.objectForKey(UIKeyboardFrameEndUserInfoKey) as? NSValue
//        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]? as AnyObject).CGRectValue().size
//
//        let keyboardRect = aValue?.CGRectValue()
//        keyboardHeight = keyboardRect?.size.height
//        var frame = editTextField!.frame
//        var offset = frame.origin.y + 32 - (self.view.frame.size.height - keyboardHeight!)
//        UIView.animate(withDuration: 0.3, animations: { () -> Void in
//            if offset > 0{
//                self.view.frame = CGRectMake(0, -offset, SCREEN_WIDTH, SCREEN_HEIGHT)
//            }
//        })
    }
    
    @objc func keyboardWillHidden(notification: NSNotification){
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
//        })
    }
    
    lazy var titleLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().darkBlackColor()
        label.text = textValue(name: "title_reset")
        label.font = UIFont.boldFont(18*view.frame.width/375)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel:UILabel = {
        var label = UILabel()
        label.textColor = ThemeColor().textGreycolor()
        label.text = textValue(name: "description_reset")
        label.font = UIFont.regularFont(15*view.frame.width/375)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sendEmailButton:UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 8*view.frame.width/375
        button.backgroundColor = ThemeColor().blueColor()
        button.setTitle(textValue(name: "sendButton_reset"), for: .normal)
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(13*view.frame.width/375)
//        button.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelButton:UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 8*view.frame.width/375
        button.backgroundColor = ThemeColor().redColor()
        button.setTitle(textValue(name: "done_reset"), for: .normal)
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.titleLabel?.font = UIFont.semiBoldFont(13*view.frame.width/375)
//        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var logoImage:UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = ThemeColor().blueColor()
        imageView.layer.cornerRadius = 40*view.frame.width/375
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = ThemeColor().whiteColor().cgColor
        imageView.layer.borderWidth = 5*view.frame.width/375
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var logo:UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = ThemeColor().blueColor()
        imageView.layer.cornerRadius = 30*view.frame.width/375
        imageView.image = UIImage(named: "email")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var emailTextField:LeftPaddedTextField = {
        var textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.backgroundColor = ThemeColor().darkGreyColor()
//        textField.textColor = ThemeColor().whiteColor()
        textField.layer.borderWidth = 1*view.frame.width/375
        textField.layer.cornerRadius = 8*view.frame.width/375
//        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(allEdit), for: .allEditingEvents)
        textField.attributedPlaceholder = NSAttributedString(string:textValue(name: "placeholder_reset"), attributes:[NSAttributedStringKey.font: UIFont.ItalicFont(13*view.frame.width/375), NSAttributedStringKey.foregroundColor: ThemeColor().grayPlaceHolder()])
        return textField
    }()
    
    @objc func cancel(){
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    @objc func allEdit(){
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if emailPredicate.evaluate(with: emailTextField.text){
            //            loginButton.backgroundColor = ThemeColor().themeWidgetColor()
            sendEmailButton.backgroundColor = ThemeColor().themeWidgetColor()
            sendEmailButton.isEnabled = true
        }else{
            sendEmailButton.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
            sendEmailButton.isEnabled = false
        }
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == emailTextField{
//            if textField.text == "" || textField.text == nil{
//                textField.text = ""
//            } else{
//                email = textField.text!
//                print(textField.text!)
//            }
//        }
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == emailTextField{
//            if textField.text == "" || textField.text == nil{
//                textField.text = ""
//            } else{
//                email = textField.text!
//                print(textField.text!)
//            }
//        }
//        return true
//    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == emailTextField{
//            if textField.text == "" || textField.text == nil{
//                textField.text = ""
//            } else{
//                email = textField.text!
//                print(textField.text!)
//            }
//        }
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == emailTextField{
//            if textField.text == "" || textField.text == nil{
//                textField.text = ""
//            } else{
//                email = textField.text!
//                print(textField.text!)
//            }
//        }
//        return true
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        emailTextField.resignFirstResponder()
//        view.endEditing(true)
//        return true
//    }
//
//    @objc func updateTime(_ timer: Timer) {
//        remainingSeconds -= 1
//    }
    
}
