//
//  EditProfileViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor.black
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor.black
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
        //titleLbl.text = "EDIT PROFILE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let saveBtn = UIButton(type: UIButtonType.custom)
        saveBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        saveBtn.setImage(UIImage(named: "save-btn.png"), for: UIControlState())
        saveBtn.backgroundColor = UIColor.blue
        saveBtn.addTarget(self, action:#selector(saveBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(saveBtn)
        
        textField1.frame = CGRect(x: 20, y: 64, width: view.frame.size.width-40, height: 64)
        textField1.backgroundColor = UIColor.clear
        textField1.delegate = self
        textField1.textColor = UIColor.white
        textField1.keyboardType = UIKeyboardType.default
        textField1.returnKeyType = UIReturnKeyType.next
        textField1.enablesReturnKeyAutomatically = true
        textField1.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        textField1.autocapitalizationType = UITextAutocapitalizationType.none
        textField1.autocorrectionType = UITextAutocorrectionType.no
        textField1.text = ""
        
        textField2.frame = CGRect(x: 20, y: 64+64, width: view.frame.size.width-40, height: 64)
        textField2.backgroundColor = UIColor.clear
        textField2.delegate = self
        textField2.textColor = UIColor.white
        textField2.keyboardType = UIKeyboardType.default
        textField2.returnKeyType = UIReturnKeyType.go
        textField2.enablesReturnKeyAutomatically = true
        textField2.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        textField2.autocapitalizationType = UITextAutocapitalizationType.none
        textField2.autocorrectionType = UITextAutocorrectionType.no
        textField2.isSecureTextEntry = false
        textField2.text = ""
        
        let lineview1 = UIView()
        lineview1.frame = CGRect(x: 0, y: 64+63.5, width: view.frame.size.width, height: 0.5)
        lineview1.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview1)
        
        let lineview2 = UIView()
        lineview2.frame = CGRect(x: 0, y: 64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        
        /////
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        
        ////
        
        let defaults = UserDefaults.standard

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
            
            let firstName = defaults.object(forKey: "firstName") as! String
            let lastName = defaults.object(forKey: "lastName") as! String
            
            titleLbl.text = "NAME"
            textField1.placeholder = "your first name"
            textField1.text = firstName
            textField2.placeholder = "your last name"
            textField2.text = lastName
            view.addSubview(textField1)
            view.addSubview(textField2)
            view.addSubview(lineview2)
            
        } else if (passedEditType == "username") {
            
            let username = defaults.object(forKey: "username") as! String
            
            titleLbl.text = "USERNAME"
            textField1.placeholder = "username"
            textField1.text = username
            view.addSubview(textField1)
            
        } else if (passedEditType == "birthday") {
            
            let birthday = defaults.object(forKey: "birthday") as! Date
            
            titleLbl.text = "BIRTHDAY"
            textField1.placeholder = "your birthday"
            textField1.text = "\(birthday)"
            view.addSubview(textField1)
            
        } else if (passedEditType == "hometown") {
            
            let hometown = defaults.object(forKey: "hometown") as! String
            
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
            
            let bio = defaults.object(forKey: "description") as! String
            
            titleLbl.text = "BIO"
            textField1.placeholder = "bio"
            textField1.text = bio
            view.addSubview(textField1)
            
            
        } else if (passedEditType == "email") {
            
            let email = defaults.object(forKey: "email") as! String
            
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
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (passedEditType == "name" || passedEditType == "username" || passedEditType == "birthday" || passedEditType == "hometown" || passedEditType == "name" || passedEditType == "bio" || passedEditType == "email" || passedEditType == "password") {
            
            textField1.becomeFirstResponder()
        }
        
    }
    
    func backAction() {
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
    
    
    
    
    func saveBtnAction() {
        
        // if logged in correctly
        
        // get bearerToken
        let defaults = UserDefaults.standard
        let bearerToken = defaults.object(forKey: "bearerToken") as! String
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        guard let URL = URL(string: "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(url: URL)
        request.httpMethod = "PUT"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.shared.delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
//        let utf8str: NSData = passwordField.text!.dataUsingEncoding(NSUTF8StringEncoding)!
//        let base64Encoded:NSString = utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
//        print("base64Encoded: \(base64Encoded)")
        
        
        let bodyObject = [
            
            "\(passedEditType)" : textField1.text!,
            
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
