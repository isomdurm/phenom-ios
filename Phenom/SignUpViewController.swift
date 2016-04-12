//
//  SignUpViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var navBarView = UIView()
    var usernameField: UITextField = UITextField()
    var passwordField: UITextField = UITextField()
    var firstNameField: UITextField = UITextField()
    var lastNameField: UITextField = UITextField()
    var birthdayField: UITextField = UITextField()
    var genderField: UITextField = UITextField()
    let genderData = ["M","F"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.blueColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "SIGN UP"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let nextBtn = UIButton(type: .Custom)
        nextBtn.frame = CGRectMake(view.frame.size.width-70-20, 20, 70, 44)
        nextBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //nextBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        nextBtn.backgroundColor = UIColor.blueColor()
        nextBtn.addTarget(self, action:#selector(nextBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(nextBtn)
        
        usernameField.frame = CGRectMake(20, 64, view.frame.size.width-40, 64)
        usernameField.backgroundColor = UIColor.clearColor()
        usernameField.delegate = self
        usernameField.textColor = UIColor.whiteColor()
        usernameField.attributedPlaceholder = NSAttributedString(string:"your new username",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        usernameField.keyboardType = .Default
        usernameField.returnKeyType = .Next
        usernameField.enablesReturnKeyAutomatically = true
        usernameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        usernameField.placeholder = "your new username"
        usernameField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameField.autocorrectionType = UITextAutocorrectionType.No
        usernameField.tag = 0
        view.addSubview(usernameField)
        usernameField.text = ""
        
        passwordField.frame = CGRectMake(20, 64+64, view.frame.size.width-40, 64)
        passwordField.backgroundColor = UIColor.clearColor()
        passwordField.delegate = self
        passwordField.textColor = UIColor.whiteColor()
        passwordField.attributedPlaceholder = NSAttributedString(string:"your new password",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        passwordField.keyboardType = .Default
        passwordField.returnKeyType = .Next
        passwordField.enablesReturnKeyAutomatically = true
        passwordField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        passwordField.placeholder = "your new password"
        passwordField.autocapitalizationType = UITextAutocapitalizationType.None
        passwordField.autocorrectionType = UITextAutocorrectionType.No
        passwordField.secureTextEntry = true
        passwordField.tag = 1
        view.addSubview(passwordField)
        passwordField.text = ""
        
        firstNameField.frame = CGRectMake(20, 64+64+64, view.frame.size.width/2-40, 64)
        firstNameField.backgroundColor = UIColor.clearColor()
        firstNameField.delegate = self
        firstNameField.textColor = UIColor.whiteColor()
        firstNameField.attributedPlaceholder = NSAttributedString(string:"first name",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        firstNameField.keyboardType = .Default
        firstNameField.returnKeyType = .Next
        firstNameField.enablesReturnKeyAutomatically = true
        firstNameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        firstNameField.placeholder = "first name"
        firstNameField.tag = 2
        view.addSubview(firstNameField)
        firstNameField.text = ""
        
        lastNameField.frame = CGRectMake(view.frame.size.width/2+20, 64+64+64, view.frame.size.width/2-40, 64)
        lastNameField.backgroundColor = UIColor.clearColor()
        lastNameField.delegate = self
        lastNameField.textColor = UIColor.whiteColor()
        lastNameField.attributedPlaceholder = NSAttributedString(string:"last name",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        lastNameField.keyboardType = .Default
        lastNameField.returnKeyType = .Next
        lastNameField.enablesReturnKeyAutomatically = true
        lastNameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        lastNameField.placeholder = "last name"
        lastNameField.autocapitalizationType = UITextAutocapitalizationType.None
        lastNameField.autocorrectionType = UITextAutocorrectionType.No
        lastNameField.tag = 3
        view.addSubview(lastNameField)
        lastNameField.text = ""
        
        birthdayField.frame = CGRectMake(20, 64+64+64+64, view.frame.size.width-40, 64)
        birthdayField.backgroundColor = UIColor.clearColor()
        birthdayField.delegate = self
        birthdayField.textColor = UIColor.whiteColor()
        birthdayField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        birthdayField.placeholder = "birthday"
        birthdayField.addTarget(self, action: #selector(birthdayFieldEditing), forControlEvents: .EditingDidBegin)
        birthdayField.tag = 5
        view.addSubview(birthdayField)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        birthdayField.text = "" //dateFormatter.stringFromDate(NSDate())
        birthdayField.attributedPlaceholder = NSAttributedString(string:"birthday",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        
        genderField.frame = CGRectMake(20, 64+64+64+64+64, view.frame.size.width-40, 64)
        genderField.backgroundColor = UIColor.clearColor()
        genderField.delegate = self
        genderField.textColor = UIColor.whiteColor()
        genderField.attributedPlaceholder = NSAttributedString(string:"gender",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        genderField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        genderField.placeholder = "gender"
        genderField.addTarget(self, action: #selector(genderFieldEditing), forControlEvents: .EditingDidBegin)
        genderField.tag = 5
        view.addSubview(genderField)
        genderField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 64+63.5, view.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2)
        
        let lineview2a = UIView()
        lineview2a.frame = CGRectMake(view.frame.size.width/2-0.25, 64+64+63.5, 0.5, 64)
        lineview2a.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2a)
        
        let lineview3 = UIView()
        lineview3.frame = CGRectMake(0, 64+64+64+63.5, view.frame.size.width, 0.5)
        lineview3.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview3)
        
        let lineview4 = UIView()
        lineview4.frame = CGRectMake(0, 64+64+64+64+63.5, view.frame.size.width, 0.5)
        lineview4.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview4)
        
        let lineview5 = UIView()
        lineview5.frame = CGRectMake(0, 64+64+64+64+64+63.5, view.frame.size.width, 0.5)
        lineview5.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview5)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameField.becomeFirstResponder()
    }
    
    func backAction() {
        view.endEditing(true)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func birthdayFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.maximumDate = NSDate()
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(birthdayPickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func birthdayPickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        birthdayField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    
    // genderPicker
    
    func genderFieldEditing(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        sender.inputView = pickerView
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderField.text = genderData[row]
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let space = " "
        if (string == space) {
            return false
        }
        
        if (textField == usernameField) {
            let maxLength = 20
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        } else {
            let maxLength = 50
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        
    }
    
    func nextBtnAction() {
        
        view.endEditing(true)
        navigationController?.pushViewController(SignUpDetailViewController(), animated: true)
        
    }
    

}
