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
        titleLbl.text = "SIGN IN"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        let signInBtn = UIButton(type: UIButtonType.Custom)
        signInBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        signInBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //signInBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signInBtn.backgroundColor = UIColor.blueColor()
        signInBtn.addTarget(self, action:#selector(self.processFields), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(signInBtn)
        
        usernameField.frame = CGRectMake(20, 64, self.view.frame.size.width-40, 64)
        usernameField.backgroundColor = UIColor.clearColor()
        usernameField.delegate = self
        usernameField.textColor = UIColor.whiteColor()
        usernameField.attributedPlaceholder = NSAttributedString(string:"your username",attributes:[NSForegroundColorAttributeName: UIColor(red:61/255, green:61/255, blue:61/255, alpha:1)])
        usernameField.keyboardType = UIKeyboardType.Default
        usernameField.returnKeyType = UIReturnKeyType.Next
        usernameField.enablesReturnKeyAutomatically = true
        usernameField.font = UIFont.systemFontOfSize(17)
        usernameField.placeholder = "your username"
        usernameField.autocapitalizationType = UITextAutocapitalizationType.None
        usernameField.autocorrectionType = UITextAutocorrectionType.No
        self.view.addSubview(usernameField)
        usernameField.text = ""
        
        passwordField.frame = CGRectMake(20, 64+64, self.view.frame.size.width-40, 64)
        passwordField.backgroundColor = UIColor.clearColor()
        passwordField.delegate = self
        passwordField.textColor = UIColor.whiteColor()
        passwordField.attributedPlaceholder = NSAttributedString(string:"your password",attributes:[NSForegroundColorAttributeName: UIColor(red:61/255, green:61/255, blue:61/255, alpha:1)])
        passwordField.keyboardType = UIKeyboardType.Default
        passwordField.returnKeyType = UIReturnKeyType.Go
        passwordField.enablesReturnKeyAutomatically = true
        passwordField.font = UIFont.systemFontOfSize(17)
        passwordField.placeholder = "your password"
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == usernameField) {
            passwordField.becomeFirstResponder()
        } else if (textField == passwordField) {
            if (passwordField.text == "" || usernameField.text == "") {
                // missing creds
            } else {
                self.processFields()
            }
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let space = " "
        if (string == space) {
            return false
        }
        
        if (textField == self.usernameField) {
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
        
        if (self.usernameField.text != "" && self.passwordField.text != "") {
            
            // get bearerToken
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
            let request = NSMutableURLRequest(URL: URL)
            request.HTTPMethod = "POST"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
            
            let utf8str: NSData = self.passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)!
            //let utf8str = self.passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)
            
            let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            //let base64Encoded = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)

            print("base64Encoded: \(base64Encoded)")
            
            let bodyObject = [
                "username": self.usernameField.text!,
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
                        //self.access_token = json["access_token"].string!
                        //print(self.access_token);
                        
                        print("json: \(json)")
                        // success, save defaults
                        
                        
                        // if 404 error
                        
                        if json["errorCode"].number == 404  {
                            print("error: \(json["errorCode"].number)")
                            
                            
                            
                            return
                        }
                        
                        // add to likedPostIds
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
                    }
                }
                else {
                    
                    //                print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            })
            task.resume()
            
            
            
        }
        
    }
    
    
    func signIn() {
        
        //
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.stringForKey("bearerToken")! as NSString
        
        if (bearerToken == "") {
            // something is wrong
            print("something is wrong")
            return
        }
        
        //
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    
                    print("userJSON: \(json)")
                    
                    // success, save user defaults
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    let userId = json["id"].string!
                    let username = json["username"].string!
                    let hometown = json["hometown"].string!
                    let imageUrl = json["imageUrl"].string!
                    let description = json["description"].string!
                    let firstName = json["firstName"].string!
                    let lastName = json["lastName"].string!
                    
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
            else {
                
                //                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        
    }


}
