//
//  PeopleListViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/7/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class PeopleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var passedTitle = ""
    var passedUserId = ""
    
    var peopleData = NSData()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(15, 20, 44, 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.clearColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = passedTitle
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(PeopleCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .Right
        view.addGestureRecognizer(swipeBack)
        
        //
        
        queryForPeople()

        //
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    

    func queryForPeople() {
        
        // user/following
                
        var url = ""
        let date = NSDate().timeIntervalSince1970 * 1000
        
        if (passedTitle == "FANS") {
            
            url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(passedUserId)/followers?since=\(date)&limit=20"
            
        } else if (passedTitle == "FOLLOWING") {
            
            url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(passedUserId)/following?since=\(date)&limit=20"
            
        } else {
            print("something is wrong")
            return
        }
        
        
        
        let bearerToken = NSUserDefaults.standardUserDefaults().objectForKey("bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)"
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
                    
                    
                    self.peopleData = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                        
                    })
                    
                }
        }
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let json = JSON(data: peopleData)
        return json["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 15+44+15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:PeopleCell = PeopleCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        
        if let person = results[indexPath.row]["username"].string {
            cell.usernameLbl.text = person
        }
        
        if let name = results[indexPath.row]["firstName"].string {
            cell.nameLbl.text = ("\(name) \(results[indexPath.row]["lastName"])")
        }
        
        if let id = results[indexPath.row]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.userImgView.frame = CGRectMake(15, 15, 44, 44)
            cell.userImgView.setNeedsLayout()
            cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                                                     success: { image in
                                                        
                                                        //print("image here: \(image)")
                                                        cell.userImgView.image = image
                                                        
                },
                                                     failure: { error in
                                                        
                                                        if ((error) != nil) {
                                                            print("error here: \(error)")
                                                            
                                                            // collapse, this cell - it was prob deleted - error 402
                                                            
                                                        }
            })
        }
        
        if let id = results[indexPath.row]["id"].string {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let currentUserId = defaults.objectForKey("userId") as! String
            if (id == currentUserId) {
                
                cell.followBtn.selected = true
                cell.followBtn.hidden = true
                
            } else {
                
                if let id = results[indexPath.row]["userFollows"].bool {
                    if (id) {
                        cell.followBtn.selected = true
                        cell.followBtn.hidden = true
                    } else {
                        cell.followBtn.selected = false
                        cell.followBtn.hidden = false
                    }
                } else {
                    cell.followBtn.selected = true
                    cell.followBtn.hidden = true
                }
                
            }
            
        }
        
        
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action:#selector(followBtnAction), forControlEvents: .TouchUpInside)
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = .None
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        
        if let _ = results[indexPath.row]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserJson = results[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    func followBtnAction(sender : UIButton) {
        
        // follow only
        
        sender.hidden = true
        
        // get frame of follow btn
        
        let ip = NSIndexPath(forItem: sender.tag, inSection: 0)
        let cell = self.theTableView.cellForRowAtIndexPath(ip) as! PeopleCell
        
        //let mediaHeight = cell.frame.size.width+110
        
        let followImgView = UIImageView(frame: CGRectMake(self.view.frame.size.width-65-15, 18, 65, 38))
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
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        let uid = results[sender.tag]["id"].string
        
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
    

}
