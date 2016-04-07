//
//  FilterViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/6/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var passedType = NSString()
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
    var theArray = NSArray()
    
    var filterBtn = UIButton.init(type: .Custom)
    
    var selectedCells = NSMutableArray()
    var selectedCell = NSIndexPath()
    
    var selectedObj = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor.blackColor()
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(self.xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(xBtn)

        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "FILTER \(self.passedType)" 
        titleLbl.font = UIFont.boldSystemFontOfSize(17)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        if (self.passedType == "SPORT") {
            
            self.theArray = ["ALL", "BASEBALL", "BASKETBALL", "FOOTBALL", "SOCCER", "LACROSSE", "ICE HOCKEY", "SOFTBALL", "TENNIS", "TRACK & FIELD", "VOLLYBALL", "WRESTLING", "SWIMMING", "CROSS COUNTRY", "FIELD HOCKEY", "GOLF", "RUGBY", "CROSS FIT", "SKIING", "SNOWBOARDING", "SKATEBOARDING", "FIGURE SKATING", "GYMNASTICS"]
            
        } else {
            
            self.theArray = ["ALL ", "CAT1", "CAT2", "CAT3", "CAT4", "CAT5", "CAT6"]
            
        }
        
        self.theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-60)
        self.theTableView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        let bottomContainerView = UIView(frame: CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49))
        bottomContainerView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(bottomContainerView)
        
        //self.filterBtn.frame = CGRectMake(10, 10, bottomContainerView.frame.size.width-20, bottomContainerView.frame.size.height-20)
        self.filterBtn.frame = CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)
        self.filterBtn.backgroundColor = UIColor.greenColor()
        self.filterBtn.addTarget(self, action:#selector(self.filterBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.filterBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(20)
        self.filterBtn.titleLabel?.numberOfLines = 1
        self.filterBtn.contentHorizontalAlignment = .Center
        self.filterBtn.contentVerticalAlignment = .Center
        self.filterBtn.titleLabel?.textAlignment = .Center
        self.filterBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.filterBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        self.filterBtn.setTitle("APPLY FILTER", forState: .Normal)
        self.view.addSubview(self.filterBtn)
        
        //
        
//        if let i = self.theArray.indexOfObject("") {
//            print("Jason is at index \(i)")
//        } else {
//            print("not there")
//        }
    
        
        
        
        if (self.selectedObj != "") {
            // passed a selected cell, figure out the index and select that index
            
            let i = self.theArray.indexOfObject(self.selectedObj)
            self.selectedCell = NSIndexPath(forRow: i, inSection: 0)
            
        } else {
            
            self.selectedCell = NSIndexPath(forRow: 0, inSection: 0)
        }
        
        //
        
        self.theTableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func xBtnAction() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterBtnAction() {
        
        //print("cell: \(self.selectedCell) - obj: \(self.selectedObj)")
        
        // post nsnotification
        
        let dict = NSDictionary(dictionary:["type": self.passedType, "obj":self.selectedObj])
        
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadExploreGearNotification", object: nil, userInfo: dict as [NSObject : AnyObject])
        
        self.xBtnAction()
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.theArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        let obj = self.theArray.objectAtIndex(indexPath.row) as! String
        cell.textLabel?.text = obj
        
        if (self.selectedCell == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
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
        
        let obj = self.theArray.objectAtIndex(indexPath.row) as! String
        
        self.selectedObj = obj
        self.selectedCell = indexPath
        
        self.theTableView.reloadData()
        
        
        
    }
    
    

}
