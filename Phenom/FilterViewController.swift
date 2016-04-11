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

        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(xBtn)

        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "FILTER \(passedType)" 
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        if (passedType == "SPORT") {
            
            theArray = ["ALL", "BASEBALL", "BASKETBALL", "FOOTBALL", "SOCCER", "LACROSSE", "ICE HOCKEY", "SOFTBALL", "TENNIS", "TRACK & FIELD", "VOLLYBALL", "WRESTLING", "SWIMMING", "CROSS COUNTRY", "FIELD HOCKEY", "GOLF", "RUGBY", "CROSS FIT", "SKIING", "SNOWBOARDING", "SKATEBOARDING", "FIGURE SKATING", "GYMNASTICS"]
            
        } else {
            
            theArray = ["ALL ", "CAT1", "CAT2", "CAT3", "CAT4", "CAT5", "CAT6"]
            
        }
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-60)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        let bottomContainerView = UIView(frame: CGRectMake(0, view.frame.size.height-49, view.frame.size.width, 49))
        bottomContainerView.backgroundColor = UIColor.blackColor()
        view.addSubview(bottomContainerView)
        
        //filterBtn.frame = CGRectMake(10, 10, bottomContainerView.frame.size.width-20, bottomContainerView.frame.size.height-20)
        filterBtn.frame = CGRectMake(0, view.frame.size.height-60, view.frame.size.width, 60)
        filterBtn.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        filterBtn.addTarget(self, action:#selector(filterBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        filterBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        filterBtn.titleLabel?.numberOfLines = 1
        filterBtn.contentHorizontalAlignment = .Center
        filterBtn.contentVerticalAlignment = .Center
        filterBtn.titleLabel?.textAlignment = .Center
        filterBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        filterBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        filterBtn.setTitle("APPLY FILTER", forState: .Normal)
        view.addSubview(filterBtn)
        
        //
        
//        if let i = theArray.indexOfObject("") {
//            print("Jason is at index \(i)")
//        } else {
//            print("not there")
//        }
    
        
        
        
        if (selectedObj != "") {
            // passed a selected cell, figure out the index and select that index
            
            let i = theArray.indexOfObject(selectedObj)
            selectedCell = NSIndexPath(forRow: i, inSection: 0)
            
        } else {
            
            selectedCell = NSIndexPath(forRow: 0, inSection: 0)
        }
        
        //
        
        theTableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func xBtnAction() {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterBtnAction() {
        
        //print("cell: \(selectedCell) - obj: \(selectedObj)")
        
        // post nsnotification
        
        let dict = NSDictionary(dictionary:["type": passedType, "obj":selectedObj])
        
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadExploreGearNotification", object: nil, userInfo: dict as [NSObject : AnyObject])
        
        xBtnAction()
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        
        let obj = theArray.objectAtIndex(indexPath.row) as! String
        cell.textLabel?.text = obj
        
        if (selectedCell == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        let obj = theArray.objectAtIndex(indexPath.row) as! String
        
        selectedObj = obj
        selectedCell = indexPath
        
        theTableView.reloadData()
        
        
        
    }
    
    

}
