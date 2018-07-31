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
            cell.titleTextField.leftAnchor.constraint(equalTo: cell.leftAnchor,constant:37.5 * width).isActive = true
            cell.lastNameTextField.rightAnchor.constraint(equalTo: cell.rightAnchor,constant:-37.5 * width).isActive = true
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
            cell.contentLabel.text = "Email"
            cell.contentTextField.placeholder = "*Email"
            cell.contentTextField.keyboardType = .emailAddress
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
            cell.contentLabel.text = "Password"
            cell.contentTextField.placeholder = "*8-20 Characters"
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
            cell.contentLabel.text = "Confirm Password"
            cell.contentTextField.placeholder = "*Confirm Your Password"
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
    
    
    
    
    
    @objc func showSelection(_ textField: UITextField){
        let superview = textField.superview
        let cell = superview as! RegisterCellB
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
            print(cell.contentTextField.isTouchInside)
            textField.layer.borderWidth = 1.8
            textField.layer.borderColor = ThemeColor().redColor().cgColor
            cell.contentLabel.text = "First Name Needed"
            cell.contentLabel.textColor = ThemeColor().redColor()
            firstName = ""
        } else {
            print(cell.contentTextField.isTouchInside)
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = "First Name"
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
            cell.lastNameLabel.text = "Last Name Needed"
            cell.lastNameLabel.textColor = ThemeColor().redColor()
            lastName = ""
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.lastNameLabel.text = "Last Name"
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
            
            cell.contentLabel.text = "Invalid Email"
            cell.contentLabel.textColor = ThemeColor().redColor()
            email = ""
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = "Email"
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
            
            cell.contentLabel.text = "Password is too short"
            cell.contentLabel.textColor = ThemeColor().redColor()
            password = ""
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = "Password"
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
            
            cell.contentLabel.text = "Invalid Confirmation"
            cell.contentLabel.textColor = ThemeColor().redColor()
            conPassword = ""
        }else{
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            cell.contentLabel.text = "Confirm Password"
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
            conPassword == password {
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
        print(firstName + "   " + lastName + "   " + titleOfUser + "    " + email + "   " + password)
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Registing"
        hud.backgroundColor = UIColor(displayP3Red: 191, green: 191, blue: 191, alpha: 0.5)
        hud.show(in: self.view)
        
        let parameter = ["email": self.email.lowercased(), "firstName": self.firstName, "lastName":self.lastName,"title": self.titleOfUser, "password": self.password]
        
        URLServices.fetchInstance.passServerData(urlParameters: ["userLogin","register"], httpMethod: "POST", parameters: parameter, completion: { (response, success) in
            if success{
                let registersuccess = response["success"].bool ?? true // Question
                if registersuccess{
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(self.email.lowercased(), forKey: "UserEmail")
                    let token = response["token"].string!
                    UserDefaults.standard.set(token, forKey: "CertificateToken")
                    
                    print(token)
                    print(self.email.lowercased())
                    
                    if !self.getDeviceToken{
                        let deviceTokenString = UserDefaults.standard.string(forKey: "UserToken")!
                        let sendDeviceTokenParameter = ["email":self.email.lowercased(),"token":token,"deviceToken":deviceTokenString]
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
                    let code = response["err"]
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.textLabel.text = "Error"
                    hud.detailTextLabel.text = registerFailure
                    if code == "23505"{
                        let indexPathC = IndexPath.init(row: 3, section: 0)
                        let cellC = self.registerTable.cellForRow(at: indexPathC) as! RegisterCellA
                        cellC.contentTextField.layer.borderWidth = 1.8
                        cellC.contentTextField.layer.borderColor = ThemeColor().redColor().cgColor
                        
                        cellC.contentLabel.text = "Email Exists"
                        cellC.contentLabel.textColor = ThemeColor().redColor()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        hud.dismiss()
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
    }
    
    
    
    
    
    
    
    func setUp(){
        
        let width = view.frame.width/375
        let height = view.frame.height/736
        print("width: \(width), height: \(height)")
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
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: 60 * height).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant:200  * width).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: registerTable.bottomAnchor, constant: 20 * height).isActive = true
        
    }
    
}

