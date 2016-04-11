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
    
    var initialProfile: Bool = false
    
    var navBarView = UIView()
    
    var teamData = NSData()
    var momentsData = NSData()
    var gearData = NSData()
    
    var userId = ""
    var username = ""
    var imageUrl = ""
    var firstName = ""
    var lastName = ""
    var sports = []
    var hometown = ""
    var bio = ""
    var userFollows: Bool = false
    var lockerProductCount = NSNumber()
    var followingCount = NSNumber()
    var followersCount = NSNumber()
    var momentCount = NSNumber()
    
    
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var activityArray = NSArray()
    
    var profileImgView = UIImageView()
    var nameLbl = UILabel()
    var sportHometownLbl = UILabel()
    var descriptionLbl = UILabel()
    var fansNumBtn = UIButton.init(type: UIButtonType.Custom)
    var followingNumBtn = UIButton.init(type: UIButtonType.Custom)
    
    let inviteBtn = UIButton.init(type: UIButtonType.Custom)
    
    var isPushed: Bool = false
    
    var tabBtn1 = UIButton(type: UIButtonType.Custom)
    var tabBtn2 = UIButton(type: UIButtonType.Custom)
    var tabBtn3 = UIButton(type: UIButtonType.Custom)
    
    var queriedForTimeline: Bool = false
    var queriedForGear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = username.uppercaseString
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .None
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(MainCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        let padding = CGFloat(10)
        let headerViewWidth = view.frame.size.width
        
        let fansWidth = (headerViewWidth/2)/2
        let fansHeight = CGFloat(50)
        
        let profilePicWidth = headerViewWidth/3
        let nameHeight = CGFloat(30)
        let sportHomeTownHeight = CGFloat(28)
        
        let bioWidth = view.frame.size.width-50
        let bioHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(bio, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: bioWidth)+padding+padding

        
        let headerContainerViewHeight = profilePicWidth+padding+nameHeight+sportHomeTownHeight+bioHeight+padding+padding+fansHeight
        let headerContainerView = UIView(frame: CGRectMake(0, 50, headerViewWidth, headerContainerViewHeight))
        
        
        //
        // profile pic, name, hometown,
        //
        
        let profileContainerViewHeight = profilePicWidth+padding+nameHeight+sportHomeTownHeight+bioHeight+padding+padding
        let profileContainerView = UIView(frame: CGRectMake(0, 0,  headerViewWidth, profileContainerViewHeight))
        
        profileImgView.frame = CGRectMake(profilePicWidth, 0, profilePicWidth, profilePicWidth)
        profileImgView.backgroundColor = UIColor.lightGrayColor()
        profileContainerView.addSubview(profileImgView)
        let fileUrl = NSURL(string: imageUrl)
        profileImgView.setNeedsLayout()
        profileImgView.hnk_setImageFromURL(fileUrl!) 
        
        nameLbl.frame = CGRectMake(0, profileImgView.frame.origin.y+profileImgView.frame.size.height+padding, headerViewWidth, nameHeight)
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.textAlignment = .Center
        nameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 24)
        nameLbl.textColor = UIColor.whiteColor()
        profileContainerView.addSubview(nameLbl)
        nameLbl.text = "\(firstName) \(lastName)".uppercaseString
        
        sportHometownLbl.frame = CGRectMake(0, profileImgView.frame.origin.y+profileImgView.frame.size.height+padding+nameLbl.frame.size.height, headerViewWidth, sportHomeTownHeight)
        sportHometownLbl.backgroundColor = UIColor.clearColor()
        sportHometownLbl.textAlignment = .Center
        sportHometownLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 13)
        sportHometownLbl.textColor = UIColor.whiteColor()
        profileContainerView.addSubview(sportHometownLbl)
        let sportsStr = sports.componentsJoinedByString(", ")
        sportHometownLbl.text = String("\(sportsStr) IN \(hometown)").uppercaseString
        
        descriptionLbl.frame = CGRectMake((headerViewWidth/2)-(bioWidth/2), profileImgView.frame.origin.y+profileImgView.frame.size.height+padding+nameLbl.frame.size.height+sportHometownLbl.frame.size.height, bioWidth, bioHeight)
        descriptionLbl.backgroundColor = UIColor.clearColor()
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        descriptionLbl.textColor = UIColor.init(white: 0.35, alpha: 1.0)
        descriptionLbl.textAlignment = NSTextAlignment.Center
        profileContainerView.addSubview(descriptionLbl)
        descriptionLbl.text = bio
        
        headerContainerView.addSubview(profileContainerView)
        
        
        //
        // fans/following/invite
        //
        let fansFollowingInviteContainerView = UIView(frame: CGRectMake(0, profileContainerViewHeight,  headerViewWidth, fansHeight))
        
        fansNumBtn.frame = CGRectMake(0, 0, fansWidth, 30)
        fansNumBtn.backgroundColor = UIColor.clearColor()
        fansNumBtn.addTarget(self, action:#selector(fansBtnAction), forControlEvents:.TouchUpInside)
        fansNumBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        fansNumBtn.titleLabel?.numberOfLines = 1
        fansNumBtn.contentHorizontalAlignment = .Center
        fansNumBtn.contentVerticalAlignment = .Center
        fansNumBtn.titleLabel?.textAlignment = .Center
        fansNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fansNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        fansFollowingInviteContainerView.addSubview(fansNumBtn)
        fansNumBtn.setTitle(String("\(followersCount)").uppercaseString, forState: .Normal)
        
        let fansBtn = UIButton.init(type: UIButtonType.Custom)
        fansBtn.frame = CGRectMake(0, 30, fansWidth, 20)
        fansBtn.backgroundColor = UIColor.clearColor()
        fansBtn.addTarget(self, action:#selector(fansBtnAction), forControlEvents:.TouchUpInside)
        fansBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Demi", size: 10)
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
        followingNumBtn.addTarget(self, action:#selector(followingBtnAction), forControlEvents:.TouchUpInside)
        followingNumBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        followingNumBtn.titleLabel?.numberOfLines = 1
        followingNumBtn.contentHorizontalAlignment = .Center
        followingNumBtn.contentVerticalAlignment = .Center
        followingNumBtn.titleLabel?.textAlignment = .Center
        followingNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        followingNumBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        fansFollowingInviteContainerView.addSubview(followingNumBtn)
        followingNumBtn.setTitle(String("\(followingCount)").uppercaseString, forState: .Normal)
        
        let followingBtn = UIButton.init(type: UIButtonType.Custom)
        followingBtn.frame = CGRectMake(fansWidth, 30, fansWidth, 20)
        followingBtn.backgroundColor = UIColor.clearColor()
        followingBtn.addTarget(self, action:#selector(followingBtnAction), forControlEvents:.TouchUpInside)
        followingBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Demi", size: 10)
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
        
        inviteBtn.frame = CGRectMake(headerViewWidth/2+(dif/2), 0, inviteBtnWidth, fansHeight)
        inviteBtn.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        inviteBtn.addTarget(self, action:#selector(inviteBtnAction), forControlEvents:.TouchUpInside)
        inviteBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        inviteBtn.titleLabel?.numberOfLines = 1
        inviteBtn.contentHorizontalAlignment = .Center
        inviteBtn.contentVerticalAlignment = .Center
        inviteBtn.titleLabel?.textAlignment = .Center
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        fansFollowingInviteContainerView.addSubview(inviteBtn)
        
        headerContainerView.addSubview(fansFollowingInviteContainerView)
        
        //
        //
        
        
        
        //
        //
        
        let headerViewHeight = CGFloat(50+headerContainerViewHeight+40)
        
        theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, headerViewWidth, headerViewHeight))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1) //UIColor(red:43/255, green:43/255, blue:43/255, alpha:1)
        
        theTableView.tableHeaderView?.addSubview(headerContainerView)
        //
        
        
        //
        //
        //
        
        
//        let headerNavView = UIView(frame: CGRectMake(0, headerViewHeight-64, headerViewWidth, 64))
//        headerNavView.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
//        theTableView.tableHeaderView?.addSubview(headerNavView)
        
        
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, headerViewHeight+64-0.5, headerViewWidth, 0.5)
        line.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        theTableView.tableHeaderView?.addSubview(line)
        
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        theTableView.addSubview(refreshControl)
        
        //
        
        self.tabBtn1Action()
        
        //
        
        print("userId: \(userId)")
        
        queryForUser()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        isPushed = false
        
    }
    
    func queryForUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.stringForKey("userId")! as NSString
        
        if (initialProfile) {
            
            let settingsBtn = UIButton(type: UIButtonType.Custom)
            settingsBtn.frame = CGRectMake(navBarView.frame.size.width-70-20, 20, 70, 44)
            settingsBtn.setImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            //settingsBtn.setBackgroundImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            settingsBtn.backgroundColor = UIColor.blueColor()
            settingsBtn.addTarget(self, action:#selector(settingsBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            navBarView.addSubview(settingsBtn)
            
            inviteBtn.setTitle("INVITE TEAM", forState: .Normal)
            
        } else {
            
            if (userId == uid) {
                print("currentUser")
                
                inviteBtn.setTitle("INVITE TEAM", forState: .Normal)
                
            } else {
                
                if (userFollows) {
                    inviteBtn.selected = true
                    inviteBtn.setTitle("UNFOLLOW", forState: .Normal)
                } else {
                    inviteBtn.selected = false
                    inviteBtn.setTitle("FOLLOW", forState: .Normal)
                }
            }
            
            // need back action
            
            let backBtn = UIButton(type: UIButtonType.Custom)
            backBtn.frame = CGRectMake(20, 20, 70, 44)
            backBtn.setImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            //settingsBtn.setBackgroundImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            backBtn.backgroundColor = UIColor.redColor()
            backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
            navBarView.addSubview(backBtn)
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
            rightSwipe.direction = .Right
            view.addGestureRecognizer(rightSwipe)
            
        }
        
        //
        
        queryForStats()
        
        //
    }
    
    
    func refreshControlAction() {
        
        
        theTableView.reloadData()
        
        refreshControl.endRefreshing()
        
        
    }
    
    func fansBtnAction() {
        
        // push to fans
        
        if (Int(followersCount) > 0) {
            let vc = PeopleListViewController()
            vc.passedTitle = "FANS"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followingBtnAction() {
        
        // push to following
        
        if (Int(followingCount) > 0) {
            let vc = PeopleListViewController()
            vc.passedTitle = "FOLLOWING"
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func inviteBtnAction() {
        
        // if currentUser, invite
        //
        // if not currentUser - follow / un-follow
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.stringForKey("userId")! as NSString
        
        if (userId == uid) {
            print("currentUser")
            
            // invite
            
            
        } else {
            
            if (inviteBtn.selected) {
                
                inviteBtn.selected = false
                inviteBtn.setTitle("FOLLOW", forState: .Normal)
                
            } else {
                
                inviteBtn.selected = true
                inviteBtn.setTitle("UNFOLLOW", forState: .Normal)
                
            }
            
        }
        
    }
    
    func tabBtn1Action() {
        
        tabBtn1.selected = true
        tabBtn2.selected = false
        tabBtn3.selected = false
        
        // refresh view to show teams
        
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 70))
        self.theTableView.tableFooterView?.backgroundColor = UIColor.yellowColor()
        
        self.theTableView.reloadData()
        self.queryForStats()
        
        
    }
    
    func tabBtn2Action() {
        
        tabBtn1.selected = false
        tabBtn2.selected = true
        tabBtn3.selected = false
        
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
        self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        
        // refresh view to show moments
        
        if (self.queriedForTimeline) {
            // do nothing
            self.theTableView.reloadData()
        } else {
            // query!
            self.theTableView.reloadData()
            self.queryForTimeline()
        }
        
    }
    
    func tabBtn3Action() {
        
        tabBtn1.selected = false
        tabBtn2.selected = false
        tabBtn3.selected = true
        
        // refresh view to show gear
        
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 00))
        self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
        
        // refresh view to show gear
        
        if (self.queriedForGear) {
            // do nothing
            self.theTableView.reloadData()
        } else {
            // query!
            self.theTableView.reloadData()
            self.queryForGear()
        }
        
    }
    
    func queryForStats() {
        
        // either way
        
        theTableView.reloadData()
        
        refreshControl.endRefreshing()
        
    }
    
    func queryForTimeline() {
        print("queryForTimeline hit")
        // get bearer token
        
        //let date = NSDate().timeIntervalSince1970 * 1000
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        // /user/:id/moments
        
        // need "since" and "limit"
        let date = NSDate().timeIntervalSince1970 * 1000
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(userId)/moments?since=\(date)&limit=20") else {return}
        
        
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
                        
                        self.momentsData = dataFromString
                        
                        self.queriedForTimeline = true
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.refreshControl.endRefreshing()
                            
                            self.theTableView.reloadData()
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
        
        // end with animation
        
    }
    
    func queryForGear() {
        print("queryForGear hit")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        let date = NSDate().timeIntervalSince1970 * 1000
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(userId)/locker?since=\(date)&limit=20") else {return}
        
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
                        
                        self.gearData = dataFromString
                        
                        let results = json["results"]
                        print(results)
                        
                        self.queriedForGear = true
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.refreshControl.endRefreshing()
                            
                            self.theTableView.reloadData()
                            
                        })
                        
                    } else {
                        print("URL Session Task Failed: %@", error!.localizedDescription)
                        
                    }
                    
                }
                
            })
            task.resume()
        })

        
        
    }
    
    
   
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func settingsBtnAction() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tabBtn1.selected) {
            return 1
        } else if (tabBtn2.selected) {
            let json = JSON(data: momentsData)
            return json["results"].count
        } else if (tabBtn3.selected) {
            let gear = JSON(data: gearData)
            return gear["results"].count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tabContainerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        tabContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) //UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        
        let tabWidth = view.frame.width/3
        
        tabBtn1.frame = CGRectMake(0, 0, tabWidth, 64)
        tabBtn1.backgroundColor = UIColor.clearColor()
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        tabBtn1.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabContainerView.addSubview(tabBtn1)
        tabBtn1.setTitle("0 STATS", forState: UIControlState.Normal)
        
        tabBtn2.frame = CGRectMake(tabWidth*1, 0, tabWidth, 64)
        tabBtn2.backgroundColor = UIColor.clearColor()
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        tabBtn2.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabContainerView.addSubview(tabBtn2)
        let s = momentCount == 1 ? "" : "S"
        tabBtn2.setTitle("\(momentCount) MOMENT\(s)", forState: UIControlState.Normal)
        
        tabBtn3.frame = CGRectMake(tabWidth*2, 0, tabWidth, 64)
        tabBtn3.backgroundColor = UIColor.clearColor()
        tabBtn3.titleLabel?.numberOfLines = 1
        tabBtn3.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn3.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        tabBtn3.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabContainerView.addSubview(tabBtn3)
        tabBtn3.setTitle("\(lockerProductCount) GEAR", forState: UIControlState.Normal)
        
        return tabContainerView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
        
        if (tabBtn1.selected) {
            
            // for stats
            return view.frame.size.width // probably 150 by default then raise to second line of text if necessary
            
        } else if (tabBtn2.selected) {
            
            // for moments - measure height
            
            let padding = CGFloat(15)
            let imgHeight = view.frame.size.width+100
            
            var headlineHeight = CGFloat()
            
            let json = JSON(data: momentsData)
            let results = json["results"]
            if let id = results[indexPath.row]["headline"].string {
                let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if (trimmedString == "") {
                    headlineHeight = 0
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: self.view.frame.size.width-30)
                    headlineHeight = height+10
                }
            } else {
                headlineHeight = 0
            }
            
            if (headlineHeight == 0) {
                return imgHeight+padding+40+padding+40+padding+padding
            } else {
                return imgHeight+padding+40+padding+headlineHeight+padding+40+padding+padding
            }
            
            
        } else if (tabBtn3.selected) {
            
            // for gear
            
            let json = JSON(data: gearData)
            let results = json["results"]
            
            var brandHeight = CGFloat()
            var nameHeight = CGFloat()
            
            if let id = results[indexPath.row]["brand"].string {
                if (id == "") {
                    brandHeight = 0
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 16)!, width: self.view.frame.size.width-15-15-44-15)
                    brandHeight = height
                }
            } else {
                brandHeight = 0
            }
            
            if let id = results[indexPath.row]["name"].string {
                if (id == "") {
                    nameHeight = 0
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 16)!, width: self.view.frame.size.width-15-15-44-15)
                    nameHeight = height
                }
            } else {
                nameHeight = 0
            }
            
            if (brandHeight == 0) {
                return view.frame.size.width+15+nameHeight+15
            } else {
                return view.frame.size.width+15+brandHeight+5+nameHeight+15+15
            }
            
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainCell = MainCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        if (tabBtn1.selected) {
            
            // for stats
            cell.teamNameLbl.hidden = false
            cell.teamSportLbl.hidden = false
            cell.teamNumLbl.hidden = false
            cell.teamPositionLbl.hidden = false
            
            cell.timelineImgView.hidden = true
            cell.timelineMusicLbl.hidden = true
            cell.timelineModeLbl.hidden = true
            cell.timelineTinyHeartBtn.hidden = true
            cell.timelineLikeLblBtn.hidden = true
            cell.timelineUserImgView.hidden = true
            cell.timelineUserImgViewBtn.hidden = true
            cell.timelineNameLbl.hidden = true
            cell.timelineTimeLbl.hidden = true
            cell.timelineFollowBtn.hidden = true
            cell.timelineHeadlineLbl.hidden = true
            cell.timelineLikeBtn.hidden = true
            cell.timelineCommentBtn.hidden = true
            cell.timelineGearBtn.hidden = true
            cell.timelineMoreBtn.hidden = true
            
            cell.gearImgView.hidden = true
            cell.gearBrandLbl.hidden = true
            cell.gearNameLbl.hidden = true
            cell.gearAddBtn.hidden = true

            
            
            
            
        } else if (tabBtn2.selected) {
            
            // for moments - measure height

            cell.teamNameLbl.hidden = true
            cell.teamSportLbl.hidden = true
            cell.teamNumLbl.hidden = true
            cell.teamPositionLbl.hidden = true
            
            cell.timelineImgView.hidden = false
            cell.timelineMusicLbl.hidden = false
            cell.timelineModeLbl.hidden = false
            cell.timelineTinyHeartBtn.hidden = false
            cell.timelineLikeLblBtn.hidden = false
            cell.timelineUserImgView.hidden = false
            cell.timelineUserImgViewBtn.hidden = false
            cell.timelineNameLbl.hidden = false
            cell.timelineTimeLbl.hidden = false
            cell.timelineFollowBtn.hidden = false
            cell.timelineHeadlineLbl.hidden = false
            cell.timelineLikeBtn.hidden = false
            cell.timelineCommentBtn.hidden = false
            cell.timelineGearBtn.hidden = false
            cell.timelineMoreBtn.hidden = false
            
            cell.gearImgView.hidden = true
            cell.gearBrandLbl.hidden = true
            cell.gearNameLbl.hidden = true
            cell.gearAddBtn.hidden = true
            
            //
            
            cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth+100)
            
            //timelineTinyHeartBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
            //timelineLikeLblBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
            
            cell.timelineUserImgView.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15, 40, 40)
            cell.timelineUserImgViewBtn.frame = CGRectMake(cell.timelineUserImgView.frame.origin.x, cell.timelineUserImgView.frame.origin.y, cell.timelineUserImgView.frame.size.width, cell.timelineUserImgView.frame.size.height)
            cell.timelineFollowBtn.frame = CGRectMake(cell.cellWidth-50-15, cell.timelineImgView.frame.size.height+15, 50, 40)
            
            //
            
            let json = JSON(data: momentsData)
            let results = json["results"]
            
            if let id = results[indexPath.row]["imageUrl"].string {
                let fileUrl = NSURL(string: id)
                
                cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth+100)
                cell.timelineImgView.setNeedsLayout()
                
                cell.timelineImgView.hnk_setImageFromURL(fileUrl!, placeholder: UIImage.init(named: ""),
                                                       success: { image in
                                                        
                                                        //print("image here: \(image)")
                                                        cell.timelineImgView.image = image
                                                        
                    },
                                                       failure: { error in
                                                        
                                                        if ((error) != nil) {
                                                            print("error here: \(error)")
                                                        }
                })
                //print("cell.momentImgView.image: \(cell.momentImgView.image)")
            }
            
            if let id = results[indexPath.row]["mode"].number {
                var str = ""
                if (id == 0) {
                    str = "TRAINING"
                } else if (id == 1) {
                    str = "GAMING"
                } else {
                    str = "STYLING"
                }
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineModeLbl.font, height: cell.timelineModeLbl.frame.size.height)
                if (width > cell.cellWidth-30) {
                    cell.timelineModeLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-15, cell.cellWidth-30, 20)
                } else {
                    cell.timelineModeLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-15, width+20, 20)
                }
                cell.timelineModeLbl.text = str
            }
            
            if let id = results[indexPath.row]["song"]["artistName"].string {
                cell.timelineMusicLbl.hidden = false
                let str = "\(id) | \(results[indexPath.row]["song"]["trackName"])"
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineMusicLbl.font, height: cell.timelineMusicLbl.frame.size.height)
                if (width > cell.cellWidth-30) {
                    cell.timelineMusicLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-10-20-15, cell.cellWidth-30, 20)
                } else {
                    cell.timelineMusicLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-10-20-15, width+20, 20)
                }
                cell.timelineMusicLbl.text = str
            } else {
                cell.timelineMusicLbl.hidden = true
            }
            
            if let id = results[indexPath.row]["user"]["imageUrl"].string {
                
                let fileUrl = NSURL(string: id)
                cell.timelineUserImgView.setNeedsLayout()
                
                //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
                cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!, placeholder: UIImage.init(named: ""),
                                                             success: { image in
                                                                
                                                                //print("image here: \(image)")
                                                                cell.timelineUserImgView.image = image
                                                                
                    },
                                                             failure: { error in
                                                                
                                                                if ((error) != nil) {
                                                                    print("error here: \(error)")
                                                                    
                                                                }
                })
            }
            
            if let id = results[indexPath.row]["user"]["firstName"].string {
                
                let last = "\(results[indexPath.row]["user"]["lastName"])"
                let str = "\(id) \(last)"
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineNameLbl.font, height: 20)
                cell.timelineNameLbl.frame = CGRect(x: 15+40+15, y: cell.timelineImgView.frame.size.height+15, width: width, height: 20)
                cell.timelineNameLbl.text = str
                
            }
            
            if let id = results[indexPath.row]["createdAt"].string {
                //let strDate = "2015-11-01T00:00:00Z" // "2015-10-06T15:42:34Z"
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"  //"yyyy-MM-dd'T'HH:mm:ssZ"
                let date = dateFormatter.dateFromString(id)!
                let since = (UIApplication.sharedApplication().delegate as! AppDelegate).timeAgoSinceDate(date, numericDates: true)
                
                var dateStr = ""
                if let ht = results[indexPath.row]["user"]["hometown"].string {
                    dateStr = "\(since) - \(ht)"
                } else {
                    dateStr = "\(since)"
                }
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(dateStr, font: cell.timelineTimeLbl.font, height: 20)
                cell.timelineTimeLbl.frame = CGRect(x: 15+40+15, y: cell.timelineImgView.frame.size.height+15+20, width: width, height: 20)
                cell.timelineTimeLbl.text = dateStr
            }
            
            if let id = results[indexPath.row]["likesCount"].number {
                let str = "\(id) likes"
                cell.timelineLikeLblBtn.titleLabel?.text = str
                
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: (cell.timelineLikeLblBtn.titleLabel?.font)!, height: (cell.timelineLikeLblBtn.titleLabel?.frame.size.height)!)
                cell.timelineLikeLblBtn.frame = CGRectMake(15, cell.cellWidth+50+3, 22+5+width, (cell.timelineLikeLblBtn.titleLabel?.frame.size.height)!)
            }
            
            var headlineHeight = CGFloat()
            if let id = results[indexPath.row]["headline"].string {
                let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if (trimmedString == "") {
                    headlineHeight = 0
                    cell.timelineHeadlineLbl.text = trimmedString
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: cell.timelineHeadlineLbl.font, width: cell.cellWidth-30)
                    headlineHeight = height+10
                    cell.timelineHeadlineLbl.text = trimmedString
                }
            } else {
                headlineHeight = 0
            }
            cell.timelineHeadlineLbl.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15+40+15, cell.cellWidth-30, headlineHeight)
            
            
            var btnY = CGFloat()
            if (headlineHeight == 0) {
                btnY = cell.timelineImgView.frame.size.height+15+40+15
            } else {
                btnY = cell.timelineImgView.frame.size.height+15+40+15+cell.timelineHeadlineLbl.frame.size.height+15
            }
            cell.timelineLikeBtn.frame = CGRectMake(15, btnY, 65, 38)
            cell.timelineCommentBtn.frame = CGRectMake(15+64+10, btnY, 65, 38)
            cell.timelineGearBtn.frame = CGRectMake(15+64+10+64+10, btnY, 65, 38)
            cell.timelineMoreBtn.frame = CGRectMake(15+64+10+64+10+64+10, btnY, 50, 38)
            
//            if let id = results[indexPath.row]["commentCount"].number {
//                let countStr = "\(id) comments"
//                cell.commentLbl.text = countStr
//            }
            
            
            if let id = results[indexPath.row]["user"]["userFollows"].bool {
                if (id) {
                    cell.timelineFollowBtn.selected = true
                    cell.timelineFollowBtn.hidden = true
                } else {
                    cell.timelineFollowBtn.selected = false
                    cell.timelineFollowBtn.hidden = false
                }
            } else {
                cell.timelineFollowBtn.selected = true
                cell.timelineFollowBtn.hidden = true
            }
            
            
            // button actions
            
            cell.timelineUserImgViewBtn.tag = indexPath.row
            cell.timelineLikeBtn.tag = indexPath.row
            cell.timelineCommentBtn.tag = indexPath.row
            cell.timelineGearBtn.tag = indexPath.row
            cell.timelineMoreBtn.tag = indexPath.row
            
            cell.timelineUserImgViewBtn.addTarget(self, action:#selector(timelineUserImgViewBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineLikeBtn.addTarget(self, action:#selector(timelineLikeBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineCommentBtn.addTarget(self, action:#selector(timelineCommentBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineGearBtn.addTarget(self, action:#selector(timelineGearBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineMoreBtn.addTarget(self, action:#selector(timelineMoreBtnAction), forControlEvents: .TouchUpInside)
            
            // handle taps
            
            cell.timelineSingleTapRecognizer.addTarget(self, action: #selector(timelineSingleTapAction(_:)))
            cell.timelineDoubleTapRecognizer.addTarget(self, action: #selector(timelineDoubleTapAction(_:)))
            
            
            
            
            
        } else if (tabBtn3.selected) {
            
            // for gear

            cell.teamNameLbl.hidden = true
            cell.teamSportLbl.hidden = true
            cell.teamNumLbl.hidden = true
            cell.teamPositionLbl.hidden = true
            
            cell.timelineImgView.hidden = true
            cell.timelineMusicLbl.hidden = true
            cell.timelineModeLbl.hidden = true
            cell.timelineTinyHeartBtn.hidden = true
            cell.timelineLikeLblBtn.hidden = true
            cell.timelineUserImgView.hidden = true
            cell.timelineUserImgViewBtn.hidden = true
            cell.timelineNameLbl.hidden = true
            cell.timelineTimeLbl.hidden = true
            cell.timelineFollowBtn.hidden = true
            cell.timelineHeadlineLbl.hidden = true
            cell.timelineLikeBtn.hidden = true
            cell.timelineCommentBtn.hidden = true
            cell.timelineGearBtn.hidden = true
            cell.timelineMoreBtn.hidden = true
            
            cell.gearImgView.hidden = false
            cell.gearBrandLbl.hidden = false
            cell.gearNameLbl.hidden = false
            cell.gearAddBtn.hidden = false
            
            
            cell.gearImgView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: cell.cellWidth)
            cell.gearBrandLbl.frame = CGRect(x: 15, y: cell.cellWidth+10, width: cell.cellWidth-15-15-44-15, height: 25)
            cell.gearAddBtn.frame = CGRect(x: cell.cellWidth-44-15, y: cell.cellWidth+15, width: 44, height: 40)
            
            let json = JSON(data: gearData)
            let results = json["results"]
            
            if let id = results[indexPath.row]["imageUrl"].string {
                
                let fileUrl = NSURL(string: id)
                cell.gearImgView.setNeedsLayout()
                
                //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
                cell.gearImgView.hnk_setImageFromURL(fileUrl!, placeholder: UIImage.init(named: ""),
                                                             success: { image in
                                                                
                                                                //print("image here: \(image)")
                                                                cell.gearImgView.image = image
                                                                
                    },
                                                             failure: { error in
                                                                
                                                                if ((error) != nil) {
                                                                    print("error here: \(error)")
                                                                    
                                                                }
                })
            }
            
            
            var brandHeight = CGFloat()
            var nameHeight = CGFloat()
            
            if let id = results[indexPath.row]["brand"].string {
                cell.gearBrandLbl.text = id
                brandHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearBrandLbl.font, width: self.view.frame.size.width-15-15-44-15)
            } else {
                brandHeight = 0
                cell.gearBrandLbl.text = ""
            }
            
            if let id = results[indexPath.row]["name"].string {
                cell.gearNameLbl.text = id
                nameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearNameLbl.font, width: self.view.frame.size.width-15-15-44-15)
            } else {
                cell.gearNameLbl.text = ""
            }

            if let id = results[indexPath.row]["existsInLocker"].bool {
                if (id) {
                    cell.gearAddBtn.selected = true
                } else {
                    cell.gearAddBtn.selected = false
                }
            }

            cell.gearBrandLbl.frame = CGRect(x: 15, y: cell.cellWidth+15, width: cell.cellWidth-15-15-44-15, height: brandHeight)
            
            if (cell.gearBrandLbl.text == "") {
                cell.gearNameLbl.frame = CGRect(x: 15, y: cell.cellWidth+15, width: cell.cellWidth-15-15-44-15, height: nameHeight)
            } else {
                cell.gearNameLbl.frame = CGRect(x: 15, y: cell.cellWidth+15+brandHeight+5, width: cell.cellWidth-15-15-44-15, height: nameHeight)
            }
            
            
            cell.gearSingleTapRecognizer.addTarget(self, action: #selector(gearSingleTapAction(_:)))
            cell.gearDoubleTapRecognizer.addTarget(self, action: #selector(gearDoubleTapAction(_:)))
            
            
            
        } else {
            
            cell.teamNameLbl.hidden = true
            cell.teamSportLbl.hidden = true
            cell.teamNumLbl.hidden = true
            cell.teamPositionLbl.hidden = true
            
            cell.timelineImgView.hidden = true
            cell.timelineMusicLbl.hidden = true
            cell.timelineModeLbl.hidden = true
            cell.timelineTinyHeartBtn.hidden = true
            cell.timelineLikeLblBtn.hidden = true
            cell.timelineUserImgView.hidden = true
            cell.timelineUserImgViewBtn.hidden = true
            cell.timelineNameLbl.hidden = true
            cell.timelineTimeLbl.hidden = true
            cell.timelineFollowBtn.hidden = true
            cell.timelineHeadlineLbl.hidden = true
            cell.timelineLikeBtn.hidden = true
            cell.timelineCommentBtn.hidden = true
            cell.timelineGearBtn.hidden = true
            cell.timelineMoreBtn.hidden = true
            
            cell.gearImgView.hidden = true
            cell.gearBrandLbl.hidden = true
            cell.gearNameLbl.hidden = true
            cell.gearAddBtn.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) //UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        if (tabBtn1.selected) {
            
            // for stats

            
        } else if (tabBtn2.selected) {
            
            // for moments - measure height

            
        } else if (tabBtn3.selected) {
            
            // for gear

            
        } else {

        }
        
    }
    
    
    
    func timelineUserImgViewBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["user"]["id"].string {
            
            let id = results[sender.tag]["user"]["id"].string
            let un = results[sender.tag]["user"]["username"].string
            let imageUrl = results[sender.tag]["user"]["imageUrl"].string
            let firstName = results[sender.tag]["user"]["firstName"].string
            let lastName = results[sender.tag]["user"]["lastName"].string
            let sport = results[sender.tag]["user"]["sport"].string
            let hometown = results[sender.tag]["user"]["hometown"].string
            let bio = results[sender.tag]["user"]["description"].string
            let userFollows = results[sender.tag]["user"]["userFollows"].bool
            let followingCount = results[sender.tag]["user"]["followingCount"].number
            let followersCount = results[sender.tag]["user"]["followersCount"].number
            let momentCount = results[sender.tag]["user"]["momentCount"].number
            let lockerProductCount = results[sender.tag]["user"]["lockerProductCount"].number
            
            let vc = ProfileViewController()
            vc.userId = id!
            vc.username = un!
            vc.imageUrl = imageUrl!
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.sports = [sport!]
            vc.hometown = hometown!
            vc.bio = bio!
            vc.userFollows = userFollows!
            vc.lockerProductCount = lockerProductCount!
            vc.followingCount = followingCount!
            vc.followersCount = followersCount!
            vc.momentCount = momentCount!
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineLikeBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["id"].string {
           
        }
    }
    
    func timelineCommentBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = CommentsViewController()
            vc.passedMomentId = id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineGearBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["products"].arrayObject {
            
            print("array: \(id)")
            
            let vc = GearListViewController()
            vc.passedProducts = id
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineMoreBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["id"].string {
            
        }
    }
    
    
    func timelineSingleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    print("single tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    // play video or music !!!
                    
                    //let json = JSON(data: momentsData)
                    //let results = json["results"]
                    //print(results)
                    
//                    if let id = results[tappedIndexPath.row]["song"]["publicUrl"].string {
//                        
//                        if (playingMedia) {
//                            
//                            // stop media
//                            
//                            
//                        } else {
//                            
//                            // play media
//                            
//                            
//                        }
//                        
//                        
//                    }
                    
                    
                }
            }
        }
    }
    
    
    func timelineDoubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    //likeMoment()
                    
                    print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    
                }
            }
        }
    }
    
    func gearSingleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    print("single tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    let json = JSON(data: gearData)
                    let results = json["results"]
                    //print("hmm: \(results)")
                    
                    let vc = GearDetailViewController()
                    
                    
                    let id = results[tappedIndexPath.row]["id"].number
                    let sku = results[tappedIndexPath.row]["sku"].string
                    let sourceId = results[tappedIndexPath.row]["sourceId"].number
                    let sourceProductId = results[tappedIndexPath.row]["sourceProductId"].string
                    
                    let name = results[tappedIndexPath.row]["name"].string
                    let brand = results[tappedIndexPath.row]["brand"].string
                    
                    let productDescription = results[tappedIndexPath.row]["description"].string
                    let productUrl = results[tappedIndexPath.row]["productUrl"].string
                    let imageUrl = results[tappedIndexPath.row]["imageUrl"].string
                    
                    let lockerCount = results[tappedIndexPath.row]["lockerCount"].number
                    let trainingMomentCount = results[tappedIndexPath.row]["trainingMomentCount"].number
                    let gamingMomentCount = results[tappedIndexPath.row]["gamingMomentCount"].number
                    let stylingMomentCount = results[tappedIndexPath.row]["stylingMomentCount"].number
                    
                    let existsInLocker = results[tappedIndexPath.row]["existsInLocker"].bool
                    
                    
                    vc.id = "\(id!)"
                    vc.sku = sku!
                    vc.sourceId = "\(sourceId!)"
                    vc.sourceProductId = sourceProductId!
                    vc.name = name!
                    vc.brand = brand!
                    
                    if let brandLogoImageUrl = results[tappedIndexPath.row]["brandLogoImageUrl"].string {
                        vc.brandLogoImageUrl = brandLogoImageUrl
                    }
                    
                    vc.productDescription = productDescription!
                    vc.productUrl = productUrl!
                    vc.imageUrl = imageUrl!
                    vc.lockerCount = lockerCount!
                    vc.trainingMomentCount = trainingMomentCount!
                    vc.gamingMomentCount = gamingMomentCount!
                    vc.stylingMomentCount = stylingMomentCount!
                    vc.existsInLocker = existsInLocker!
                    
                    navigationController?.pushViewController(vc, animated: true)
                    
                    
                    isPushed = true                    
                    
                }
            }
        }
    }
    
    func gearDoubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    // if not added - add gear
                    
                    
                    
                }
            }
        }
    }
    

}
