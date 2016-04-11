//
//  PopularMomentsViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/7/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class PopularMomentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var momentsData = NSData()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!

    var pageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside) 
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "POPULAR"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        theTableView.separatorColor = UIColor(red:238/255, green:238/255, blue:238/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), forControlEvents: UIControlEvents.ValueChanged)
        theTableView.addSubview(refreshControl)
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .Right
        view.addGestureRecognizer(swipeBack)


    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func refreshControlAction() {
        
        
    }
    
    
    func queryForPopular() {
        
        // get bearer token
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/discover/moment/featured?pageNumber=\(pageNumber)") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
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
                        
                        if (self.pageNumber > 1) {
                            
                            print("add results to current nsdata")
                            
                            // momentsData =
                            
                            
                            
                        } else {
                            
                            self.momentsData = dataFromString
                            
                        }
                        
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
        
        
    }
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let moments = JSON(data: momentsData)
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
        
        let moments = JSON(data: momentsData)
        
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
        
        headerView.userBtn!.tag = section
        headerView.userBtn!.addTarget(self, action:#selector(userBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        
        
        //        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
        //        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        //
        //        aView.addSubview(aLbl)
        //        headerView.timeLbl?.text = "TIME LBL HERE"
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:TimelineCell = TimelineCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        let moments = JSON(data: momentsData)
        
        let results = moments["results"]
        
        if let id = results[indexPath.section]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.momentImgView.frame = CGRectMake(0, 0, cell.cellWidth, cell.cellWidth)
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
        
        if let id = results[indexPath.section]["likesCount"].number {
            let countStr = "\(id) likes"
            cell.likesLbl.text = countStr
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
            cell.modeLbl.frame = CGRectMake(15, cell.cellWidth-10-20, width+20, 20)
            cell.modeLbl.text = str
        }
        
        if let id = results[indexPath.section]["song"]["artistName"].string {
            cell.musicLbl.hidden = false
            let str = "\(id) | \(results[indexPath.section]["song"]["trackName"])"
            let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView(str, font: cell.musicLbl.font, height: cell.musicLbl.frame.size.height)
            cell.musicLbl.frame = CGRectMake(15, cell.cellWidth-10-20-10-20, width+20, 20)
            cell.musicLbl.text = str
        } else {
            cell.musicLbl.hidden = true
        }
        
        // button actions
        
        cell.commentBtn.tag = indexPath.section
        cell.gearBtn.tag = indexPath.section
        cell.headerBtn.tag = indexPath.section
        
        cell.commentBtn.addTarget(self, action:#selector(commentBtnAction), forControlEvents: .TouchUpInside)
        cell.gearBtn.addTarget(self, action:#selector(gearBtnAction), forControlEvents: .TouchUpInside)
        cell.headerBtn.addTarget(self, action:#selector(commentBtnAction), forControlEvents: .TouchUpInside)
        
        // handle taps
        
        cell.singleTapRecognizer.addTarget(self, action: #selector(singleTapAction(_:)))
        cell.doubleTapRecognizer.addTarget(self, action: #selector(doubleTapAction(_:)))
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        //isPushed = false
        
        //let vc  = DetailViewController()
        //vc.isGear = false
        //navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        print("y: \(theTableView.contentOffset.y)")
        if (theTableView.contentOffset.y != 0) {

        }
        
        
    }
    
    func getNextPage() {
        
        pageNumber = pageNumber + 1
        
        queryForPopular()
        
    }
    
    func userBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: momentsData)
        
        //        print(moments)
        
        let test = moments["results"]
        
        if let id = test[sender.tag]["user"]["id"].string {
            
            // push to user
            let vc = ProfileViewController()
            
            //vc.userId = id
            
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func commentBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: momentsData)
        let results = moments["results"]
        
        if let id = results[sender.tag]["id"].string {
            print("id: \(id)")
            let vc = CommentsViewController()
            vc.passedMomentId = id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func gearBtnAction(sender: UIButton!){
        print(sender.tag)
        
        let moments = JSON(data: momentsData)
        let moment = moments["results"]
        
        if let id = moment[sender.tag]["id"].string {
            let vc = GearDetailViewController()

            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func singleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    print("single tapped section: \(tappedIndexPath.section), \(tappedCell)")
                    
                    // play video or music !!!
                    
                    
                    
                }
            }
        }
    }
    
    
    func doubleTapAction(sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            let tappedLocation = sender.locationInView(theTableView)
            if let tappedIndexPath = theTableView.indexPathForRowAtPoint(tappedLocation) {
                if let tappedCell = theTableView.cellForRowAtIndexPath(tappedIndexPath) {
                    
                    //likeMoment()
                    
                    print("double tapped section: \(tappedIndexPath.section), \(tappedCell)")
                    
                    
                }
            }
        }
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
