//
//  SearchViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftyJSON
import Haneke

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var people = NSData()
    var gear = NSData()
    
    var bg: UIView = UIView()
    var cancelBtn = UIButton()
    var icon = UIImageView()
    var theTextField = UITextField()
    var theTableView = UITableView()
    var duration: NSNumber!
    var curve: NSNumber!
    
    var peopleArray = NSMutableArray()
    var savedSearchNames = NSMutableArray()
    
    var gearArray = NSMutableArray()
    var savedSearchGear = NSMutableArray()
    
    var selectedTab = NSString()
    var tabBtn1 = UIButton(type: UIButtonType.Custom)
    var tabBtn2 = UIButton(type: UIButtonType.Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let searchView:UIView = UIView()
        searchView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        searchView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        cancelBtn.frame = CGRectMake(searchView.frame.size.width-70, 20, 70, 44)
        cancelBtn.backgroundColor = UIColor.clearColor()
        cancelBtn.addTarget(self, action:#selector(cancelBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        cancelBtn.titleLabel?.numberOfLines = 1
        cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        cancelBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        searchView.addSubview(cancelBtn)
        cancelBtn.enabled = false
        cancelBtn.alpha = 0.0
        
        bg.frame = CGRectMake(14, 20+7, view.frame.size.width-28, 30)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0) //UIColor.init(white: 0.94, alpha: 1.0)
        searchView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height)
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action:#selector(btnAction), forControlEvents:UIControlEvents.TouchUpInside)
        bg.addSubview(btn)
        
        let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView("Search", font: UIFont.systemFontOfSize(15), height: 30)
        
        //icon.frame = CGRectMake(14+10, 20+7+10, 12, 12)
        icon.frame = CGRectMake((view.frame.size.width/2)-(width/2)-7, 20+7+10, 12, 12)
        icon.backgroundColor = UIColor.clearColor()
        icon.image = UIImage(named:"miniSearchImg.png")
        searchView.addSubview(icon)
        
        //theTextField.frame = CGRectMake(44, 28, view.frame.size.width-44-14, 30)
        theTextField.frame = CGRectMake(icon.frame.origin.x+icon.frame.size.width+6, 28, width, 30)
        theTextField.backgroundColor = UIColor.clearColor()
        theTextField.delegate = self
        theTextField.textColor = UIColor.whiteColor() // UIColor(red:42/255, green:42/255, blue:42/255, alpha:1)
        theTextField.keyboardType = UIKeyboardType.Default
        theTextField.returnKeyType = UIReturnKeyType.Done
        theTextField.enablesReturnKeyAutomatically = true
        theTextField.font = UIFont.systemFontOfSize(15)
        theTextField.placeholder = "Search"
        theTextField.autocapitalizationType = UITextAutocapitalizationType.None
        theTextField.autocorrectionType = UITextAutocorrectionType.No
        searchView.addSubview(theTextField)
        //theTextField.addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        theTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, searchView.frame.size.height-0.5, searchView.frame.size.width, 0.5)
        line.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        searchView.addSubview(line)
        
        view.addSubview(searchView)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRectMake(0, 64, view.frame.size.width, 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        tabBtn1.frame = CGRectMake(0, 0, tabView.frame.size.width/2, 44)
        tabBtn1.backgroundColor = UIColor.clearColor()
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn1.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn1.setTitle("PEOPLE", forState: UIControlState.Normal)
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn2.frame = CGRectMake(tabView.frame.size.width/2*1, 0, tabView.frame.size.width/2, 44)
        tabBtn2.backgroundColor = UIColor.clearColor()
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn2.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn2.setTitle("GEAR", forState: UIControlState.Normal)
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn2)
        
        let line2:UIView = UIView()
        line2.frame = CGRectMake(0, tabView.frame.size.height-0.5, tabView.frame.size.width, 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        view.addSubview(tabView)
        
        if (selectedTab == "gear") {
            tabBtn2.selected = true
        } else {
            tabBtn1.selected = true
        }
        
        //
        
        theTableView.frame = CGRectMake(0, 64+44, view.frame.size.width, view.frame.size.height-64-44-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.registerClass(SearchCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillShow(_:)),name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardDidShow(_:)),name: UIKeyboardDidShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self,selector: "textDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showErrorAlert(_:)), name:"ShowErrorAlertNotification" ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reachedLimitErrorAlert(_:)), name:"ReachedLimitErrorAlertNotification" ,object: nil)
        
        theTextField.becomeFirstResponder()
        
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnAction() {
        theTextField.becomeFirstResponder()
    }
    
    func tabBtn1Action() {
        tabBtn1.selected = true
        tabBtn2.selected = false
        
        // load people array
        theTableView.reloadData()
    }
    
    func tabBtn2Action() {
        tabBtn1.selected = false
        tabBtn2.selected = true
        
        // load gear array
        theTableView.reloadData()
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
        
        theTextField.text = ""
        peopleArray.removeAllObjects()
        gearArray.removeAllObjects()
        theTextField.resignFirstResponder()
        
        navigationController?.popViewControllerAnimated(false)
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        let userInfo = notification.userInfo!
        duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(duration.doubleValue, delay:0, options: .CurveEaseOut, animations: {
            
            var bgFrame = self.bg.frame
            var iconFrame = self.icon.frame
            var tfFrame = self.theTextField.frame
            
            bgFrame.size.width = self.view.frame.size.width-14-70
            
            iconFrame.origin.x = 24
            tfFrame.origin.x = 44
            tfFrame.size.width = self.view.frame.size.width-44-70
            
            self.bg.frame = bgFrame
            self.icon.frame = iconFrame
            self.theTextField.frame = tfFrame
            
            self.cancelBtn.alpha = 1.0
            
            }, completion: { finished in
                self.cancelBtn.enabled = true
        })
        
    }
    func keyboardDidShow(notification: NSNotification){
    }
    func keyboardWillHide(notification: NSNotification){
        
    }
    //    func textDidChange(notification: NSNotification){
    //
    //    }
    
    func textFieldDidChange(textField: UITextField) {
        
        if (tabBtn1.selected) {
            peopleArray.removeAllObjects()
            
            let nothing = ""
            if (theTextField.text == nothing) {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let array = defaults.arrayForKey("savedSearchNames")
                let ma = NSMutableArray(array: array!)
                
                let arr = ma.sort { $0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending}
                
                for name in arr {
                    
                    let n = name as! String
                    
                    if (n.lowercaseString).hasPrefix(theTextField.text!.lowercaseString) {
                        peopleArray.addObject(n)
                    }
                }
                
                theTableView.reloadData()
                
            } else {
                
                //peopleArray.addObject(n)
                
                
                peopleArray.addObject("\(theTextField.text!)")
                
                theTableView.reloadData()
            }
            
        } else if (tabBtn2.selected) {
            
            gearArray.removeAllObjects()
            
            let nothing = ""
            if (theTextField.text == nothing) {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let array = defaults.arrayForKey("savedSearchNames")
                let ma = NSMutableArray(array: array!)
                
                let arr = ma.sort { $0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending}
                
                for name in arr {
                    
                    let n = name as! String
                    
                    if (n.lowercaseString).hasPrefix(theTextField.text!.lowercaseString) {
                        gearArray.addObject(n)
                    }
                }
                
                theTableView.reloadData()
                
            } else {
                
                gearArray.addObject("\(theTextField.text!)")
                
                theTableView.reloadData()
            }
            
        } else {
            // error
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == theTextField) {
            let space = " "
            if (string == space) {
                return false
            }
            let maxLength = 30
            let currentString: NSString = theTextField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            
            return newString.length <= maxLength
        } else {
            let maxLength = 400
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            
            return newString.length <= maxLength
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == theTextField) {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    
    
    func queryForGearWithString(str : String) {
        
        // https://api1.phenomapp.com:8081/product?query=STRING
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/discover/gear") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
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
                        
                        self.gear = dataFromString
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.theTableView.reloadData()
                        })
                        
                    } else {
                        print("URL Session Task Failed: %@", error!.localizedDescription);
                    }
                }
                
            })
            task.resume()
        })
        
    }
    
    
    func queryForPeopleWithString(str : String) {
        
        //https://api1.phenomapp.com:8081/user/search?pageNumber=INT&query=STRING
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/discover/people") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
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
                        
                        self.people = dataFromString
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.theTableView.reloadData()
                        })
                        
                        
                    } else {
                        print("URL Session Task Failed: %@", error!.localizedDescription);
                    }
                }
                
            })
            task.resume()
        })
        
    }
    
    func queryForMusicWithString(str : String) {
        
        // https://api1.phenomapp.com:8081/moment/searchForSongs?searchString=STRING
        
        
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tabBtn1.selected) {
           return peopleArray.count
        } else if (tabBtn2.selected) {
            return gearArray.count
        } else {
            // error
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        let cell:SearchCell = SearchCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        cell.cellString = (theTextField.text)!
        
        cell.textLabel?.frame = CGRectMake(20, 0, view.frame.size.width-20-20-80, 64)
        cell.textLabel?.font = UIFont.systemFontOfSize(17)
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.addBtn.hidden = true
        
        let name = peopleArray.objectAtIndex(indexPath.row) as! String
        cell.textLabel?.text = name
        
        
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (theTextField.editing) {
            theTextField.resignFirstResponder()
        }
    }


}
