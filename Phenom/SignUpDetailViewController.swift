//
//  SignUpDetailViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpDetailViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate , UITableViewDataSource, UITableViewDelegate {

    var passedEmail = ""
    var passedUsername = ""
    var passedPassword = ""
    var passedFirstName = ""
    var passedLastName = ""
    var passedGender = ""
    var passedBirthdayDate = Date?()
    
    var navBarView = UIView()
    var profileImgView = UIImageView()
    var locationField: UITextField = UITextField()
    
    var sportsArray = NSMutableArray()
    
    var theTableView: UITableView = UITableView()
    var selectedCells = NSMutableArray()
    var selectedSports = NSMutableArray()
    
    var signUpBtnBottom = UIButton(type: UIButtonType.custom)
    
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
        titleLbl.text = "PROFILE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let signUpBtnTop = UIButton(type: UIButtonType.custom)
        signUpBtnTop.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        signUpBtnTop.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //signUpBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signUpBtnTop.backgroundColor = UIColor.blue
        signUpBtnTop.addTarget(self, action:#selector(signUpBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(signUpBtnTop)
        
        signUpBtnBottom = UIButton(type: UIButtonType.custom)
        signUpBtnBottom.frame = CGRect(x: 0, y: view.frame.size.height-60, width: view.frame.size.width, height: 60)
        signUpBtnBottom.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //signUpBtnBottom.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signUpBtnBottom.backgroundColor = UINavigationBar.appearance().tintColor
        signUpBtnBottom.addTarget(self, action:#selector(signUpBtnAction), for:UIControlEvents.touchUpInside)
        
        signUpBtnBottom.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        signUpBtnBottom.titleLabel?.numberOfLines = 1
        signUpBtnBottom.contentHorizontalAlignment = .center
        signUpBtnBottom.contentVerticalAlignment = .center
        signUpBtnBottom.titleLabel?.textAlignment = .center
        signUpBtnBottom.setTitleColor(UIColor.white, for: UIControlState())
        signUpBtnBottom.setTitleColor(UIColor.white, for: .highlighted)
        signUpBtnBottom.setTitle("LET'S GO!", for: UIControlState())
        
        view.addSubview(signUpBtnBottom)
        
        //
        
        sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
        
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-60)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        
        let profileWidth = view.frame.size.width/3
        //let profileY = 64+(profileWidth/3)
        let headerHeight = view.frame.size.width/3*2
        
        theTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: headerHeight))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)  
        
        
        //profileImgView.frame = CGRectMake(view.frame.size.width/2-(profileWidth/2), profileY, profileWidth, profileWidth)
        profileImgView.frame = CGRect(x: view.frame.size.width/2-(profileWidth/2), y: headerHeight/2-(profileWidth/2), width: profileWidth, height: profileWidth)
        profileImgView.backgroundColor = UIColor.blue
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
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // TableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 35))
        aLbl.textAlignment = NSTextAlignment.left
        
        switch (section) {
        case 0: aLbl.text = "WHAT DO YOU PLAY?"
        default: aLbl.text = ""}
        
        aLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        aLbl.textColor = UINavigationBar.appearance().tintColor //gold
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        aView.addSubview(aLbl)
        
        return aView;
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sportsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        
        let obj = sportsArray.object(at: indexPath.row) as! String
        cell.textLabel?.text = obj
        
        if (self.selectedCells.contains(indexPath.row)) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let obj = sportsArray.object(at: indexPath.row) as! String
        
        
        if (selectedCells.contains(indexPath.row)) {
            // remove
            selectedCells.remove(indexPath.row)
            selectedSports.remove(obj)
        } else {
            // add
            selectedCells.add(indexPath.row)
            selectedSports.add(obj)
        }
        
        
        theTableView.reloadData()
        
    }
    
    
    func signUpBtnAction() {
        
        if (passedUsername == "" || passedPassword == "" || passedEmail == "" || passedFirstName == "" || passedLastName == "" || passedBirthdayDate == nil || passedGender == "" || selectedSports.count == 0 ) {
            
            print("you shall not pass!")
            return
        }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.shared.delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        
        let utf8str: Data = self.passedPassword.data(using: String.Encoding.utf8)!
        let base64Encoded:NSString = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("base64Encoded: \(base64Encoded)")
        
        let bodyObject = [
            "username": self.passedUsername,
            "password": base64Encoded,
            "firstName" : self.passedFirstName,
            "lastName" : self.passedLastName,
            "email" : self.passedEmail,
            "client_id": (UIApplication.shared.delegate as! AppDelegate).clientId,
            "client_secret": (UIApplication.shared.delegate as! AppDelegate).clientSecret,
            //"grant_type": "password"
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8)
                
                if let dataFromString = datastring!.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    
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
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.shared.delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        
        let utf8str: Data = self.passedPassword.data(using: String.Encoding.utf8)!
        let base64Encoded:NSString = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("base64Encoded: \(base64Encoded)")
        
        let bodyObject = [
            "username": self.passedUsername,
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
            
                    print("received bearer token")
                    
                    let defaults = UserDefaults.standard
                    
                    let newBearerToken = json["access_token"].string!
                    let refreshToken = json["refresh_token"].string!
                    
                    defaults.setObject(newBearerToken, forKey: "bearerToken")
                    defaults.setObject(refreshToken, forKey: "refreshToken")
                    defaults.set(base64Encoded, forKey: "password")
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
        
        let defaults = UserDefaults.standard
        let bearerToken = defaults.string(forKey: "bearerToken")! as String
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.shared.delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
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
        
        let utf8str: Data = self.passedPassword.data(using: String.Encoding.utf8)!
        let base64Encoded:NSString = utf8str.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print("base64Encoded: \(base64Encoded)")
        
        // multi-part request
        
        
        let bodyObject = [
            //"username": self.passedUsername,
            //"password": base64Encoded,
            //"email": self.passedEmail,
            "firstName": self.passedFirstName,
            "lastName": self.passedLastName,
            "sports": self.selectedSports,
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
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        return
                    }

                    print("successful sign up") // follow phenom !!
                    
                    DispatchQueue.main.async(execute: {
                        
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
                    
                    //let sport = json["sport"].string! // make an arrray
                    //let sportsArray = [sport]
                    let sportsArray = json["sports"].arrayObject!
                    
                    //
                    
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
                    
                    NSUserDefaults.standardUserDefaults().setObject(sportsArray, forKey: "sports")
                    
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    //
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        self.navigationController?.pushViewController(InviteFriendsViewController(), animated: true)
                        
                    })
                    
                    
                }
        }
        
        
    }


}
