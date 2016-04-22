//
//  SignUpDetailViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpDetailViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate , UITableViewDataSource, UITableViewDelegate {

    var passedEmail = ""
    var passedUsername = ""
    var passedPassword = ""
    var passedFirstName = ""
    var passedLastName = ""
    var passedGender = ""
    var passedBirthdayDate = NSDate?()
    
    var navBarView = UIView()
    var profileImgView = UIImageView()
    var locationField: UITextField = UITextField()
    
    var sportsArray = NSMutableArray()
    var sportsScrollView = UIScrollView()
    var selectedSportsArray = NSMutableArray()
    
    var theTableView: UITableView = UITableView()
    var selectedCells = NSMutableArray()
    var selectedSports = NSMutableArray()
    
    var signUpBtnBottom = UIButton(type: UIButtonType.Custom)
    
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
        backBtn.frame = CGRectMake(15, 20, 44, 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.clearColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PROFILE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let signUpBtnTop = UIButton(type: UIButtonType.Custom)
        signUpBtnTop.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
        signUpBtnTop.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //signUpBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signUpBtnTop.backgroundColor = UIColor.blueColor()
        signUpBtnTop.addTarget(self, action:#selector(signUpBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(signUpBtnTop)
        
        signUpBtnBottom = UIButton(type: UIButtonType.Custom)
        signUpBtnBottom.frame = CGRectMake(0, view.frame.size.height-60, view.frame.size.width, 60)
        signUpBtnBottom.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //signUpBtnBottom.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signUpBtnBottom.backgroundColor = UINavigationBar.appearance().tintColor
        signUpBtnBottom.addTarget(self, action:#selector(signUpBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        
        signUpBtnBottom.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        signUpBtnBottom.titleLabel?.numberOfLines = 1
        signUpBtnBottom.contentHorizontalAlignment = .Center
        signUpBtnBottom.contentVerticalAlignment = .Center
        signUpBtnBottom.titleLabel?.textAlignment = .Center
        signUpBtnBottom.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpBtnBottom.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        signUpBtnBottom.setTitle("LET'S GO!", forState: .Normal)
        
        view.addSubview(signUpBtnBottom)
        
        //
        
        sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
        
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-60)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        
        let profileWidth = view.frame.size.width/3
        //let profileY = 64+(profileWidth/3)
        let headerHeight = view.frame.size.width/3*2
        
        theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, headerHeight))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)  
        
        
        //profileImgView.frame = CGRectMake(view.frame.size.width/2-(profileWidth/2), profileY, profileWidth, profileWidth)
        profileImgView.frame = CGRectMake(view.frame.size.width/2-(profileWidth/2), headerHeight/2-(profileWidth/2), profileWidth, profileWidth)
        profileImgView.backgroundColor = UIColor.blueColor()
        theTableView.tableHeaderView?.addSubview(profileImgView)
        
//        let locationY = profileY+profileWidth+30
//        locationField.frame = CGRectMake(20, locationY, view.frame.size.width-40, 64)
//        locationField.backgroundColor = UIColor.clearColor()
//        locationField.delegate = self
//        locationField.textColor = UIColor.whiteColor()
//        locationField.attributedPlaceholder = NSAttributedString(string:"your location",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
//        locationField.keyboardType = UIKeyboardType.Default
//        locationField.returnKeyType = UIReturnKeyType.Next
//        locationField.enablesReturnKeyAutomatically = true
//        locationField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
//        locationField.placeholder = "your location"
//        locationField.autocapitalizationType = .Words
//        locationField.autocorrectionType = .No
//        view.addSubview(locationField)
//        locationField.text = ""
        
        
//        sportsScrollView.frame = CGRectMake(0, locationY+64+30, view.frame.size.width, 120)
//        sportsScrollView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
//        sportsScrollView.delegate = self
//        sportsScrollView.pagingEnabled = false
//        sportsScrollView.showsHorizontalScrollIndicator = true
//        sportsScrollView.showsVerticalScrollIndicator = false
//        sportsScrollView.scrollsToTop = true
//        sportsScrollView.scrollEnabled = true
//        sportsScrollView.bounces = true
//        sportsScrollView.alwaysBounceVertical = false
//        sportsScrollView.alwaysBounceHorizontal = true
//        sportsScrollView.userInteractionEnabled = true
//        view.addSubview(sportsScrollView)
//        
//        let padding = 2*sportsArray.count
//        let width = 100*sportsArray.count
//        let totalWidth = CGFloat(width+padding+20+20)
//        sportsScrollView.contentSize = CGSize(width: totalWidth, height: sportsScrollView.frame.size.height)
//        sportsScrollView.contentOffset = CGPoint(x: 0, y: 0)
//        
//        buildSportsScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func buildSportsScrollView() {
        
        for (index, element) in sportsArray.enumerate() {
            print("Item \(index): \(element)")
            
            let sport = element as! String
            let i = CGFloat(index)
            let x = 20+(100*i)
            let pad = 2*i
            let f = CGRectMake(x+pad, 0, 100, 120)
            
            let sportBtn = UIButton(type: UIButtonType.Custom)
            sportBtn.frame = f
            sportBtn.setImage(UIImage(named: "sportBtn-sport.png"), forState: .Normal)
            sportBtn.setImage(UIImage(named: "sportBtn-sport.png"), forState: .Highlighted)
            sportBtn.setImage(UIImage(named: "sportBtn-sport.png"), forState: .Selected)
            
            sportBtn.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            sportBtn.setBackgroundImage(UIImage(named: "goldTabBar.png"), forState: .Selected)
            
            sportBtn.backgroundColor = UIColor.blueColor()
            sportBtn.addTarget(self, action:#selector(sportBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            
            sportBtn.tag = NSInteger(i)
            
            sportBtn.titleLabel?.numberOfLines = 1
            sportBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 13)
            sportBtn.contentHorizontalAlignment = .Center
            sportBtn.contentVerticalAlignment = .Bottom
            sportBtn.titleLabel?.textAlignment = .Center
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            sportBtn.setTitle(sport, forState: UIControlState.Normal)
            
            
            sportsScrollView.addSubview(sportBtn)
            
            
            
        }
        
    }
    
    func sportBtnAction(sender: UIButton) {
        print(sender.tag)
        print(sender.currentTitle!)
        
        if (sender.selected) {
            sender.selected = false
            selectedSportsArray.removeObject(sender.currentTitle!)
        } else {
            sender.selected = true
            selectedSportsArray.addObject(sender.currentTitle!)
        }
    }
    
    
    // TableViewDelegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRectMake(20, 0, view.frame.size.width, 35))
        aLbl.textAlignment = NSTextAlignment.Left
        
        switch (section) {
        case 0: aLbl.text = "WHAT DO YOU PLAY?"
        default: aLbl.text = ""}
        
        aLbl.font = UIFont.boldSystemFontOfSize(12)
        aLbl.textColor = UINavigationBar.appearance().tintColor //gold
        
        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        aView.addSubview(aLbl)
        
        return aView;
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        
        let obj = sportsArray.objectAtIndex(indexPath.row) as! String
        cell.textLabel?.text = obj
        
        if (self.selectedCells.containsObject(indexPath.row)) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        let obj = sportsArray.objectAtIndex(indexPath.row) as! String
        
        
        if (selectedCells.containsObject(indexPath.row)) {
            // remove
            selectedCells.removeObject(indexPath.row)
            selectedSports.removeObject(obj)
        } else {
            // add
            selectedCells.addObject(indexPath.row)
            selectedSports.addObject(obj)
        }
        
        
        theTableView.reloadData()
        
    }
    
    
    func signUpBtnAction() {
        
        if (passedUsername == "" || passedPassword == "" || passedEmail == "" || passedFirstName == "" || passedLastName == "" || passedBirthdayDate == nil || passedGender == "" || selectedSports.count == 0 ) {
            
            print("you shall not pass!")
            return
        }
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        
        let utf8str: NSData = self.passedPassword.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        print("base64Encoded: \(base64Encoded)")
        
        let bodyObject = [
            "username": self.passedUsername,
            "password": base64Encoded,
            "firstName" : self.passedFirstName,
            "lastName" : self.passedLastName,
            "email" : self.passedEmail,
            "client_id": (UIApplication.sharedApplication().delegate as! AppDelegate).clientId,
            "client_secret": (UIApplication.sharedApplication().delegate as! AppDelegate).clientSecret,
            //"grant_type": "password"
        ]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyObject, options: [])
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        return
                    }

                
                    print("user created successfully")
                    
                    //
                    
                    self.oAuth()
                    
                    //
                }
            }
            else {
                
                //                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        
        
    }
    
    
    
    func oAuth() {
        
        // get bearerToken
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        
        let utf8str: NSData = self.passedPassword.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        print("base64Encoded: \(base64Encoded)")
        
        let bodyObject = [
            "username": self.passedUsername,
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
            
                    print("received bearer token")
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    let newBearerToken = json["access_token"].string!
                    let refreshToken = json["refresh_token"].string!
                    
                    defaults.setObject(newBearerToken, forKey: "bearerToken")
                    defaults.setObject(refreshToken, forKey: "refreshToken")
                    defaults.setObject(base64Encoded, forKey: "password")
                    defaults.synchronize()
                    
                    //
                    
                    self.addUserDetails()
                    
                    //
                }
            }
            else {
                
                //                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        
        
    }
    
    
    func addUserDetails() {
        
        print("addUserDetails")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.stringForKey("bearerToken")! as String
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        // need this
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        //
        
//        
//        
//        let boundary = "Boundary-\(NSUUID().UUIDString)" //generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        let selectedImg = UIImage()
//        let imageData = UIImageJPEGRepresentation(selectedImg, 1)
//        
//        if(imageData==nil)  { return; }
//        
//        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
//        
//        
//        
        
        let utf8str: NSData = self.passedPassword.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        print("base64Encoded: \(base64Encoded)")
        
        // multi-part request
        
        
        let bodyObject = [
            //"username": self.passedUsername,
            //"password": base64Encoded,
            //"email": self.passedEmail,
            "firstName": self.passedFirstName,
            "lastName": self.passedLastName,
            "sport": self.selectedSports.lastObject!,
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
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        return
                    }

                    print("successful sign up") // follow phenom !!
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.getUser()
                        
                    })
                    
                    //
                }
            }
            else {
                
                //                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        
    }
    
    
    func getUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.stringForKey("bearerToken")! as String
        
        if (bearerToken == "") {
            // something is wrong
            print("something is wrong")
            return
        }
                
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
                        
                        self.navigationController?.pushViewController(InviteFriendsViewController(), animated: true)
                        
                    })
                    
                }
                
            }
        })
        
        
    }


}
