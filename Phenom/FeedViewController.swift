//
//  FeedViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/22/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import Alamofire
import AsyncDisplayKit
import SwiftyJSON
import Haneke


class FeedViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate  {
    
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
        theTableView.asyncDelegate = self
        theTableView.asyncDataSource = self
        theTableView.showsVerticalScrollIndicator = true
        //theTableView.registerClass(ASCellNode.self, forCellReuseIdentifier: "cell")
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
        
        //
        self.momentsData = NSData()
        //
        
        let bearerToken = NSUserDefaults.standardUserDefaults().objectForKey("bearerToken") as! String
        let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/feed?date=\(date)&amount=\(momentNumber)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    //print("JSON: \(JSON)")
                    
                    if let errorCode = JSON["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    self.momentsData = response.data!

                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.reloadAction()
                        
                    })
                }
        }
        
    }
    
    func reloadAction() {
        
        self.theTableView.reloadData()
        //self.refreshControl.endRefreshing()
        
        UIView.animateWithDuration(0.38, delay:0.5, options: .CurveEaseInOut, animations: {
            
            var tableFrame = self.theTableView.frame
            tableFrame.origin.y = 64
            self.theTableView.frame = tableFrame
            
            }, completion: { finished in
                
                //self.activityIndicator.stopAnimating()
                //self.activityIndicator.removeFromSuperview()
                
                
                // IF hasNotAddedAMoment, show view
                
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let hasAddedAMoment = defaults.boolForKey("hasAddedAMoment")
                if (!hasAddedAMoment) {
                    
                    (UIApplication.sharedApplication().delegate as! AppDelegate).showAddMomentView()
                    
                }
                
                //(UIApplication.sharedApplication().delegate as! AppDelegate).queryForActivityCountSinceLastVisit()
        })        
        
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
        var h = CGFloat()
        
        
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: UIFont.systemFontOfSize(17), width: self.view.frame.size.width)
        } else {
            h = 0
        }
        
        return h
        
    }

    
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        let node = ASCellNode()
        node.layerBacked = false // are touches required?
        
        var h = ""
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            h = trimmedString
        } else {
            h = ""
        }

        
        let headlineNode = ASTextCellNode()
        headlineNode.frame = CGRectMake(0, 0, 200, 60)
        headlineNode.layout()
        headlineNode.text = h
        node.addSubnode(headlineNode)
        
        
        return node
        
        
        //ASDataController * dataController = [self valueForKey:@"_dataController"];
        //NSAssert(dataController != nil, @"Could not find data controller");
        //return [dataController nodeAtIndexPath:indexPath];

        //let dataController = self.theTableView .valueForKey("_dataController") as! ASDataController
        //return dataController.nodeAtIndexPath(indexPath)
        
    }
    
    

    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
        
        print("tapped: \(indexPath.row)")
        
        
    }
    
    
    //
    //
    //
    
    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
        
        
        
    }
    
  
    
}
