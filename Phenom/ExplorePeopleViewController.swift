//
//  ExplorePeopleViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class ExplorePeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var exploreGear = NSData()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
    var isSearching: Bool = false
    
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
        backBtn.addTarget(self, action:#selector(self.backAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "EXPLORE PEOPLE"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        let searchBtn = UIButton(type: .Custom)
        searchBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        searchBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //searchBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.blueColor()
        searchBtn.addTarget(self, action:#selector(self.searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(searchBtn)
        
        self.theTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49)
        //self.theTableView.contentOffset = CGPoint(x: 0, y: 44)
        self.theTableView.backgroundColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:0.5)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(ExploreCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        
        //
        
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.backAction))
        swipeBack.direction = .Right
        self.view.addGestureRecognizer(swipeBack)
        
        //
        
        //self.queryForPeople()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore = false
            //self.queryForFeatured()
        }
        
        self.isSearching = false
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBtnAction() {
        
        // pre-select "people"
        let vc = SearchViewController()
        
        self.navigationController?.pushViewController(vc, animated: false)
        
        self.isSearching = true
    }
    
    func queryForPeople() {
        
        
        
    }
    
    
    func navBtnAction() {
        //        print("navBtnAction hit")
        
        self.navigationController?.pushViewController(SearchViewController(), animated: false)
        
        self.isSearching = true
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        //self.navigationController?.pushViewController(ProfileViewController(), animated: true)
        
    }
    


}
