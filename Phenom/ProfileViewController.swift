//
//  ProfileViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var navBarView = UIView()
    
    var userData = NSData()
    var momentsData = NSData()
    
    var passedUserId = NSString()
    
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var activityArray = NSArray()
    
    var profileImgView = UIImageView()
    var nameLbl = UILabel()
    var sportHometownLbl = UILabel()
    var descriptionLbl = UILabel()
    var fansNumBtn = UIButton.init(type: UIButtonType.Custom)
    var followingNumBtn = UIButton.init(type: UIButtonType.Custom)
    
    var isPushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let settingsBtn = UIButton(type: UIButtonType.Custom)
        settingsBtn.frame = CGRectMake(self.navBarView.frame.size.width-70-20, 0, 70, 44)
        settingsBtn.setImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
        //settingsBtn.setBackgroundImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
        settingsBtn.backgroundColor = UIColor.blueColor()
        settingsBtn.addTarget(self, action:#selector(self.settingsBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(settingsBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "USERNAME"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        
        self.theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        self.theTableView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(TimelineCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        
        
        let headerViewWidth = self.view.frame.size.width
        
        // number of fans
        // "fans"
        // number of following
        // "following"
        // invite button

        let fansWidth = (headerViewWidth/2)/2
        let fansHeight = CGFloat(50)
        
        //
        
        let profilePicWidth = headerViewWidth/3
        let nameHeight = CGFloat(30)
        let sportHomeTownHeight = CGFloat(30)
        
        //let bio = "This is a test of the american broadcasting system of america americana this is a test of the american broadcasting system of americaaaaaa" //"Just getting warmed up!"
        let bio = "this is a test of the american broadcasting system of american americana"
        
        let bioWidth = self.view.frame.size.width-50
        let bioHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(bio, font: UIFont.boldSystemFontOfSize(14), width: bioWidth)+10

        
        let headerContainerViewHeight = profilePicWidth+nameHeight+sportHomeTownHeight+bioHeight+fansHeight+5+15
        let headerContainerView = UIView(frame: CGRectMake(0, 50, headerViewWidth, headerContainerViewHeight))
        
        
        //
        // profile pic, name, hometown,
        //
        
        let profileContainerViewHeight = profilePicWidth+nameHeight+sportHomeTownHeight+bioHeight
        let profileContainerView = UIView(frame: CGRectMake(0, 0,  headerViewWidth, profileContainerViewHeight))
        
        profileImgView.frame = CGRectMake(profilePicWidth, 0, profilePicWidth, profilePicWidth)
        profileImgView.backgroundColor = UIColor.lightGrayColor()
        profileContainerView.addSubview(profileImgView)
        
        nameLbl.frame = CGRectMake(0, profileImgView.frame.origin.y+profileImgView.frame.size.height+5, headerViewWidth, nameHeight)
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.textAlignment = .Center
        nameLbl.font = UIFont.boldSystemFontOfSize(24)
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.text = "FIRST LAST"
        profileContainerView.addSubview(nameLbl)
        
        sportHometownLbl.frame = CGRectMake(0, profileImgView.frame.origin.y+profileImgView.frame.size.height+nameLbl.frame.size.height, headerViewWidth, sportHomeTownHeight)
        sportHometownLbl.backgroundColor = UIColor.clearColor()
        sportHometownLbl.textAlignment = .Center
        sportHometownLbl.font = UIFont.boldSystemFontOfSize(13)
        sportHometownLbl.textColor = UIColor.whiteColor()
        sportHometownLbl.text = "SPORT IN HOMETOWN, CA"
        profileContainerView.addSubview(sportHometownLbl)
        
        descriptionLbl.frame = CGRectMake((headerViewWidth/2)-(bioWidth/2), profileImgView.frame.origin.y+profileImgView.frame.size.height+nameLbl.frame.size.height+sportHometownLbl.frame.size.height, bioWidth, bioHeight)
        descriptionLbl.backgroundColor = UIColor.clearColor()
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = UIFont.boldSystemFontOfSize(14)
        descriptionLbl.textColor = UIColor.init(white: 0.35, alpha: 1.0)
        descriptionLbl.text = bio
        descriptionLbl.textAlignment = NSTextAlignment.Center
        profileContainerView.addSubview(descriptionLbl)
        
        headerContainerView.addSubview(profileContainerView)
        
        
        //
        // fans/following/invite
        //
        let fansFollowingInviteContainerView = UIView(frame: CGRectMake(0, profileContainerViewHeight+15,  headerViewWidth, fansHeight))
        
        fansNumBtn.frame = CGRectMake(0, 0, fansWidth, 30)
        fansNumBtn.backgroundColor = UIColor.clearColor()
        fansNumBtn.addTarget(self, action:#selector(self.fansBtnAction), forControlEvents:.TouchUpInside)
        fansNumBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        fansNumBtn.titleLabel?.numberOfLines = 1
        fansNumBtn.contentHorizontalAlignment = .Center
        fansNumBtn.contentVerticalAlignment = .Center
        fansNumBtn.titleLabel?.textAlignment = .Center
        fansNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fansNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        fansNumBtn.setTitle("11", forState: UIControlState.Normal)
        fansFollowingInviteContainerView.addSubview(fansNumBtn)
        
        let fansBtn = UIButton.init(type: UIButtonType.Custom)
        fansBtn.frame = CGRectMake(0, 30, fansWidth, 20)
        fansBtn.backgroundColor = UIColor.clearColor()
        fansBtn.addTarget(self, action:#selector(self.fansBtnAction), forControlEvents:.TouchUpInside)
        fansBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        fansBtn.titleLabel?.numberOfLines = 1
        fansBtn.contentHorizontalAlignment = .Center
        fansBtn.contentVerticalAlignment = .Center
        fansBtn.titleLabel?.textAlignment = .Center
        fansBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fansBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        fansBtn.setTitle("FANS", forState: .Normal)
        fansFollowingInviteContainerView.addSubview(fansBtn)
        
        followingNumBtn.frame = CGRectMake(fansWidth, 0, fansWidth, 30)
        followingNumBtn.backgroundColor = UIColor.clearColor()
        followingNumBtn.addTarget(self, action:#selector(self.followingBtnAction), forControlEvents:.TouchUpInside)
        followingNumBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        followingNumBtn.titleLabel?.numberOfLines = 1
        followingNumBtn.contentHorizontalAlignment = .Center
        followingNumBtn.contentVerticalAlignment = .Center
        followingNumBtn.titleLabel?.textAlignment = .Center
        followingNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        followingNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        followingNumBtn.setTitle("12", forState: .Normal)
        fansFollowingInviteContainerView.addSubview(followingNumBtn)
        
        let followingBtn = UIButton.init(type: UIButtonType.Custom)
        followingBtn.frame = CGRectMake(fansWidth, 30, fansWidth, 20)
        followingBtn.backgroundColor = UIColor.clearColor()
        followingBtn.addTarget(self, action:#selector(self.followingBtnAction), forControlEvents:.TouchUpInside)
        followingBtn.titleLabel?.font = UIFont.systemFontOfSize(10)
        followingBtn.titleLabel?.numberOfLines = 1
        followingBtn.contentHorizontalAlignment = .Center
        followingBtn.contentVerticalAlignment = .Center
        followingBtn.titleLabel?.textAlignment = .Center
        followingBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        followingBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        followingBtn.setTitle("FOLLOWING", forState: .Normal)
        fansFollowingInviteContainerView.addSubview(followingBtn)
        
        let inviteBtnWidth = ((headerViewWidth/2)/4)*3
        let half = headerViewWidth/2
        let dif = half - inviteBtnWidth
        
        let inviteBtn = UIButton.init(type: UIButtonType.Custom)
        inviteBtn.frame = CGRectMake(headerViewWidth/2+(dif/2), 0, inviteBtnWidth, fansHeight)
        inviteBtn.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        inviteBtn.addTarget(self, action:#selector(self.inviteBtnAction), forControlEvents:.TouchUpInside)
        inviteBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        inviteBtn.titleLabel?.numberOfLines = 1
        inviteBtn.contentHorizontalAlignment = .Center
        inviteBtn.contentVerticalAlignment = .Center
        inviteBtn.titleLabel?.textAlignment = .Center
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        inviteBtn.setTitle("INVITE", forState: .Normal)
        fansFollowingInviteContainerView.addSubview(inviteBtn)
        
        headerContainerView.addSubview(fansFollowingInviteContainerView)
        
        //
        //
        //
        
        let headerViewHeight = CGFloat(50+headerContainerViewHeight+40+64)
        
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, headerViewWidth, headerViewHeight))
        self.theTableView.tableHeaderView?.backgroundColor = UIColor(red:43/255, green:43/255, blue:43/255, alpha:1)

        self.theTableView.tableHeaderView?.addSubview(headerContainerView)
        
        //
        //
        //
        
        
        let headerNavView = UIView(frame: CGRectMake(0, headerViewHeight-64, headerViewWidth, 64))
        headerNavView.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        self.theTableView.tableHeaderView?.addSubview(headerNavView)
        
        
        
        
        
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, headerViewHeight+64-0.5, headerViewWidth, 0.5)
        line.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        self.theTableView.tableHeaderView?.addSubview(line)
        
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        self.theTableView.addSubview(refreshControl)
        
        print("passedUserId: \(passedUserId)")
        
        self.getUser()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.isPushed = false
    }
    
    func getUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let userId = defaults.stringForKey("userId")! as NSString
        
        if (self.passedUserId == userId) {
            
            // set user base on defaults
            
            print("currentUser")
            
            // profileImgView
            // nameLbl
            // sportHometownLbl
            // descriptionLbl
            // fansNumBtn
            // followingNumBtn
            
//            defaults.setObject(userId, forKey: "userId")
//            defaults.setObject(username, forKey: "username")
//            defaults.setObject(hometown, forKey: "hometown")
//            defaults.setObject(imageUrl, forKey: "imageUrl")
//            defaults.setObject(description, forKey: "description")
//            defaults.setObject(firstName, forKey: "firstName")
//            defaults.setObject(lastName, forKey: "lastName")
//            defaults.setObject(followersCount, forKey: "followersCount")
//            defaults.setObject(followingCount, forKey: "followingCount")
//            
//            defaults.setObject(momentCount, forKey: "momentCount")
//            defaults.setObject(lockerProductCount, forKey: "lockerProductCount")
//            
//            defaults.setObject(sportsArray, forKey: "sports")
            
            //let imageUrl = defaults.objectForKey("imageUrl") as! String
            //let username = defaults.objectForKey("username") as! String
            let firstName = defaults.objectForKey("firstName") as! String
            let lastName = defaults.objectForKey("lastName") as! String
            let sports = defaults.objectForKey("sports") as! NSArray
            let hometown = defaults.objectForKey("hometown") as! String
            let description = defaults.objectForKey("description") as! String
            let followersNum = defaults.objectForKey("followersCount") as! NSNumber
            let followingNum = defaults.objectForKey("followingCount") as! NSNumber
            
            
            print("sports: \(sports)")
            let sportsStr = sports.componentsJoinedByString(", ")
            //let sportsStr = sports.description
            //let momentNum = defaults.objectForKey("momentCount") as! NSNumber
            //let gearNum = defaults.objectForKey("lockerProductCount") as! NSNumber
            
            self.nameLbl.text = String("\(firstName) \(lastName)").uppercaseString
            self.sportHometownLbl.text = String("\(sportsStr) IN \(hometown)").uppercaseString
            self.descriptionLbl.text = "\(description)"
            self.fansNumBtn.setTitle(String("\(followersNum)").uppercaseString, forState: .Normal)
            self.followingNumBtn.setTitle(String("\(followingNum)").uppercaseString, forState: .Normal)
            
            self.queryForTimeline()
            
        } else {
            
            // need back action
            
            let backBtn = UIButton(type: UIButtonType.Custom)
            backBtn.frame = CGRectMake(20, 0, 70, 44)
            backBtn.setImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            //settingsBtn.setBackgroundImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            backBtn.backgroundColor = UIColor.redColor()
            backBtn.addTarget(self, action:#selector(self.backBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            self.navBarView.addSubview(backBtn)
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.backBtnAction))
            rightSwipe.direction = .Right
            self.view.addGestureRecognizer(rightSwipe)
            
            //
            // query for user?
            // or query for moments and use a single user dictionary from moment data?
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let bearerToken = defaults.objectForKey("bearerToken") as! NSString
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            
            guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/:id?\(self.passedUserId)") else {return}
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
                            
                            self.userData = dataFromString
                            let user = JSON(data: self.userData)
                            print("user: \(user)")
                                                        
                            // populate headerView and stats tab
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                            })
                            
                        } else {
                            // print("URL Session Task Failed: %@", error!.localizedDescription);
                            self.refreshControl.endRefreshing()
                        }
                    } else {
                        self.refreshControl.endRefreshing()
                    }
                })
                task.resume()
                //
            })
        }
        
    }
    
    func fansBtnAction() {
        
        // push to fans
        
        
    }
    
    func followingBtnAction() {
        
        // push to following
        
    }

    func inviteBtnAction() {
        
        
        
    }
    
    
    
    func refreshControlAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).lastvisiteddate = NSDate()
        
        //let newme = PFUser.currentUser()
        //newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //newme!.saveInBackground()
        
        
        self.queryForTimeline()
        
    }
    func queryForTimeline() {
        
        
        
        
        
        
        
        
        // either way
        
        self.theTableView.reloadData()
        
        self.refreshControl.endRefreshing()
        
    }
    
   
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    func backBtnAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func settingsBtnAction() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        //        aView.addSubview(aLbl)
        
        return aView;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TimelineCell = TimelineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        cell.textLabel
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
    }
    
    func userBtnAction(sender: UIButton!){
        
        
    }
    
    

}
