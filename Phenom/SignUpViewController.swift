//
//  SignUpViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import QuartzCore

class SignUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var passedEmail = ""
    
    var navBarView = UIView()
    var usernameField: UITextField = UITextField()
    var passwordField: UITextField = UITextField()
    var firstNameField: UITextField = UITextField()
    var lastNameField: UITextField = UITextField()
    var birthdayField: UITextField = UITextField()
    var genderField: UITextField = UITextField()
    let genderData = ["Male","Female"]
    
    let passwordCheckmarkImgView = UIImageView()
    
    var birthdayDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), for: UIControlState())
        backBtn.backgroundColor = UIColor.clear
        backBtn.addTarget(self, action:#selector(backAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(backBtn)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "SIGN UP"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let nextBtn = UIButton(type: .custom)
        nextBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        nextBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //nextBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        nextBtn.backgroundColor = UIColor.blue
        nextBtn.addTarget(self, action:#selector(nextBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(nextBtn)
        
        usernameField.frame = CGRect(x: 20, y: 64, width: view.frame.size.width-40, height: 64)
        usernameField.backgroundColor = UIColor.clear
        usernameField.delegate = self
        usernameField.textColor = UIColor.white
        usernameField.attributedPlaceholder = NSAttributedString(string:"your new username",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        usernameField.keyboardType = .default
        usernameField.returnKeyType = .next
        usernameField.enablesReturnKeyAutomatically = true
        usernameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        usernameField.placeholder = "your new username"
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.tag = 0
        view.addSubview(usernameField)
        usernameField.text = ""
        
        passwordField.frame = CGRect(x: 20, y: 64+64, width: view.frame.size.width-40, height: 64)
        passwordField.backgroundColor = UIColor.clear
        passwordField.delegate = self
        passwordField.textColor = UIColor.white
        passwordField.attributedPlaceholder = NSAttributedString(string:"your new password",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        passwordField.keyboardType = .default
        passwordField.returnKeyType = .next
        passwordField.enablesReturnKeyAutomatically = true
        passwordField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        passwordField.placeholder = "your new password"
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.isSecureTextEntry = true
        passwordField.tag = 1
        view.addSubview(passwordField)
        passwordField.text = ""
        
        firstNameField.frame = CGRect(x: 20, y: 64+64+64, width: view.frame.size.width/2-40, height: 64)
        firstNameField.backgroundColor = UIColor.clear
        firstNameField.delegate = self
        firstNameField.textColor = UIColor.white
        firstNameField.attributedPlaceholder = NSAttributedString(string:"first name",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        firstNameField.keyboardType = .default
        firstNameField.returnKeyType = .next
        firstNameField.enablesReturnKeyAutomatically = true
        firstNameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        firstNameField.placeholder = "first name"
        firstNameField.autocapitalizationType = .words
        firstNameField.autocorrectionType = .no
        firstNameField.tag = 2
        view.addSubview(firstNameField)
        firstNameField.text = ""
        
        lastNameField.frame = CGRect(x: view.frame.size.width/2+20, y: 64+64+64, width: view.frame.size.width/2-40, height: 64)
        lastNameField.backgroundColor = UIColor.clear
        lastNameField.delegate = self
        lastNameField.textColor = UIColor.white
        lastNameField.attributedPlaceholder = NSAttributedString(string:"last name",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        lastNameField.keyboardType = .default
        lastNameField.returnKeyType = .next
        lastNameField.enablesReturnKeyAutomatically = true
        lastNameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        lastNameField.placeholder = "last name"
        lastNameField.autocapitalizationType = .words
        lastNameField.autocorrectionType = .no
        lastNameField.tag = 3
        view.addSubview(lastNameField)
        lastNameField.text = ""
        
        birthdayField.frame = CGRect(x: 20, y: 64+64+64+64, width: self.view.frame.size.width/2-40, height: 64)
        birthdayField.backgroundColor = UIColor.clear
        birthdayField.delegate = self
        birthdayField.textColor = UIColor.white
        birthdayField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        birthdayField.placeholder = "birthday"
        birthdayField.addTarget(self, action: #selector(birthdayFieldEditing), for: .editingDidBegin)
        birthdayField.tag = 5
        view.addSubview(birthdayField)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        birthdayField.text = "" //dateFormatter.stringFromDate(NSDate())
        birthdayField.attributedPlaceholder = NSAttributedString(string:"birthday",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        
        genderField.frame = CGRect(x: self.view.frame.size.width/2+20, y: 64+64+64+64, width: self.view.frame.size.width/2-40, height: 64)
        genderField.backgroundColor = UIColor.clear
        genderField.delegate = self
        genderField.textColor = UIColor.white
        genderField.attributedPlaceholder = NSAttributedString(string:"gender",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        genderField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        genderField.placeholder = "gender"
        genderField.addTarget(self, action: #selector(genderFieldEditing), for: .editingDidBegin)
        genderField.tag = 5
        view.addSubview(genderField)
        genderField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRect(x: 0, y: 64+63.5, width: view.frame.size.width, height: 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRect(x: 0, y: 64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2)
        
        let lineview2a = UIView()
        lineview2a.frame = CGRect(x: view.frame.size.width/2-0.25, y: 64+64+63.5, width: 0.5, height: 64)
        lineview2a.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2a)
        
        let lineview3 = UIView()
        lineview3.frame = CGRect(x: 0, y: 64+64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview3.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview3)
        
        let lineview3a = UIView()
        lineview3a.frame = CGRect(x: view.frame.size.width/2-0.25, y: 64+64+64+63.5, width: 0.5, height: 64)
        lineview3a.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview3a)
        
        let lineview4 = UIView()
        lineview4.frame = CGRect(x: 0, y: 64+64+64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview4.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview4)
        
        
        passwordCheckmarkImgView.frame = CGRect(x: self.view.frame.size.width-20-20, y: 64+64+22, width: 20, height: 20)
        passwordCheckmarkImgView.backgroundColor = UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)
        self.view.addSubview(passwordCheckmarkImgView)
        passwordCheckmarkImgView.layer.cornerRadius = 10
        passwordCheckmarkImgView.layer.masksToBounds = true
        passwordCheckmarkImgView.image = UIImage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameField.becomeFirstResponder()
    }
    
    func backAction() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
    
    
    func birthdayFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(birthdayPickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func birthdayPickerValueChanged(_ sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayField.text = dateFormatter.string(from: sender.date)
        birthdayDate = sender.date
    }
    
    
    // genderPicker
    
    func genderFieldEditing(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        sender.inputView = pickerView
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderData[row]
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == usernameField) {
            passwordField.becomeFirstResponder()
        } else if (textField == passwordField) {
            firstNameField.becomeFirstResponder()
        } else if (textField == firstNameField) {
            lastNameField.becomeFirstResponder()
        } else if (textField == lastNameField) {
            birthdayField.becomeFirstResponder()
        } else if (textField == birthdayField) {
            genderField.becomeFirstResponder()
        } else if (textField == genderField) {
            
            if (passwordField.text == "" || usernameField.text == "" || firstNameField.text == "" || lastNameField.text == "" || birthdayField.text == "" ) {
                // missing creds
            } else {
                nextBtnAction()
            }
            
        } else if (textField == passwordField) {
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let space = " "
        if (string == space) {
            return false
        }
        
        if (textField == usernameField) {
            
            let maxLength = 20
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
            
        } else if (textField == passwordField) {
            
            let minLength = 8
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            
            if (newString.length >= minLength) {
                // show checkmark
                passwordCheckmarkImgView.image = UIImage(named: "heart.png")
            } else {
                // needs to be longer
                passwordCheckmarkImgView.image = UIImage()
            }
            return true
        
        } else {
            
            let maxLength = 50
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
            
        }
        
    }
    
    func nextBtnAction() {
        
        view.endEditing(true)
        
        let vc = SignUpDetailViewController()
        vc.passedEmail = passedEmail
        vc.passedUsername = usernameField.text!
        vc.passedPassword = passwordField.text!
        vc.passedFirstName = firstNameField.text!
        vc.passedLastName = lastNameField.text!
        vc.passedGender = genderField.text!
        
        vc.passedBirthdayDate = birthdayDate
        
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    

}
