//
//  InviteFriendsViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        
        // NO BACK BUTTON
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "INVITE FRIENDS"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let doneBtn = UIButton(type: UIButtonType.Custom)
        doneBtn.frame = CGRectMake(view.frame.size.width-70-20, 20, 70, 44)
        doneBtn.setImage(UIImage(named: "doneBtn.png"), forState: UIControlState.Normal)
        //doneBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        doneBtn.backgroundColor = UIColor.redColor()
        doneBtn.addTarget(self, action:#selector(doneBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(doneBtn)
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64)
        theTableView.backgroundColor = UIColor.redColor()
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        
        // auto-follow friends
        //
        // ask for access to contacts
        //
        // show friends already on the service
        //
        // show 10 suggested users under
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        //cell.detailTextLabel?.textColor = UIColor.init(white: 0.6, alpha: 1.0)
        //cell.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        
        //cell.textLabel?.text = "text"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
        
    }
    
    
    func doneBtnAction() {
        
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
        (UIApplication.sharedApplication().delegate as! AppDelegate).presentTabBarViewController()
        
    }
    
    

}
