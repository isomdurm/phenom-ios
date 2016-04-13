//
//  PeopleListViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/7/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
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
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
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
        
        let date = NSDate().timeIntervalSince1970 * 1000
        
        var queryUrl = ""
        
        if (passedTitle == "FANS") {
            
            queryUrl = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(passedUserId)/followers?since=\(date)&limit=20"
            
        } else if (passedTitle == "FOLLOWING") {
            
            queryUrl = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(passedUserId)/following?since=\(date)&limit=20"
            
        } else {
            print("something is wrong")
            return
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: queryUrl) else {return}
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
                        
                        self.peopleData = dataFromString
                        
                        let results = json["results"]
                        print("results: \(results)")
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.theTableView.reloadData()
                            
                        })
                        
                    } else {
                        print("URL Session Task Failed: %@", error!.localizedDescription)
                        
                    }
                    
                }
                
            })
            task.resume()
        })
        
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
            
            let id = results[indexPath.row]["id"].string
            let un = results[indexPath.row]["username"].string
            let imageUrl = results[indexPath.row]["imageUrl"].string
            let firstName = results[indexPath.row]["firstName"].string
            let lastName = results[indexPath.row]["lastName"].string
            let sport = results[indexPath.row]["sport"].string
            let hometown = results[indexPath.row]["hometown"].string
            let bio = results[indexPath.row]["description"].string
            let userFollows = results[indexPath.row]["userFollows"].bool
            let followingCount = results[indexPath.row]["followingCount"].number
            let followersCount = results[indexPath.row]["followersCount"].number
            let momentCount = results[indexPath.row]["momentCount"].number
            let lockerProductCount = results[indexPath.row]["lockerProductCount"].number
            
            let vc = ProfileViewController()
            vc.userId = id!
            vc.username = un!
            vc.imageUrl = imageUrl!
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.sports = [sport!]
            vc.hometown = hometown != nil ? hometown! : ""
            vc.bio = bio!
            vc.userFollows = userFollows!
            vc.lockerProductCount = lockerProductCount!
            vc.followingCount = followingCount!
            vc.followersCount = followersCount!
            vc.momentCount = momentCount!
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func userBtnAction(sender: UIButton){
        print(sender.tag)
        
        
    }
    

}
