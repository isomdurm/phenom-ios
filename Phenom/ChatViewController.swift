//
//  ChatViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/28/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke
import SafariServices

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, SFSafariViewControllerDelegate {
    
    var commentsData = NSData()
    
    var passedMomentData = JSON(data: NSData())
    
    var passedMomentId = ""
    var passedMomentUsername = ""
    var passedMomentUserImageUrl = ""
    var passedMomentHeadline = ""
    var passedMomentCreatedAt = ""
    var passedMomentReferences = NSArray()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    
    var chatView = UIView()
    var savedKeyboardHeight = CGFloat()
    var theTextView = KMPlaceholderTextView()
    var sendBtn = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        // parse passed moment
        
        passedMomentId = passedMomentData["id"].string!
        passedMomentHeadline = passedMomentData["headline"].string!
        passedMomentUsername = passedMomentData["user"]["username"].string!
        passedMomentUserImageUrl = passedMomentData["user"]["imageUrlTiny"].string!
        let obj = passedMomentData["references"].arrayObject!
        passedMomentReferences = obj as NSArray
        print("passedMomentReferences: \(passedMomentReferences)")
        
        //
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(15, 20, 44, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "CHAT"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-50)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        theTableView.addSubview(refreshControl)
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .Right
        view.addGestureRecognizer(swipeBack)
        
        //
        
        self.chatView.frame = CGRectMake(0, self.view.frame.size.height-51, self.view.frame.size.width, 51) //55
        self.chatView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.chatView)
        
        self.savedKeyboardHeight = 224
        
        self.theTextView.frame = CGRectMake(20, 10, self.chatView.frame.width-20-10-50-10, 35)
        self.theTextView.backgroundColor = UIColor.clearColor()
        self.theTextView.delegate = self;
        self.theTextView.keyboardType = UIKeyboardType.Twitter;
        self.theTextView.returnKeyType = UIReturnKeyType.Default;
        self.theTextView.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        self.theTextView.enablesReturnKeyAutomatically = true;
        self.theTextView.textAlignment = NSTextAlignment.Left
        self.theTextView.scrollEnabled = false;
        self.theTextView.scrollsToTop = false;
        self.chatView.addSubview(self.theTextView)
        self.theTextView.text = ""
        self.theTextView.textColor = UIColor.whiteColor()
        self.theTextView.placeholderColor = UIColor.init(white: 0.6, alpha: 1.0)
        self.theTextView.placeholder = "Add a comment..."
        
        self.sendBtn = UIButton(type: UIButtonType.Custom)
        self.sendBtn.frame = CGRectMake(self.chatView.frame.width-50-10, 2, 50, 47)
        self.sendBtn.backgroundColor = UIColor.clearColor()
        self.sendBtn.titleLabel?.numberOfLines = 1
        self.sendBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        self.sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        self.sendBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        self.sendBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        self.sendBtn.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Normal)
        self.sendBtn.setTitleColor(UIColor(red:207/255, green:185/255, blue:114/255, alpha:1), forState: UIControlState.Highlighted)
        self.sendBtn.setTitleColor(UIColor.init(white: 0.6, alpha: 1.0), forState: UIControlState.Disabled)
        self.sendBtn.setTitle("Send", forState: UIControlState.Normal)
        //self.sendBtn.addTarget(self, action:"sendBtnAction", forControlEvents:UIControlEvents.TouchUpInside)
        self.chatView.addSubview(self.sendBtn)
        self.sendBtn.enabled = false
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 0, self.chatView.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor.init(white: 0.6, alpha: 1.0) //UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        self.chatView.addSubview(lineview)
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIKeyboardWillHideNotification ,object: nil)
        
        //
        
        queryForChat()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
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

    
    func keyboardWillShow(notification: NSNotification) {
        
        //
        
        let info = notification.userInfo!
        let keyboardframe: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue as NSNumber
        //let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        self.savedKeyboardHeight = keyboardframe.size.height
        
        UIView.animateWithDuration(duration.doubleValue, delay:0, options: .CurveEaseOut, animations: {
            
            var chatViewFrame = self.chatView.frame
            chatViewFrame.origin.y = self.view.frame.size.height-self.savedKeyboardHeight-self.chatView.frame.size.height
            self.chatView.frame = chatViewFrame
            
            var tableViewFrame = self.theTableView.frame
            tableViewFrame.size.height = self.view.frame.size.height-self.savedKeyboardHeight-self.chatView.frame.size.height
            self.theTableView.frame = tableViewFrame
            
            }, completion: { finished in
                
        })
        
        let json = JSON(data: commentsData)
        let results = json["results"]["comments"]
        if (results.count>0) {
            let lastrow = self.theTableView.numberOfRowsInSection(1)
            let ip = NSIndexPath(forRow: lastrow-1, inSection: 1)
            self.theTableView.scrollToRowAtIndexPath(ip, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //
        
        let info = notification.userInfo!
        let keyboardframe: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue as NSNumber
        //let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        self.savedKeyboardHeight = keyboardframe.size.height
        
        UIView.animateWithDuration(duration.doubleValue, delay:0, options: .CurveEaseOut, animations: {
            
            var chatViewFrame = self.chatView.frame
            chatViewFrame.origin.y = self.view.frame.size.height-self.chatView.frame.size.height
            self.chatView.frame = chatViewFrame
            
            var tableViewFrame = self.theTableView.frame
            tableViewFrame.size.height = self.view.frame.size.height-self.chatView.frame.size.height
            self.theTableView.frame = tableViewFrame
            
            }, completion: { finished in
                
        })
        
    }
    
    // UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (self.theTextView.text == "") {
            if (text == " ") {
                return false;
            }
        }
        if (text == "\n")
        {
            return false
        }
        
        let maxLength = 400
        let currentString: NSString = textView.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: text)
        
        if (newString.length > 0) {
            self.sendBtn.enabled = true
        } else {
            self.sendBtn.enabled = false
        }
        
        return newString.length <= maxLength
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        // adjust height
        
        let maxFloat = CGFloat(MAXFLOAT)
        let newSize = textView.sizeThatFits(CGSizeMake(self.chatView.frame.width-20-10-50-10, maxFloat))
        
        
        UIView.animateWithDuration(0.05, delay:0, options: .CurveEaseOut, animations: {
            
            var newFrame = textView.frame
            newFrame.size = CGSizeMake(self.chatView.frame.width-20-10-50-10, newSize.height)
            textView.frame = newFrame
            
            let newheight = 10+newSize.height+10
            
            var chatViewFrame = self.chatView.frame
            chatViewFrame.size.height = newheight
            chatViewFrame.origin.y = self.view.frame.size.height-self.savedKeyboardHeight-newheight
            self.chatView.frame = chatViewFrame
            
            var tableViewFrame = self.theTableView.frame
            tableViewFrame.size.height = self.view.frame.size.height-self.savedKeyboardHeight-newheight
            self.theTableView.frame = tableViewFrame
            
            }, completion: { finished in
                
        })
        
        let json = JSON(data: commentsData)
        let results = json["results"]["comments"]
        if (results.count>0) {
            let lastrow = self.theTableView.numberOfRowsInSection(1)
            let ip = NSIndexPath(forRow: lastrow-1, inSection: 1)
            self.theTableView.scrollToRowAtIndexPath(ip, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
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
    
    
    //
    
    func refreshControlAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).lastvisiteddate = NSDate()
        
        //let newme = PFUser.currentUser()
        //newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //newme!.saveInBackground()
        
        queryForChat()
        
    }
    
    func queryForChat() {
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)/comments"
        let date = NSDate().timeIntervalSince1970 * 1000
        let params = "since=\(date)&limit=30"
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
                    
                    self.commentsData = dataFromString
                    print("results: \(json["results"])")
                    let results = json["results"]["comments"]
                    print("comments: \(results)")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                        
                        self.refreshControl.endRefreshing()
                        
                    })
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
                
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 1
        } else if (section == 1) {
            let json = JSON(data: commentsData)
            let results = json["results"]["comments"]
            return results.count
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            if (passedMomentHeadline == "") {
                return 0
            } else {
                let width = self.view.frame.size.width-15-44-15-15
                let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(passedMomentHeadline, font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, width: width)
                return 15+20+15+height+5
            }
        } else if (indexPath.section == 1) {
            
            let json = JSON(data: commentsData)
            let results = json["results"]["comments"]
            if let id = results[indexPath.row]["commentText"].string {
                
                let width = self.view.frame.size.width-15-44-15-15
                let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, width: width)
                return 15+20+15+height+5
            } else {
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ChatCell = ChatCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        cell.userImgView.frame = CGRectMake(15, 15, 44, 44)
        cell.userBtn.frame = CGRectMake(15, 15, 44, 44)
        
        if (indexPath.section == 0) {
            
            let fileUrl = NSURL(string: self.passedMomentUserImageUrl)
            cell.userImgView.setNeedsLayout()
            cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                success: { image in
                    
                    cell.userImgView.image = image
                    
                },
                failure: { error in
                    
                    if ((error) != nil) {
                        print("error here: \(error)")
                        // collapse, this cell - it was prob deleted - error 402
                    }
            })
            
            let nameWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(self.passedMomentUsername, font: cell.usernameBtn.titleLabel!.font, height: 20)
            cell.usernameBtn.frame = CGRectMake(15+44+15, 15, nameWidth, 20)
            cell.usernameBtn.setTitle(self.passedMomentUsername, forState: .Normal)
            
            let dateWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(self.passedMomentCreatedAt, font: cell.dateLbl.font, height: 20)
            cell.dateLbl.frame = CGRectMake(cell.cellWidth-dateWidth-15, 15, dateWidth, 20)
            cell.dateLbl.text = self.passedMomentCreatedAt
            
            let chatWidth = cell.cellWidth-15-44-15-15
            let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(self.passedMomentHeadline, font: cell.chatLbl.font, width: chatWidth)
            cell.chatLbl.frame = CGRectMake(15+44+15, 15+20, chatWidth, height+10)
            cell.chatLbl.text = self.passedMomentHeadline
        
            
            cell.userBtn.hidden = false
            cell.userBtn.tag = indexPath.row
            cell.userBtn.addTarget(self, action:#selector(userBtnAction1), forControlEvents: .TouchUpInside)
            
        } else if (indexPath.section == 1) {
            
            let json = JSON(data: commentsData)
            let results = json["results"]["comments"]
            
            // author
            // - username
            // IF tapped on avatar, pass all "auther" details: id, firstName, lastName, sport, followersCount... etc
            //
            // commentText
            // createdAt
            // flaggedAsInappropriate
            
            if let id = results[indexPath.row]["author"]["imageUrl"].string {
                let fileUrl = NSURL(string: id)
                
                cell.userImgView.setNeedsLayout()
                
                cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                    success: { image in
                        
                        cell.userImgView.image = image
                    },
                    failure: { error in
                        
                        if ((error) != nil) {
                            print("error here: \(error)")
                        }
                })
            }            
            
            if let id = results[indexPath.row]["author"]["username"].string {
                
                let nameWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(id, font: cell.usernameBtn.titleLabel!.font, height: 20)
                cell.usernameBtn.frame = CGRectMake(15+44+15, 15, nameWidth, 20)
                cell.usernameBtn.setTitle(id, forState: .Normal)
                
            }
            
            if let id = results[indexPath.row]["createdAt"].string {
                
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(id, font: cell.dateLbl.font, height: 20)
                cell.dateLbl.frame = CGRectMake(cell.cellWidth-width-15, 15, width, 20)
                cell.dateLbl.text = id
                
            }
            
            if let id = results[indexPath.row]["commentText"].string {
                
                let width = cell.cellWidth-15-44-15-15
                let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.chatLbl.font, width: width)
                cell.chatLbl.frame = CGRectMake(15+44+15, 15+20, width, height+10)
                cell.chatLbl.text = id
                
            }
            
            cell.userBtn.hidden = false
            cell.userBtn.tag = indexPath.row
            cell.userBtn.addTarget(self, action:#selector(userBtnAction2), forControlEvents: .TouchUpInside)
            
            
            cell.chatLbl.handleMentionTap { userHandle in
            
                print("\(userHandle) tapped")
                
                //self.handleMentionTap(indexPath, username: <#T##String#>)
                
//                if let id = results[indexPath.row]["author"]["id"].string {
//                    
//                }
            }
            
            cell.chatLbl.handleURLTap { userHandle in
                
                print("\(userHandle) tapped")
                
                if (userHandle != "") {
                    
                    let svc = SFSafariViewController(URL: userHandle, entersReaderIfAvailable: false)
                    self.presentViewController(svc, animated: false, completion: nil)
                    
                    UIApplication.sharedApplication().statusBarStyle = .Default
                }
            }
            
        } else {
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        if (indexPath.section == 0) {

            // get user, then go to user
            
        } else if (indexPath.section == 1) {

        } else {
            
        }
    }
    
    func userBtnAction1(sender: UIButton){
        
        let vc = ProfileViewController()
        vc.passedUserData = passedMomentData["user"]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func userBtnAction2(sender: UIButton){
       
        let json = JSON(data: commentsData)
        let results = json["results"]["comments"]
        
        if let _ = results[sender.tag]["author"]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserData = results[sender.tag]["author"]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleMentionTap(ip : NSIndexPath, username : String) {
    
        
        
    }

}
