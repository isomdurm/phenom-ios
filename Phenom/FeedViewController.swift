//
//  FeedViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/22/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import AsyncDisplayKit
import SwiftyJSON
import Haneke


class FeedViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate  {
    
    var momentsData = Data()
    
    var navBarView = UIView()
    fileprivate var lastOffsetY : CGFloat = 0
    fileprivate var distancePulledDownwards: CGFloat = 0
    
    var theTableView = ASTableView()
    
    var isPushed: Bool = false
    
    var momentNumber = 20
    var loadNextPage: Bool = false
    var playingMedia: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 20, width: view.frame.size.width, height: 44)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let searchBtn = UIButton(type: UIButtonType.custom)
        searchBtn.frame = CGRect(x: 15, y: 0, width: 44, height: 44)
        searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), for: UIControlState())
        //searchBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.clear
        //searchBtn.addTarget(self, action:#selector(searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(searchBtn)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "PHENOM"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)

        
        theTableView.frame = CGRect(x: 0, y: 64+60, width: view.frame.size.width, height: view.frame.size.height-20-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .None
        theTableView.asyncDelegate = self
        theTableView.asyncDataSource = self
        theTableView.showsVerticalScrollIndicator = true
        //theTableView.registerClass(ASCellNode.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 100))
                
        let statusBarView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
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
        self.momentsData = Data()
        //
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        let date = Date().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment/feed?date=\(date)&amount=\(momentNumber)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                
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
        
        UIView.animate(withDuration: 0.38, delay:0.5, options: UIViewAnimationOptions(), animations: {
            
            var tableFrame = self.theTableView.frame
            tableFrame.origin.y = 64
            self.theTableView.frame = tableFrame
            
            }, completion: { finished in
                
                //self.activityIndicator.stopAnimating()
                //self.activityIndicator.removeFromSuperview()
                
                
                // IF hasNotAddedAMoment, show view
                
                let defaults = UserDefaults.standard
                
                let hasAddedAMoment = defaults.bool(forKey: "hasAddedAMoment")
                if (!hasAddedAMoment) {
                    
                    (UIApplication.shared.delegate as! AppDelegate).showAddMomentView()
                    
                }
                
                //(UIApplication.sharedApplication().delegate as! AppDelegate).queryForActivityCountSinceLastVisit()
        })        
        
    }

    // TableViewDelegate
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let json = JSON(data: momentsData)
        return json["results"].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        var h = CGFloat()
        
        
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(CharacterSet.whitespaceCharacterSet())
            h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: UIFont.systemFontOfSize(17), width: self.view.frame.size.width)
        } else {
            h = 0
        }
        
        return h
        
    }

    
    func tableView(_ tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode! {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        let node = ASCellNode()
        node.layerBacked = false // are touches required?
        
        var h = ""
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(CharacterSet.whitespaceCharacterSet())
            h = trimmedString
        } else {
            h = ""
        }

        
        let headlineNode = ASTextCellNode()
        headlineNode.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        headlineNode.layout()
        headlineNode.text = h
        //node.addSubnode(headlineNode)
        
        
        return headlineNode
        
        
        //ASDataController * dataController = [self valueForKey:@"_dataController"];
        //NSAssert(dataController != nil, @"Could not find data controller");
        //return [dataController nodeAtIndexPath:indexPath];

        //let dataController = self.theTableView .valueForKey("_dataController") as! ASDataController
        //return dataController.nodeAtIndexPath(indexPath)
        
    }
    
    

    
    func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        
        
        print("tapped: \(indexPath.row)")
        
        
    }
    
    
    //
    //
    //
    
    func tableView(_ tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
        
        
        
    }
    
  
    
}
