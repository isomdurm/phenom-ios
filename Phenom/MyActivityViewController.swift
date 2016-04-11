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
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "NOTIFICATIONS"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
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
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: 30)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        theTableView.addSubview(refreshControl)
        
        //
        
        queryForMyActivity()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        isPushed = false
    }
    
    func refreshControlAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).lastvisiteddate = NSDate()
        
        //let newme = PFUser.currentUser()
        //newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //newme!.saveInBackground()
        
        
        queryForMyActivity()
        
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
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        
    }
    
    
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let moments = JSON(data: myActivityData)
        return moments["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return 64
        
        let moments = JSON(data: myActivityData)
        let results = moments["results"]
        
        if let id = results[indexPath.row]["message"].string {
            
            let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 13)!, width: self.view.frame.size.width-30)
            let messageHeight = height+20
            if (messageHeight > 64) {
                return messageHeight
            } else {
                return 64
            }
            
        } else {
            return 64
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ActivityCell = ActivityCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        let moments = JSON(data: myActivityData)
        let results = moments["results"]
        
        if let id = results[indexPath.row]["source"]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.userImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
            cell.userImgView.setNeedsLayout()
            
            cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: UIImage.init(named: ""),
                                                     success: { image in
                                                        
                                                        //print("image here: \(image)")
                                                        cell.userImgView.image = image
                                                        
                },
                                                     failure: { error in
                                                        
                                                        if ((error) != nil) {
                                                            print("error here: \(error)")
                                                        }
            })
        }
        
        if let id = results[indexPath.row]["message"].string {
            
            let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.activityLbl.font, width: self.view.frame.size.width-30)
            let messageHeight = height+20
            if (messageHeight > 64) {
                cell.activityLbl.frame = CGRectMake(15+44+10, 0, cell.cellWidth-15-40-15-44-15-10, messageHeight)
            } else {
                cell.activityLbl.frame = CGRectMake(15+44+10, 0, cell.cellWidth-15-40-15-44-15-10, 64)
            }
            cell.activityLbl.text = id
            
        } else {
            cell.activityLbl.frame = CGRectMake(15+44+10, 0, cell.cellWidth-15-40-15-44-15-10, 64)
        }
        
        
        // button actions
        
        cell.userBtn.tag = indexPath.row
        cell.momentBtn.tag = indexPath.row
        
        cell.userBtn.addTarget(self, action:#selector(userBtnAction), forControlEvents: .TouchUpInside)
        cell.momentBtn.addTarget(self, action:#selector(momentBtnAction), forControlEvents: .TouchUpInside)
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) //UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        isPushed = true
        
        //let vc = DetailViewController()
        //vc.isGear = true
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func userBtnAction(sender: UIButton!) {
        print(sender.tag)
        
        let json = JSON(data: myActivityData)

        let results = json["results"]
        
        print("source: \(results[sender.tag]["source"])")
        
        if let _ = results[sender.tag]["source"]["id"].string {
            
            let id = results[sender.tag]["source"]["id"].string
            let un = results[sender.tag]["source"]["username"].string
            
            let imageUrl = results[sender.tag]["source"]["imageUrl"].string
            let firstName = results[sender.tag]["source"]["firstName"].string
            let lastName = results[sender.tag]["source"]["lastName"].string
            let sport = results[sender.tag]["source"]["sport"].string
            let hometown = results[sender.tag]["source"]["hometown"].string
            let bio = results[sender.tag]["source"]["description"].string
            
            let userFollows = results[sender.tag]["source"]["userFollows"].bool
            
            let lockerProductCount = results[sender.tag]["source"]["lockerProductCount"].number
            let followingCount = results[sender.tag]["source"]["followingCount"].number
            let followersCount = results[sender.tag]["source"]["followersCount"].number
            let momentCount = results[sender.tag]["source"]["momentCount"].number
            
            //
            
            let vc = ProfileViewController()
            
            vc.userId = id!
            vc.username = un!
            vc.imageUrl = imageUrl!
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.sports = [sport!]
            vc.hometown = hometown!
            vc.bio = bio!
            
            vc.userFollows = userFollows!
            
            vc.lockerProductCount = lockerProductCount!
            vc.followingCount = followingCount!
            vc.followersCount = followersCount!
            vc.momentCount = momentCount!
            
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }

        
    }

    
    func momentBtnAction(sender: UIButton!) {
        print(sender.tag)
        
//        let moments = JSON(data: myActivityData)
//        let results = moments["results"]
//        
//        if let id = results[sender.tag]["id"].string {
//            print("id: \(id)")
//            let vc = CommentsViewController()
//            vc.passedMomentId = id
//            vc.hidesBottomBarWhenPushed = true
//            navigationController?.pushViewController(vc, animated: true)
//            
//            isPushed = true
//        }
    }

    

}
