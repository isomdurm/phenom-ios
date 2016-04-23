//
//  FeedViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/22/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SwiftyJSON
import Haneke


class FeedViewController: UIViewController, ASTableViewDelegate, ASTableViewDataSource {

    var momentsData = NSData()
    
    var navBarView = UIView()
    private var lastOffsetY : CGFloat = 0
    private var distancePulledDownwards: CGFloat = 0
    
    var theTableView = ASTableView()
    
    var isPushed: Bool = false
    
    var momentNumber = 20
    var loadNextPage: Bool = false
    var playingMedia: Bool = false
    
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 20, view.frame.size.width, 44)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let searchBtn = UIButton(type: UIButtonType.Custom)
        searchBtn.frame = CGRectMake(15, 0, 44, 44)
        searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), forState: UIControlState.Normal)
        //searchBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.clearColor()
        //searchBtn.addTarget(self, action:#selector(searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(searchBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PHENOM"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)

        
        theTableView.frame = CGRectMake(0, 64+60, view.frame.size.width, view.frame.size.height-20-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .None
        //theTableView.delegate = self
        //theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(ASCellNode.self, forCellReuseIdentifier: "cell") 
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 100))
        

        
        let statusBarView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 20))
        statusBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(statusBarView)
        
        //
        
        queryForTimeline()
        

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    func queryForTimeline() {
        
        
    }
    

    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let json = JSON(data: momentsData)
        return json["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        let h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForTimelineMoment(results, ip: indexPath, cellWidth: view.frame.size.width)
        return h
        
    }
    
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        
        
        
        return ASCellNode()
        
    }
    
}
