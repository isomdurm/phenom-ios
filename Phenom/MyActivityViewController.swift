//
//  MyActivityViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class MyActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var navBarView = UIView()

    var myActivityData = NSData()
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var isPushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "NOTIFICATIONS"
        titleLbl.font = UIFont.boldSystemFontOfSize(17)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        self.theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
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
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        self.theTableView.addSubview(refreshControl)
        
        //
        
        self.queryForMyActivity()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isPushed = false
    }
    
    func refreshControlAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).lastvisiteddate = NSDate()
        
        //let newme = PFUser.currentUser()
        //newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //newme!.saveInBackground()
        
        
        self.queryForMyActivity()
        
    }
    
    func queryForMyActivity() {
        
        // https://api1.phenomapp.com:8081/notification?since=DATE&limit=INT
        
        let date = NSDate().timeIntervalSince1970 * 1000
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/notification?since=\(date)&limit=30") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
    
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    
                    let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    
                    if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                        
                        let json = JSON(data: dataFromString)
                        if json["errorCode"].number != 200  {
                            print("json: \(json)")
                            print("error: \(json["errorCode"].number)")
                            
                            return
                        }
                        
                        self.myActivityData = dataFromString
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.refreshControl.endRefreshing()
                            
                            self.theTableView.reloadData()
                            
                        })
                        
                    } else {
                        // print("URL Session Task Failed: %@", error!.localizedDescription);
                        self.refreshControl.endRefreshing()
                    }
                } else {
                    self.refreshControl.endRefreshing()
                }
            })
            task.resume()
            //
        })
        
        
        
        // either way
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        
    }
    
    
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let moments = JSON(data: self.myActivityData)
        return moments["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ActivityCell = ActivityCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        let moments = JSON(data: self.myActivityData)
        
        let results = moments["results"]
        
        if let id = results[indexPath.row]["source"]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.userImgView.frame = CGRectMake(0, 0, cell.self.cellWidth, cell.self.cellWidth)
            cell.userImgView.setNeedsLayout()
            
            cell.userImgView.hnk_setImageFromURL(fileUrl!)
        }
        
        if let id = results[indexPath.row]["message"].string {
            
            //cell.activityLbl.frame = CGRectMake(0, 0, cell.self.cellWidth, cell.self.cellWidth)
            //cell.userImgView.setNeedsLayout()
            
            cell.activityLbl.text = id
        }
        
        
        
//        let timeAgo = (UIApplication.sharedApplication().delegate as! AppDelegate).timeAgoSinceDate(NSDate(), numericDates: NSDate())
        
        
        
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
        
        self.isPushed = true
        
        //let vc = DetailViewController()
        //vc.isGear = true
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func userBtnAction(sender: UIButton!){
        
        
    }
    

}
