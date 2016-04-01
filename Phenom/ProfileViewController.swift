//
//  ProfileViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var navBarView = UIView()
    
    var wasPushed: Bool = false
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var activityArray = NSArray()
    
    var querySkip = Int()
    
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
        settingsBtn.addTarget(self, action:#selector(ProfileViewController.settingsBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(settingsBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "USERNAME"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        if (self.wasPushed) {
            let backBtn = UIButton(type: UIButtonType.Custom)
            backBtn.frame = CGRectMake(20, 0, 70, 44)
            backBtn.setImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            //settingsBtn.setBackgroundImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            backBtn.backgroundColor = UIColor.redColor()
            backBtn.addTarget(self, action:#selector(ProfileViewController.backBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            self.navBarView.addSubview(backBtn)
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ProfileViewController.backBtnAction))
            rightSwipe.direction = .Right
            self.view.addGestureRecognizer(rightSwipe)
        }
        
        self.theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        self.theTableView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(TimelineCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        
        let headerViewWidth = self.view.frame.size.width
        let headerViewHeight = self.view.frame.size.width+20+64
        
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, headerViewWidth, headerViewHeight))
        self.theTableView.tableHeaderView?.backgroundColor = UIColor(red:43/255, green:43/255, blue:43/255, alpha:1)
        
        // number of fans
        // "fans"
        // number of following
        // "following"
        // invite button

        let fansWidth = (headerViewWidth/2)/2
        let fansHeight = CGFloat(50)
        
        // 
        
        let fansFollowingInviteContainerView = UIView(frame: CGRectMake(0, headerViewHeight-64-30-fansHeight,  headerViewWidth, fansHeight))
        
        let fansNumBtn = UIButton.init(type: UIButtonType.Custom)
        fansNumBtn.frame = CGRectMake(0, 0, fansWidth, 30)
        fansNumBtn.backgroundColor = UIColor.lightGrayColor()
        //fansNumBtn.addTarget(self, action:#selector(CameraViewController.fansNumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        fansNumBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        fansNumBtn.titleLabel?.numberOfLines = 1
        fansNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        fansNumBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        fansNumBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        fansNumBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fansNumBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        fansNumBtn.setTitle("11", forState: UIControlState.Normal)
        fansFollowingInviteContainerView.addSubview(fansNumBtn)
        
        let fansBtn = UIButton.init(type: UIButtonType.Custom)
        fansBtn.frame = CGRectMake(0, 30, fansWidth, 20)
        fansBtn.backgroundColor = UIColor.grayColor()
        //fansBtn.addTarget(self, action:#selector(CameraViewController.fansNumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        fansBtn.titleLabel?.font = UIFont.systemFontOfSize(11)
        fansBtn.titleLabel?.numberOfLines = 1
        fansBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        fansBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        fansBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        fansBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        fansBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        fansBtn.setTitle("FANS", forState: UIControlState.Normal)
        fansFollowingInviteContainerView.addSubview(fansBtn)
        
        let followingNumBtn = UIButton.init(type: UIButtonType.Custom)
        followingNumBtn.frame = CGRectMake(fansWidth, 0, fansWidth, 30)
        followingNumBtn.backgroundColor = UIColor.orangeColor()
        //followingNumBtn.addTarget(self, action:#selector(CameraViewController.fansNumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        followingNumBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        followingNumBtn.titleLabel?.numberOfLines = 1
        followingNumBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        followingNumBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        followingNumBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        followingNumBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        followingNumBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        followingNumBtn.setTitle("12", forState: UIControlState.Normal)
        fansFollowingInviteContainerView.addSubview(followingNumBtn)
        
        let followingBtn = UIButton.init(type: UIButtonType.Custom)
        followingBtn.frame = CGRectMake(fansWidth, 30, fansWidth, 20)
        followingBtn.backgroundColor = UIColor.blueColor()
        //followingBtn.addTarget(self, action:#selector(CameraViewController.fansNumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        followingBtn.titleLabel?.font = UIFont.systemFontOfSize(11)
        followingBtn.titleLabel?.numberOfLines = 1
        followingBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        followingBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        followingBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        followingBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        followingBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        followingBtn.setTitle("FOLLOWING", forState: UIControlState.Normal)
        fansFollowingInviteContainerView.addSubview(followingBtn)

        let inviteBtn = UIButton.init(type: UIButtonType.Custom)
        inviteBtn.frame = CGRectMake(headerViewWidth/2, 0, ((headerViewWidth/2)/4)*3, fansHeight)
        inviteBtn.backgroundColor = UIColor.yellowColor()
        //inviteBtn.addTarget(self, action:#selector(CameraViewController.fansNumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        inviteBtn.titleLabel?.font = UIFont.systemFontOfSize(20)
        inviteBtn.titleLabel?.numberOfLines = 1
        inviteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        inviteBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        inviteBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        inviteBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        inviteBtn.setTitle("INVITE", forState: UIControlState.Normal)
        fansFollowingInviteContainerView.addSubview(inviteBtn)
        
        self.theTableView.tableHeaderView?.addSubview(fansFollowingInviteContainerView)
        
        // profileContainerView - height =
        // profile pic = 1/3 width
        // name height = 40
        // hometown height = 20
        // bio height = size of text in rect
        //
        // this gets placed directly above fans/following/invite
        
        
        let profilePicWidth = headerViewWidth/3
        let nameHeight = CGFloat(30)
        let sportHomeTownHeight = CGFloat(30)
        
        let bio = "This is a test of the american broadcasting system of america americana this is a test of the american broadcasting system of americaaaaaa" //"Just getting warmed up!"
        
        let bioWidth = self.view.frame.size.width-50
        let bioHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(bio, font: UIFont.boldSystemFontOfSize(13), width: bioWidth)+10
        
        let containerViewHeight = profilePicWidth+nameHeight+sportHomeTownHeight+bioHeight
        let containerView = UIView(frame: CGRectMake(0, fansFollowingInviteContainerView.frame.origin.y-containerViewHeight-10, headerViewWidth, containerViewHeight))
        
        
        
        let profileImgView = UIImageView(frame: CGRectMake(profilePicWidth, 0, profilePicWidth, profilePicWidth))
        profileImgView.backgroundColor = UIColor.lightGrayColor()
        containerView.addSubview(profileImgView)
        
        let nameLbl = UILabel(frame: CGRectMake(0, profileImgView.frame.origin.y+profileImgView.frame.size.height+5, headerViewWidth, nameHeight))
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.textAlignment = .Center
        nameLbl.font = UIFont.boldSystemFontOfSize(24)
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.text = "FIRST LAST"
        containerView.addSubview(nameLbl)
        
        let sportHometownLbl = UILabel(frame: CGRectMake(0, profileImgView.frame.origin.y+profileImgView.frame.size.height+nameLbl.frame.size.height, headerViewWidth, sportHomeTownHeight))
        sportHometownLbl.backgroundColor = UIColor.clearColor()
        sportHometownLbl.textAlignment = .Center
        sportHometownLbl.font = UIFont.boldSystemFontOfSize(13)
        sportHometownLbl.textColor = UIColor.whiteColor()
        sportHometownLbl.text = "SPORT IN HOMETOWN, CA"
        containerView.addSubview(sportHometownLbl)
        
        let bioLbl = UILabel(frame: CGRectMake((headerViewWidth/2)-(bioWidth/2), profileImgView.frame.origin.y+profileImgView.frame.size.height+nameLbl.frame.size.height+sportHometownLbl.frame.size.height, bioWidth, bioHeight))
        bioLbl.backgroundColor = UIColor.clearColor()
        bioLbl.numberOfLines = 0
        bioLbl.font = UIFont.boldSystemFontOfSize(13)
        bioLbl.textColor = UIColor.init(white: 0.35, alpha: 1.0)
        bioLbl.text = bio
        bioLbl.textAlignment = NSTextAlignment.Center
        containerView.addSubview(bioLbl)
        
        self.theTableView.tableHeaderView?.addSubview(containerView)
        
        
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
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: 30)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ProfileViewController.refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        self.theTableView.addSubview(refreshControl)
        
        querySkip = 0
        self.queryForTimeline(querySkip)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func refreshControlAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).lastvisiteddate = NSDate()
        
        //let newme = PFUser.currentUser()
        //newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //newme!.saveInBackground()
        
        self.querySkip = 0
        self.queryForTimeline(self.querySkip)
        
    }
    func queryForTimeline(skip:Int) {
        
        
        // either way
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        self.theTableView.reloadData()
        
        self.refreshControl.endRefreshing()
        
    }
    
    func loadmoreAction() {
        self.querySkip = self.querySkip+10
        self.queryForTimeline(self.querySkip)
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
