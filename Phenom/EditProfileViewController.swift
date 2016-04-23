//
//  EditProfileViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditProfileViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var navBarView = UIView()
    
    var passedEditType = ""
    
    var textField1: UITextField = UITextField()
    var textField2: UITextField = UITextField()

    var sportsArray = NSMutableArray()
    
    var theTableView: UITableView = UITableView()
    var selectedCells = NSMutableArray()
    var selectedSports = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor.blackColor()
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor.blackColor()
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(15, 20, 44, 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.blueColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        //titleLbl.text = "EDIT PROFILE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let saveBtn = UIButton(type: UIButtonType.Custom)
        saveBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
        saveBtn.setImage(UIImage(named: "save-btn.png"), forState: UIControlState.Normal)
        saveBtn.backgroundColor = UIColor.blueColor()
        saveBtn.addTarget(self, action:#selector(saveBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(saveBtn)
        
        textField1.frame = CGRectMake(20, 64, view.frame.size.width-40, 64)
        textField1.backgroundColor = UIColor.clearColor()
        textField1.delegate = self
        textField1.textColor = UIColor.whiteColor()
        textField1.keyboardType = UIKeyboardType.Default
        textField1.returnKeyType = UIReturnKeyType.Next
        textField1.enablesReturnKeyAutomatically = true
        textField1.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        textField1.autocapitalizationType = UITextAutocapitalizationType.None
        textField1.autocorrectionType = UITextAutocorrectionType.No
        textField1.text = ""
        
        textField2.frame = CGRectMake(20, 64+64, view.frame.size.width-40, 64)
        textField2.backgroundColor = UIColor.clearColor()
        textField2.delegate = self
        textField2.textColor = UIColor.whiteColor()
        textField2.keyboardType = UIKeyboardType.Default
        textField2.returnKeyType = UIReturnKeyType.Go
        textField2.enablesReturnKeyAutomatically = true
        textField2.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        textField2.autocapitalizationType = UITextAutocapitalizationType.None
        textField2.autocorrectionType = UITextAutocorrectionType.No
        textField2.secureTextEntry = false
        textField2.text = ""
        
        let lineview1 = UIView()
        lineview1.frame = CGRectMake(0, 64+63.5, view.frame.size.width, 0.5)
        lineview1.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview1)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        
        /////
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        
        ////
        
        let defaults = NSUserDefaults.standardUserDefaults()

//        defaults.setObject(self.username, forKey: "username")
//        defaults.setObject(self.hometown, forKey: "hometown")
//        defaults.setObject(self.imageUrl, forKey: "imageUrl")
//        defaults.setObject(self.bio, forKey: "description")
//        defaults.setObject(self.firstName, forKey: "firstName")
//        defaults.setObject(self.lastName, forKey: "lastName")
//        defaults.setObject(self.followersCount, forKey: "followersCount")
//        defaults.setObject(self.followingCount, forKey: "followingCount")
//        defaults.setObject(self.momentCount, forKey: "momentCount")
//        defaults.setObject(self.lockerProductCount, forKey: "lockerProductCount")
//        defaults.setObject(self.sports, forKey: "sports")
//        defaults.synchronize()
        
        if (passedEditType == "name") {
            
            let firstName = defaults.objectForKey("firstName") as! String
            let lastName = defaults.objectForKey("lastName") as! String
            
            titleLbl.text = "NAME"
            textField1.placeholder = "your first name"
            textField1.text = firstName
            textField2.placeholder = "your last name"
            textField2.text = lastName
            view.addSubview(textField1)
            view.addSubview(textField2)
            view.addSubview(lineview2)
            
        } else if (passedEditType == "username") {
            
            let username = defaults.objectForKey("username") as! String
            
            titleLbl.text = "USERNAME"
            textField1.placeholder = "username"
            textField1.text = username
            view.addSubview(textField1)
            
        } else if (passedEditType == "birthday") {
            
            let birthday = defaults.objectForKey("birthday") as! NSDate
            
            titleLbl.text = "BIRTHDAY"
            textField1.placeholder = "your birthday"
            textField1.text = "\(birthday)"
            view.addSubview(textField1)
            
        } else if (passedEditType == "hometown") {
            
            let hometown = defaults.objectForKey("hometown") as! String
            
            titleLbl.text = "HOMETOWN"
            textField1.placeholder = "your hometown"
            textField1.text = hometown
            view.addSubview(textField1)
            
        } else if (passedEditType == "sports") {
            
            sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
            
//            let sports = defaults.objectForKey("sports") as! NSArray
//            let sportsMA = sports as! NSMutableArray
//            self.selectedSports = sportsMA
//            
//            for obj in sportsArray {
//                
//                if selectedSports.containsObject(obj) {
//                    
//                    let index = sportsArray.indexOfObject(obj)
//                    let ip = NSIndexPath(forRow: index, inSection: 0)
//                    self.selectedCells.addObject(ip)
//                }
//                
//            }
//            
            
            titleLbl.text = "SPORTS"
            
            // show tableview
            view.addSubview(theTableView)
            
            self.theTableView.reloadData()
            
            
        } else if (passedEditType == "bio") {
            
            let bio = defaults.objectForKey("description") as! String
            
            titleLbl.text = "BIO"
            textField1.placeholder = "bio"
            textField1.text = bio
            view.addSubview(textField1)
            
            
        } else if (passedEditType == "email") {
            
            let email = defaults.objectForKey("email") as! String
            
            titleLbl.text = "EMAIL"
            textField1.placeholder = "your email"
            textField1.text = email
            view.addSubview(textField1)
            
        } else if (passedEditType == "password") {
            
            titleLbl.text = "PASSWORD"
            textField1.placeholder = "confirm your password"
            view.addSubview(textField1)
            
        } else {
            print("something is wrongggg")
        }
        
        //
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (passedEditType == "name" || passedEditType == "username" || passedEditType == "birthday" || passedEditType == "hometown" || passedEditType == "name" || passedEditType == "bio" || passedEditType == "email" || passedEditType == "password") {
            
            textField1.becomeFirstResponder()
        }
        
    }
    
    func backAction() {
        view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
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
        
        aLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
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
    
    
    
    
    func saveBtnAction() {
        
        // if logged in correctly
        
        // get bearerToken
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! String
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
//        let utf8str: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)!
//        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//        print("base64Encoded: \(base64Encoded)")
        
        
        let bodyObject = [
            
            "\(passedEditType)" : textField1.text!,
            
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
