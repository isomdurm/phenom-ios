//
//  SignInViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignInViewController: UIViewController, UITextFieldDelegate {

    var navBarView = UIView()
    var usernameField: UITextField = UITextField()
    var passwordField: UITextField = UITextField()
    
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
        titleLbl.text = "SIGN IN"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let signInBtn = UIButton(type: UIButtonType.custom)
        signInBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        signInBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //signInBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signInBtn.backgroundColor = UIColor.blue
        signInBtn.addTarget(self, action:#selector(processFields), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(signInBtn)
        
        usernameField.frame = CGRect(x: 20, y: 64, width: view.frame.size.width-40, height: 64)
        usernameField.backgroundColor = UIColor.clear
        usernameField.delegate = self
        usernameField.textColor = UIColor.white
        usernameField.attributedPlaceholder = NSAttributedString(string:"your username",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        usernameField.keyboardType = UIKeyboardType.default
        usernameField.returnKeyType = UIReturnKeyType.next
        usernameField.enablesReturnKeyAutomatically = true
        usernameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        usernameField.placeholder = "your username"
        usernameField.autocapitalizationType = UITextAutocapitalizationType.none
        usernameField.autocorrectionType = UITextAutocorrectionType.no
        view.addSubview(usernameField)
        usernameField.text = ""
        
        passwordField.frame = CGRect(x: 20, y: 64+64, width: view.frame.size.width-40, height: 64)
        passwordField.backgroundColor = UIColor.clear
        passwordField.delegate = self
        passwordField.textColor = UIColor.white
        passwordField.attributedPlaceholder = NSAttributedString(string:"your password",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        passwordField.keyboardType = UIKeyboardType.default
        passwordField.returnKeyType = UIReturnKeyType.go
        passwordField.enablesReturnKeyAutomatically = true
        passwordField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        passwordField.placeholder = "your password"
        passwordField.autocapitalizationType = UITextAutocapitalizationType.none
        passwordField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.isSecureTextEntry = true
        view.addSubview(passwordField)
        passwordField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRect(x: 0, y: 64+63.5, width: view.frame.size.width, height: 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRect(x: 0, y: 64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.becomeFirstResponder()
        
    }
    
    func xBtnAction() {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == usernameField) {
            passwordField.becomeFirstResponder()
        } else if (textField == passwordField) {
            if (passwordField.text == "" || usernameField.text == "") {
                // missing creds
            } else {
                processFields()
            }
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
        } else {
            let maxLength = 35
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
        }
        
    }
    
    
    func processFields() {
        
        // if logged in correctly
        
        if (usernameField.text != "" && passwordField.text != "") {
            
            // get bearerToken
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            guard let URL = URL(string: "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
            let request = NSMutableURLRequest(url: URL)
            request.httpMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\((UIApplication.shared.delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
            
            let utf8str: Data = passwordField.text!.data(using: String.Encoding.utf8)!
            let base64Encoded:NSString = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            print("base64Encoded: \(base64Encoded)")
            
            let bodyObject = [
                "username": usernameField.text!,
                "password": base64Encoded,
                "client_id": (UIApplication.shared.delegate as! AppDelegate).clientId,
                "client_secret": (UIApplication.shared.delegate as! AppDelegate).clientSecret,
                "grant_type": "password"
            ]
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
            
            let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    
                    let datastring = NSString(data: data!, encoding: String.Encoding.utf8)
                    
                    if let dataFromString = datastring!.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                        
                        let json = JSON(data: dataFromString)
                        if (json["errorCode"].number == nil) {
                            
                            print("u shall pass")
                            
                        } else {
                            // double check
                            if json["errorCode"].number != 200 {
                                print("json: \(json)")
                                print("error: \(json["errorCode"].number)")
                                return
                            }
                        }

                        
                        // add to likedMomentIds
                        let defaults = UserDefaults.standard
                        
                        let newBearerToken = json["access_token"].string!
                        let refreshToken = json["refresh_token"].string!
                        
                        defaults.setObject(newBearerToken, forKey: "bearerToken")
                        defaults.setObject(refreshToken, forKey: "refreshToken")
                        defaults.set(base64Encoded, forKey: "password")
                        defaults.synchronize()
                        
                        //
                        
                        self.signIn()
                        
                        //
                    } else {
                        print("no data string ?")
                    }
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                    
                }
            })
            task.resume()            
            
        }
        
    }
    
    
    func signIn() {
        
        //
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        
        if (bearerToken == "") {
            // something is wrong
            print("something is wrong")
            return
        }
        
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    // success, save user defaults
                    
                    let json = JSON(data: response.data!)
                    
                    let userId = json["id"].string!
                    let username = json["username"].string!
                    let hometown = json["hometown"].string!
                    let imageUrl = json["imageUrl"].string!
                    let description = json["description"].string!
                    let firstName = json["firstName"].string!
                    let lastName = json["lastName"].string!
                    let email = json["email"].string!
                    
                    let followersCount = json["followersCount"].number!
                    let followingCount = json["followingCount"].number!
                    
                    let momentCount = json["momentCount"].number!
                    let lockerProductCount = json["lockerProductCount"].number!
                    
//                    let sport = json["sport"].string! // make an arrray
//                    let sportsArray = [sport]
//                    
                    var sportsArray = []
                    if (json["sports"].arrayObject != nil) {
                        sportsArray = json["sports"].arrayObject!
                    } else {
                        sportsArray = [json["sport"].string!]
                    }
                    
                    
                    
                    NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                    NSUserDefaults.standardUserDefaults().setObject(hometown, forKey: "hometown")
                    NSUserDefaults.standardUserDefaults().setObject(imageUrl, forKey: "imageUrl")
                    NSUserDefaults.standardUserDefaults().setObject(description, forKey: "description")
                    NSUserDefaults.standardUserDefaults().setObject(firstName, forKey: "firstName")
                    NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "lastName")
                    NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
                    NSUserDefaults.standardUserDefaults().setObject(followersCount, forKey: "followersCount")
                    NSUserDefaults.standardUserDefaults().setObject(followingCount, forKey: "followingCount")
                    
                    NSUserDefaults.standardUserDefaults().setObject(momentCount, forKey: "momentCount")
                    NSUserDefaults.standardUserDefaults().setObject(lockerProductCount, forKey: "lockerProductCount")
                    
                    NSUserDefaults.standardUserDefaults().setObject(sportsArray, forKey: "sport")
                    
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    //
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.view.endEditing(true)
                        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
                        (UIApplication.sharedApplication().delegate as! AppDelegate).presentTabBarViewController()
                        
                    })
                    
                }
        }
        
    }


}
