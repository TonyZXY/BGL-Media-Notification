//
//  RegisterPageViewController.swift
//  BGL-MediaApp
//
//  Created by Victor Ma on 22/6/18.
//  Copyright © 2018 Xuyang Zheng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterationPageViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
//    var keyboardIsShown = false
    var pickOption = ["Male", "Female"]
    var titlePickOption = ["Mr","Mrs","Ms","Miss","Dr","Sir"]
    
    let firstNameLabel: UILabel = {
       let label = UILabel()
        label.text = "First Name  *"
        label.bounds = CGRect(x: 0, y: 0, width: 70, height: 50)
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email  *"
        label.bounds = CGRect(x: 0, y: 0, width: 70, height: 50)
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password  *"
        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        return label
    }()
    
    let reEnterPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password  *"
        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name  *"
        label.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        return label
    }()
    
    let firstNameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = ""
        textField.backgroundColor = .white
        return textField
    }()
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = ""
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = ""
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    let reEnterPasswordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = ""
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        return textField
    }()
    
    let titleTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = ""
        textField.backgroundColor = .white
        return textField
    }()
    
    let lastNameTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = ""
        textField.backgroundColor = .white
        return textField
    }()
    
    
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
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
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        setUp()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    

        
        let titlePickerView = UIPickerView()
        titlePickerView.delegate = self
        titlePickerView.tag = 0
        titleTextField.inputView = titlePickerView
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        return titlePickOption.count
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        return titlePickOption[row]
    
    
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        titleTextField.text = titlePickOption[row]
        
    
    }
    
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "test string"
        label.textColor = UIColor.red
        label.font = UIFont(name: "Helvetica-Bold", size: 15)
        label.isHidden = true
        return label
    }()
    
    @objc func register(sender: UIButton){
        
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
        
        if (firstNameTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! ||  (reEnterPasswordTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! {
            notificationLabel.text = "Please provide all information necessary"
            notificationLabel.isHidden = false
        } else if passwordTextField.text == reEnterPasswordTextField.text {
            let parameter = ["firstName": firstNameTextField.text!, "email": emailTextField.text!, "password": passwordTextField.text!, "title": titleTextField.text!, "lastName": lastNameTextField.text!]

            let (message, success) = LoginPageViewController().checkUsernameAndPassword(username: emailTextField.text!, password: passwordTextField.text!)
            if success {
               
                registerRequestToServer(parameter: parameter){(res,pass) in
                    if pass {
                        self.notificationLabel.text = "Registration Complete. Now login user. "
                        print(res["token"])
                        self.notificationLabel.isHidden = false
                    } else{
                        self.notificationLabel.text = "Registration. Error code \(res["code"])"
                        self.notificationLabel.isHidden = false
                    }
                }
                
                
                notificationLabel.text = "Write some code send to server."
                notificationLabel.isHidden = false
            } else {
                self.notificationLabel.text = message
                self.notificationLabel.isHidden = false
            }
        } else {
            notificationLabel.text = "Password does not match"
            notificationLabel.isHidden = false
        }
    }
    
    func registerRequestToServer(parameter: [String : String], completion:@escaping (JSON, Bool)->Void){
        
        let url = URL(string: "http://10.10.6.218:3030/userLogin/register")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
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
        
    
    func combineViews(combine view1: UILabel, with view2: LeftPaddedTextField) -> UIView {
        let newView = UIView()
        
        newView.addSubview(view1)
        newView.addSubview(view2)
        newView.backgroundColor = .lightGray
        
        view1.textColor = .white
        view1.translatesAutoresizingMaskIntoConstraints = false
        view1.topAnchor.constraint(equalTo: newView.topAnchor, constant: 2).isActive = true
        view1.leftAnchor.constraint(equalTo: newView.leftAnchor, constant: 30).isActive = true
        view1.rightAnchor.constraint(equalTo: newView.rightAnchor, constant: -30).isActive = true

        view1.heightAnchor.constraint(equalToConstant: 20)
        
        view2.translatesAutoresizingMaskIntoConstraints = false
        view2.topAnchor.constraint(equalTo: view1.bottomAnchor, constant: 5).isActive = true
        view2.leftAnchor.constraint(equalTo: newView.leftAnchor, constant: 30).isActive = true
        view2.rightAnchor.constraint(equalTo: newView.rightAnchor, constant: -30).isActive = true

        view2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return newView
    }

    
    @objc func keyboardShow() {
        notificationLabel.isHidden = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -40, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    //hide keyboard when touch somewhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    
        
    }
    
    
    
    func setUp(){
        
        let titleView = combineViews(combine: titleLabel, with: titleTextField)
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        
//        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 80).isActive = false
//        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
        
        titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 80).isActive = true
        titleView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(notificationLabel)
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.bottomAnchor.constraint(equalTo: titleView.topAnchor, constant: -5).isActive = true
        notificationLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        notificationLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        notificationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let firstNameView = combineViews(combine: firstNameLabel, with: firstNameTextField)
        view.addSubview(firstNameView)
        firstNameView.translatesAutoresizingMaskIntoConstraints = false
        firstNameView.topAnchor.constraint(equalTo: titleView.bottomAnchor,constant: 5).isActive = true
        firstNameView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstNameView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        firstNameView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let lastNameView = combineViews(combine: lastNameLabel , with: lastNameTextField)
        view.addSubview(lastNameView)
        lastNameView.translatesAutoresizingMaskIntoConstraints = false
        lastNameView.topAnchor.constraint(equalTo: firstNameView.bottomAnchor,constant: 5).isActive = true
        lastNameView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lastNameView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lastNameView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let emailView = combineViews(combine: emailLabel, with: emailTextField)
        view.addSubview(emailView)
        emailView.translatesAutoresizingMaskIntoConstraints = false
        emailView.topAnchor.constraint(equalTo: lastNameView.bottomAnchor,constant: 5).isActive = true
        emailView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let passwordView = combineViews(combine: passwordLabel , with: passwordTextField)
        view.addSubview(passwordView)
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor,constant: 5).isActive = true
        passwordView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let reEnterPasswordView = combineViews(combine: reEnterPasswordLabel, with: reEnterPasswordTextField)
        view.addSubview(reEnterPasswordView)
        reEnterPasswordView.translatesAutoresizingMaskIntoConstraints = false
        reEnterPasswordView.topAnchor.constraint(equalTo: passwordView.bottomAnchor,constant: 5).isActive = true
        reEnterPasswordView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        reEnterPasswordView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        reEnterPasswordView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.topAnchor.constraint(equalTo: reEnterPasswordView.bottomAnchor, constant: 5).isActive = true
        registerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: reEnterPasswordView.bottomAnchor, constant: 5).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
    }
    
    
    @objc func closePage(sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
