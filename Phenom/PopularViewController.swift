//
//  PopularViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/16/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import Haneke

class PopularViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var momentsData = Data()
    
    var navBarView = UIView()
    
    let activityIndicator = UIActivityIndicatorView()
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var pageNumber = 1
    var loadNextPage: Bool = false
    var playingMedia: Bool = false
    
    var isPushed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
     
        let searchBtn = UIButton(type: UIButtonType.custom)
        searchBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), for: UIControlState())
        //searchBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.clear
        searchBtn.addTarget(self, action:#selector(searchBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(searchBtn)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "POPULAR" //🔥
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: 64+30)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        theTableView.frame = CGRect(x: 0, y: 64+60, width: view.frame.size.width, height: view.frame.size.height-20-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .none
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(queryForTimeline), for: UIControlEvents.valueChanged)
        theTableView.addSubview(refreshControl)
        
        //theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, theTableView.frame.size.width/2))
        //theTableView.tableHeaderView?.backgroundColor = UIColor.lightGrayColor()
        
        queryForTimeline()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isPushed = false
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ((UIApplication.shared.delegate as! AppDelegate).addMomentView != nil) {
            (UIApplication.shared.delegate as! AppDelegate).removeAddMomentView()
        }
        
    }
    
    func searchBtnAction() {
        
        self.navigationController?.pushViewController(ExploreViewController(), animated: true)
        
        isPushed = true
    }
    
    
    func queryForTimeline() {
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/discover/moment/featured?pageNumber=\(pageNumber)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    if (self.pageNumber > 1) {
                        
                        print("add results to current nsdata")
                        // momentsData =
                        
                    } else {
                        
                        self.momentsData = response.data!
                        
                    }
                    
                    // done, reload tableView
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.reloadAction()
                        
                    })
                }
        }
        
    }

    func reloadAction() {
        
        self.theTableView.reloadData()
        self.refreshControl.endRefreshing()
        
        UIView.animate(withDuration: 0.38, delay:0.5, options: UIViewAnimationOptions(), animations: {
            
            var tableFrame = self.theTableView.frame
            tableFrame.origin.y = 64
            self.theTableView.frame = tableFrame
            
            }, completion: { finished in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
        })
        
    }
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let json = JSON(data: momentsData)
        return json["results"].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        let h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForTimelineMoment(results, ip: indexPath, cellWidth: view.frame.size.width)
        return h
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MainCell = MainCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        // for moments - measure height
        
        cell.teamBannerView.isHidden = true
        cell.teamNameLbl.isHidden = true
        cell.teamSportLbl.isHidden = true
        cell.teamNumLbl.isHidden = true
        cell.teamPositionLbl.isHidden = true
        
        cell.timelineImgView.isHidden = false
        cell.timelineMusicLbl.isHidden = false
        cell.timelineModeLbl.isHidden = false
        cell.timelineRankLbl.isHidden = false
        cell.timelineTinyHeartBtn.isHidden = false
        cell.timelineLikeLblBtn.isHidden = false
        cell.timelineUserImgView.isHidden = false
        cell.timelineUserImgViewBtn.isHidden = false
        cell.timelineNameLbl.isHidden = false
        cell.timelineTimeLbl.isHidden = false
        cell.timelineFollowBtn.isHidden = false
        cell.timelineHeadlineLbl.isHidden = false
        cell.timelineLikeBtn.isHidden = false
        cell.timelineChatBtn.isHidden = false
        cell.timelineGearBtn.isHidden = false
        cell.timelineMoreBtn.isHidden = false
        
        cell.gearImgView.isHidden = true
        cell.gearBrandLbl.isHidden = true
        cell.gearNameLbl.isHidden = true
        cell.gearAddBtn.isHidden = true
        
        //
        
        let mediaHeight = view.frame.size.width+110
        
        cell.timelineImgView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: mediaHeight)
        
        //timelineTinyHeartBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        //timelineLikeLblBtn.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        
        cell.timelineUserImgView.frame = CGRect(x: 15, y: cell.timelineImgView.frame.size.height+15, width: 38, height: 38)
        cell.timelineUserImgViewBtn.frame = CGRect(x: cell.timelineUserImgView.frame.origin.x, y: cell.timelineUserImgView.frame.origin.y, width: cell.timelineUserImgView.frame.size.width, height: cell.timelineUserImgView.frame.size.height)
        cell.timelineFollowBtn.frame = CGRect(x: cell.cellWidth-65-15, y: cell.timelineImgView.frame.size.height+15, width: 65, height: 38)
        
        //
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        // get mediaHeight
        
        if let id = results[indexPath.row]["imageUrl"].string { //imageUrlCropped
            let fileUrl = URL(string: id)
            
            cell.timelineImgView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: mediaHeight)
            cell.timelineImgView.setNeedsLayout()
            
            //cell.timelineImgView.hnk_setImageFromURL(fileUrl!)
            cell.timelineImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
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
        
        cell.timelineRankLbl.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        cell.timelineRankLbl.text = "#\(indexPath.row+1)"
        
        
        if let id = results[indexPath.row]["mode"].number {
            var str = ""
            if (id == 0) {
                str = "TRAINING"
            } else if (id == 1) {
                str = "GAMING"
            } else {
                str = "STYLING"
            }
            let width = (UIApplication.shared.delegate as! AppDelegate).widthForView(str, font: cell.timelineModeLbl.font, height: cell.timelineModeLbl.frame.size.height)
            if (width > cell.cellWidth-30) {
                cell.timelineModeLbl.frame = CGRect(x: cell.cellWidth-width-20-15, y: cell.timelineImgView.frame.size.height-20-15, width: cell.cellWidth-30, height: 20)
            } else {
                cell.timelineModeLbl.frame = CGRect(x: cell.cellWidth-width-20-15, y: cell.timelineImgView.frame.size.height-20-15, width: width+20, height: 20)
            }
            cell.timelineModeLbl.text = str
        }
        
        if let id = results[indexPath.row]["song"]["artistName"].string {
            cell.timelineMusicLbl.isHidden = false
            
            let str = "\(id) | \(results[indexPath.row]["song"]["trackName"])"
            
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.timelineMusicLbl.font, height: cell.timelineMusicLbl.frame.size.height)
            
            if (width > cell.cellWidth-30) {
                cell.timelineMusicLbl.frame = CGRect(x: 15, y: cell.timelineImgView.frame.size.height-20-10-20-15, width: cell.cellWidth-30, height: 20)
            } else {
                cell.timelineMusicLbl.frame = CGRect(x: cell.cellWidth-width-20-15, y: cell.timelineImgView.frame.size.height-20-10-20-15, width: width+20, height: 20)
            }
            cell.timelineMusicLbl.text = str
        } else {
            cell.timelineMusicLbl.isHidden = true
        }
        
        
        if let id = results[indexPath.row]["user"]["imageUrlTiny"].string {
            
            let fileUrl = URL(string: id)
            cell.timelineUserImgView.setNeedsLayout()
            
            //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
            cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
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
            cell.timelineNameLbl.frame = CGRect(x: 15+38+15, y: cell.timelineImgView.frame.size.height+15, width: width, height: 19)
            cell.timelineNameLbl.text = str
            
        }
        
        if let id = results[indexPath.row]["createdAt"].string {
            //let strDate = "2015-11-01T00:00:00Z" // "2015-10-06T15:42:34Z"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"  //"yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.dateFromString(id)!
            let since = (UIApplication.sharedApplication().delegate as! AppDelegate).timeAgoSinceDate(date, numericDates: true)
            
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
            let width = (UIApplication.shared.delegate as! AppDelegate).widthForView(dateStr, font: cell.timelineTimeLbl.font, height: 20)
            cell.timelineTimeLbl.frame = CGRect(x: 15+38+15, y: cell.timelineImgView.frame.size.height+15+19, width: width, height: 19)
            cell.timelineTimeLbl.text = dateStr
        }
        
        if let id = results[indexPath.row]["likesCount"].number {
            let str = "\(id) likes"
            cell.timelineLikeLblBtn.titleLabel?.text = str
            
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: (cell.timelineLikeLblBtn.titleLabel?.font)!, height: (cell.timelineLikeLblBtn.titleLabel?.frame.size.height)!)
            cell.timelineLikeLblBtn.frame = CGRect(x: 15, y: cell.cellWidth+50+3, width: 22+5+width, height: (cell.timelineLikeLblBtn.titleLabel?.frame.size.height)!)
        }
        
        var headlineHeight = CGFloat()
        if let id = results[indexPath.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(CharacterSet.whitespaceCharacterSet())
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
        cell.timelineHeadlineLbl.frame = CGRect(x: 15, y: cell.timelineImgView.frame.size.height+15+38+15, width: cell.cellWidth-30, height: headlineHeight)
        
        
        var btnY = CGFloat()
        if (headlineHeight == 0) {
            btnY = cell.timelineImgView.frame.size.height+15+38+15
        } else {
            btnY = cell.timelineImgView.frame.size.height+15+38+15+cell.timelineHeadlineLbl.frame.size.height+15
        }
        cell.timelineLikeBtn.frame = CGRect(x: 15, y: btnY, width: 65, height: 38)
        cell.timelineChatBtn.frame = CGRect(x: 15+64+10, y: btnY, width: 65, height: 38)
        cell.timelineGearBtn.frame = CGRect(x: 15+64+10+64+10, y: btnY, width: 65, height: 38)
        cell.timelineMoreBtn.frame = CGRect(x: 15+64+10+64+10+64+10, y: btnY, width: 50, height: 38)
        
        //            if let id = results[indexPath.row]["commentCount"].number {
        //                let countStr = "\(id) comments"
        //                cell.commentLbl.text = countStr
        //            }
        
        
        let momentId = results[indexPath.row]["id"].string
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(momentId!)) {
            cell.timelineLikeBtn.isSelected = false
        } else {
            
            if ((UIApplication.sharedApplication().delegate as! AppDelegate).likedMomentId(momentId!)) {
                cell.timelineLikeBtn.isSelected = true
            } else {
                // check if user likes
                
                if let id = results[indexPath.row]["userLikes"].bool {
                    if (id) {
                        // add it!
                        (UIApplication.sharedApplication().delegate as! AppDelegate).addLikedMomentId(momentId!)
                        cell.timelineLikeBtn.isSelected = true
                    } else {
                        cell.timelineLikeBtn.isSelected = false
                    }
                } else {
                    cell.timelineLikeBtn.isSelected = true
                }
            }
            
        }
        
        
        let uid = results[indexPath.row]["user"]["id"].string
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).followingUserId(uid!)) {
            cell.timelineFollowBtn.isHidden = true
        } else {
            // check if following this user
            if let id = results[indexPath.row]["user"]["userFollows"].bool {
                if (id) {
                    // add user!
                    (UIApplication.sharedApplication().delegate as! AppDelegate).followUserId(uid!)
                    cell.timelineFollowBtn.isHidden = true
                } else {
                    cell.timelineFollowBtn.isSelected = false
                    cell.timelineFollowBtn.isHidden = false
                }
            } else {
                cell.timelineFollowBtn.isHidden = true
            }
        }
        
        
        // buttons
        
        cell.timelineUserImgViewBtn.tag = indexPath.row
        cell.timelineLikeBtn.tag = indexPath.row
        cell.timelineChatBtn.tag = indexPath.row
        cell.timelineGearBtn.tag = indexPath.row
        cell.timelineMoreBtn.tag = indexPath.row
        cell.timelineFollowBtn.tag = indexPath.row
        
        cell.timelineUserImgViewBtn.addTarget(self, action:#selector(timelineUserImgViewBtnAction), for: .touchUpInside)
        cell.timelineLikeBtn.addTarget(self, action:#selector(timelineLikeBtnAction), for: .touchUpInside)
        cell.timelineChatBtn.addTarget(self, action:#selector(timelineChatBtnAction), for: .touchUpInside)
        cell.timelineGearBtn.addTarget(self, action:#selector(timelineGearBtnAction), for: .touchUpInside)
        cell.timelineMoreBtn.addTarget(self, action:#selector(timelineMoreBtnAction), for: .touchUpInside)
        cell.timelineFollowBtn.addTarget(self, action:#selector(timelineFollowBtnAction), for: .touchUpInside)
        
        // taps
        
        cell.timelineSingleTapRecognizer.addTarget(self, action: #selector(timelineSingleTapAction(_:)))
        cell.timelineDoubleTapRecognizer.addTarget(self, action: #selector(timelineDoubleTapAction(_:)))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        //isPushed = false
        
        //let vc  = DetailViewController()
        //vc.isGear = false
        //navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    func getNextPage() {
        
        pageNumber = pageNumber + 1
        
        queryForTimeline()
        
    }
    
    func timelineUserImgViewBtnAction(_ sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["user"]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserJson = results[sender.tag]["user"] 
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func timelineLikeBtnAction(_ sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        let id = results[sender.tag]["id"].string
        
        if (sender.isSelected) {
            print("currently liked")
            sender.isSelected = false
            unlikeAction(id!)
        } else {
            print("currently NOT liked")
            sender.isSelected = true
            
            if ((UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.containsObject(id!)) {
                (UIApplication.sharedApplication().delegate as! AppDelegate).tempUnLikedIdsArray.removeObjectsInArray([id!])
            }
            
            likeAction(id!)
        }
    }
    
    func likeAction(_ momentId : String) {
        
        if ((UIApplication.shared.delegate as! AppDelegate).likedMomentId(momentId)) {
            return
        }
        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment/\(momentId)/like"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
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
                    
                    let array = NSUserDefaults.standardUserDefaults().arrayForKey("likedMomentIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(momentId)) {
                        // in likedMomentIds, do nothing
                    } else {
                        ma.addObject(momentId)
                        let newarray = ma as NSArray
                        NSUserDefaults.standardUserDefaults().setObject(newarray, forKey: "likedMomentIds")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("liked")
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
    }
    
    func unlikeAction(_ momentId : String) {
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment/\(momentId)/unlike"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
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
                    
                    //
                    
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
    
    
    func timelineChatBtnAction(_ sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = ChatViewController()
            vc.passedMomentJson = results[sender.tag] 
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func timelineGearBtnAction(_ sender: UIButton) {
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["products"].arrayObject {
            print("id: \(id)")
            if (id.count > 0) {
                
                if let momentId = results[sender.tag]["id"].string {
                    
                    let vc = GearListViewController()
                    vc.passedMomentId = momentId
                    navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            }
        }
    }
    
    func timelineMoreBtnAction(_ sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let _ = results[sender.tag]["id"].string {
            
        }
        
        let alertController = UIAlertController(title:nil, message:nil, preferredStyle:.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (action) in
            
        }
        let facebookAction = UIAlertAction(title: "Share to Facebook", style: .default) { (action) in
            
        }
        let twitterAction = UIAlertAction(title: "Tweet", style: .default) { (action) in
            
        }
        let copyUrlAction = UIAlertAction(title: "Copy Share URL", style: .default) { (action) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(reportAction)
        alertController.addAction(facebookAction)
        alertController.addAction(twitterAction)
        alertController.addAction(copyUrlAction)
        self.present(alertController, animated: true) {
        }
        
    }
    
    func timelineFollowBtnAction(_ sender : UIButton) {
        
        // follow only
        
        sender.isHidden = true
        
        // get height of media
        //
        // get frame of follow btn
        //
        // CGRectMake(cell.cellWidth-50-15, cell.timelineImgView.frame.size.height+15, 50, 50)
        
        let ip = IndexPath(item: sender.tag, section: 0)
        let cell = self.theTableView.cellForRow(at: ip) as! MainCell
        
        let mediaHeight = cell.frame.size.width+110
        
        let followImgView = UIImageView(frame: CGRect(x: self.view.frame.size.width-50-15, y: mediaHeight+15, width: 50, height: 50))
        followImgView.backgroundColor = UIColor.clear
        followImgView.image = UIImage(named: "addedBtnImg.png")
        cell.addSubview(followImgView)
        
        followImgView.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.18, animations: {
            followImgView.transform = CGAffineTransform.identity.scaledBy(x: 1.04, y: 1.04)
            }, completion: { finished in
                if (finished){
                    UIView.animate(withDuration: 0.16, animations: {
                        followImgView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                        }, completion: { finished in
                            if (finished) {
                                
                                let delay = 0.3 * Double(NSEC_PER_SEC)
                                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: time) {
                                    
                                    UIView.animate(withDuration: 0.18, animations: {
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
    
    func followAction(_ sender : UIButton) {
        
        // follow only
        
        sender.isHidden = true
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        let uid = results[sender.tag]["user"]["id"].string
        
        // follow
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(uid!)/follow"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
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
    
    
    func timelineSingleTapAction(_ sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.ended {
            let tappedLocation = sender.location(in: theTableView)
            if let tappedIndexPath = theTableView.indexPathForRow(at: tappedLocation) {
                if let tappedCell = theTableView.cellForRow(at: tappedIndexPath) {
                    
                    print("single tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    // play video or music !!!
                    //
                    //                    let json = JSON(data: momentsData)
                    //
                    //                    let results = json["results"]
                    //                    print(results)
                    
                }
            }
        }
    }
    
    
    func timelineDoubleTapAction(_ sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.ended {
            let tappedLocation = sender.location(in: theTableView)
            if let tappedIndexPath = theTableView.indexPathForRow(at: tappedLocation) {
                if let tappedCell = theTableView.cellForRow(at: tappedIndexPath) {
                    
                    //print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    let json = JSON(data: momentsData)
                    let results = json["results"]
                    let id = results[tappedIndexPath.row]["id"].string
                    
                    let cell = tappedCell as! MainCell
                    cell.timelineLikeBtn.isSelected = true
                    
                    likeHeartAnimation(tappedCell, momentId: id!)
                    
                    
                }
            }
        }
    }
    
    func likeHeartAnimation(_ cell : UITableViewCell, momentId : String) {
        
        // get height of media
        
        let mediaHeight = cell.frame.size.width+110
        
        let heartImgView = UIImageView(frame: CGRect(x: cell.frame.size.width/2-45, y: mediaHeight/2-45, width: 90, height: 90))
        heartImgView.backgroundColor = UIColor.clear
        heartImgView.image = UIImage(named: "heart.png")
        cell.addSubview(heartImgView)
        
        heartImgView.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.18, animations: {
            heartImgView.transform = CGAffineTransform.identity.scaledBy(x: 1.04, y: 1.04)
            }, completion: { finished in
                if (finished){
                    UIView.animate(withDuration: 0.16, animations: {
                        heartImgView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                        }, completion: { finished in
                            if (finished) {
                                
                                let delay = 0.3 * Double(NSEC_PER_SEC)
                                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: time) {
                                    
                                    UIView.animate(withDuration: 0.18, animations: {
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
    

   

}
