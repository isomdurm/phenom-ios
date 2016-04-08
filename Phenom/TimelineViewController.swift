//
//  TimelineViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var momentsData = NSData()
    
    var navBarView = UIView()
    private var lastOffsetY : CGFloat = 0
    private var distancePulledDownwards: CGFloat = 0
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
        
    var isPushed: Bool = false
    
    var pageNumber = 1
    var loadNextPage: Bool = false
    
    var playingMedia: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PHENOM"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        self.theTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-20-49)
        //self.theTableView.contentOffset = CGPoint(x: 0, y: 44)
        self.theTableView.backgroundColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:0.5)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.activityIndicator.center = CGPoint(x: self.view.frame.size.width/2, y: 64+30)
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.queryForTimeline), forControlEvents: UIControlEvents.ValueChanged)
        self.theTableView.addSubview(self.refreshControl)
        //
        
        let statusBarView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 20))
        statusBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(statusBarView)
        
        //
        
        self.queryForTimeline()
        
        //
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let username = defaults.stringForKey("username")
//        let password = defaults.stringForKey("password")
//        let bt = defaults.stringForKey("bearerToken")
//        let rt = defaults.stringForKey("refreshToken")
//        let id = defaults.stringForKey("userId")
//        print("defaults: \(username), \(password), \(id), \(bt), \(rt),")
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isPushed = false
    }
    
    func queryForTimeline() {
        
        // get bearer token
        
        let date = NSDate().timeIntervalSince1970 * 1000
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/feed?date=\(date)&amount=20") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        //

//        let qualityOfServiceClass = QOS_CLASS_BACKGROUND //QOS_CLASS_USER_INTERACTIVE, QOS_CLASS_USER_INITIATED, QOS_CLASS_UTILITY
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        dispatch_async(backgroundQueue, {
//            print("This is run on the background queue")
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                print("This is run on the main queue, after the previous code in outer block")
//            })
//        })
        
        //
        
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
                        
                        self.momentsData = dataFromString
                        
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

        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
        
        // get moments
        
        // end with animation
        
        
    }
    
    func singleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(self.theTableView)
            if let tappedIndexPath = self.theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = self.theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    print("single tapped section: \(tappedIndexPath.section), \(tappedCell)")
                    
                    // play video or music !!!
                    
                    let moments = JSON(data: self.momentsData)
                    
                    let results = moments["results"]
                    print(results)
                    
                    if let id = results[tappedIndexPath.section]["song"]["publicUrl"].string {
                        
                        if (self.playingMedia) {
                            
                            // stop media
                            
                            
                            
                        } else {
                            
                            // play media
                            
                            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
                            
                            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
                            
                            guard let URL = NSURL(string: id) else {return}
                            let request = NSMutableURLRequest(URL: URL)
                            request.HTTPMethod = "GET"
                            
                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                                    if (error == nil) {
                                        
                                        let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                        
                                        print("ok: \(datastring)")
                                        
//                                        if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//                                            
//                                            let json = JSON(data: dataFromString)
//                                            if json["errorCode"].number != 200  {
//                                                print("json: \(json)")
//                                                print("error: \(json["errorCode"].number)")
//                                                
//                                                return
//                                            }
//                                            
//                                            
//                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                                
//
//                                                
//                                            })
//                                            
//                                        } else {
//                                            print("URL Session Task Failed: %@", error!.localizedDescription)
//                                            
//                                        }
                                        
                                    } else {
                                        
                                        print("error in \(self)")
                                    }
                                    
                                    
                                })
                                task.resume()
                            })

                            
                        }
                        
                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    func doubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(self.theTableView)
            if let tappedIndexPath = self.theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = self.theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    //self.likeMoment()
                    
                    print("double tapped section: \(tappedIndexPath.section), \(tappedCell)")
                    
                    
                }
            }
        }
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let moments = JSON(data: self.momentsData)
        return moments["results"].count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = TimelineHeaderView(frame: CGRectMake(0, 0, view.frame.size.width, 64))
        
        let moments = JSON(data: self.momentsData)
        
//        print(moments)
        
        let test = moments["results"]
        
        if let id = test[section]["user"]["firstName"].string {
            headerView.userLbl!.text = "\(id) \(test[section]["user"]["lastName"])"
        }
        
        if let id = test[section]["createdAt"].string {
            headerView.timeLbl!.text = id
        }
        
        if let id = test[section]["user"]["imageUrl"].string {
            
            let fileUrl = NSURL(string: id)
            headerView.userImgView!.frame = CGRectMake(15, 10, 44, 44)
            headerView.userImgView!.setNeedsLayout()
            
            headerView.userImgView!.hnk_setImageFromURL(fileUrl!)
        }

        
        let profileBtnWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(headerView.userLbl!.text!, font: headerView.userLbl!.font, height: headerView.userLbl!.frame.size.height)
        
        headerView.userBtn!.frame = CGRectMake(15, 10, 44+10+profileBtnWidth, 44)
        headerView.userBtn!.tag = section
        headerView.userBtn!.addTarget(self, action:#selector(self.userBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        
        
//        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
//        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        
//        aView.addSubview(aLbl)
//        headerView.timeLbl?.text = "TIME LBL HERE"
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width+165 // probably 150 by default then raise to second line of text if necessary
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TimelineCell = TimelineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        let moments = JSON(data: self.momentsData)
        
        let results = moments["results"]
        
        if let id = results[indexPath.section]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.momentImgView.frame = CGRectMake(0, 0, cell.self.cellWidth, cell.self.cellWidth)
            cell.momentImgView.setNeedsLayout()

            cell.momentImgView.hnk_setImageFromURL(fileUrl!)
        }
        
        if let id = results[indexPath.section]["likesCount"].number {
            let str = "\(id) likes"
            cell.likesLbl.text = str
            
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: (cell.likesBtn.titleLabel?.font)!, height: (cell.likesBtn.titleLabel?.frame.size.height)!)
            cell.likesBtn.frame = CGRectMake(15, cell.cellWidth+50+3, 22+5+width, (cell.likesBtn.titleLabel?.frame.size.height)!)
        }
        
        if let id = results[indexPath.section]["headline"].string {
            cell.headerLbl.text = id
        }
        
        if let id = results[indexPath.section]["commentCount"].number {
            let countStr = "\(id) comments"
            cell.commentLbl.text = countStr
        }
        
        if let id = results[indexPath.section]["mode"].number {
            var str = ""
            if (id == 0) {
                str = "TRAINING"
            } else if (id == 1) {
                str = "GAMING"
            } else {
                str = "STYLING"
            }
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.modeLbl.font, height: cell.modeLbl.frame.size.height)
            if (width > cell.cellWidth-30) {
                cell.modeLbl.frame = CGRectMake(15, cell.cellWidth-10-20, cell.cellWidth-30, 20)
            } else {
                cell.modeLbl.frame = CGRectMake(15, cell.cellWidth-10-20, width+20, 20)
            }
            cell.modeLbl.text = str
        }
        
        if let id = results[indexPath.section]["song"]["artistName"].string {
            cell.musicLbl.hidden = false
            let str = "\(id) | \(results[indexPath.section]["song"]["trackName"])"
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.musicLbl.font, height: cell.musicLbl.frame.size.height)
            if (width > cell.cellWidth-30) {
                cell.musicLbl.frame = CGRectMake(15, cell.cellWidth-10-20-10-20, cell.cellWidth-30, 20)
            } else {
                cell.musicLbl.frame = CGRectMake(15, cell.cellWidth-10-20-10-20, width+20, 20)
            }
            cell.musicLbl.text = str
            
        } else {
            cell.musicLbl.hidden = true
            
        }
        
        // button actions
        
        cell.commentBtn.tag = indexPath.section
        cell.gearBtn.tag = indexPath.section
        cell.headerBtn.tag = indexPath.section
        cell.likesBtn.tag = indexPath.section
        
        cell.commentBtn.addTarget(self, action:#selector(self.commentBtnAction), forControlEvents: .TouchUpInside)
        cell.gearBtn.addTarget(self, action:#selector(self.gearBtnAction), forControlEvents: .TouchUpInside)
        cell.headerBtn.addTarget(self, action:#selector(self.commentBtnAction), forControlEvents: .TouchUpInside)
        cell.likesBtn.addTarget(self, action:#selector(self.likesBtnAction), forControlEvents: .TouchUpInside)
        
        // handle taps
        
        cell.singleTapRecognizer.addTarget(self, action: #selector(self.singleTapAction(_:)))
        cell.doubleTapRecognizer.addTarget(self, action: #selector(self.doubleTapAction(_:)))
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        //
        //
        //
        
        if (indexPath.section == tableView.indexPathsForVisibleRows?.last?.section) {
            //end of loading
            print("this section hit: \(indexPath.section)")
            
            let moments = JSON(data: self.momentsData)
            let lastMomentNum = moments["results"].count-1
            
            if (indexPath.section == lastMomentNum) {
                
                if (!self.loadNextPage) {
                    
                    print("load next page")
                    self.loadNextPage = true
                    
                    
                }
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        //self.isPushed = false
        
        //let vc  = DetailViewController()
        //vc.isGear = false
        //self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getNextPage() {
        
        pageNumber = pageNumber + 1
        
        self.queryForTimeline()
        
    }
    
    func userBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: self.momentsData)
        
        //        print(moments)
        
        let user = moments["results"]
        
        print("user: \(user[sender.tag]["user"])")
        
        if let _ = user[sender.tag]["user"]["id"].string {
         
            let id = user[sender.tag]["user"]["id"].string
            let un = user[sender.tag]["user"]["username"].string
            
            let imageUrl = user[sender.tag]["user"]["imageUrl"].string
            let firstName = user[sender.tag]["user"]["firstName"].string
            let lastName = user[sender.tag]["user"]["lastName"].string
            let sport = user[sender.tag]["user"]["sport"].string
            let hometown = user[sender.tag]["user"]["hometown"].string
            let bio = user[sender.tag]["user"]["description"].string
            
            let userFollows = user[sender.tag]["user"]["userFollows"].bool
            
            let lockerProductCount = user[sender.tag]["user"]["lockerProductCount"].number
            let followingCount = user[sender.tag]["user"]["followingCount"].number
            let followersCount = user[sender.tag]["user"]["followersCount"].number
            let momentCount = user[sender.tag]["user"]["momentCount"].number
            
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
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            self.isPushed = true
        }
        
    }
    
    func commentBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: self.momentsData)
        let results = moments["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = CommentsViewController()
            vc.passedMomentId = id
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            
            self.isPushed = true
        }
    }
    
    func gearBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: self.momentsData)
        let moment = moments["results"]
                
        if let id = moment[sender.tag]["products"].arrayObject {
            
            print("array: \(id)")
            
            let vc = GearListViewController()
            vc.passedProducts = id
            self.navigationController?.pushViewController(vc, animated: true)
        
            self.isPushed = true
        }
        
    }
    
    func likesBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: self.momentsData)
        let results = moments["results"]
        
        if let id = results[sender.tag]["likesCount"].number {
            if (Int(id) > 0) {
                if let id = results[sender.tag]["id"].string {
                    print("id: \(id)")
                    let vc = LikesViewController()
                    vc.passedMomentId = id
                    vc.hidesBottomBarWhenPushed = false
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    self.isPushed = true
                }
            }
        }
    }
    
    // UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var currentScrollViewRect = scrollView.frame //CGRect
        
        var currentScrollViewOffset = scrollView.contentOffset //CGPoint
        
        let offsetShiftY = self.lastOffsetY - scrollView.contentOffset.y //CGFloat
        
        if (offsetShiftY > 0)
        {
            self.distancePulledDownwards += offsetShiftY;
            
            var wantedOriginY = currentScrollViewRect.origin.y //CGFloat
            if ((scrollView.contentOffset.y<0)  || (currentScrollViewRect.origin.y>20) || (self.distancePulledDownwards > 100)) //|| (self.distancePulledDownwards > SIGNIFICANT_SCROLLING_DISTANCE)
            {
                // shift scroll views frame by offset shift
                wantedOriginY = currentScrollViewRect.origin.y + offsetShiftY
                // compensate that shift by moving content offset back
                currentScrollViewOffset.y += (wantedOriginY <= 64) ? offsetShiftY : 0
                
                
            }
            currentScrollViewRect.origin.y = (wantedOriginY <= 64) ? wantedOriginY : 64
            //currentScrollViewRect.size.height = self.view.frame.size.height-20-49
            
        }
        else
        {
            self.distancePulledDownwards = 0
            
            if (scrollView.contentOffset.y > 0)
            {
                let wantedOriginY = currentScrollViewRect.origin.y + offsetShiftY //CGFloat
                currentScrollViewRect.origin.y = (wantedOriginY >= 20) ? wantedOriginY : 20
                //currentScrollViewRect.size.height = self.view.frame.size.height-20-49
                currentScrollViewOffset.y += (wantedOriginY >= 20) ? offsetShiftY : 0
            }
        }
        
        scrollView.frame = currentScrollViewRect
        scrollView.delegate = nil
        scrollView.contentOffset = currentScrollViewOffset
        scrollView.delegate = self
        
        self.lastOffsetY = scrollView.contentOffset.y
        
        //
        
        var navBarViewFrame = self.navBarView.frame
        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
        self.navBarView.frame = navBarViewFrame
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//        print("scrollViewShouldScrollToTop hit")
//        scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20-49)
//        scrollView.contentOffset = CGPoint(x: 0, y: 44)
//        var navBarViewFrame = self.navBarView.frame
//        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
//        self.navBarView.frame = navBarViewFrame
        return true
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
//        print("scrollViewDidScrollToTop hit")
//        scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20-49)
//        scrollView.contentOffset = CGPoint(x: 0, y: 44)
//        var navBarViewFrame = self.navBarView.frame
//        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
//        self.navBarView.frame = navBarViewFrame
        
    }
    
    
    
    func likeMoment() {
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
//        
//        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//        
//        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//        
//        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)/like") else {return}
//        let request = NSMutableURLRequest(URL: URL)
//        request.HTTPMethod = "POST"
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
//        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                if (error == nil) {
//                        
//                    self.theTableView.reloadData()
//
//                }
//                
//            })
//            task.resume()
//        })
    }
    
    func unlikeMoment() {
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
//        
//        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//        
//        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//        
//        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)/unlike") else {return}
//        let request = NSMutableURLRequest(URL: URL)
//        request.HTTPMethod = "DELETE"
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
//        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                if (error == nil) {
//                    
//                    self.theTableView.reloadData()
//                    
//                }
//                
//            })
//            task.resume()
//        })
    }
    
}
