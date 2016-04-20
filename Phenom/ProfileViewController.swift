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
import AVFoundation
import MobileCoreServices
import Just

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var initialProfile: Bool = false
    
    var navBarView = UIView()
    
    var passedUserData = JSON(data: NSData())
    
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
        
        // parse user json
        
        if (!self.initialProfile) {
            
            let ht = passedUserData["hometown"].string
            
            userId = passedUserData["id"].string!
            username = passedUserData["username"].string!
            imageUrl = passedUserData["imageUrl"].string!
            firstName = passedUserData["firstName"].string!
            lastName = passedUserData["lastName"].string!
            sports = [passedUserData["sport"].string!]
            hometown = ht != nil ? ht! : ""
            bio = passedUserData["description"].string!
            
            userFollows = passedUserData["userFollows"].bool!
            
            lockerProductCount = passedUserData["lockerProductCount"].number!
            followingCount = passedUserData["followingCount"].number!
            followersCount = passedUserData["followersCount"].number!
            momentCount = passedUserData["momentCount"].number!
            
        }
        
        //
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let searchBtn = UIButton(type: UIButtonType.Custom)
        searchBtn.frame = CGRectMake(15, 20, 44, 44)
        searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), forState: UIControlState.Normal)
        //searchBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.clearColor()
        searchBtn.addTarget(self, action:#selector(searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(searchBtn)
        
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
        sportHometownLbl.text = String("\(sportsStr)").uppercaseString // IN \(hometown)
        
        descriptionLbl.frame = CGRectMake((headerViewWidth/2)-(bioWidth/2), profileImgView.frame.origin.y+profileImgView.frame.size.height+padding+nameLbl.frame.size.height+sportHometownLbl.frame.size.height, bioWidth, bioHeight)
        descriptionLbl.backgroundColor = UIColor.clearColor()
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        descriptionLbl.textColor = UIColor.init(white: 0.5, alpha: 1.0)
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
        inviteBtn.backgroundColor = UINavigationBar.appearance().tintColor
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
        
        let headerViewHeight = CGFloat(50+headerContainerViewHeight+40)
        
        ////
        
        //let tabContainerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        let tabContainerView = UIView(frame: CGRectMake(0, headerViewHeight, self.view.frame.size.width, 64))
        tabContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        //let tabWidth = view.frame.width/3
        let tabWidth = view.frame.width/2
        
        tabBtn1.frame = CGRectMake(0, 0, tabWidth, 64)
        tabBtn1.backgroundColor = UIColor.clearColor()
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        //tabContainerView.addSubview(tabBtn1)
        tabBtn1.setTitle("0 STATS", forState: UIControlState.Normal)
        
        tabBtn2.frame = CGRectMake(tabWidth*0, 0, tabWidth, 64)
        tabBtn2.backgroundColor = UIColor.clearColor()
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabContainerView.addSubview(tabBtn2)
        let s = momentCount == 1 ? "" : "S"
        tabBtn2.setTitle("\(momentCount) MOMENT\(s)", forState: UIControlState.Normal)
        
        tabBtn3.frame = CGRectMake(tabWidth*1, 0, tabWidth, 64)
        tabBtn3.backgroundColor = UIColor.clearColor()
        tabBtn3.titleLabel?.numberOfLines = 1
        tabBtn3.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn3.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        tabBtn3.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabContainerView.addSubview(tabBtn3)
        tabBtn3.setTitle("\(lockerProductCount) GEAR", forState: UIControlState.Normal)
        
        ////
        
        theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, headerViewWidth, headerViewHeight+64))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        
        theTableView.tableHeaderView?.addSubview(headerContainerView)
        
        theTableView.tableHeaderView?.addSubview(tabContainerView)
        
        //
        //
        //
        
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        theTableView.addSubview(refreshControl)
        
        //
        
        //self.tabBtn1Action()
        self.tabBtn2Action()
        
        //
        
        queryForUser()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isPushed = false
        
        if (!initialProfile) {

            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
        
        
        //
        // to update user defaults
        //
        self.theTableView.reloadData()
        //
        
    }
    
    func searchBtnAction() {
        
        self.navigationController?.pushViewController(ExploreViewController(), animated: true)
        
        self.isPushed = true
        
    }
    
    
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    func refreshControlAction() {
        
        if (tabBtn1.selected) {
            
            self.queryForUser()
            
        } else if (tabBtn2.selected) {
            
            self.queryForTimeline()
            
        } else if (tabBtn3.selected) {
            
            self.queryForGear()
            
        } else {
            print("no tab selected")
        }
        
    }
    
    
    
    func queryForUser() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.stringForKey("userId")! as String
        
        if (initialProfile) {
            
            let settingsBtn = UIButton(type: UIButtonType.Custom)
            settingsBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
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
            backBtn.frame = CGRectMake(15, 20, 44, 44)
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
        // now get user
        //
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(userId)"
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
                    
                    // update user
    
                    let user = json["results"]
                    print("user: \(user)")
                    
                    // success, save user defaults
                    
                    self.userId = user["id"].string!
                    self.username = user["username"].string!
                    self.hometown = user["hometown"].string!
                    self.imageUrl = user["imageUrl"].string!
                    self.bio = user["description"].string!
                    self.firstName = user["firstName"].string!
                    self.lastName = user["lastName"].string!
                    
                    self.followersCount = user["followersCount"].number!
                    self.followingCount = user["followingCount"].number!
                    
                    self.momentCount = user["momentCount"].number!
                    self.lockerProductCount = user["lockerProductCount"].number!
                    
                    let sport = user["sport"].string! // make an array
                    self.sports = [sport]
                    
                    
                    if (self.userId == uid) {
                        
                        // update current user defaults
                        
                        defaults.setObject(self.userId, forKey: "userId")
                        defaults.setObject(self.username, forKey: "username")
                        defaults.setObject(self.hometown, forKey: "hometown")
                        defaults.setObject(self.imageUrl, forKey: "imageUrl")
                        defaults.setObject(self.bio, forKey: "description")
                        defaults.setObject(self.firstName, forKey: "firstName")
                        defaults.setObject(self.lastName, forKey: "lastName")
                        defaults.setObject(self.followersCount, forKey: "followersCount")
                        defaults.setObject(self.followingCount, forKey: "followingCount")
                        defaults.setObject(self.momentCount, forKey: "momentCount")
                        defaults.setObject(self.lockerProductCount, forKey: "lockerProductCount")
                        defaults.setObject(self.sports, forKey: "sports")
                        defaults.synchronize()
                    }
                    
                    //
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("got here")
                        self.reloadAction()
                    })
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                }
                
            }
        })
        
        refreshControl.endRefreshing()
        
    }
    
    func reloadAction() {
        
        
        theTableView.reloadData()
        
        refreshControl.endRefreshing()
        
    }
    
    func fansBtnAction() {
        
        // push to fans
        
        if (Int(followersCount) > 0) {
            let vc = PeopleListViewController()
            vc.passedTitle = "FANS"
            vc.passedUserId = userId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followingBtnAction() {
        
        // push to following
        
        if (Int(followingCount) > 0) {
            let vc = PeopleListViewController()
            vc.passedTitle = "FOLLOWING"
            vc.passedUserId = userId
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func inviteBtnAction(sender : UIButton) {
        
        // if currentUser, invite
        //
        // if not currentUser - follow / un-follow
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.stringForKey("userId")! as String
        
        if (userId == uid) {
            print("currentUser")
            
            // invite
            
            
        } else {
            
            if (inviteBtn.selected) {
                
                inviteBtn.selected = false
                
                inviteBtn.setTitle("UNFOLLOW", forState: .Normal)
                unfollowAction(sender)
                
            } else {
                
                inviteBtn.selected = true
                
                inviteBtn.setTitle("FOLLOW", forState: .Normal)
                followAction(sender)
                
            }
            
        }
    }
    
    func tabBtn1Action() {
        
        tabBtn1.selected = true
        tabBtn2.selected = false
        tabBtn3.selected = false
        
        // refresh view to show teams
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uid = defaults.stringForKey("userId")! as String
        
        if (userId == uid && initialProfile) {
            print("currentUser")
            
            self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100))
            self.theTableView.tableFooterView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
            
            let addBtn = UIButton(frame: CGRectMake(15, 0, self.view.frame.size.width-30, 50))
            addBtn.backgroundColor = UINavigationBar.appearance().tintColor
            addBtn.addTarget(self, action:#selector(addTeamBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            addBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
            addBtn.titleLabel?.numberOfLines = 1
            addBtn.contentHorizontalAlignment = .Center
            addBtn.contentVerticalAlignment = .Center
            addBtn.titleLabel?.textAlignment = .Center
            addBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            addBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            addBtn.setTitle("ADD TEAM", forState: .Normal)
            self.theTableView.tableFooterView?.addSubview(addBtn)
            
        } else {
            
            self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
            self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
            
        }
        
        
        self.theTableView.reloadData()
        
        
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
        
        if (self.queriedForGear) {
            // do nothing
            self.theTableView.reloadData()
        } else {
            // query!
            self.theTableView.reloadData()
            self.queryForGear()
        }
        
    }

    
    func queryForTimeline() {
        print("queryForTimeline hit")
        // get bearer token
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(userId)/moments"
        let date = NSDate().timeIntervalSince1970 * 1000
        let params = "since=\(date)&limit=20"
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
                    
                    self.momentsData = dataFromString
                    
                    self.queriedForTimeline = true
                    
                    // done, reload tableView
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // footer
                        //
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let uid = defaults.stringForKey("userId")! as String
                        
                        if (self.userId == uid && self.initialProfile) {
                            print("currentUser")
                            
                            let json = JSON(data: self.momentsData)
                            if (json["results"].count == 0) {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
                                
                                let addBtn = UIButton(frame: CGRectMake(15, 0, self.view.frame.size.width-30, 50))
                                addBtn.backgroundColor = UINavigationBar.appearance().tintColor
                                addBtn.addTarget(self, action:#selector(self.addMomentBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
                                addBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
                                addBtn.titleLabel?.numberOfLines = 1
                                addBtn.contentHorizontalAlignment = .Center
                                addBtn.contentVerticalAlignment = .Center
                                addBtn.titleLabel?.textAlignment = .Center
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                                addBtn.setTitle("ADD A MOMENT", forState: .Normal)
                                self.theTableView.tableFooterView?.addSubview(addBtn)
                                
                            } else {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                                
                            }
                        } else {
                            
                            // no momments
                            self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                            self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                        }
                        //
                        //
                        
                        self.refreshControl.endRefreshing()
                        self.theTableView.reloadData()
                        
                        
                    })
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                    self.refreshControl.endRefreshing()
                }
                
            } else {
                //
            }
        })
        
    }
    
    func queryForGear() {
        print("queryForGear hit")
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(userId)/locker"
        let date = NSDate().timeIntervalSince1970 * 1000
        let params = "since=\(date)&limit=20"
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
                    
                    let results = json["results"]
                    print("gear results: \(results)")
                    
                    self.queriedForGear = true
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // footer
                        //
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let uid = defaults.stringForKey("userId")! as String
                        
                        if (self.userId == uid && self.initialProfile) {
                            print("currentUser")
                            
                            let json = JSON(data: self.gearData)
                            if (json["results"].count == 0) {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
                                
                                let addBtn = UIButton(frame: CGRectMake(15, 0, self.view.frame.size.width-30, 50))
                                addBtn.backgroundColor = UINavigationBar.appearance().tintColor
                                addBtn.addTarget(self, action:#selector(self.addGearBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
                                addBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
                                addBtn.titleLabel?.numberOfLines = 1
                                addBtn.contentHorizontalAlignment = .Center
                                addBtn.contentVerticalAlignment = .Center
                                addBtn.titleLabel?.textAlignment = .Center
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                                addBtn.setTitle("ADD GEAR", forState: .Normal)
                                self.theTableView.tableFooterView?.addSubview(addBtn)
                                
                            } else {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                            }
                        } else {
                            
                            // no gear
                            
                            self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                            self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                        }
                        //
                        //
                        
                        
                        self.refreshControl.endRefreshing()
                        self.theTableView.reloadData()
                        
                    })
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription)
                }
            } else {
                
            }
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
    
    
    func followAction(sender: UIButton) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(self.userId)/follow"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = ""
        let type = "POST"
        
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
                    
                    // followed
                    
                    let array = defaults.arrayForKey("followingUserIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(self.userId)) {
                        // in followingUserIds, do nothing
                    } else {
                        let followingCount = defaults.objectForKey("followingCount") as! Int
                        let newcount = followingCount+1
                        
                        ma.addObject(self.userId)
                        let newarray = ma as NSArray
                        defaults.setObject(newarray, forKey: "followingUserIds")
                        defaults.setObject(newcount, forKey: "followingCount")
                        defaults.synchronize()
                    }
                    
                    print("followed")
                    
                    sender.selected = true
                    
                    (UIApplication.sharedApplication().delegate as! AppDelegate).reloadTimeline = true
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                    
                }
            } else {
                //
            }
        })
        
    }
    
    func unfollowAction(sender: UIButton) {
        
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(self.userId)/unfollow"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = ""
        let type = "DELETE"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sendRequest(url, parameters: params, type: type, completionHandler:  { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        sender.selected = true
                        
                        return
                    }
                    
                    
                    print("unfollowed")
                    
                    sender.selected = false
                    
                    (UIApplication.sharedApplication().delegate as! AppDelegate).reloadTimeline = true
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            } else {
                //
            }
        })
        
    }
    
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tabBtn1.selected) {
            return 3
        } else if (tabBtn2.selected) {
            let json = JSON(data: momentsData)
            return json["results"].count
        } else if (tabBtn3.selected) {
            let json = JSON(data: gearData)
            return json["results"].count
        } else {
            return 0
        }
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 64
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let tabContainerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
//        tabContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        
//        //let tabWidth = view.frame.width/3
//        let tabWidth = view.frame.width/2
//        
//        tabBtn1.frame = CGRectMake(0, 0, tabWidth, 64)
//        tabBtn1.backgroundColor = UIColor.clearColor()
//        tabBtn1.titleLabel?.numberOfLines = 1
//        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
//        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
//        tabBtn1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
//        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
//        //tabContainerView.addSubview(tabBtn1)
//        tabBtn1.setTitle("0 STATS", forState: UIControlState.Normal)
//        
//        tabBtn2.frame = CGRectMake(tabWidth*0, 0, tabWidth, 64)
//        tabBtn2.backgroundColor = UIColor.clearColor()
//        tabBtn2.titleLabel?.numberOfLines = 1
//        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
//        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
//        tabBtn2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
//        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
//        tabContainerView.addSubview(tabBtn2)
//        let s = momentCount == 1 ? "" : "S"
//        tabBtn2.setTitle("\(momentCount) MOMENT\(s)", forState: UIControlState.Normal)
//        
//        tabBtn3.frame = CGRectMake(tabWidth*1, 0, tabWidth, 64)
//        tabBtn3.backgroundColor = UIColor.clearColor()
//        tabBtn3.titleLabel?.numberOfLines = 1
//        tabBtn3.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
//        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.Center
//        tabBtn3.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        tabBtn3.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
//        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), forControlEvents:UIControlEvents.TouchUpInside)
//        tabContainerView.addSubview(tabBtn3)
//        tabBtn3.setTitle("\(lockerProductCount) GEAR", forState: UIControlState.Normal)
//        
//        return tabContainerView
//        
//    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
        
        if (tabBtn1.selected) {
            
            // for stats
            return (view.frame.size.width/3)*2
            
        } else if (tabBtn2.selected) {
            
            // for moments - measure height
            
            let json = JSON(data: momentsData)
            let results = json["results"]
            
            let h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForTimelineMoment(results, ip: indexPath, cellWidth: view.frame.size.width) 
            return h
            
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
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 16)!, width: self.view.frame.size.width-15-15-50-15)
                    brandHeight = height
                }
            } else {
                brandHeight = 0
            }
            
            if let id = results[indexPath.row]["name"].string {
                if (id == "") {
                    nameHeight = 0
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 16)!, width: self.view.frame.size.width-15-15-50-15)
                    nameHeight = height
                }
            } else {
                nameHeight = 0
            }
            
            if (brandHeight == 0) {
                
                let contentHeight = view.frame.size.width+15+nameHeight+15
                
                if (contentHeight > view.frame.size.width+15+38+15+15) {
                    return view.frame.size.width+15+nameHeight+15
                } else {
                    return view.frame.size.width+15+38+15+15 // default height with add btn, 38 height
                }
                
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
            cell.teamBannerView.hidden = false
            cell.teamNameLbl.hidden = false
            cell.teamSportLbl.hidden = false
            cell.teamNumLbl.hidden = false
            cell.teamPositionLbl.hidden = false
            
            cell.timelineImgView.hidden = true
            cell.timelineMusicLbl.hidden = true
            cell.timelineModeLbl.hidden = true
            cell.timelineRankLbl.hidden = true
            cell.timelineTinyHeartBtn.hidden = true
            cell.timelineLikeLblBtn.hidden = true
            cell.timelineUserImgView.hidden = true
            cell.timelineUserImgViewBtn.hidden = true
            cell.timelineNameLbl.hidden = true
            cell.timelineTimeLbl.hidden = true
            cell.timelineFollowBtn.hidden = true
            cell.timelineHeadlineLbl.hidden = true
            cell.timelineLikeBtn.hidden = true
            cell.timelineChatBtn.hidden = true
            cell.timelineGearBtn.hidden = true
            cell.timelineMoreBtn.hidden = true
            
            cell.gearImgView.hidden = true
            cell.gearBrandLbl.hidden = true
            cell.gearNameLbl.hidden = true
            cell.gearAddBtn.hidden = true

            
            let padding = CGFloat(10)
            
            let teamName = "West Chester Vikings"
            let mySport = "Lacrosse"
            let myNumber = "38"
            let myPosition = "Attack"
            
            
            let teamBannerHeight = ((cell.cellWidth/3)*2)-15
            let nameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(teamName, font: cell.teamNameLbl.font, width: cell.cellWidth-60)+padding
            let totalContentHeight = nameHeight+padding+(padding/2)+50
            let nameY = (teamBannerHeight/2)-(totalContentHeight/2)
            let detailsY = nameY+nameHeight+padding+(padding/2)
            
            let sportWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(mySport, font: cell.teamSportLbl.font, height: 40)
            let positionWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(myPosition, font: cell.teamPositionLbl.font, height: 40)
            
            cell.teamBannerView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: teamBannerHeight)
            cell.teamNameLbl.frame = CGRect(x: 30, y: nameY, width: cell.cellWidth-60, height: nameHeight)
            cell.teamSportLbl.frame = CGRect(x: cell.cellWidth/2-sportWidth-20-padding, y: detailsY, width: sportWidth, height: 40)
            cell.teamNumLbl.frame = CGRect(x: cell.cellWidth/2-20, y: detailsY, width: 40, height: 40)
            cell.teamPositionLbl.frame = CGRect(x: cell.cellWidth/2+20+padding, y: detailsY, width: positionWidth, height: 40)

            cell.teamNameLbl.text = teamName
            cell.teamSportLbl.text = mySport
            cell.teamNumLbl.text = myNumber
            cell.teamPositionLbl.text = myPosition
            
            
            
        } else if (tabBtn2.selected) {
            
            // for moments - measure height

            cell.teamBannerView.hidden = true
            cell.teamNameLbl.hidden = true
            cell.teamSportLbl.hidden = true
            cell.teamNumLbl.hidden = true
            cell.teamPositionLbl.hidden = true
            
            cell.timelineImgView.hidden = false
            cell.timelineMusicLbl.hidden = false
            cell.timelineModeLbl.hidden = false
            cell.timelineRankLbl.hidden = true // odd one out
            cell.timelineTinyHeartBtn.hidden = false
            cell.timelineLikeLblBtn.hidden = false
            cell.timelineUserImgView.hidden = false
            cell.timelineUserImgViewBtn.hidden = false
            cell.timelineNameLbl.hidden = false
            cell.timelineTimeLbl.hidden = false
            cell.timelineFollowBtn.hidden = false
            cell.timelineHeadlineLbl.hidden = false
            cell.timelineLikeBtn.hidden = false
            cell.timelineChatBtn.hidden = false
            cell.timelineGearBtn.hidden = false
            cell.timelineMoreBtn.hidden = false
            
            cell.gearImgView.hidden = true
            cell.gearBrandLbl.hidden = true
            cell.gearNameLbl.hidden = true
            cell.gearAddBtn.hidden = true
            
            //
            
            let mediaHeight = view.frame.size.width+110
            
            cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, mediaHeight)
            
            //timelineTinyHeartBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
            //timelineLikeLblBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
            
            cell.timelineUserImgView.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15, 38, 38)
            cell.timelineUserImgViewBtn.frame = CGRectMake(cell.timelineUserImgView.frame.origin.x, cell.timelineUserImgView.frame.origin.y, cell.timelineUserImgView.frame.size.width, cell.timelineUserImgView.frame.size.height)
            cell.timelineFollowBtn.frame = CGRectMake(cell.cellWidth-65-15, cell.timelineImgView.frame.size.height+15, 65, 38)
            
            //
            
            let json = JSON(data: momentsData)
            let results = json["results"]
            
            // get mediaHeight
            
            if let id = results[indexPath.row]["imageUrl"].string {
                let fileUrl = NSURL(string: id)
                
                cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, mediaHeight)
                cell.timelineImgView.setNeedsLayout()
                
                cell.timelineImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                    success: { image in
                        
                        //print("image here: \(image)")
                        cell.timelineImgView.image = image
                        
                    },
                    failure: { error in
                        
                        if ((error) != nil) {
                            print("error here: \(error)")
                            
                            // collapse, this cell - it was prob deleted - error 402
                            
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
                    cell.timelineMusicLbl.frame = CGRectMake(15, cell.timelineImgView.frame.size.height-20-10-20-15, cell.cellWidth-30, 20)
                } else {
                    cell.timelineMusicLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-10-20-15, width+20, 20)
                }
                cell.timelineMusicLbl.text = str
            } else {
                cell.timelineMusicLbl.hidden = true
            }
            
            if let id = results[indexPath.row]["user"]["imageUrlTiny"].string {
                
                let fileUrl = NSURL(string: id)
                cell.timelineUserImgView.setNeedsLayout()
                
                //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
                cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
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
                cell.timelineNameLbl.frame = CGRect(x: 15+38+15, y: cell.timelineImgView.frame.size.height+15, width: width, height: 19)
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
                    if (ht == "") {
                        dateStr = "\(since)"
                    } else {
                        dateStr = "\(since) - \(ht)"
                    }
                } else {
                    dateStr = "\(since)"
                }
                let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(dateStr, font: cell.timelineTimeLbl.font, height: 20)
                cell.timelineTimeLbl.frame = CGRect(x: 15+38+15, y: cell.timelineImgView.frame.size.height+15+19, width: width, height: 19)
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
            cell.timelineHeadlineLbl.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15+38+15, cell.cellWidth-30, headlineHeight)
            
            
            var btnY = CGFloat()
            if (headlineHeight == 0) {
                btnY = cell.timelineImgView.frame.size.height+15+38+15
            } else {
                btnY = cell.timelineImgView.frame.size.height+15+38+15+cell.timelineHeadlineLbl.frame.size.height+15
            }
            cell.timelineLikeBtn.frame = CGRectMake(15, btnY, 65, 38)
            cell.timelineChatBtn.frame = CGRectMake(15+64+10, btnY, 65, 38)
            cell.timelineGearBtn.frame = CGRectMake(15+64+10+64+10, btnY, 65, 38)
            cell.timelineMoreBtn.frame = CGRectMake(15+64+10+64+10+64+10, btnY, 50, 38)
            
            //            if let id = results[indexPath.row]["commentCount"].number {
            //                let countStr = "\(id) comments"
            //                cell.commentLbl.text = countStr
            //            }
            
            
            let momentId = results[indexPath.row]["id"].string
            
            if ((UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(momentId!)) {
                cell.timelineLikeBtn.selected = false
            } else {
                
                if ((UIApplication.sharedApplication().delegate as! AppDelegate).likedMomentId(momentId!)) {
                    cell.timelineLikeBtn.selected = true
                } else {
                    // check if user likes
                    
                    if let id = results[indexPath.row]["userLikes"].bool {
                        if (id) {
                            // add it!
                            (UIApplication.sharedApplication().delegate as! AppDelegate).addLikedMomentId(momentId!)
                            cell.timelineLikeBtn.selected = true
                        } else {
                            cell.timelineLikeBtn.selected = false
                        }
                    } else {
                        cell.timelineLikeBtn.selected = true
                    }
                }
                
            }
            
            
            // buttons
            
            cell.timelineUserImgViewBtn.tag = indexPath.row
            cell.timelineLikeBtn.tag = indexPath.row
            cell.timelineChatBtn.tag = indexPath.row
            cell.timelineGearBtn.tag = indexPath.row
            cell.timelineMoreBtn.tag = indexPath.row
            cell.timelineFollowBtn.tag = indexPath.row
            
            cell.timelineUserImgViewBtn.addTarget(self, action:#selector(timelineUserImgViewBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineLikeBtn.addTarget(self, action:#selector(timelineLikeBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineChatBtn.addTarget(self, action:#selector(timelineChatBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineGearBtn.addTarget(self, action:#selector(timelineGearBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineMoreBtn.addTarget(self, action:#selector(timelineMoreBtnAction), forControlEvents: .TouchUpInside)
            cell.timelineFollowBtn.hidden = true
            
            // taps
            
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
            cell.timelineRankLbl.hidden = true
            cell.timelineTinyHeartBtn.hidden = true
            cell.timelineLikeLblBtn.hidden = true
            cell.timelineUserImgView.hidden = true
            cell.timelineUserImgViewBtn.hidden = true
            cell.timelineNameLbl.hidden = true
            cell.timelineTimeLbl.hidden = true
            cell.timelineFollowBtn.hidden = true
            cell.timelineHeadlineLbl.hidden = true
            cell.timelineLikeBtn.hidden = true
            cell.timelineChatBtn.hidden = true
            cell.timelineGearBtn.hidden = true
            cell.timelineMoreBtn.hidden = true
            
            cell.gearImgView.hidden = false
            cell.gearBrandLbl.hidden = false
            cell.gearNameLbl.hidden = false
            cell.gearAddBtn.hidden = false
            
            
            cell.gearImgView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: cell.cellWidth)
            cell.gearBrandLbl.frame = CGRect(x: 15, y: cell.cellWidth+10, width: cell.cellWidth-15-15-65-15, height: 25)
            cell.gearAddBtn.frame = CGRect(x: cell.cellWidth-65-15, y: cell.cellWidth+15, width: 65, height: 38)
            
            let json = JSON(data: gearData)
            let results = json["results"]
            
            if let id = results[indexPath.row]["imageUrl"].string {
                
                let fileUrl = NSURL(string: id)
                cell.gearImgView.setNeedsLayout()
                
                //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
                cell.gearImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
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
                brandHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearBrandLbl.font, width: self.view.frame.size.width-15-15-65-15)
            } else {
                brandHeight = 0
                cell.gearBrandLbl.text = ""
            }
            
            if let id = results[indexPath.row]["name"].string {
                cell.gearNameLbl.text = id
                nameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearNameLbl.font, width: self.view.frame.size.width-15-15-65-15)
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

            cell.gearBrandLbl.frame = CGRect(x: 15, y: cell.cellWidth+15, width: cell.cellWidth-15-15-65-15, height: brandHeight)
            
            if (cell.gearBrandLbl.text == "") {
                cell.gearNameLbl.frame = CGRect(x: 15, y: cell.cellWidth+15, width: cell.cellWidth-15-15-65-15, height: nameHeight)
            } else {
                cell.gearNameLbl.frame = CGRect(x: 15, y: cell.cellWidth+15+brandHeight+5, width: cell.cellWidth-15-15-65-15, height: nameHeight)
            }
            
            cell.gearAddBtn.tag = indexPath.row
            cell.gearAddBtn.addTarget(self, action: #selector(gearAddBtnAction), forControlEvents: .TouchUpInside)
            
            cell.gearSingleTapRecognizer.addTarget(self, action: #selector(gearSingleTapAction(_:)))
            cell.gearDoubleTapRecognizer.addTarget(self, action: #selector(gearDoubleTapAction(_:)))
            
            
            
        } else {
            
            cell.teamBannerView.hidden = true
            cell.teamNameLbl.hidden = true
            cell.teamSportLbl.hidden = true
            cell.teamNumLbl.hidden = true
            cell.teamPositionLbl.hidden = true
            
            cell.timelineImgView.hidden = true
            cell.timelineMusicLbl.hidden = true
            cell.timelineModeLbl.hidden = true
            cell.timelineRankLbl.hidden = true 
            cell.timelineTinyHeartBtn.hidden = true
            cell.timelineLikeLblBtn.hidden = true
            cell.timelineUserImgView.hidden = true
            cell.timelineUserImgViewBtn.hidden = true
            cell.timelineNameLbl.hidden = true
            cell.timelineTimeLbl.hidden = true
            cell.timelineFollowBtn.hidden = true
            cell.timelineHeadlineLbl.hidden = true
            cell.timelineLikeBtn.hidden = true
            cell.timelineChatBtn.hidden = true
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
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) 
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

    
    func getNextPage() {
        
        //pageNumber = pageNumber + 1
        
        queryForTimeline()
        
    }
    
    func timelineUserImgViewBtnAction(sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["user"]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserData = results[sender.tag]["user"]
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineLikeBtnAction(sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        let id = results[sender.tag]["id"].string
        
        if (sender.selected) {
            print("currently liked")
            sender.selected = false
            unlikeAction(id!)
        } else {
            print("currently NOT liked")
            sender.selected = true
            
            if ((UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(id!)) {
                (UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.removeObjectsInArray([id!])
            }
            
            likeAction(id!)
        }
    }
    
    func likeAction(momentId : String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).likedMomentId(momentId)) {
            return
        }
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(momentId)/like"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = ""
        let type = "POST"
        
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
                    
                    // update likedPostIdeas
                    //
                    // reload
                    
                    let array = defaults.arrayForKey("likedMomentIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(momentId)) {
                        // in likedMomentIds, do nothing
                    } else {
                        ma.addObject(momentId)
                        let newarray = ma as NSArray
                        defaults.setObject(newarray, forKey: "likedMomentIds")
                        defaults.synchronize()
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("liked")
                        self.theTableView.reloadData()
                    })
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    func unlikeAction(momentId : String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(momentId)/unlike"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = ""
        let type = "DELETE"
        
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
                    
                    // update likedPostIdeas
                    //
                    // reload
                    
                    let array = defaults.arrayForKey("likedMomentIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(momentId)) {
                        // in likedMomentIds, do nothing
                        ma.removeObject(momentId)
                        let newarray = ma as NSArray
                        defaults.setObject(newarray, forKey: "likedMomentIds")
                        defaults.synchronize()
                    }
                    
                    
                    if (!(UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(momentId)) {
                        (UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.addObject(momentId)
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("unliked")
                        self.theTableView.reloadData()
                    })
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            } else {
                //
                print("errorrr in \(self)")
            }
        })

    }
    
    
    func timelineChatBtnAction(sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = ChatViewController()
            vc.passedMomentData = results[sender.tag]
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineGearBtnAction(sender: UIButton) {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["products"].arrayObject {
            print("id: \(id)")
            if (id.count > 0) {
                
                if let momentId = results[sender.tag]["id"].string {
                    
                    let vc = GearListViewController()
                    vc.passedMomentId = momentId
                    navigationController?.pushViewController(vc, animated: true)
                    
                    isPushed = true
                    
                }
            }
        }
    }
    
    func timelineMoreBtnAction(sender: UIButton){
        
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
//                    
//                    let json = JSON(data: momentsData)
//                    
//                    let results = json["results"]
//                    print(results)
                    
                }
            }
        }
    }
    
    
    func timelineDoubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    //print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    let json = JSON(data: momentsData)
                    let results = json["results"]
                    let id = results[tappedIndexPath.row]["id"].string
                    
                    let cell = tappedCell as! MainCell
                    cell.timelineLikeBtn.selected = true
                    
                    likeHeartAnimation(tappedCell, momentId: id!)
                    
                    
                }
            }
        }
    }
    
    func likeHeartAnimation(cell : UITableViewCell, momentId : String) {
        
        // get height of media
        
        let mediaHeight = cell.frame.size.width+100
        
        let heartImgView = UIImageView(frame: CGRectMake(cell.frame.size.width/2-44, mediaHeight/2-44, 88, 88))
        heartImgView.backgroundColor = UIColor.clearColor()
        heartImgView.image = UIImage(named: "heart.png")
        cell.addSubview(heartImgView)
        
        heartImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75)
        
        UIView.animateWithDuration(0.18, animations: {
            heartImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.04, 1.04)
            }, completion: { finished in
                if (finished){
                    UIView.animateWithDuration(0.16, animations: {
                        heartImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                        }, completion: { finished in
                            if (finished) {
                                
                                let delay = 0.3 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue()) {
                                    
                                    UIView.animateWithDuration(0.18, animations: {
                                        heartImgView.alpha = 0.0
                                        }, completion: { finished in
                                            if (finished) {
                                                heartImgView.removeFromSuperview()
                                                
                                                //
                                                self.likeAction(momentId)
                                                //
                                                
                                            }
                                    })
                                }
                            }
                    })
                }
        })
        
    }
    
    //
    // gear actions
    //
    
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
        
        let productJson = results[sender.tag] 
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
    
    //
    // team actions
    //
    
    func addTeamBtnAction() {
        
        let newnav = UINavigationController(rootViewController: AddTeamViewController())
        navigationController?.presentViewController(newnav, animated: true, completion: nil)
    }
    
    func addMomentBtnAction() {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc!.centerBtnAction()
    }
    
    func addGearBtnAction() {
        
        let newnav = UINavigationController(rootViewController: AddTeamViewController())
        navigationController?.presentViewController(newnav, animated: true, completion: nil)
    }

    
    
    
    
    //
    //
    //
    
    // testing photo picker
    
    func cameraBtnAction() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        
        self.presentViewController(imagePicker, animated: true,
                                   completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            
            //print("mediaType: \(mediaType)")
            let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            self.savePhoto(selectedImage)
            
        } else if mediaType.isEqualToString(kUTTypeVideo as String) {
            
            print("mediaType: \(mediaType)")
            //let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            //self.savePhoto(selectedImage)
            
        } else {
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savePhoto(image:UIImage) {
        
        // maxHeight
        // maxWidth
        
        
        let resizedimage = self.resizeImage(image, newWidth: 600)
        //let resizedimagesmall = self.resizeImage(image, newWidth: 300)
        
        let imageData = UIImageJPEGRepresentation(resizedimage, 0.9)
        //let imagedatasmall = UIImageJPEGRepresentation(image, 1.0)
        
        
        
        self.sendRequest(imageData!)
        
        // multi-part upload
        //print("image: \(image)")
        //print("imagedata: \(imagedata)")
        
        
        //let request = self.createRequest("uid", password: "pw", email: "email@email.com")
        
        
//        self.uploadImage(image)
//        
//
//        let path  = NSURL(fileURLWithPath: "flash.jpeg")
//        
//        //  talk to registration end point
//        let r = Just.post(
//            "http://justiceleauge.org/member/register",
//            data: ["username": "barryallen", "password":"ReverseF1ashSucks"],
//            files: ["profile_photo": .URL(path, nil)]
//        )
//
//        if (r.ok) {
//            /* success! */
//            print("r.json: \(r.json)")
//            
//        }
//        
//        
//        Just.get("http://httpbin.org/get", params:["page": 3]) { (r) in
//            // the same "r" is available asynchronously here
//            if (r.ok) {
//                // success
//            }
//        }
        
//        if let json = Just.post(
//            "http://httpbin.org/post",
//            data:["lastName":"Musk"],
//            files:["elon":path, nil)]
//            ).json as? [String:AnyObject] {
//            print(json["form"] ?? [:])      // lastName:Musk
//            print(json["files"] ?? [:])     // elon
//        }
        
        
        
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
    
    
    func uploadImage(image : UIImage) {
        
        let url = NSURL(string: "http://www.kaleidosblog.com/tutorial/upload.php")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        //define the multipart request type
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let image_data = UIImagePNGRepresentation(image)
        
        if(image_data == nil) {
            return
        }
        
        
        let body = NSMutableData()
        
        let fname = "test.png"
        let mimetype = "image/png"
        
        //define the data post parameter
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        
        
        request.HTTPBody = body
        
        
        
        let session = NSURLSession.sharedSession()
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
        }
        
        task.resume()
        
    }
    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sendRequest(imageData : NSData) {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.stringForKey("bearerToken")! as String
        let boundary = generateBoundaryString()
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
    
        /* Create session, and optionally set a NSURLSessionDelegate. */
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        /* Create the Request:

         */
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "PUT"
        
        // Headers
        //request.addValue("multipart/form-data; boundary=__X_PAW_BOUNDARY__", forHTTPHeaderField: "Content-Type")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        
        // Body
        //let bodyString = "--__X_PAW_BOUNDARY__--"
        //request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        let body  = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"; mimetype=\"image/jpeg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData)
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        
        // bearer & version
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        
        /* Start a new Task */
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }
    
    
    
}
