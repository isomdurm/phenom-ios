//
//  SignUpViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var navBarView = UIView()
    var usernameField: UITextField = UITextField()
    var passwordField: UITextField = UITextField()
    
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
        xBtn.addTarget(self, action:#selector(SignInViewController.xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, self.navBarView.frame.size.width, 64))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "SIGN IN"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        usernameField.frame = CGRectMake(20, 64, self.view.frame.size.width-40, 64)
        usernameField.backgroundColor = UIColor.clearColor()
        usernameField.delegate = self
        usernameField.textColor = UIColor(red:51/255, green:51/255, blue:51/255, alpha:1)
        usernameField.keyboardType = UIKeyboardType.Default
        usernameField.returnKeyType = UIReturnKeyType.Next
        usernameField.enablesReturnKeyAutomatically = true
        usernameField.font = UIFont.systemFontOfSize(17)
        usernameField.placeholder = "your new username"
        usernameField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameField.autocorrectionType = UITextAutocorrectionType.No
        self.view.addSubview(usernameField)
        usernameField.text = ""
        
        passwordField.frame = CGRectMake(20, 64+64, self.view.frame.size.width-40, 64)
        passwordField.backgroundColor = UIColor.clearColor()
        passwordField.delegate = self
        passwordField.textColor = UIColor(red:51/255, green:51/255, blue:51/255, alpha:1)
        passwordField.keyboardType = UIKeyboardType.Default
        passwordField.returnKeyType = UIReturnKeyType.Go
        passwordField.enablesReturnKeyAutomatically = true
        passwordField.font = UIFont.systemFontOfSize(17)
        passwordField.placeholder = "your new password"
        passwordField.autocapitalizationType = UITextAutocapitalizationType.None
        passwordField.autocorrectionType = UITextAutocorrectionType.No
        passwordField.secureTextEntry = true
        self.view.addSubview(passwordField)
        passwordField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 64+63.5, self.view.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, self.view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.view.addSubview(lineview2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameField.becomeFirstResponder()
    }
    
    func xBtnAction() {
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
