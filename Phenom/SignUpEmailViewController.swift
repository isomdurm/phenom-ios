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
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor.blackColor()
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(self.xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "VERIFY EMAIL"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        let nextBtn = UIButton(type: .Custom)
        nextBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        nextBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //nextBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        nextBtn.backgroundColor = UIColor.blueColor()
        nextBtn.addTarget(self, action:#selector(self.nextBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(nextBtn)
        
        emailField.frame = CGRectMake(20, 64, self.view.frame.size.width-40, 64)
        emailField.backgroundColor = UIColor.clearColor()
        emailField.delegate = self
        emailField.textColor = UIColor.whiteColor()
        emailField.attributedPlaceholder = NSAttributedString(string:"your email",attributes:[NSForegroundColorAttributeName: UIColor(red:61/255, green:61/255, blue:61/255, alpha:1)])
        emailField.keyboardType = .EmailAddress
        emailField.returnKeyType = .Next
        emailField.enablesReturnKeyAutomatically = true
        emailField.font = UIFont.systemFontOfSize(17)
        emailField.placeholder = "your email"
        emailField.autocapitalizationType = UITextAutocapitalizationType.None
        emailField.autocorrectionType = UITextAutocorrectionType.No
        self.view.addSubview(emailField)
        emailField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 64+63.5, self.view.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.view.addSubview(lineview)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.becomeFirstResponder()
    }
    
    func xBtnAction() {
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (emailField.text == "") {
            // missing creds
        } else {
            self.nextBtnAction()
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let space = " "
        if (string == space) {
            return false
        }
        
        if (textField == self.emailField) {
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
        
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    

}
