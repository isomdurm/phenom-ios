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

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var theTableView: UITableView = UITableView()
    var viewersArray = NSMutableArray()
    
    var navBarView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(SettingsViewController.backBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "SETTINGS"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        
        self.theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        self.theTableView.backgroundColor = UIColor.redColor()
        self.theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SettingsViewController.backBtnAction))
        swipeRight.direction = .Right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func backBtnAction() {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRectMake(20, 0, self.view.frame.size.width, 35))
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
        case 0: return 1
        case 1: return 2
        case 2: return 4
        case 3: return 2
        case 4: return 1
        default: return 0}
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        //cell.detailTextLabel?.textColor = UIColor.init(white: 0.6, alpha: 1.0)
        //cell.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        
        //cell.textLabel?.text = "text"
        cell.textLabel?.font = UIFont.systemFontOfSize(17)
        cell.textLabel?.textColor = UIColor.init(white: 1.0, alpha: 1.0)
        
        if (indexPath.section==0 && indexPath.row==0) {
            
            cell.textLabel!.text = "Edit Profile"
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
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
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:39/255, green:39/255, blue:42/255, alpha:1)
        cell.selectedBackgroundView = bgView
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
        if (indexPath.section == 4 && indexPath.row == 0) {
            
            self.logout()
        }
    }
    
    
    func inviteViaTwitter() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username"))")
        vc.setInitialText(textToShare)
        vc.addURL(NSURL(string: "http://Phenombeta.com"))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func inviteViaFacebook() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username"))")
        vc.setInitialText(textToShare)
        vc.addURL(NSURL(string: "http://phenomapp.com"))
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func inviteViaMessages() {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username") / http://phenomapp.com)")
        messageComposeVC.body = textToShare
    }
    
    func inviteViaEmail() {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Invite to Phenom")
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \("username"))\n\nhttp://phenomapp.com")
        mailComposerVC.setMessageBody(textToShare, isHTML: false)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func logout() {
        
        // are you sure?
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).logoutAction()
        
    }
 

}
