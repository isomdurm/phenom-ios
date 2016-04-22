//
//  SignInViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignInViewController: UIViewController, UITextFieldDelegate {

    var navBarView = UIView()
    var usernameField: UITextField = UITextField()
    var passwordField: UITextField = UITextField()
    
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
        xBtn.frame = CGRectMake(15, 20, 44, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "SIGN IN"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let signInBtn = UIButton(type: UIButtonType.Custom)
        signInBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
        signInBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //signInBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signInBtn.backgroundColor = UIColor.blueColor()
        signInBtn.addTarget(self, action:#selector(processFields), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(signInBtn)
        
        usernameField.frame = CGRectMake(20, 64, view.frame.size.width-40, 64)
        usernameField.backgroundColor = UIColor.clearColor()
        usernameField.delegate = self
        usernameField.textColor = UIColor.whiteColor()
        usernameField.attributedPlaceholder = NSAttributedString(string:"your username",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        usernameField.keyboardType = UIKeyboardType.Default
        usernameField.returnKeyType = UIReturnKeyType.Next
        usernameField.enablesReturnKeyAutomatically = true
        usernameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        usernameField.placeholder = "your username"
        usernameField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameField.autocorrectionType = UITextAutocorrectionType.No
        view.addSubview(usernameField)
        usernameField.text = ""
        
        passwordField.frame = CGRectMake(20, 64+64, view.frame.size.width-40, 64)
        passwordField.backgroundColor = UIColor.clearColor()
        passwordField.delegate = self
        passwordField.textColor = UIColor.whiteColor()
        passwordField.attributedPlaceholder = NSAttributedString(string:"your password",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        passwordField.keyboardType = UIKeyboardType.Default
        passwordField.returnKeyType = UIReturnKeyType.Go
        passwordField.enablesReturnKeyAutomatically = true
        passwordField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        passwordField.placeholder = "your password"
        passwordField.autocapitalizationType = UITextAutocapitalizationType.None
        passwordField.autocorrectionType = UITextAutocorrectionType.No
        passwordField.secureTextEntry = true
        view.addSubview(passwordField)
        passwordField.text = ""
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 64+63.5, view.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        usernameField.becomeFirstResponder()
        
    }
    
    func xBtnAction() {
        view.endEditing(true)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
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
            let maxLength = 35
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        
    }
    
    
    func processFields() {
        
        // if logged in correctly
        
        if (usernameField.text != "" && passwordField.text != "") {
            
            // get bearerToken
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
            
            let utf8str: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            print("base64Encoded: \(base64Encoded)")
            
            let bodyObject = [
                "username": usernameField.text!,
                "password": base64Encoded,
                "client_id": (UIApplication.sharedApplication().delegate as! AppDelegate).clientId,
                "client_secret": (UIApplication.sharedApplication().delegate as! AppDelegate).clientSecret,
                "grant_type": "password"
            ]
            
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyObject, options: [])
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    
                    let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    
                    if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                        
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
                        let defaults = NSUserDefaults.standardUserDefaults()
                        
                        let newBearerToken = json["access_token"].string!
                        let refreshToken = json["refresh_token"].string!
                        
                        defaults.setObject(newBearerToken, forKey: "bearerToken")
                        defaults.setObject(refreshToken, forKey: "refreshToken")
                        defaults.setObject(base64Encoded, forKey: "password")
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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.stringForKey("bearerToken")! as String
        
        if (bearerToken == "") {
            // something is wrong
            print("something is wrong")
            return
        }
        
        //
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = ""
        let type = "GET"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sendRequest(url, parameters: params, type: type, completionHandler:  { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        return
                    }
                    
                    
                    // success, save user defaults
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
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
                    
                    let sport = json["sport"].string! // make an arrray
                    let sportsArray = [sport]
                    
                    //
                    
                    defaults.setObject(userId, forKey: "userId")
                    defaults.setObject(username, forKey: "username")
                    defaults.setObject(hometown, forKey: "hometown")
                    defaults.setObject(imageUrl, forKey: "imageUrl")
                    defaults.setObject(description, forKey: "description")
                    defaults.setObject(firstName, forKey: "firstName")
                    defaults.setObject(lastName, forKey: "lastName")
                    defaults.setObject(email, forKey: "email")
                    defaults.setObject(followersCount, forKey: "followersCount")
                    defaults.setObject(followingCount, forKey: "followingCount")
                    
                    defaults.setObject(momentCount, forKey: "momentCount")
                    defaults.setObject(lockerProductCount, forKey: "lockerProductCount")
                    
                    defaults.setObject(sportsArray, forKey: "sports")
                    
                    defaults.synchronize()
                    
                    //
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.view.endEditing(true)
                        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
                        (UIApplication.sharedApplication().delegate as! AppDelegate).presentTabBarViewController()
                        
                    })
                    
                }
                
            }
        })
        
    }


}
