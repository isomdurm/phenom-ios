//
//  SignUpEmailViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/4/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class SignUpEmailViewController: UIViewController, UITextFieldDelegate {
    
    var navBarView = UIView()
    var emailField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "VERIFY EMAIL"
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
        
        emailField.frame = CGRectMake(20, 64, view.frame.size.width-40, 64)
        emailField.backgroundColor = UIColor.clearColor()
        emailField.delegate = self
        emailField.textColor = UIColor.whiteColor()
        emailField.attributedPlaceholder = NSAttributedString(string:"your email",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        emailField.keyboardType = .EmailAddress
        emailField.returnKeyType = .Next
        emailField.enablesReturnKeyAutomatically = true
        emailField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        emailField.placeholder = "your email"
        emailField.autocapitalizationType = UITextAutocapitalizationType.None
        emailField.autocorrectionType = UITextAutocorrectionType.No
        view.addSubview(emailField)
        emailField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 64+63.5, view.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.becomeFirstResponder()
        
    }
    
    func xBtnAction() {
        view.endEditing(true)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (emailField.text == "") {
            // missing creds
        } else {
            nextBtnAction()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let space = " "
        if (string == space) {
            return false
        }
        
        if (textField == emailField) {
            let maxLength = 50
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        } else {
            let maxLength = 35
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        
    }

    func nextBtnAction() {
        
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    

}
