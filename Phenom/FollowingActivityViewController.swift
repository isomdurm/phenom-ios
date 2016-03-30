//
//  FollowingActivityViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class FollowingActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var activityArray = NSArray()
    
    var querySkip = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.theTableView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-64-49)
        self.theTableView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: 30)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(FollowingActivityViewController.refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        self.theTableView.addSubview(refreshControl)
        
        querySkip = 0
        self.queryForActivity(querySkip)
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
        self.queryForActivity(self.querySkip)
        
    }
    func queryForActivity(skip:Int) {
        
        
        // either way
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        self.theTableView.reloadData()
        
        self.refreshControl.endRefreshing()
        
    }
    
    func loadmoreAction() {
        self.querySkip = self.querySkip+10
        self.queryForActivity(self.querySkip)
    }
    
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15 // self.activityArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ActivityCell = ActivityCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectedBackgroundView = bgView
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
        
    }
    
    func userBtnAction(sender: UIButton!){
        
        
    }


}
