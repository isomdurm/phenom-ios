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
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 20, view.frame.size.width, 44)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PHENOM"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-20-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .None
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: 64+30)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(queryForTimeline), forControlEvents: UIControlEvents.ValueChanged)
        theTableView.addSubview(refreshControl)
        //
        
        let statusBarView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 20))
        statusBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(statusBarView)
        
        //
        
        queryForTimeline()
        
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
        
        isPushed = false
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

        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        // end with animation
        
        
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
        
        let padding = CGFloat(15)
        let imgHeight = view.frame.size.width+100
        
        var headlineHeight = CGFloat()
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (trimmedString == "") {
                headlineHeight = 0
            } else {
                let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: self.view.frame.size.width-30)
                headlineHeight = height+10
            }
        } else {
            headlineHeight = 0
        }
        
        if (headlineHeight == 0) {
            return imgHeight+padding+40+padding+40+padding+padding
        } else {
            return imgHeight+padding+40+padding+headlineHeight+padding+40+padding+padding
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainCell = MainCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        // for moments - measure height
        
        cell.teamNameLbl.hidden = true
        cell.teamSportLbl.hidden = true
        cell.teamNumLbl.hidden = true
        cell.teamPositionLbl.hidden = true
        
        cell.timelineImgView.hidden = false
        cell.timelineMusicLbl.hidden = false
        cell.timelineModeLbl.hidden = false
        cell.timelineTinyHeartBtn.hidden = false
        cell.timelineLikeLblBtn.hidden = false
        cell.timelineUserImgView.hidden = false
        cell.timelineUserImgViewBtn.hidden = false
        cell.timelineNameLbl.hidden = false
        cell.timelineTimeLbl.hidden = false
        cell.timelineFollowBtn.hidden = false
        cell.timelineHeadlineLbl.hidden = false
        cell.timelineLikeBtn.hidden = false
        cell.timelineCommentBtn.hidden = false
        cell.timelineGearBtn.hidden = false
        cell.timelineMoreBtn.hidden = false
        
        cell.gearImgView.hidden = true
        cell.gearBrandLbl.hidden = true
        cell.gearNameLbl.hidden = true
        cell.gearAddBtn.hidden = true
        
        //
        
        cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth+100)
        
        //timelineTinyHeartBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        //timelineLikeLblBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        
        cell.timelineUserImgView.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15, 40, 40)
        cell.timelineUserImgViewBtn.frame = CGRectMake(cell.timelineUserImgView.frame.origin.x, cell.timelineUserImgView.frame.origin.y, cell.timelineUserImgView.frame.size.width, cell.timelineUserImgView.frame.size.height)
        cell.timelineFollowBtn.frame = CGRectMake(cell.cellWidth-50-15, cell.timelineImgView.frame.size.height+15, 50, 40)
        
        //
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[indexPath.row]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth+100)
            cell.timelineImgView.setNeedsLayout()
            
            //cell.momentImgView.hnk_setImageFromURL(fileUrl!)
            cell.timelineImgView.hnk_setImageFromURL(fileUrl!, placeholder: UIImage.init(named: ""),
                                                     success: { image in
                                                        
                                                        //print("image here: \(image)")
                                                        cell.timelineImgView.image = image
                                                        
                },
                                                     failure: { error in
                                                        
                                                        if ((error) != nil) {
                                                            print("error here: \(error)")
                                                            
                                                            // collapse, this cell - it was prob deleted - error 402
                                                            
                                                        }
            })
            //print("cell.momentImgView.image: \(cell.momentImgView.image)")
        }
        
        if let id = results[indexPath.row]["mode"].number {
            var str = ""
            if (id == 0) {
                str = "TRAINING"
            } else if (id == 1) {
                str = "GAMING"
            } else {
                str = "STYLING"
            }
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineModeLbl.font, height: cell.timelineModeLbl.frame.size.height)
            if (width > cell.cellWidth-30) {
                cell.timelineModeLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-15, cell.cellWidth-30, 20)
            } else {
                cell.timelineModeLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-15, width+20, 20)
            }
            cell.timelineModeLbl.text = str
        }
        
        if let id = results[indexPath.row]["song"]["artistName"].string {
            cell.timelineMusicLbl.hidden = false
            let str = "\(id) | \(results[indexPath.row]["song"]["trackName"])"
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineMusicLbl.font, height: cell.timelineMusicLbl.frame.size.height)
            if (width > cell.cellWidth-30) {
                cell.timelineMusicLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-10-20-15, cell.cellWidth-30, 20)
            } else {
                cell.timelineMusicLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-10-20-15, width+20, 20)
            }
            cell.timelineMusicLbl.text = str
        } else {
            cell.timelineMusicLbl.hidden = true
        }
        
        if let id = results[indexPath.row]["user"]["imageUrl"].string {
            
            let fileUrl = NSURL(string: id)
            cell.timelineUserImgView.setNeedsLayout()
            
            //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
            cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!, placeholder: UIImage.init(named: ""),
                                                         success: { image in
                                                            
                                                            //print("image here: \(image)")
                                                            cell.timelineUserImgView.image = image
                                                            
                },
                                                         failure: { error in
                                                            
                                                            if ((error) != nil) {
                                                                print("error here: \(error)")
                                                                
                                                            }
            })
        }
        
        if let id = results[indexPath.row]["user"]["firstName"].string {
            
            let last = "\(results[indexPath.row]["user"]["lastName"])"
            let str = "\(id) \(last)"
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineNameLbl.font, height: 20)
            cell.timelineNameLbl.frame = CGRect(x: 15+40+15, y: cell.timelineImgView.frame.size.height+15, width: width, height: 20)
            cell.timelineNameLbl.text = str
            
        }
        
        if let id = results[indexPath.row]["createdAt"].string {
            //let strDate = "2015-11-01T00:00:00Z" // "2015-10-06T15:42:34Z"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"  //"yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.dateFromString(id)!
            let since = (UIApplication.sharedApplication().delegate as! AppDelegate).timeAgoSinceDate(date, numericDates: true)
            
            var dateStr = ""
            if let ht = results[indexPath.row]["user"]["hometown"].string {
                dateStr = "\(since) - \(ht)"
            } else {
                dateStr = "\(since)"
            }
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(dateStr, font: cell.timelineTimeLbl.font, height: 20)
            cell.timelineTimeLbl.frame = CGRect(x: 15+40+15, y: cell.timelineImgView.frame.size.height+15+20, width: width, height: 20)
            cell.timelineTimeLbl.text = dateStr
        }
        
        if let id = results[indexPath.row]["likesCount"].number {
            let str = "\(id) likes"
            cell.timelineLikeLblBtn.titleLabel?.text = str
            
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: (cell.timelineLikeLblBtn.titleLabel?.font)!, height: (cell.timelineLikeLblBtn.titleLabel?.frame.size.height)!)
            cell.timelineLikeLblBtn.frame = CGRectMake(15, cell.cellWidth+50+3, 22+5+width, (cell.timelineLikeLblBtn.titleLabel?.frame.size.height)!)
        }
        
        var headlineHeight = CGFloat()
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (trimmedString == "") {
                headlineHeight = 0
                cell.timelineHeadlineLbl.text = trimmedString
            } else {
                let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: cell.timelineHeadlineLbl.font, width: cell.cellWidth-30)
                headlineHeight = height+10
                cell.timelineHeadlineLbl.text = trimmedString
            }
        } else {
            headlineHeight = 0
        }
        cell.timelineHeadlineLbl.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15+40+15, cell.cellWidth-30, headlineHeight)
        
        
        var btnY = CGFloat()
        if (headlineHeight == 0) {
            btnY = cell.timelineImgView.frame.size.height+15+40+15
        } else {
            btnY = cell.timelineImgView.frame.size.height+15+40+15+cell.timelineHeadlineLbl.frame.size.height+15
        }
        cell.timelineLikeBtn.frame = CGRectMake(15, btnY, 65, 38)
        cell.timelineCommentBtn.frame = CGRectMake(15+64+10, btnY, 65, 38)
        cell.timelineGearBtn.frame = CGRectMake(15+64+10+64+10, btnY, 65, 38)
        cell.timelineMoreBtn.frame = CGRectMake(15+64+10+64+10+64+10, btnY, 50, 38)
        
        //            if let id = results[indexPath.row]["commentCount"].number {
        //                let countStr = "\(id) comments"
        //                cell.commentLbl.text = countStr
        //            }
        
        
        if let id = results[indexPath.row]["user"]["userFollows"].bool {
            if (id) {
                cell.timelineFollowBtn.selected = true
                cell.timelineFollowBtn.hidden = true
            } else {
                cell.timelineFollowBtn.selected = false
                cell.timelineFollowBtn.hidden = false
            }
        } else {
            cell.timelineFollowBtn.selected = true
            cell.timelineFollowBtn.hidden = true
        }
        
        
        // button actions
        
        cell.timelineUserImgViewBtn.tag = indexPath.row
        cell.timelineLikeBtn.tag = indexPath.row
        cell.timelineCommentBtn.tag = indexPath.row
        cell.timelineGearBtn.tag = indexPath.row
        cell.timelineMoreBtn.tag = indexPath.row
        
        cell.timelineUserImgViewBtn.addTarget(self, action:#selector(timelineUserImgViewBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineLikeBtn.addTarget(self, action:#selector(timelineLikeBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineCommentBtn.addTarget(self, action:#selector(timelineCommentBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineGearBtn.addTarget(self, action:#selector(timelineGearBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineMoreBtn.addTarget(self, action:#selector(timelineMoreBtnAction), forControlEvents: .TouchUpInside)
        
        // handle taps
        
        cell.timelineSingleTapRecognizer.addTarget(self, action: #selector(timelineSingleTapAction(_:)))
        cell.timelineDoubleTapRecognizer.addTarget(self, action: #selector(timelineDoubleTapAction(_:)))
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) //UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.row == tableView.indexPathsForVisibleRows?.last?.row) {
            //end of loading
            print("this section hit: \(indexPath.row)")
            
            let json = JSON(data: momentsData)
            let lastMomentNum = json["results"].count-1
            
            if (indexPath.row == lastMomentNum) {
                
                if (!loadNextPage) {
                    
                    print("load next page")
                    loadNextPage = true
                    
                    pageNumber = pageNumber+1
                    
                    queryForTimeline()
                    
                    
                }
            }
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        //isPushed = false
        
        //let vc  = DetailViewController()
        //vc.isGear = false
        //navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getNextPage() {
        
        pageNumber = pageNumber + 1
        
        queryForTimeline()
        
    }
    
    func timelineUserImgViewBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["user"]["id"].string {
            
            let id = results[sender.tag]["user"]["id"].string
            let un = results[sender.tag]["user"]["username"].string
            let imageUrl = results[sender.tag]["user"]["imageUrl"].string
            let firstName = results[sender.tag]["user"]["firstName"].string
            let lastName = results[sender.tag]["user"]["lastName"].string
            let sport = results[sender.tag]["user"]["sport"].string
            let hometown = results[sender.tag]["user"]["hometown"].string
            let bio = results[sender.tag]["user"]["description"].string
            let userFollows = results[sender.tag]["user"]["userFollows"].bool
            let followingCount = results[sender.tag]["user"]["followingCount"].number
            let followersCount = results[sender.tag]["user"]["followersCount"].number
            let momentCount = results[sender.tag]["user"]["momentCount"].number
            let lockerProductCount = results[sender.tag]["user"]["lockerProductCount"].number
            
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
    
    func timelineLikeBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["id"].string {
            
        }
    }
    
    func timelineCommentBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = CommentsViewController()
            vc.passedMomentId = id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineGearBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["products"].arrayObject {
            
            print("array: \(id)")
            
            let vc = GearListViewController()
            vc.passedProducts = id
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineMoreBtnAction(sender: UIButton!){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["id"].string {
            
        }
    }
    
    func likesBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["likesCount"].number {
            if (Int(id) > 0) {
                if let id = results[sender.tag]["id"].string {
                    print("id: \(id)")
                    let vc = LikesViewController()
                    vc.passedMomentId = id
                    vc.hidesBottomBarWhenPushed = false
                    navigationController?.pushViewController(vc, animated: true)
                    
                    isPushed = true
                }
            }
        }
    }
    
    func timelineSingleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    print("single tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    // play video or music !!!
                    
                    let json = JSON(data: momentsData)
                    
                    let results = json["results"]
                    print(results)
                    
                    if let id = results[tappedIndexPath.row]["song"]["publicUrl"].string {
                        
                        if (playingMedia) {
                            
                            // stop media
                            
                            
                            
                        } else {
                            
                            // play media
                            
//                            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//                            
//                            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//                            
//                            guard let URL = NSURL(string: id) else {return}
//                            let request = NSMutableURLRequest(URL: URL)
//                            request.HTTPMethod = "GET"
//                            
//                            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                            
//                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                                
//                                let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                                    if (error == nil) {
//                                        
//                                        let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                                        
//                                        print("ok: \(datastring)")
//                                        
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
//                                        
//                                    } else {
//                                        
//                                        print("error in \(self)")
//                                    }
//                                    
//                                    
//                                })
//                                task.resume()
//                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    
    func timelineDoubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    //likeMoment()
                    
                    print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    
                }
            }
        }
    }
    
    
    
    
    // UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var currentScrollViewRect = scrollView.frame //CGRect
        
        var currentScrollViewOffset = scrollView.contentOffset //CGPoint
        
        let offsetShiftY = lastOffsetY - scrollView.contentOffset.y //CGFloat
        
        if (offsetShiftY > 0)
        {
            distancePulledDownwards += offsetShiftY;
            
            var wantedOriginY = currentScrollViewRect.origin.y //CGFloat
            if ((scrollView.contentOffset.y<0)  || (currentScrollViewRect.origin.y>20) || (distancePulledDownwards > 100)) //|| (distancePulledDownwards > SIGNIFICANT_SCROLLING_DISTANCE)
            {
                // shift scroll views frame by offset shift
                wantedOriginY = currentScrollViewRect.origin.y + offsetShiftY
                // compensate that shift by moving content offset back
                currentScrollViewOffset.y += (wantedOriginY <= 64) ? offsetShiftY : 0
                
                
            }
            currentScrollViewRect.origin.y = (wantedOriginY <= 64) ? wantedOriginY : 64
            //currentScrollViewRect.size.height = view.frame.size.height-20-49
            
        }
        else
        {
            distancePulledDownwards = 0
            
            if (scrollView.contentOffset.y > 0)
            {
                let wantedOriginY = currentScrollViewRect.origin.y + offsetShiftY //CGFloat
                currentScrollViewRect.origin.y = (wantedOriginY >= 20) ? wantedOriginY : 20
                //currentScrollViewRect.size.height = view.frame.size.height-20-49
                currentScrollViewOffset.y += (wantedOriginY >= 20) ? offsetShiftY : 0
            }
        }
        
        scrollView.frame = currentScrollViewRect
        scrollView.delegate = nil
        scrollView.contentOffset = currentScrollViewOffset
        scrollView.delegate = self
        
        lastOffsetY = scrollView.contentOffset.y
        
        //
        
        var navBarViewFrame = navBarView.frame
        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
        navBarView.frame = navBarViewFrame
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//        print("scrollViewShouldScrollToTop hit")
//        scrollView.frame = CGRectMake(0, 20, view.frame.size.width, view.frame.size.height-20-49)
//        scrollView.contentOffset = CGPoint(x: 0, y: 44)
//        var navBarViewFrame = navBarView.frame
//        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
//        navBarView.frame = navBarViewFrame
        return true
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
//        print("scrollViewDidScrollToTop hit")
//        scrollView.frame = CGRectMake(0, 20, view.frame.size.width, view.frame.size.height-20-49)
//        scrollView.contentOffset = CGPoint(x: 0, y: 44)
//        var navBarViewFrame = navBarView.frame
//        navBarViewFrame.origin.y = scrollView.frame.origin.y-44
//        navBarView.frame = navBarViewFrame
        
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
//                    theTableView.reloadData()
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
//                    theTableView.reloadData()
//                    
//                }
//                
//            })
//            task.resume()
//        })
    }
    
}
