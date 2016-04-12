//
//  SettingsViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import Social
import MessageUI

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var theTableView: UITableView = UITableView()
    var viewersArray = NSMutableArray()
    
    var navBarView = UIView()
    
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
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "SETTINGS"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
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
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRectMake(20, 0, view.frame.size.width, 35))
        aLbl.textAlignment = NSTextAlignment.Left
        
        switch (section) {
        case 0: aLbl.text = "ACCOUNT"
        case 1: aLbl.text = "ADD FRIENDS"
        case 2: aLbl.text = "INVITE FRIENDS"
        case 3: aLbl.text = "SUPPORT"
        case 4: aLbl.text = ""
        default: aLbl.text = ""}
        
        aLbl.font = UIFont.boldSystemFontOfSize(12)
        aLbl.textColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1) //gold
        
        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        aView.addSubview(aLbl)
        
        return aView;
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 9
        case 1: return 2
        case 2: return 4
        case 3: return 2
        case 4: return 1
        default: return 0}
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        //cell.detailTextLabel?.textColor = UIColor.init(white: 0.6, alpha: 1.0)
        //cell.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        
        //cell.textLabel?.text = "text"
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.textColor = UIColor.init(white: 1.0, alpha: 1.0)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")! as String
        let firstName = defaults.objectForKey("firstName") as! String
        let lastName = defaults.objectForKey("lastName") as! String
        let sports = defaults.objectForKey("sports") as! NSArray
        let hometown = defaults.objectForKey("hometown") as! String
        
        if (indexPath.section==0 && indexPath.row==0) {
            
            cell.textLabel!.text = "Name"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = "\(firstName) \(lastName)"
            
        } else if (indexPath.section==0 && indexPath.row==1) {
            
            cell.textLabel!.text = "Username"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = "\(username)"
            
        } else if (indexPath.section==0 && indexPath.row==2) {
            
            cell.textLabel!.text = "Birthday"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = "testing"
            
        } else if (indexPath.section==0 && indexPath.row==3) {
            
            cell.textLabel!.text = "Hometown"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = "\(hometown)"
            
        } else if (indexPath.section==0 && indexPath.row==4) {
            
            cell.textLabel!.text = "Sports"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            let sportsStr = sports.componentsJoinedByString(", ")
            cell.detailTextLabel?.text = "\(sportsStr)"
            
        } else if (indexPath.section==0 && indexPath.row==5) {
            
            cell.textLabel!.text = "Bio"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = ""
            
        } else if (indexPath.section==0 && indexPath.row==6) {
            
            cell.textLabel!.text = "Email"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = "testing"
            
        } else if (indexPath.section==0 && indexPath.row==7) {
            
            cell.textLabel!.text = "Password"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = ""
            
        } else if (indexPath.section==0 && indexPath.row==8) {
            
            cell.textLabel!.text = "Notifications"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.detailTextLabel?.text = ""
            
        } else if (indexPath.section==1 && indexPath.row==0) {
            
            cell.textLabel!.text = "Add by Username"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==1 && indexPath.row==1) {
            
            cell.textLabel!.text = "Add from Contacts"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==1 && indexPath.row==2) {
            
            cell.textLabel!.text = "Add Nearby"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==0) {
            
            cell.textLabel!.text = "Invite via Twitter"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==1) {
            
            cell.textLabel!.text = "Invite via Facebook"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==2) {
            
            cell.textLabel!.text = "Invite via Messages"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==3) {
            
            cell.textLabel!.text = "Invite via Email"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==3 && indexPath.row==0) {
            
            cell.textLabel!.text = "Love Phenom?"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==3 && indexPath.row==1) {
            
            cell.textLabel!.text = "Send Feedback"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
        } else if (indexPath.section==4 && indexPath.row==0) {
            
            cell.textLabel!.text = "Log Out"
            cell.accessoryType = UITableViewCellAccessoryType.None
            
        } else {
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1) 
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:43/255, green:43/255, blue:45/255, alpha:1)
        cell.selectedBackgroundView = bgView
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
        if (indexPath.section == 4 && indexPath.row == 0) {
            
            areyousureyouwanttologout()
        }
    }
    
    
    func inviteViaTwitter() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username"))")
        vc.setInitialText(textToShare)
        vc.addURL(NSURL(string: "http://phenom.co"))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func inviteViaFacebook() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username"))")
        vc.setInitialText(textToShare)
        vc.addURL(NSURL(string: "http://phenom.co"))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func inviteViaMessages() {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username") / http://phenom.co)")
        messageComposeVC.body = textToShare
    }
    
    func inviteViaEmail() {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Invite to Phenom")
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username"))\n\nhttp://phenom.co")
        mailComposerVC.setMessageBody(textToShare, isHTML: false)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func areyousureyouwanttologout() {
        let alertController = UIAlertController(title:"Are you sure?", message:nil, preferredStyle:.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let logoutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).logoutAction()
        }
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
 

}
