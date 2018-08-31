//
//  ViewController.swift
//  RegisterV2
//
//  Created by ZHANG ZEYAO on 29/7/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import Alamofire
import JGProgressHUD
import SafariServices

class RegisterController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    
    var getDeviceToken:Bool{
        get{
            return UserDefaults.standard.bool(forKey: "getDeviceToken")
        }
    }
    
    let cells = ["blank","firstName","lastName&Title","email","password","conPassword"]
    var firstName  = ""
    var titleOfUser  = ""
    var lastName  = ""
    var email  = ""
    var password  = ""
    var conPassword  = ""
    var isChecked = false
    
    let titleView: UIView = {
        let view = UIView()
        return view
    }()
    let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "signUp")
        label.textAlignment = .center
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    lazy var navButton: UIButton = {
        let width = view.frame.width/375
        let button = UIButton()
        button.setImage(UIImage(named: "back_button"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10 * width, 0, 20 * width)
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        button.addTarget(self, action: #selector(closePage), for: .touchUpInside)
        return button
    }()
    
    
    lazy var registerTable: UITableView = {
        let view = UITableView()
        view.backgroundColor = ThemeColor().themeColor()
        view.separatorStyle = .none
        view.register(UITableViewCell.self, forCellReuseIdentifier: "blank")
        view.register(RegisterCellA.self, forCellReuseIdentifier: "firstName")
        view.register(RegisterCellB.self, forCellReuseIdentifier: "lastName&Title")
        view.register(RegisterCellA.self, forCellReuseIdentifier: "email")
        view.register(RegisterCellA.self, forCellReuseIdentifier: "password")
        view.register(RegisterCellA.self, forCellReuseIdentifier: "conPassword")
        view.setEditing(false, animated: false)
        view.delaysContentTouches = false
        view.delegate = self
        view.dataSource = self
        return view
    }()
    let checkboxImage: UIButton = {
        let image = UIButton()
        image.setImage(UIImage(named: "checkbox"), for: .normal)
//        image.contentEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0)
//        image.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)
//        image.contentEdgeInsets = uiedg
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addTarget(self, action: #selector(checkbox), for: .touchUpInside)
        image.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .touchUpInside)
        return image
    }()
    let textlabel: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "read")
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.textColor = ThemeColor().whiteColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let termButton1: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.semiBoldFont(12)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let myAttribute = [NSAttributedStringKey.font: UIFont.semiBoldFont(12), NSAttributedStringKey.foregroundColor: ThemeColor().blueColor(),NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let myString = NSMutableAttributedString(string: textValue(name: "more_disclaimer"), attributes: myAttribute )
        
        button.setAttributedTitle(myString, for: .normal)
        button.addTarget(self, action: #selector(termsOpenURL), for: .touchUpInside)
        return button
    }()
    let textlabel2: UILabel = {
        let label = UILabel()
        label.text = textValue(name: "and")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    let termButton2: UIButton = {
        let button = UIButton()
        button.setTitleColor(ThemeColor().whiteColor(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.semiBoldFont(12)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let myAttribute = [NSAttributedStringKey.font: UIFont.semiBoldFont(12), NSAttributedStringKey.foregroundColor: ThemeColor().blueColor(),NSAttributedStringKey.underlineStyle:NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let myString = NSMutableAttributedString(string: textValue(name: "help_privacy"), attributes: myAttribute )
        
        button.setAttributedTitle(myString, for: .normal)
        button.addTarget(self, action: #selector(privacyOpenURL), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle(textValue(name: "signUp"),for: .disabled)
        button.setTitle(textValue(name: "signUp"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.height/736
        if indexPath.row == 0 {
            return 40 * height
        } else {
            return 90 * height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let width = view.frame.width/375
        let height = view.frame.height/736
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[0],for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = ThemeColor().themeColor()
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[1], for: indexPath) as! RegisterCellA
            cell.contentTextField.delegate = self
            cell.selectionStyle = .none
            cell.contentLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            cell.contentLabel.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentTextField.topAnchor.constraint(equalTo: cell.contentLabel.bottomAnchor, constant: 5 * height).isActive = true
            cell.contentTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
            cell.contentTextField.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentTextField.addTarget(self, action: #selector(checkFirstName), for: .allEditingEvents)
            cell.contentTextField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
            cell.contentTextField.tag = 1
            cell.backgroundColor = ThemeColor().themeColor()
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[2], for: indexPath) as! RegisterCellB
            cell.selectionStyle = .none
            
            if defaultLanguage == "CN"{
                cell.lastNameTextField.leftAnchor.constraint(equalTo: cell.leftAnchor,constant:37.5 * width).isActive = true
                cell.titleTextField.rightAnchor.constraint(equalTo: cell.rightAnchor,constant:-37.5 * width).isActive = true
            } else{
                cell.titleTextField.leftAnchor.constraint(equalTo: cell.leftAnchor,constant:37.5 * width).isActive = true
                cell.lastNameTextField.rightAnchor.constraint(equalTo: cell.rightAnchor,constant:-37.5 * width).isActive = true
            }
            
            cell.lastNameTextField.topAnchor.constraint(equalTo: cell.lastNameLabel.bottomAnchor, constant: 5 * height).isActive = true
            cell.lastNameTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
            cell.lastNameTextField.widthAnchor.constraint(equalToConstant:220 * width).isActive = true
            cell.lastNameLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            cell.lastNameLabel.widthAnchor.constraint(equalToConstant:220 * width).isActive = true
            cell.titleTextField.topAnchor.constraint(equalTo: cell.titleLabel.bottomAnchor, constant: 5 * height).isActive = true
            cell.titleTextField.tag = 6
            cell.titleTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
            cell.titleTextField.widthAnchor.constraint(equalToConstant:60  * width).isActive = true
            cell.titleLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            cell.titleLabel.widthAnchor.constraint(equalToConstant:80  * width).isActive = true
            cell.backgroundColor = ThemeColor().themeColor()
            cell.titleTextField.addTarget(self, action: #selector(showSelection), for: .touchDown)
            cell.lastNameTextField.addTarget(self, action: #selector(checkLastName), for: .allEditingEvents)
            cell.lastNameTextField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
            return cell
        } else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[3], for: indexPath) as! RegisterCellA
            cell.selectionStyle = .none
            cell.contentLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            cell.contentLabel.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentTextField.topAnchor.constraint(equalTo: cell.contentLabel.bottomAnchor, constant: 5 * height).isActive = true
            cell.contentTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
            cell.contentTextField.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentLabel.text = textValue(name: "email")
            cell.contentTextField.placeholder = "*email@email.com"
            cell.contentTextField.keyboardType = .emailAddress
            cell.contentTextField.autocorrectionType = .no
            cell.contentTextField.autocapitalizationType = .none
            cell.backgroundColor = ThemeColor().themeColor()
            cell.contentTextField.addTarget(self, action: #selector(checkEmail), for: .allEditingEvents)
            cell.contentTextField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
            return cell
        } else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[4], for: indexPath) as! RegisterCellA
            cell.selectionStyle = .none
            cell.contentLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            cell.contentLabel.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentTextField.topAnchor.constraint(equalTo: cell.contentLabel.bottomAnchor, constant: 5 * height).isActive = true
            cell.contentTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
            cell.contentTextField.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentLabel.text = textValue(name: "password")
            cell.contentTextField.placeholder = "*" + textValue(name: "passwordHint")
            cell.contentTextField.isSecureTextEntry = true
            cell.contentTextField.addTarget(self, action: #selector(checkPassword), for: .allEditingEvents)
            cell.contentTextField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
            cell.backgroundColor = ThemeColor().themeColor()
            return cell
        } else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: cells[5], for: indexPath) as! RegisterCellA
            cell.selectionStyle = .none
            cell.contentLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
            cell.contentLabel.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentTextField.topAnchor.constraint(equalTo: cell.contentLabel.bottomAnchor, constant: 5 * height).isActive = true
            cell.contentTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
            cell.contentTextField.widthAnchor.constraint(equalToConstant:300 * width).isActive = true
            cell.contentLabel.text = textValue(name: "conPassword")
            cell.contentTextField.placeholder = "*" + textValue(name: "conPasswordPlaceHolder")
            cell.contentTextField.isSecureTextEntry = true
            cell.contentTextField.addTarget(self, action: #selector(checkPasswordConfirmed), for: .allEditingEvents)
            cell.contentTextField.addTarget(self, action: #selector(checkValuesAndChangeButton), for: .allEditingEvents)
            cell.backgroundColor = ThemeColor().themeColor()
            return cell
        } else{
            return UITableViewCell()
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        setUp()
        signUpButton.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        signUpButton.isEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func closePage(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkbox(sender: UIButton) {
        if isChecked == false{
            isChecked = true
            sender.setImage(UIImage(named: "checktick"), for: .normal)
        } else {
            isChecked = false
            sender.setImage(UIImage(named: "checkbox"), for: .normal)
        }
        
    }
    
    
    @objc func termsOpenURL(sender: UIButton){
        let urlString = "https://cryptogeekapp.com/policy"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            if #available(iOS 11.0, *) {
                vc.dismissButtonStyle = .close
            } else {
                
            }
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func privacyOpenURL(sender: UIButton){
        let urlString = "https://cryptogeekapp.com/policy"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            if #available(iOS 11.0, *) {
                vc.dismissButtonStyle = .close
            } else {
                
            }
            vc.hidesBottomBarWhenPushed = true
            vc.accessibilityNavigationStyle = .separate
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func showSelection(_ textField: UITextField){
        let superview = textField.superview
        let cell = superview as! RegisterCellB
        var picker: TCPickerViewInput = TCPickerView()
        picker.title = "Title"
        let titles = [
            textValue(name: "mr"),
            textValue(name: "ms"),
            textValue(name: "mrs"),
            textValue(name: "dr")
        ]
        let values = titles.map{ TCPickerView.Value(title: $0) }
        picker.values = values
        picker.delegate = self as? TCPickerViewOutput
        picker.selection = .single
        picker.completion = { (selectedIndex) in
            for i in selectedIndex {
                cell.titleTextField.text = values[i].title
            }
        }
        picker.show()
        
    }
    
    @objc func checkFirstName(_ textField: UITextField){
        let superview = textField.superview
        let cell = superview as! RegisterCellA
        let trimmedFirstName = cell.contentTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if textField.isTouchInside && trimmedFirstName == ""{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            cell.contentLabel.text = textValue(name: "firstNameNeeded")
            cell.contentLabel.textColor = ThemeColor().redColor()
            firstName = ""
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = textValue(name: "firstName")
            cell.contentLabel.textColor = ThemeColor().whiteColor()
            firstName = textField.text!
        }
    }
    
    
    @objc func checkLastName(_ textField: UITextField){
        let superview = textField.superview
        let cell = superview as! RegisterCellB
        let trimmedLastName = cell.lastNameTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if textField.isTouchInside && trimmedLastName == ""{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            cell.lastNameLabel.text = textValue(name: "lastNameNeeded")
            cell.lastNameLabel.textColor = ThemeColor().redColor()
            lastName = ""
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.lastNameLabel.text = textValue(name: "lastName")
            cell.lastNameLabel.textColor = ThemeColor().whiteColor()
            lastName = textField.text!
        }
    }
    
    @objc func checkEmail(_ textField: UITextField){
        let superview = textField.superview
        let cell = superview as! RegisterCellA
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        let trimmedEmail = cell.contentTextField.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if trimmedEmail == "" || !emailPredicate.evaluate(with: textField.text){
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            cell.contentLabel.text = textValue(name: "wrongEmail")
            cell.contentLabel.textColor = ThemeColor().redColor()
            email = ""
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = textValue(name: "email")
            cell.contentLabel.textColor = ThemeColor().whiteColor()
            email = textField.text!
        }
        
    }
    
    @objc func checkPassword(_ textField: UITextField) {
        let superview = textField.superview
        let cell = superview as! RegisterCellA
        if (textField.text?.count)! < 8{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            cell.contentLabel.text = textValue(name: "passwordTooShort")
            cell.contentLabel.textColor = ThemeColor().redColor()
            password = ""
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = textValue(name: "password")
            cell.contentLabel.textColor = ThemeColor().whiteColor()
            password = textField.text!
        }
    }
    
    
    @objc func checkPasswordConfirmed(_ textField: UITextField){
        let superview = textField.superview
        let cell = superview as! RegisterCellA
        let indexPath = IndexPath.init(row: 4, section: 0)
        let cellB = registerTable.cellForRow(at: indexPath) as! RegisterCellA
        if (textField.text?.count)! < 8 || textField.text != cellB.contentTextField.text{
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            
            cell.contentLabel.text = textValue(name: "wrongConPassword")
            cell.contentLabel.textColor = ThemeColor().redColor()
            conPassword = ""
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = textValue(name: "conPassword")
            cell.contentLabel.textColor = ThemeColor().whiteColor()
            conPassword = textField.text!
        }
    }
    
    
    @objc func checkValuesAndChangeButton(sender: UITextField){
        let trimmedFirstName = firstName.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let trimmedLastName = lastName.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if trimmedFirstName != "" &&
            trimmedLastName != "" &&
            emailPredicate.evaluate(with: email) &&
            password.count >= 8 &&
            conPassword == password  && isChecked{
            signUpButton.backgroundColor = ThemeColor().themeWidgetColor()
            signUpButton.isEnabled = true
        }else{
            signUpButton.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
            signUpButton.isEnabled = false
        }
    }
    
    
    @objc func register(sender: UIButton) {
        let indexPath = IndexPath.init(row: 2, section: 0)
        let cell = registerTable.cellForRow(at: indexPath) as! RegisterCellB
        titleOfUser = cell.titleTextField.text!
        if titleOfUser == "先生" {
            titleOfUser = "Mr"
        } else if titleOfUser == "女士" {
            titleOfUser = "Ms"
        } else if titleOfUser == "夫人" {
            titleOfUser = "Mrs"
        } else if titleOfUser == "博士" {
            titleOfUser = "Dr"
        } else {
            titleOfUser = cell.titleTextField.text!
        }
//        print(firstName + "   " + lastName + "   " + titleOfUser + "    " + email + "   " + password)
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = textValue(name: "registing")
        hud.backgroundColor = UIColor(displayP3Red: 191, green: 191, blue: 191, alpha: 0.5)
        hud.show(in: self.view)
        
        let parameter = ["email": self.email.lowercased(), "firstName": self.firstName, "lastName":self.lastName,"title": self.titleOfUser, "password": self.password]
        
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","register"], httpMethod: "POST", parameters: parameter, completion: { (response, success) in
            if success{
                let registersuccess = response["success"].bool ?? false // Question
                if registersuccess{
                    print(response)
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.textLabel.text = textValue(name: "successRegiste")
                    hud.detailTextLabel.text = textValue(name: "verifyEmail")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                        let confirmAlertCtrl = UIAlertController(title: NSLocalizedString(textValue(name: "registerVerify_alertTitle"), comment: ""), message: NSLocalizedString(textValue(name: "registerVerify_alertContent"), comment: ""), preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: NSLocalizedString(textValue(name: "registerVerify_alertOK"), comment: ""), style: .cancel) { (_) in
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        confirmAlertCtrl.addAction(cancelAction)
                        self.present(confirmAlertCtrl, animated: true, completion: nil)
                    }
                    
//                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
//                    UserDefaults.standard.set(self.email.lowercased(), forKey: "UserEmail")
//                    let token = response["token"].string!
//                    UserDefaults.standard.set(token, forKey: "CertificateToken")
//
//                    print(token)
//                    print(self.email.lowercased())
//
//                    if !self.getDeviceToken{
//                        let deviceTokenString = UserDefaults.standard.string(forKey: "UserToken")!
//                        let sendDeviceTokenParameter = ["email":self.email.lowercased(),"token":token,"deviceToken":deviceTokenString]
//                        URLServices.fetchInstance.passServerData(urlParameters: ["deviceManage","addIOSDevice"], httpMethod: "POST", parameters: sendDeviceTokenParameter, completion: { (response, success) in
//                            if success{
//                                UserDefaults.standard.set(true, forKey: "SendDeviceToken")
//                            }
//                        })
//                    }
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logIn"), object: nil)
//
//                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
//                    hud.textLabel.text = "Success"
//
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        hud.dismiss()
//                        if self.presentingViewController?.presentingViewController?.presentingViewController != nil{
//                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//                        } else {
//                            self.presentingViewController?.dismiss(animated: true, completion: nil)
//                        }
//                    }
                } else {
//                    let registerFailure = response["message"].string ?? textValue(name: "registerfailed")
                    let code = response["err"]
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = textValue(name: "errorShow")
                    
                    if code == "23505"{
                        hud.detailTextLabel.text = textValue(name: "emailExist")
                        let indexPathC = IndexPath.init(row: 3, section: 0)
                        let cellC = self.registerTable.cellForRow(at: indexPathC) as! RegisterCellA
                        cellC.contentTextField.layer.borderWidth = 1.8
                        cellC.contentTextField.layer.borderColor = ThemeColor().redColor().cgColor
                        
                        cellC.contentLabel.text = textValue(name: "emailExist")
                        cellC.contentLabel.textColor = ThemeColor().redColor()
                    } else {
                        hud.detailTextLabel.text = textValue(name: "registerfailed")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
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
                    hud.textLabel.text = textValue(name: "errorShow")
                    hud.detailTextLabel.text = textValue(name: "timeout") // To change?
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
                    }
                    
                }
                
            }
        })
    }
    
    
    
    
    
    
    
    func setUp(){
        
        let width = view.frame.width/375
        let height = view.frame.height/736
//        print("width: \(width), height: \(height)")
        // Add First Name Label
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            titleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        titleView.heightAnchor.constraint(equalToConstant: 50 * height).isActive = true
        titleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        //        navTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        titleView.addSubview(navTitleLabel)
        navTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navTitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        navTitleLabel.widthAnchor.constraint(equalToConstant:200 * width).isActive = true
        navTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        
        
        titleView.addSubview(navButton)
        navButton.translatesAutoresizingMaskIntoConstraints = false
        //        navButton.heightAnchor.constraint(equalToConstant: 23 * width).isActive = true
        //        navButton.widthAnchor.constraint(equalToConstant: 23 * width).isActive = true
        navButton.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        navButton.centerYAnchor.constraint(equalTo:titleView.centerYAnchor).isActive = true
        
        view.addSubview(registerTable)
        registerTable.translatesAutoresizingMaskIntoConstraints = false
        registerTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        registerTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        registerTable.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        registerTable.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 480 * height).isActive = true
        let tableVC = UITableViewController.init(style: .plain)
        tableVC.tableView = self.registerTable
        self.addChildViewController(tableVC)
        
        
        view.addSubview(checkboxImage)
        view.addSubview(textlabel)
        view.addSubview(termButton1)
        view.addSubview(textlabel2)
        view.addSubview(termButton2)
        checkboxImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38 * width).isActive = true
        checkboxImage.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 10 * height).isActive = true
        checkboxImage.heightAnchor.constraint(equalToConstant: 15 * height).isActive  = true
        checkboxImage.widthAnchor.constraint(equalToConstant: 15 * height).isActive = true
        textlabel.leftAnchor.constraint(equalTo: checkboxImage.rightAnchor, constant: 7.5 * width).isActive = true
        termButton1.leftAnchor.constraint(equalTo: textlabel.rightAnchor, constant: 2.5 * width).isActive = true
        textlabel2.leftAnchor.constraint(equalTo: termButton1.rightAnchor, constant: 2.5 * width).isActive = true



        if defaultLanguage == "CN"{
            
            textlabel.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 10 * height).isActive = true
            textlabel.centerYAnchor.constraint(equalTo: checkboxImage.centerYAnchor).isActive = true
            
            termButton1.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 10 * height).isActive = true
            termButton1.centerYAnchor.constraint(equalTo: checkboxImage.centerYAnchor).isActive = true
            
            
            textlabel2.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 10 * height).isActive = true
            textlabel2.centerYAnchor.constraint(equalTo: checkboxImage.centerYAnchor).isActive = true
            
            termButton2.leftAnchor.constraint(equalTo: textlabel2.rightAnchor, constant: 2.5 * width).isActive = true
            termButton2.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 10 * height).isActive = true
            termButton2.centerYAnchor.constraint(equalTo: checkboxImage.centerYAnchor).isActive = true
        } else {

            textlabel.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 5 * height).isActive = true
            textlabel.heightAnchor.constraint(equalToConstant: 10 * height).isActive = true
            
            termButton1.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 5 * height).isActive = true
            termButton1.centerYAnchor.constraint(equalTo: textlabel.centerYAnchor).isActive = true
            
            textlabel2.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 5 * height).isActive = true
            textlabel2.centerYAnchor.constraint(equalTo: textlabel.centerYAnchor).isActive = true

            
            termButton2.leftAnchor.constraint(equalTo: checkboxImage.rightAnchor, constant: 7.5 * width).isActive = true
            termButton2.topAnchor.constraint(equalTo: textlabel.bottomAnchor).isActive = true
        }


        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 60 * height).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant:200  * width).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: termButton2.bottomAnchor, constant: 20 * height).isActive = true
        
        
        

        
    }
    
    
    
}

