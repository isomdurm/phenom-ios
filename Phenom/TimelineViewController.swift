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
//import AFNetworking


class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var momentsData = NSData()
    
    var passedMomentId = NSString()
    
    var momentsArray = NSArray()
    
    var access_token = ""
    
    var imageUrl = ""

    var navBarView = UIView()
    private var lastOffsetY : CGFloat = 0
    private var distancePulledDownwards: CGFloat = 0
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var timelineArray = NSMutableArray()
    
    var isPushed: Bool = false
    
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
        self.refreshControl.addTarget(self, action: #selector(TimelineViewController.queryForTimeline), forControlEvents: UIControlEvents.ValueChanged)
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
        request.addValue("1.2.3", forHTTPHeaderField: "apiVersion")
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
                        
                        self.momentsData = dataFromString
                        
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
        
        
        //self.timelineArray = result
        
//        UIView.animateWithDuration(0.40, delay:2.0, options: .CurveEaseInOut, animations: {
//            
//            //var tableFrame = self.theTableView.frame
//            //tableFrame.origin.y = 64
//            //self.theTableView.frame = tableFrame
//            
//            }, completion: { finished in
//                if (finished) {
//                    
//                    self.activityIndicator.stopAnimating()
//                    self.activityIndicator.removeFromSuperview()
//                }
//        })
        
    }
    
    
    func doubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(self.theTableView)
            if let tappedIndexPath = self.theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = self.theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    likeMoment()
                    
                    print("tapped section: \(tappedIndexPath.section), \(tappedCell)")
                    
                    
                    
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
        
        let cell:TimelineCell = TimelineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
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

        
        
//        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
//        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        
//        aView.addSubview(aLbl)
//        headerView.timeLbl?.text = "TIME LBL HERE"
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TimelineCell = TimelineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        let moments = JSON(data: self.momentsData)
        
        let test = moments["results"]
        
        if let id = test[indexPath.section]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.momentImgView.frame = CGRectMake(0, 0, cell.self.cellWidth, cell.self.cellWidth)
            cell.momentImgView.setNeedsLayout()

            cell.momentImgView.hnk_setImageFromURL(fileUrl!)
            
//            if ((cell.momentImgView.image) != nil) {
//                cell.momentImgView.hnk_setImageFromURL(fileUrl!)
//            } else {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    
//                })
//            }
            
            
            
        }
        
        if let id = test[indexPath.section]["likesCount"].number {
            let countStr = "\(id) likes" 
            cell.likesLbl.text = countStr
        }
        
        if let id = test[indexPath.section]["headline"].string {
            cell.headerLbl.text = id
        }
        
        if let id = test[indexPath.section]["commentCount"].number {
            let countStr = "\(id) comments"
            cell.commentLbl.text = countStr
        }
        
        if let id = test[indexPath.section]["mode"].number {
            if (id == 0) {
                cell.typeLbl.text = "TRAINING"
            } else if (id == 1) {
                cell.typeLbl.text = "GAMING"
            } else {
                cell.typeLbl.text = "STYLING"
            }
        }
        
        if let id = test[indexPath.section]["song"]["artistName"].string {
            cell.musicLbl.text = "\(id) \(test[indexPath.section]["song"]["trackName"])"
        }
        
        // handle double tap
        
        cell.doubleTapRecognizer.addTarget(self, action: #selector(TimelineViewController.doubleTapAction(_:)))
        cell.doubleTapRecognizer.numberOfTapsRequired = 2
        
        //
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        //self.isPushed = false
        
        //let vc  = DetailViewController()
        //vc.isGear = false
        //self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func userBtnAction(sender: UIButton!){
        
        
        
    }
    
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
    
    func sendRequest() {
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "https://api1.phenomapp.com:8081/oauth/token") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("1.2.3", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer 6B3P/uVDXfSk7dSDK4DAyI1VfcgJNOceO5DhPYp5GnY=", forHTTPHeaderField: "Authorization")
        
        let bodyObject = [
            "username": "isomisom",
            "password": "R2lkODY3NTMwOSE=",
            "client_id": "chLsgAqWLqXGPsWDKACcAhobUmZrxpdZowOOwyPpFEBPHDQYGO",
            "client_secret": "YlVsbkxaeFFtZVhDY3ZaU2dIRWFCYmtUcWZhcXFPYldsT2JSaU1NZ2tjcm1MWEVKeko=",
            "grant_type": "password"
        ]
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyObject, options: [])
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    self.access_token = json["access_token"].string!
//                    print(self.access_token);
                }
                
            }
            else {
                
//                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }
    
    func likeMoment() {
        
        let bearer = "Bearer O31VCYHpKrCvoqJ+3iN7MeH7b/Dvok6394eR+LZoKhI="
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "https://api1.phenomapp.com:8081/moment/\(passedMomentId)/like") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("1.2.3", forHTTPHeaderField: "apiVersion")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                        
                    self.theTableView.reloadData()

                }
                
            })
            task.resume()
        })
    }
    
    func unlikeMoment() {
        
        let bearer = "Bearer O31VCYHpKrCvoqJ+3iN7MeH7b/Dvok6394eR+LZoKhI="
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "https://api1.phenomapp.com:8081/moment/\(passedMomentId)/unlike") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("1.2.3", forHTTPHeaderField: "apiVersion")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if (error == nil) {
                    
                    self.theTableView.reloadData()
                    
                }
                
            })
            task.resume()
        })
    }
    
}
