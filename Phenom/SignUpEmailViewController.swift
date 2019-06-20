//
//  SignUpEmailViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/4/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class SignUpEmailViewController: UIViewController, UITextFieldDelegate {
    
    var navBarView = UIView()
    var emailField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.custom)
        xBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blue
        xBtn.addTarget(self, action:#selector(xBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "VERIFY EMAIL"
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
        
        emailField.frame = CGRect(x: 20, y: 64, width: view.frame.size.width-40, height: 64)
        emailField.backgroundColor = UIColor.clear
        emailField.delegate = self
        emailField.textColor = UIColor.white
        emailField.attributedPlaceholder = NSAttributedString(string:"your email",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        emailField.keyboardType = .emailAddress
        emailField.returnKeyType = .next
        emailField.enablesReturnKeyAutomatically = true
        emailField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        emailField.placeholder = "your email"
        emailField.autocapitalizationType = UITextAutocapitalizationType.none
        emailField.autocorrectionType = UITextAutocorrectionType.no
        view.addSubview(emailField)
        emailField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRect(x: 0, y: 64+63.5, width: view.frame.size.width, height: 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.becomeFirstResponder()
        
    }
    
    func xBtnAction() {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (emailField.text == "") {
            // missing creds
        } else {
            nextBtnAction()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let space = " "
        if (string == space) {
            return false
        }
        
        if (textField == emailField) {
            let maxLength = 50
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
        } else {
            let maxLength = 35
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
        }
        
    }

    func nextBtnAction() {
        
        let vc = SignUpViewController()
        vc.passedEmail = emailField.text!
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
