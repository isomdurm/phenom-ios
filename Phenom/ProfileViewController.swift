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
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, self.theTableView.frame.size.width+64))
        self.theTableView.tableHeaderView?.backgroundColor = UIColor(red:43/255, green:43/255, blue:43/255, alpha:1)
        
        let headerNavView = UIView(frame: CGRectMake(0, self.theTableView.frame.size.width, self.theTableView.frame.size.width, 64))
        headerNavView.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        self.theTableView.tableHeaderView?.addSubview(headerNavView)
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, self.theTableView.frame.size.width+64-0.5, self.theTableView.frame.size.width, 0.5)
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
