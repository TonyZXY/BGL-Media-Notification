//
//  ReportProblemViewController.swift
//  BGLMedia
//
//  Created by ZHANG ZEYAO on 9/8/18.
//  Copyright © 2018 ZHANG ZEYAO. All rights reserved.
//

import UIKit
import MessageUI

class ReportProblemViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        titleLabel.font = UIFont.semiBoldFont(17)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = textValue(name: "email")
        label.font = UIFont.semiBoldFont(16)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Montserrat-Light", size: 14)
        textField.attributedPlaceholder = NSAttributedString(string: textValue(name: "email_report"), attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Italic", size: 14)!])
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.layer.cornerRadius = 8.5
        textField.backgroundColor = .white
        return textField
    }()
    
    let reportLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = textValue(name: "feedBack_reportbug")
        label.font = UIFont.semiBoldFont(16)
        label.textColor = ThemeColor().whiteColor()
        return label
    }()
    
    let reportTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Montserrat-Light", size: 14)
        textView.layer.cornerRadius = 8.5
        textView.backgroundColor = .white
        return textView
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(textValue(name: "submit"),for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        button.backgroundColor = UIColor.init(red:168/255.0, green:234/255.0, blue:214/255.0, alpha:1)
        button.layer.cornerRadius = 8.5
        return button
    }()
    
    lazy var mc: MFMailComposeViewController = {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        return controller
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor().themeColor()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
        setupView()

    }
    
    @objc func submit(sender: UIButton){
        mc.setSubject("Bug Report")
        mc.setToRecipients(["cryptogeekapp@gmail.com"])
        mc.setMessageBody(reportTextView.text,isHTML: false)
        self.present(mc,animated:true,completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("cancelled")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        case .failed:
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeLanguage(){
        titleLabel.text = textValue(name: "feedBack_reportbug")
        navigationItem.titleView = titleLabel
    }
    func setupView(){
        let height = view.frame.height/736
        let width = view.frame.width/375
        titleLabel.text = textValue(name: "feedBack_reportbug")
        navigationItem.titleView = titleLabel
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(reportLabel)
        view.addSubview(reportTextView)
        view.addSubview(submitButton)

        if #available(iOS 11.0, *) {
            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30 * height).isActive = true
        } else {
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50 * height).isActive = true
        }
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35 * width).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -25 * width).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 20 * height ).isActive = true


        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5 * height).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35 * width).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -25 * width).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
        
        reportLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20 * height).isActive = true
        reportLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35 * width).isActive = true
        reportLabel.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -25 * width).isActive = true
        reportLabel.heightAnchor.constraint(equalToConstant: 20 * height).isActive = true
        
        reportTextView.topAnchor.constraint(equalTo: reportLabel.bottomAnchor, constant: 5 * height).isActive = true
        reportTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35 * width).isActive = true
        reportTextView.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -25 * width).isActive = true
        reportTextView.heightAnchor.constraint(equalToConstant: 200 * height).isActive = true
        
        submitButton.topAnchor.constraint(equalTo: reportTextView.bottomAnchor, constant: 40 * height).isActive = true
        submitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 35 * width).isActive = true
        submitButton.rightAnchor.constraint(equalTo: view.rightAnchor,  constant: -25 * width).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40 * height).isActive = true
        
        
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeLanguage"), object: nil)
    }

}
