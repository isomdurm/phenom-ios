//
//  ExploreViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//


import UIKit
import QuartzCore
import SwiftyJSON
import Haneke

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var theTextField = UITextField()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    
    var peopleData = NSData()
    var gearData = NSData()
    
    var tabBtn1 = UIButton(type: UIButtonType.Custom)
    var tabBtn2 = UIButton(type: UIButtonType.Custom)
    
    var isTyping: Bool = false
    var savedSearchArray = NSMutableArray()
    
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
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.clearColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "EXPLORE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        //
        
        let searchContainerView = UIView()
        searchContainerView.frame = CGRectMake(0, 64, self.view.frame.size.width, 44)
        searchContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(searchContainerView)
        
        let bg = UIView()
        bg.frame = CGRectMake(15, 5, view.frame.size.width-30, 34)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        searchContainerView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        theTextField.frame = CGRectMake(15+14, 6, searchContainerView.frame.size.width-50, 34)
        theTextField.backgroundColor = UIColor.clearColor()
        theTextField.delegate = self
        theTextField.textColor = UIColor.whiteColor() // UIColor(red:42/255, green:42/255, blue:42/255, alpha:1)
        theTextField.keyboardType = UIKeyboardType.Default
        theTextField.returnKeyType = UIReturnKeyType.Search
        theTextField.enablesReturnKeyAutomatically = true
        theTextField.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        theTextField.placeholder = "Search people and gear!"
        theTextField.autocapitalizationType = UITextAutocapitalizationType.None
        theTextField.autocorrectionType = UITextAutocorrectionType.No
        theTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        searchContainerView.addSubview(theTextField)
        //theTextField.addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        theTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRectMake(0, 64+44, view.frame.size.width, 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(tabView)
        
        tabBtn1.frame = CGRectMake(0, 0, tabView.frame.size.width/2, 44)
        tabBtn1.backgroundColor = UIColor.clearColor()
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn1.setTitle("PEOPLE", forState: UIControlState.Normal)
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn2.frame = CGRectMake(tabView.frame.size.width/2*1, 0, tabView.frame.size.width/2, 44)
        tabBtn2.backgroundColor = UIColor.clearColor()
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn2.setTitle("GEAR", forState: UIControlState.Normal)
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn2)
        
        let line2:UIView = UIView()
        line2.frame = CGRectMake(0, tabView.frame.size.height-0.5, tabView.frame.size.width, 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        //
        
        tabBtn1.selected = true
        
        //
        
        theTableView.frame = CGRectMake(0, 64+44+44, view.frame.size.width, view.frame.size.height-64-49-44-44)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(SearchCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        //
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        //
        
        //queryForLikes()
        //
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillShow(_:)),name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardDidShow(_:)),name: UIKeyboardDidShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self,selector: "textDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showErrorAlert(_:)), name:"ShowErrorAlertNotification" ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachedLimitErrorAlert(_:)), name:"ReachedLimitErrorAlertNotification" ,object: nil)
        
        //theTextField.becomeFirstResponder()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    func tabBtn1Action() {
        tabBtn1.selected = true
        tabBtn2.selected = false
        
        if (self.isTyping) {
            
            self.checkForSavedSearchMatches()
            
        } else {
            
            // load people
            if (self.theTextField.text != "") {
                
                self.view.endEditing(true)
                
                self.queryForPeople(self.theTextField.text!)
            }
        }
        
    }
    
    func tabBtn2Action() {
        tabBtn1.selected = false
        tabBtn2.selected = true
        
        if (self.isTyping) {
            
            self.checkForSavedSearchMatches()
            
        } else {
            
            // load gear
            if (self.theTextField.text != "") {
                
                self.view.endEditing(true)
                
                self.queryForGear(self.theTextField.text!)
            }
        }
        
    }


    func showErrorAlert(notification: NSNotification){
        //theTextField.resignFirstResponder()
        
        let alertController = UIAlertController(title: "There is no one with that username.", message:"", preferredStyle:.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true) {
        }
    }
    
    func reachedLimitErrorAlert(notification: NSNotification){
        //theTextField.resignFirstResponder()
        
        let alertController = UIAlertController(title: "You have reached the following limit: 500.", message:"", preferredStyle:.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true) {
        }
        
    }
    
    func cancelBtnAction() {
        
        
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        // userInfo = notification.userInfo!
        //duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
       
        
    }
    func keyboardDidShow(notification: NSNotification){
    }
    func keyboardWillHide(notification: NSNotification){
        
    }
    //    func textDidChange(notification: NSNotification){
    //
    //    }
    
    func textFieldDidChange(textField: UITextField) {
        
        print("textFieldDidChange hit: \(textField.text!)")
        
        if (!self.isTyping) {
            self.isTyping = true
        }
        
        self.checkForSavedSearchMatches()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text!
        if (currentString == "") {
            let space = " "
            if (string == space) {
                return false
            }
        }
        
        let maxLength = 100
        //let currentString: NSString = theTextField.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
        
        return newString.length <= maxLength
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == theTextField) {
            
            self.isTyping = false
            self.view.endEditing(true)
            
            if (self.tabBtn1.selected) {
                self.queryForPeople(textField.text!)
            } else {
                self.queryForGear(textField.text!)
            }
            
            textField.resignFirstResponder()
            
            return true
        } else {
            return true
        }
        
    }
    
    func checkForSavedSearchMatches() {
        
        self.savedSearchArray.removeAllObjects()
        
        // find matches
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (self.tabBtn1.selected) {
            
            // find matches in saved people array
            
            let array = defaults.arrayForKey("searchedPeopleWords")
            let ma = NSMutableArray(array: array!)
            
            for obj in ma {
                
                if (obj.hasPrefix(self.theTextField.text!)) {
                    
                    self.savedSearchArray.addObject(obj)
                }
            }
            
        } else if (self.tabBtn2.selected) {
            
            // find matches in saved gear array
            
            let array = defaults.arrayForKey("searchedGearWords")
            let ma = NSMutableArray(array: array!)
            
            for obj in ma {
                
                if (obj.hasPrefix(self.theTextField.text!)) {
                    
                    self.savedSearchArray.addObject(obj)
                }
            }
        } else {
            print("something is wrong")
        }
        
        
        // reload table to show search saved results
        
        self.theTableView.reloadData()
        
        //
        
    }
    
    func queryForPeople(str : String) {
        
        // https://api1.phenomapp.com:8081/user/search?query=STRING&pageNumber=INT
        
        self.peopleData = NSData()
        self.theTableView.reloadData()
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/search"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "query=\(str)&pageNumber=1"
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
                    
                    self.peopleData = dataFromString
                    let results = json["results"]
                    print("people: \(results)")
                    
                    if (results.count > 0) {
                        
                        // save "searchedPeopleWords"
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let array = defaults.arrayForKey("searchedPeopleWords")
                        let ma = NSMutableArray(array: array!)
                        if (ma.containsObject(str)) {
                            // in searchedGearWords, do nothing
                        } else {
                            ma.addObject(str)
                            let newarray = ma as NSArray
                            defaults.setObject(newarray, forKey: "searchedPeopleWords")
                            defaults.synchronize()
                        }
                        //
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.reloadAction()
                            
                        })
                        
                    } else {
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showEmptyTable()
                            
                        })
                    }
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
                
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    func queryForGear(str : String) {
        
        // https://api1.phenomapp.com:8081/product?query=STRING STRING STRING
        
        self.gearData = NSData()
        self.theTableView.reloadData()
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/product"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "query=\(str)"
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
                    
                    self.gearData = dataFromString
                    let results = json["results"]["products"]
                    print("gear: \(results)")
                    
                    if (results.count > 0) {
                        
                        // save "searchedGearWords"
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let array = defaults.arrayForKey("searchedGearWords")
                        let ma = NSMutableArray(array: array!)
                        if (ma.containsObject(str)) {
                            // in searchedGearWords, do nothing
                        } else {
                            ma.addObject(str)
                            let newarray = ma as NSArray
                            defaults.setObject(newarray, forKey: "searchedGearWords")
                            defaults.synchronize()
                        }
                        //
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.reloadAction()
                            
                        })
                        
                    } else {
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showEmptyTable()
                            
                        })
                    }
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
                
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    func reloadAction() {
        
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        self.theTableView.reloadData()
        
    }
    
    func showEmptyTable() {
        
        // show empty timeline btn
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, self.theTableView.frame.size.height))
        self.theTableView.tableHeaderView!.userInteractionEnabled = true
        let emptyTableBtn = UIButton(type: UIButtonType.Custom)
        //emptyTableBtn.frame = CGRectMake(self.theTableView.tableHeaderView!.frame.size.width/2-125, self.theTableView.tableHeaderView!.frame.size.height/2-50, 250, 100)
        emptyTableBtn.frame = CGRectMake(self.theTableView.tableHeaderView!.frame.size.width/2-100, 50, 200, 50)
        emptyTableBtn.backgroundColor = UIColor.clearColor()
        emptyTableBtn.titleLabel?.numberOfLines = 2
        emptyTableBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        emptyTableBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        emptyTableBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        emptyTableBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        emptyTableBtn.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Normal)
        emptyTableBtn.setTitleColor(UIColor(red:197/255, green:175/255, blue:104/255, alpha:1), forState: UIControlState.Highlighted)
        emptyTableBtn.setTitle("No results :(", forState: UIControlState.Normal)
        self.theTableView.tableHeaderView!.addSubview(emptyTableBtn)
        
        //
        
        self.theTableView.reloadData()
        
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.isTyping) {
            return savedSearchArray.count
        } else {
            if (self.tabBtn1.selected) {
                let json = JSON(data: peopleData)
                return json["results"].count
            } else {
                let json = JSON(data: gearData)
                return json["results"]["products"].count
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (self.isTyping) {
            return 60
        } else {
            if (self.tabBtn1.selected) {
                return 15+44+15
            } else {
                return 130
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:SearchCell = SearchCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        if (self.isTyping) {
            
            cell.peopleImgView.hidden = true
            cell.peopleNameLbl.hidden = true
            cell.peopleUsernameLbl.hidden = true
            cell.peopleFollowBtn.hidden = true
            
            cell.gearImgView.hidden = true
            cell.gearNameLbl.hidden = true
            cell.gearBrandLbl.hidden = true
            cell.gearAddBtn.hidden = true
            
            let result = self.savedSearchArray.objectAtIndex(indexPath.row) as! String
            cell.textLabel?.text = result
            cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
            cell.textLabel?.textColor = UIColor.whiteColor()
            
        } else {
            
            cell.textLabel?.text = ""
            
            if (tabBtn1.selected) {
                
                //let json = JSON(data: peopleData)
                //let results = json["results"]
                
                cell.peopleImgView.hidden = false
                cell.peopleNameLbl.hidden = false
                cell.peopleUsernameLbl.hidden = false
                cell.peopleFollowBtn.hidden = false
                
                cell.gearImgView.hidden = true
                cell.gearNameLbl.hidden = true
                cell.gearBrandLbl.hidden = true
                cell.gearAddBtn.hidden = true
                
                cell.peopleImgView.frame = CGRectMake(15, 15, 44, 44)
                cell.peopleNameLbl.frame = CGRectMake(15+50+10, 15, cell.cellWidth-15-50-15-50-15, 20)
                cell.peopleUsernameLbl.frame = CGRectMake(15+50+10, 15+20, cell.cellWidth-15-50-15-50-15, 20)
                cell.peopleFollowBtn.frame = CGRectMake(cell.cellWidth-15-40, 20, 40, 40)
                
                let people = JSON(data: peopleData)
                let results = people["results"]
                
                if let person = results[indexPath.row]["username"].string {
                    cell.peopleUsernameLbl.text = person
                }
                
                if let name = results[indexPath.row]["firstName"].string {
                    cell.peopleNameLbl.text = ("\(name) \(results[indexPath.row]["lastName"])")
                }
                
                if let id = results[indexPath.row]["imageUrl"].string {
                    let fileUrl = NSURL(string: id)
                    
                    cell.peopleImgView.frame = CGRectMake(15, 10, 44, 44)
                    cell.peopleImgView.setNeedsLayout()
                    cell.peopleImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                        success: { image in
                            
                            //print("image here: \(image)")
                            cell.peopleImgView.image = image
                            
                        },
                        failure: { error in
                            
                            if ((error) != nil) {
                                print("error here: \(error)")
                                
                                // collapse, this cell - it was prob deleted - error 402
                                
                            }
                    })
                }
                
                
            } else {
                
                //let json = JSON(data: gearData)
                //let results = json["results"]["products"]
                
                cell.peopleImgView.hidden = true
                cell.peopleNameLbl.hidden = true
                cell.peopleUsernameLbl.hidden = true
                cell.peopleFollowBtn.hidden = true
                
                cell.gearImgView.hidden = false
                cell.gearNameLbl.hidden = false
                cell.gearBrandLbl.hidden = false
                cell.gearAddBtn.hidden = false
                
                let json = JSON(data: self.gearData)
                let results = json["results"]
                let productsDict = results["products"]
                
                if let id = productsDict[indexPath.row]["imageUrl"].string {
                    
                    let fileUrl = NSURL(string: id)
                    
                    cell.gearImgView.frame = CGRectMake(15, 15, 100, 100)
                    cell.gearImgView.setNeedsLayout()
                    
                    //cell.momentImgView.hnk_setImageFromURL(fileUrl!)
                    cell.gearImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                        success: { image in
                            
                            //print("image here: \(image)")
                            cell.gearImgView.image = image
                            
                        },
                        failure: { error in
                            
                            if ((error) != nil) {
                                print("error here: \(error)")
                                
                                // collapse, this cell - it was prob deleted - error 402
                                
                            }
                    })
                    
                }
                
                var nameHeight = CGFloat()
                
                if let id = productsDict[indexPath.row]["brand"].string {
                    cell.gearBrandLbl.text = id                    
                } else {
                    cell.gearBrandLbl.text = ""
                }
                
                if let id = productsDict[indexPath.row]["name"].string {
                    cell.gearNameLbl.text = id
                    nameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearNameLbl.font, width: self.view.frame.size.width-15-15-44-15)
                } else {
                    nameHeight = 0
                    cell.gearNameLbl.text = ""
                }
                
                cell.gearNameLbl.frame = CGRect(x: 15+100+15, y: 15, width: cell.cellWidth-15-100-15-15, height: nameHeight)
                cell.gearBrandLbl.frame = CGRect(x: 15+100+15, y: 15+nameHeight, width: cell.cellWidth-15-100-15-15, height: 20)
                
                if let id = productsDict[indexPath.row]["existsInLocker"].bool {
                    if (id) {
                        cell.gearAddBtn.selected = true
                    } else {
                        cell.gearAddBtn.selected = false
                    }
                }
                
                cell.gearAddBtn.frame = CGRect(x: cell.cellWidth-65-15, y: 130-38-15, width: 65, height: 38)
                cell.gearAddBtn.tag = indexPath.row
                cell.gearAddBtn.addTarget(self, action:#selector(gearAddBtnAction), forControlEvents: .TouchUpInside)
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = .None
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        if (self.isTyping) {
            self.isTyping = false
            self.view.endEditing(true)
            
            let result = self.savedSearchArray.objectAtIndex(indexPath.row) as! String
            self.theTextField.text = result
            
            if (tabBtn1.selected) {
                self.queryForPeople(self.theTextField.text!)
            } else if (tabBtn2.selected) {
                self.queryForGear(self.theTextField.text!)
            } else {
                print("something is wrong")
            }
            
        } else {
            
            if (tabBtn1.selected) {
                
                // person
                let json = JSON(data: peopleData)
                let results = json["results"]
                if let _ = results[indexPath.row]["id"].string {
                    let vc = ProfileViewController()
                    vc.passedUserData = results[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            } else if (tabBtn2.selected) {
                
                // gear
                let json = JSON(data: self.gearData)
                let results = json["results"]
                let productsDict = results["products"]
                
                let vc = GearDetailViewController()
                vc.passedGearData = productsDict[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)

                
            } else {
                print("something went wrong")
            }
            
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        switch (scrollView.panGestureRecognizer.state) {
            
        case UIGestureRecognizerState.Began:
            break;
        case UIGestureRecognizerState.Changed:
            
            self.view.endEditing(true)
            
            break;
        case UIGestureRecognizerState.Possible:
            break;
        default:
            break;
        }
    }
    
    
    func gearAddBtnAction(sender : UIButton) {
        
        if (sender.selected) {
            
            sender.selected = false
            removeGearFromLocker(sender)
            
        } else {
            
            sender.selected = true
            addGearToLocker(sender)
            
        }
    }
    
    func addGearToLocker(sender : UIButton) {
        
        let json = JSON(data: gearData)
        let results = json["results"]
        let productsDict = results["products"]
        
        let productJson = productsDict[sender.tag]
        print("productJson: \(productJson)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/locker"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "product=\(productJson)"
        let type = "PUT"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sendRequest(url, parameters: params, type: type, completionHandler:  { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        sender.selected = false
                        
                        return
                    }
                    
                    print("+1 added to locker")
                    
                    sender.selected = true
                    
                    let followingCount = defaults.objectForKey("lockerProductCount") as! Int
                    let newcount = followingCount+1
                    defaults.setObject(newcount, forKey: "lockerProductCount")
                    defaults.synchronize()
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                    })
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                    
                }
                
            } else {
                //
            }
            
        })
        
    }
    
    func removeGearFromLocker(sender : UIButton) {
        
        
    }
    
    
    
    
}
