//
//  SearchViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var bg: UIView = UIView()
    var cancelBtn = UIButton()
    var icon = UIImageView()
    var theTextField = UITextField()
    var theTableView = UITableView()
    var duration: NSNumber!
    var curve: NSNumber!
    
    var friendslist = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let searchView:UIView = UIView()
        searchView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        searchView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        self.cancelBtn.frame = CGRectMake(searchView.frame.size.width-70, 20, 70, 44)
        self.cancelBtn.backgroundColor = UIColor.clearColor()
        self.cancelBtn.addTarget(self, action:#selector(SearchViewController.cancelBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.cancelBtn.titleLabel?.numberOfLines = 1
        self.cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.cancelBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        self.cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        self.cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        searchView.addSubview(self.cancelBtn)
        self.cancelBtn.enabled = false
        self.cancelBtn.alpha = 0.0
        
        self.bg.frame = CGRectMake(14, 20+7, self.view.frame.size.width-28, 30)
        self.bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0) //UIColor.init(white: 0.94, alpha: 1.0)
        searchView.addSubview(self.bg)
        self.bg.layer.cornerRadius = 7
        self.bg.layer.masksToBounds = true
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height)
        btn.backgroundColor = UIColor.clearColor()
        btn.addTarget(self, action:#selector(SearchViewController.btnAction), forControlEvents:UIControlEvents.TouchUpInside)
        bg.addSubview(btn)
        
        let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView("Search", font: UIFont.systemFontOfSize(15), height: 30)
        
        //self.icon.frame = CGRectMake(14+10, 20+7+10, 12, 12)
        self.icon.frame = CGRectMake((self.view.frame.size.width/2)-(width/2)-7, 20+7+10, 12, 12)
        self.icon.backgroundColor = UIColor.clearColor()
        self.icon.image = UIImage(named:"miniSearchImg.png")
        searchView.addSubview(self.icon)
        
        //self.theTextField.frame = CGRectMake(44, 28, self.view.frame.size.width-44-14, 30)
        self.theTextField.frame = CGRectMake(self.icon.frame.origin.x+self.icon.frame.size.width+6, 28, width, 30)
        self.theTextField.backgroundColor = UIColor.clearColor()
        self.theTextField.delegate = self
        self.theTextField.textColor = UIColor.whiteColor() // UIColor(red:42/255, green:42/255, blue:42/255, alpha:1)
        self.theTextField.keyboardType = UIKeyboardType.Default
        self.theTextField.returnKeyType = UIReturnKeyType.Done
        self.theTextField.enablesReturnKeyAutomatically = true
        self.theTextField.font = UIFont.systemFontOfSize(15)
        self.theTextField.placeholder = "Search"
        self.theTextField.autocapitalizationType = UITextAutocapitalizationType.None
        self.theTextField.autocorrectionType = UITextAutocorrectionType.No
        searchView.addSubview(self.theTextField)
        //self.theTextField.addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.theTextField.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, searchView.frame.size.height-0.5, searchView.frame.size.width, 0.5)
        line.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        searchView.addSubview(line)
        
        self.view.addSubview(searchView)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRectMake(0, 64, self.view.frame.size.width, 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let tabBtn1 = UIButton(type: UIButtonType.Custom)
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
        tabBtn1.addTarget(self, action:#selector(SearchViewController.tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn1.selected = true
        
        let tabBtn2 = UIButton(type: UIButtonType.Custom)
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
        tabBtn2.addTarget(self, action:#selector(SearchViewController.tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn2)
        
        let line2:UIView = UIView()
        line2.frame = CGRectMake(0, tabView.frame.size.height-0.5, tabView.frame.size.width, 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        self.view.addSubview(tabView)
        
        //
        
        self.theTableView.frame = CGRectMake(0, 64+44, view.frame.size.width, view.frame.size.height-64-44-49)
        self.theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        self.theTableView.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(SearchViewController.keyboardWillShow(_:)),name: UIKeyboardWillShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(SearchViewController.keyboardDidShow(_:)),name: UIKeyboardDidShowNotification,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: #selector(SearchViewController.keyboardWillHide(_:)),name: UIKeyboardWillHideNotification,object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self,selector: "textDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.showErrorAlert(_:)), name:"ShowErrorAlertNotification" ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.reachedLimitErrorAlert(_:)), name:"ReachedLimitErrorAlertNotification" ,object: nil)
        
        self.theTextField.becomeFirstResponder()
        
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnAction() {
        theTextField.becomeFirstResponder()
    }
    
    func tabBtn1Action() {
        
        
    }
    
    func tabBtn2Action() {
        
        
    }
    
    func showErrorAlert(notification: NSNotification){
        //self.theTextField.resignFirstResponder()
        
        let alertController = UIAlertController(title: "There is no one with that username.", message:"", preferredStyle:.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    func reachedLimitErrorAlert(notification: NSNotification){
        //self.theTextField.resignFirstResponder()
        
        let alertController = UIAlertController(title: "You have reached the following limit: 500.", message:"", preferredStyle:.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
        }
        
    }
    
    func cancelBtnAction() {
        
        self.theTextField.text = ""
        self.theTableView.hidden = true
        self.theTextField.resignFirstResponder()
        
        self.navigationController?.popViewControllerAnimated(false)
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
        
        let nothing = ""
        if (self.theTextField.text == nothing) {
            self.theTableView.hidden = true
        } else {
            self.theTableView.hidden = false
        }
        
        //
        // find char in friends array
        
//        self.friendslist.removeAllObjects()
//        
//        let followingnames = PFUser.currentUser()!.objectForKey("followingnames") as! NSArray
//        let ma = NSMutableArray(array: followingnames)
//        let arr = ma.sort { $0.localizedCaseInsensitiveCompare($1 as! String) == NSComparisonResult.OrderedAscending}
//        
//        for name in arr {
//            
//            let n = name as! String
//            
//            if (n.lowercaseString).hasPrefix(self.theTextField.text!.lowercaseString) {
//                self.friendslist.addObject(n)
//            }
//        }
//        
//        self.theTableView.reloadData()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.theTextField) {
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
        
        if (textField == self.theTextField) {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRectMake(20, 0, self.view.frame.size.width, 35))
        aLbl.textAlignment = NSTextAlignment.Left
        
        switch (section) {
        case 0: aLbl.text = "ADD BY USERNAME"
        case 1: aLbl.text = self.friendslist.count > 0 ? "FRIENDS" : ""
        default: aLbl.text = ""}
        
        aLbl.font = UIFont.boldSystemFontOfSize(12)
        aLbl.textColor = UINavigationBar.appearance().tintColor
        self.view.addSubview(aLbl)
        
        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
        aView.backgroundColor = UIColor.init(white: 1.0, alpha: 1.0)
        aView.addSubview(aLbl)
        
        return aView;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return self.friendslist.count
        default: break}
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
//        let cell:UserCell = UserCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
//        cell.cellWith = self.view.frame.size.width
//        cell.cellString = (theTextField.text)!
//        
//        cell.textLabel?.frame = CGRectMake(20, 0, self.view.frame.size.width-20-20-80, 64)
//        cell.textLabel?.font = UIFont.systemFontOfSize(17)
//        
//        if (indexPath.section == 0) {
//            
//            cell.textLabel?.text = theTextField.text! as String
//            
//            if (self.theTextField.text == "") {
//                
//                cell.addBtn.selected = false
//                cell.addBtn.hidden = true
//                
//            } else {
//                
//                cell.addBtn.selected = false
//                cell.addBtn.hidden = true
//                let un = PFUser.currentUser()!.username
//                if (self.theTextField.text?.lowercaseString == un?.lowercaseString) {
//                    
//                    cell.addBtn.hidden = true
//                } else {
//                    
//                    let followingnames = PFUser.currentUser()!.objectForKey("followingnames") as! NSArray
//                    if (followingnames.containsObject((self.theTextField.text?.lowercaseString)!)) {
//                        cell.addBtn.selected = true
//                    } else {
//                        cell.addBtn.selected = false
//                    }
//                    
//                    cell.addBtn.hidden = false;
//                }
//            }
//        } else if (indexPath.section == 1) {
//            
//            cell.addBtn.hidden = true
//            
//            let name = self.friendslist.objectAtIndex(indexPath.row) as! String
//            cell.textLabel?.text = name
//            
//        } else {
//            
//        }
        
        return cell
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        //print("You selected cell #\(indexPath.row)!")
        
//        if (indexPath.section == 0) {
//            
//        } else if (indexPath.section == 1) {
//            
//            self.theTextField.resignFirstResponder()
//            
//            let name = self.friendslist.objectAtIndex(indexPath.row) as! String
//            self.sendChatTo(name)
//            //cell.textLabel?.text = name
//            
//        } else {
//            
//        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (self.theTextField.editing) {
            self.theTextField.resignFirstResponder()
        }
    }

}
