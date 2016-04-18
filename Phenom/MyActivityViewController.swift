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
        
        let searchBtn = UIButton(type: UIButtonType.Custom)
        searchBtn.frame = CGRectMake(15, 20, 44, 44)
        searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), forState: UIControlState.Normal)
        //searchBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.clearColor()
        searchBtn.addTarget(self, action:#selector(searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(searchBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "NOTIFICATIONS"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: 64+30)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        theTableView.frame = CGRectMake(0, 64+60, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(queryForMyActivity), forControlEvents: UIControlEvents.ValueChanged)
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
    
    
    func searchBtnAction() {
        
        self.navigationController?.pushViewController(DiscoverViewController(), animated: true)
        
        self.isPushed = true
    }
    
    func queryForMyActivity() {
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/notification"
        let date = NSDate().timeIntervalSince1970 * 1000
        let params = "since=\(date)&limit=30"
        let type = "GET"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sendRequest(url, parameters: params, type: type, completionHandler:  { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        return
                    }
                    
                    let results = json["results"]
                    print("results: \(results)")
                    
                    self.myActivityData = dataFromString
                    
                    if (results.count > 0) {
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.reloadAction()
                            
                        })
                        
                    } else {
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showEmptyTimeline()
                            
                        })
                    }
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                    self.refreshControl.endRefreshing()
                }
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    func reloadAction() {
        
        self.theTableView.scrollEnabled = true
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, 0, 0))
        self.theTableView.tableHeaderView!.userInteractionEnabled = true
        
        self.theTableView.reloadData()
        self.refreshControl.endRefreshing()
        
        UIView.animateWithDuration(0.38, delay:0.5, options: .CurveEaseInOut, animations: {
            
            var tableFrame = self.theTableView.frame
            tableFrame.origin.y = 64
            self.theTableView.frame = tableFrame
            
            }, completion: { finished in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
        })
        
    }
    
    func showEmptyTimeline() {
        
        // show empty timeline btn
        self.theTableView.scrollEnabled = false
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, self.theTableView.frame.size.height))
        self.theTableView.tableHeaderView!.userInteractionEnabled = true
        let emptyTimelineBtn = UIButton(type: UIButtonType.Custom)
        emptyTimelineBtn.frame = CGRectMake(self.theTableView.tableHeaderView!.frame.size.width/2-125, self.theTableView.tableHeaderView!.frame.size.height/2-50, 250, 100)
        emptyTimelineBtn.backgroundColor = UIColor.clearColor()
        emptyTimelineBtn.titleLabel?.numberOfLines = 2
        emptyTimelineBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 18)
        emptyTimelineBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        emptyTimelineBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        emptyTimelineBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        emptyTimelineBtn.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Normal)
        emptyTimelineBtn.setTitleColor(UIColor(red:197/255, green:175/255, blue:104/255, alpha:1), forState: UIControlState.Highlighted)
        emptyTimelineBtn.setTitle("Phenom is more fun with friends! Tap to invite.", forState: UIControlState.Normal)
        emptyTimelineBtn.addTarget(self, action:#selector(emptyTimelineBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.theTableView.tableHeaderView!.addSubview(emptyTimelineBtn)
        
        self.theTableView.reloadData()
    }
    
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let json = JSON(data: myActivityData)
        return json["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return 64
        
        let json = JSON(data: myActivityData)
        let results = json["results"]
        
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
        
        if let id = results[indexPath.row]["source"]["imageUrlTiny"].string {
            let fileUrl = NSURL(string: id)
            
            cell.userImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
            cell.userImgView.setNeedsLayout()
            
            cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
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
        
        
        // notificationType
        
        if let id = results[indexPath.row]["notificationType"].number {
            if (id == 0) {
                // like
                cell.momentImgView.hidden = false
                cell.momentBtn.hidden = false
                cell.followBtn.hidden = true
                
                // show my moment
                if let id = results[indexPath.row]["additionalData"]["imageUrlTiny"].string {
                    let fileUrl = NSURL(string: id)
                    
                    cell.momentImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
                    cell.momentImgView.setNeedsLayout()
                    
                    cell.momentImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                        success: { image in
                            
                            //print("image here: \(image)")
                            cell.momentImgView.image = image
                            
                        },
                        failure: { error in
                            
                            if ((error) != nil) {
                                print("error here: \(error)")
                            }
                    })
                }
                
            } else if (id == 1) {
                // follow
                cell.momentImgView.hidden = true
                cell.momentBtn.hidden = true
                cell.followBtn.hidden = false
                
                
                if let id = results[indexPath.row]["userFollows"].bool {
                    if (id) {
                        cell.followBtn.selected = true
                    } else {
                        cell.followBtn.selected = false
                    }
                } else {
                    cell.followBtn.selected = true
                    cell.followBtn.hidden = true
                }
                
            } else if (id == 2) {
                // commented on your moment
                
                cell.momentImgView.hidden = false
                cell.momentBtn.hidden = false
                cell.followBtn.hidden = true
                
                // show my moment
                if let id = results[indexPath.row]["additionalData"]["momentId"].string {
                    
                    
                    // GET "imageUrlTiny" !!!
                    cell.momentImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
                    
                }
                
            } else if (id == 3) {
                // mentioned in a comment
                
                cell.momentImgView.hidden = false
                cell.momentBtn.hidden = false
                cell.followBtn.hidden = true
                
                // show my moment
                if let id = results[indexPath.row]["additionalData"]["momentId"].string {
                    
                    
                    // GET "imageUrlTiny" !!!
                    cell.momentImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
                    
                }
                
                
            } else if (id == 4) {
                // tagged in a moment - mentioned in headline
                
                cell.momentImgView.hidden = false
                cell.momentBtn.hidden = false
                cell.followBtn.hidden = true
                
                // show my moment
                if let id = results[indexPath.row]["additionalData"]["momentId"].string {
                    
                    
                    // GET "imageUrlTiny" !!!
                    cell.momentImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
                    
                }
                
                
            } else {
                // something is
            }
            
        } else {
            // something is wrong
            
        }
        
        // button actions
        
        cell.userBtn.tag = indexPath.row
        cell.momentBtn.tag = indexPath.row
        cell.followBtn.tag = indexPath.row
        
        cell.userBtn.addTarget(self, action:#selector(userBtnAction), forControlEvents: .TouchUpInside)
        cell.momentBtn.addTarget(self, action:#selector(momentBtnAction), forControlEvents: .TouchUpInside)
        cell.followBtn.addTarget(self, action:#selector(followBtnAction), forControlEvents: .TouchUpInside)
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) 
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        isPushed = true
        
        //let vc = DetailViewController()
        //vc.isGear = true
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func userBtnAction(sender: UIButton) {
        print(sender.tag)
        
        let json = JSON(data: myActivityData)

        let results = json["results"]
        
        print("source: \(results[sender.tag]["source"])")
        
        if let _ = results[sender.tag]["source"]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserData = results[sender.tag]["source"]
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }

    }

    
    func momentBtnAction(sender: UIButton) {
        print(sender.tag)
        
        let moments = JSON(data: myActivityData)
        let results = moments["results"]
        
        print("moment model: \(results)")
        
        if let id = results[sender.tag]["additionalData"]["momentId"].string {

            let vc = SingleMomentViewController()
            vc.passedMomentId = id
            navigationController?.pushViewController(vc, animated: true)
            
            isPushed = true
        }
    }

    func followBtnAction(sender: UIButton) {
        print(sender.tag)
     
        
        
    }
    

}
