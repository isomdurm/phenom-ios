//
//  TimelineViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import SDWebImage


class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var momentsData = NSData()
    
    var navBarView = UIView()
    private var lastOffsetY : CGFloat = 0
    private var distancePulledDownwards: CGFloat = 0
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
        
    var isPushed: Bool = false
    
    var momentNumber = 20
    var loadNextPage: Bool = false
    var playingMedia: Bool = false
    
    var theArray = NSMutableArray()
    
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
        searchBtn.addTarget(self, action:#selector(searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(searchBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PHENOM"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: 64+30)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        theTableView.frame = CGRectMake(0, 64+60, view.frame.size.width, view.frame.size.height-20-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .None
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 100))
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).addMomentView != nil) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).removeAddMomentView()
        }
        
    }
    
    func searchBtnAction() {
        
        self.navigationController?.pushViewController(ExploreViewController(), animated: true)
        
        self.isPushed = true
    }
    
    func queryForTimeline() {
        
        // moment/feed?since=this morning&amount=YYY
        
        //let oldDateTime = NSDate(timeIntervalSinceReferenceDate: -86400.0)
        //let hmmm = NSDate().timeIntervalSinceDate(oldDateTime) * 1000
        
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
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    self.momentsData = response.data!
                    
                } else {
                    print("hit here ?: \(response.description)")
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.reloadAction()
                    
                })
        }
        
    }
    
    
    func reloadAction() {
        
        self.theTableView.reloadData()
        self.refreshControl.endRefreshing()
        
        UIView.animateWithDuration(0.38, delay:0.5, options: .CurveEaseInOut, animations: {
            
            var tableFrame = self.theTableView.frame
            tableFrame.origin.y = 64
            self.theTableView.frame = tableFrame
            
            }, completion: { finished in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
                
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
        
        let h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForTimelineMoment(results, ip: indexPath, cellWidth: view.frame.size.width)
        return h

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:MainCell = MainCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        // for moments - measure height
        
        cell.teamBannerView.hidden = true
        cell.teamNameLbl.hidden = true
        cell.teamSportLbl.hidden = true
        cell.teamNumLbl.hidden = true
        cell.teamPositionLbl.hidden = true
        
        cell.timelineImgView.hidden = false
        cell.timelineMusicLbl.hidden = false
        cell.timelineModeLbl.hidden = false
        cell.timelineRankLbl.hidden = true // odd one out
        cell.timelineTinyHeartBtn.hidden = false
        cell.timelineLikeLblBtn.hidden = false
        cell.timelineUserImgView.hidden = false
        cell.timelineUserImgViewBtn.hidden = false
        cell.timelineNameLbl.hidden = false
        cell.timelineTimeLbl.hidden = false
        cell.timelineFollowBtn.hidden = false
        cell.timelineHeadlineLbl.hidden = false
        cell.timelineLikeBtn.hidden = false
        cell.timelineChatBtn.hidden = false
        cell.timelineGearBtn.hidden = false
        cell.timelineMoreBtn.hidden = false
        
        cell.gearImgView.hidden = true
        cell.gearBrandLbl.hidden = true
        cell.gearNameLbl.hidden = true
        cell.gearAddBtn.hidden = true
        
        //
        
        //let mediaHeight = view.frame.size.width+110
        let mediaHeight = view.frame.size.width+110
        
        cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, mediaHeight)
        
        //timelineTinyHeartBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        //timelineLikeLblBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        
        cell.timelineUserImgView.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15, 38, 38)
        cell.timelineUserImgViewBtn.frame = CGRectMake(cell.timelineUserImgView.frame.origin.x, cell.timelineUserImgView.frame.origin.y, cell.timelineUserImgView.frame.size.width, cell.timelineUserImgView.frame.size.height)
        cell.timelineFollowBtn.frame = CGRectMake(cell.cellWidth-65-15, cell.timelineImgView.frame.size.height+15, 65, 38)
        
        //
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        // get mediaHeight
        
        if let id = results[indexPath.row]["imageUrl"].string { //imageUrlCropped
            let fileUrl = NSURL(string: id)
            
            cell.timelineImgView.frame = CGRectMake(0, 0, cell.cellWidth, mediaHeight)
            cell.timelineImgView.setNeedsLayout()
            
            //cell.timelineImgView.hnk_setImageFromURL(fileUrl!)
//            cell.timelineImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
//                                                     success: { image in
//                                                        
//                                                        //print("image here: \(image)")
//                                                        cell.timelineImgView.image = image
//                                                        
//                },
//                                                     failure: { error in
//                                                        
//                                                        if ((error) != nil) {
//                                                            print("error here: \(error)")
//                                                            
//                                                            // collapse, this cell - it was prob deleted - error 402
//                                                            
//                                                        }
//            })
            //print("cell.momentImgView.image: \(cell.momentImgView.image)")
            
            
//            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//                //print("yo")
//                cell.timelineImgView.image = image
//            }
//            
//            cell.timelineImgView.sd_setImageWithURL(fileUrl, completed: block)
            
            cell.timelineImgView.sd_setImageWithURL(fileUrl)
            
            
            
            
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
                cell.timelineMusicLbl.frame = CGRectMake(15, cell.timelineImgView.frame.size.height-20-10-20-15, cell.cellWidth-30, 20)
            } else {
                cell.timelineMusicLbl.frame = CGRectMake(cell.cellWidth-width-20-15, cell.timelineImgView.frame.size.height-20-10-20-15, width+20, 20)
            }
            cell.timelineMusicLbl.text = str
        } else {
            cell.timelineMusicLbl.hidden = true
        }
        
        if let id = results[indexPath.row]["user"]["imageUrlTiny"].string {
            
            let fileUrl = NSURL(string: id)
//            cell.timelineUserImgView.setNeedsLayout()
//            
//            //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
//            cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
//                                                         success: { image in
//                                                            
//                                                            //print("image here: \(image)")
//                                                            cell.timelineUserImgView.image = image
//                                                            
//                },
//                                                         failure: { error in
//                                                            
//                                                            if ((error) != nil) {
//                                                                print("error here: \(error)")
//                                                                
//                                                            }
//            })
            
//            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//                print("yo")
//                cell.timelineUserImgView.image = image
//            }
//            
//            cell.timelineUserImgView.sd_setImageWithURL(fileUrl, completed: block)
            
            cell.timelineUserImgView.sd_setImageWithURL(fileUrl)
            
        }
        
        if let id = results[indexPath.row]["user"]["firstName"].string {
            
            let last = "\(results[indexPath.row]["user"]["lastName"])"
            let str = "\(id) \(last)"
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineNameLbl.font, height: 20)
            cell.timelineNameLbl.frame = CGRect(x: 15+38+15, y: cell.timelineImgView.frame.size.height+15, width: width, height: 19)
            cell.timelineNameLbl.text = str
            
        }
        
//        NSDateFormatter *rfc3339DateFormatter = [[NSDateFormatter alloc] init];
//        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        
//        [rfc3339DateFormatter setLocale:enUSPOSIXLocale];
//        [rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss '+0000'"];
//        [rfc3339DateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        if let id = results[indexPath.row]["createdAt"].string {
            //let strDate = "2015-11-01T00:00:00Z" // "2015-10-06T15:42:34Z"
            
            let dateFormatter = NSDateFormatter()
            //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            // "yyyy-MM-dd HH:mm:ss '+0000'" //
            //dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"  //"yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.dateFromString(id)!
        
            let since = (UIApplication.sharedApplication().delegate as! AppDelegate).timeAgoSinceDate(date, numericDates: false)
            
            var dateStr = ""
            if let ht = results[indexPath.row]["user"]["hometown"].string {
                if (ht == "") {
                    dateStr = "\(since)"
                } else {
                    dateStr = "\(since) - \(ht)"
                }
            } else {
                dateStr = "\(since)"
            }
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(dateStr, font: cell.timelineTimeLbl.font, height: 20)
            cell.timelineTimeLbl.frame = CGRect(x: 15+38+15, y: cell.timelineImgView.frame.size.height+15+19, width: width, height: 19)
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
        cell.timelineHeadlineLbl.frame = CGRectMake(15, cell.timelineImgView.frame.size.height+15+38+15, cell.cellWidth-30, headlineHeight)
        
        
        var btnY = CGFloat()
        if (headlineHeight == 0) {
            btnY = cell.timelineImgView.frame.size.height+15+38+15
        } else {
            btnY = cell.timelineImgView.frame.size.height+15+38+15+cell.timelineHeadlineLbl.frame.size.height+15
        }
        cell.timelineLikeBtn.frame = CGRectMake(15, btnY, 65, 38)
        cell.timelineChatBtn.frame = CGRectMake(15+64+10, btnY, 65, 38)
        cell.timelineGearBtn.frame = CGRectMake(15+64+10+64+10, btnY, 65, 38)
        cell.timelineMoreBtn.frame = CGRectMake(15+64+10+64+10+64+10, btnY, 50, 38)
        
        //            if let id = results[indexPath.row]["commentCount"].number {
        //                let countStr = "\(id) comments"
        //                cell.commentLbl.text = countStr
        //            }
        
        
        let momentId = results[indexPath.row]["id"].string
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(momentId!)) {
            cell.timelineLikeBtn.selected = false
        } else {
            
            if ((UIApplication.sharedApplication().delegate as! AppDelegate).likedMomentId(momentId!)) {
                cell.timelineLikeBtn.selected = true
            } else {
                // check if user likes
                
                if let id = results[indexPath.row]["userLikes"].bool {
                    if (id) {
                        // add it!
                        (UIApplication.sharedApplication().delegate as! AppDelegate).addLikedMomentId(momentId!)
                        cell.timelineLikeBtn.selected = true
                    } else {
                        cell.timelineLikeBtn.selected = false
                    }
                } else {
                    cell.timelineLikeBtn.selected = true
                }
            }
            
        }
        
        
        let uid = results[indexPath.row]["user"]["id"].string
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).followingUserId(uid!)) {
            cell.timelineFollowBtn.hidden = true
        } else {
            // check if following this user
            if let id = results[indexPath.row]["user"]["userFollows"].bool {
                if (id) {
                    // add user!
                    (UIApplication.sharedApplication().delegate as! AppDelegate).followUserId(uid!)
                    cell.timelineFollowBtn.hidden = true
                } else {
                    cell.timelineFollowBtn.selected = false
                    cell.timelineFollowBtn.hidden = false
                }
            } else {
                cell.timelineFollowBtn.hidden = true
            }
        }
        
        
        // buttons
        
        cell.timelineUserImgViewBtn.tag = indexPath.row
        cell.timelineLikeBtn.tag = indexPath.row
        cell.timelineChatBtn.tag = indexPath.row
        cell.timelineGearBtn.tag = indexPath.row
        cell.timelineMoreBtn.tag = indexPath.row
        cell.timelineFollowBtn.tag = indexPath.row
        
        cell.timelineUserImgViewBtn.addTarget(self, action:#selector(timelineUserImgViewBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineLikeBtn.addTarget(self, action:#selector(timelineLikeBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineChatBtn.addTarget(self, action:#selector(timelineChatBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineGearBtn.addTarget(self, action:#selector(timelineGearBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineMoreBtn.addTarget(self, action:#selector(timelineMoreBtnAction), forControlEvents: .TouchUpInside)
        cell.timelineFollowBtn.addTarget(self, action:#selector(timelineFollowBtnAction), forControlEvents: .TouchUpInside)
        
        // taps
        
        cell.timelineSingleTapRecognizer.addTarget(self, action: #selector(timelineSingleTapAction(_:)))
        cell.timelineDoubleTapRecognizer.addTarget(self, action: #selector(timelineDoubleTapAction(_:)))
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (indexPath.row == tableView.indexPathsForVisibleRows?.last?.row) {
            //end of loading
            //print("this section hit: \(indexPath.row)")
            
            let json = JSON(data: momentsData)
            let lastMomentNum = json["results"].count-1
            
            if (indexPath.row == lastMomentNum) {
                
                if (!loadNextPage) {
                    
                    print("load next page")
                    loadNextPage = true
                    
                    self.getNextPage()
                    
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
        print("getNextPage hit")
        
        momentNumber = momentNumber + 20
        
        queryForTimeline()
        
    }
    
    func timelineUserImgViewBtnAction(sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["user"]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserJson = results[sender.tag]["user"] 
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineLikeBtnAction(sender: UIButton) {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        let id = results[sender.tag]["id"].string
        
        if (sender.selected) {
            print("currently liked")
            sender.selected = false
            unlikeAction(id!)
        } else {
            print("currently NOT liked")
            sender.selected = true
            
            if ((UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(id!)) {
                (UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.removeObjectsInArray([id!])
            }
            
            likeAction(id!)
        }
    }
    
    func likeAction(momentId : String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).likedMomentId(momentId)) {
            return
        }

        
        let bearerToken = NSUserDefaults.standardUserDefaults().objectForKey("bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(momentId)/like"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.POST, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    let array = defaults.arrayForKey("likedMomentIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(momentId)) {
                        // in likedMomentIds, do nothing
                    } else {
                        ma.addObject(momentId)
                        let newarray = ma as NSArray
                        defaults.setObject(newarray, forKey: "likedMomentIds")
                        defaults.synchronize()
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("liked")
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
    }
    
    func unlikeAction(momentId : String) {
    
        let bearerToken = NSUserDefaults.standardUserDefaults().objectForKey("bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(momentId)/unlike"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.DELETE, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    let array = NSUserDefaults.standardUserDefaults().arrayForKey("likedMomentIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(momentId)) {
                        // in likedMomentIds, do nothing
                        ma.removeObject(momentId)
                        let newarray = ma as NSArray
                        NSUserDefaults.standardUserDefaults().setObject(newarray, forKey: "likedMomentIds")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    
                    if (!(UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(momentId)) {
                        (UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.addObject(momentId)
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("unliked")
                        self.theTableView.reloadData()
                    })

                    
                }
        }
        
    }
    
    
    func timelineChatBtnAction(sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = ChatViewController()
            vc.passedMomentJson = results[sender.tag]
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }
    
    func timelineGearBtnAction(sender: UIButton) {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["products"].arrayObject {
            print("id: \(id)")
            if (id.count > 0) {
                
                if let momentId = results[sender.tag]["id"].string {
                    
                    let vc = GearListViewController()
                    vc.passedMomentId = momentId
                    navigationController?.pushViewController(vc, animated: true)
                    
                    isPushed = true
                    
                }
            }
        }
    }
    
    func timelineMoreBtnAction(sender: UIButton) {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["id"].string {
            
        }
        
        let alertController = UIAlertController(title:nil, message:nil, preferredStyle:.ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        let reportAction = UIAlertAction(title: "Report", style: .Destructive) { (action) in
            
        }
        let facebookAction = UIAlertAction(title: "Share to Facebook", style: .Default) { (action) in
            
        }
        let twitterAction = UIAlertAction(title: "Tweet", style: .Default) { (action) in
            
        }
        let copyUrlAction = UIAlertAction(title: "Copy Share URL", style: .Default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(reportAction)
        alertController.addAction(facebookAction)
        alertController.addAction(twitterAction)
        alertController.addAction(copyUrlAction)
        self.presentViewController(alertController, animated: true) {
        }
        
    }
    
    func timelineFollowBtnAction(sender : UIButton) {
        
        // follow only
        
        sender.hidden = true
        
        // get height of media
        //
        // get frame of follow btn
        
        let ip = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = self.theTableView.cellForRowAtIndexPath(ip) as! MainCell
        
        let mediaHeight = cell.frame.size.width+110
        
        let followImgView = UIImageView(frame: CGRectMake(self.view.frame.size.width-65-15, mediaHeight+15, 65, 38))
        followImgView.backgroundColor = UIColor.clearColor()
        followImgView.image = UIImage(named: "addedBtnImg.png")
        cell.addSubview(followImgView)
        
        followImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75)
        
        UIView.animateWithDuration(0.18, animations: {
            followImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.04, 1.04)
            }, completion: { finished in
                if (finished){
                    UIView.animateWithDuration(0.16, animations: {
                        followImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                        }, completion: { finished in
                            if (finished) {
                                
                                let delay = 0.3 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue()) {
                                    
                                    UIView.animateWithDuration(0.18, animations: {
                                        followImgView.alpha = 0.0
                                        }, completion: { finished in
                                            if (finished) {
                                                followImgView.removeFromSuperview()
                                                
                                                //
                                                self.followAction(sender)
                                                //
                                                
                                            }
                                    })
                                }
                            }
                    })
                }
        })
    }
    
    func followAction(sender : UIButton) {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        let uid = results[sender.tag]["user"]["id"].string
        
        // follow
        
        let bearerToken = NSUserDefaults.standardUserDefaults().objectForKey("bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(uid!)/follow"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.POST, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    let array = NSUserDefaults.standardUserDefaults().arrayForKey("followingUserIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(uid!)) {
                        // in followingUserIds, do nothing
                    } else {
                        let followingCount = NSUserDefaults.standardUserDefaults().objectForKey("followingCount") as! Int
                        let newcount = followingCount+1
                        
                        ma.addObject(uid!)
                        let newarray = ma as NSArray
                        NSUserDefaults.standardUserDefaults().setObject(newarray, forKey: "followingUserIds")
                        NSUserDefaults.standardUserDefaults().setObject(newcount, forKey: "followingCount")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("followed")
                        self.theTableView.reloadData()
                    })
                    
                    
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
                    
//                    let json = JSON(data: momentsData)
//                    
//                    let results = json["results"]
//                    print(results)

                    
                }
            }
        }
    }
    
    
    func timelineDoubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    //print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    let json = JSON(data: momentsData)
                    let results = json["results"]
                    let id = results[tappedIndexPath.row]["id"].string
                    
                    let cell = tappedCell as! MainCell
                    cell.timelineLikeBtn.selected = true
                    
                    likeHeartAnimation(tappedCell, momentId: id!)
                    
                    
                }
            }
        }
    }
    
    func likeHeartAnimation(cell : UITableViewCell, momentId : String) {
        
        // get height of media
        
        let mediaHeight = cell.frame.size.width+110
        
        let heartImgView = UIImageView(frame: CGRectMake(cell.frame.size.width/2-45, mediaHeight/2-45, 90, 90))
        heartImgView.backgroundColor = UIColor.clearColor()
        heartImgView.image = UIImage(named: "heart.png")
        cell.addSubview(heartImgView)
        
        heartImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75)
        
        UIView.animateWithDuration(0.18, animations: {
            heartImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.04, 1.04)
            }, completion: { finished in
                if (finished){
                    UIView.animateWithDuration(0.16, animations: {
                        heartImgView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
                        }, completion: { finished in
                            if (finished) {
                                
                                let delay = 0.3 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue()) {
                                    
                                    UIView.animateWithDuration(0.18, animations: {
                                        heartImgView.alpha = 0.0
                                        }, completion: { finished in
                                            if (finished) {
                                                heartImgView.removeFromSuperview()
                                                
                                                //
                                                self.likeAction(momentId)
                                                //
                                                
                                            }
                                    })
                                }
                            }
                    })
                }
        })
        
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
    

}
