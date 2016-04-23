//
//  DiscoverViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/16/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftyJSON
import Haneke

class DiscoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var peopleData = NSData()
    
    var gearScrollView = UIScrollView()
    var gearData = NSData()
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let bg = UIView()
        bg.frame = CGRectMake(14, 20+7, view.frame.size.width-28, 30)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        navBarView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        let searchWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView("Search", font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, height: 30)
        
        let icon = UIImageView()
        icon.frame = CGRectMake((view.frame.size.width/2)-(searchWidth/2)-7, 20+7+10, 12, 12)
        icon.backgroundColor = UIColor.clearColor()
        icon.image = UIImage(named:"miniSearchImg.png")
        navBarView.addSubview(icon)
        
        let lbl = UILabel(frame: CGRectMake(icon.frame.origin.x+icon.frame.size.width+6, 28, searchWidth, 30))
        lbl.textAlignment = NSTextAlignment.Center
        lbl.text = "Search"
        lbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        lbl.textColor = UIColor.lightGrayColor()
        navBarView.addSubview(lbl)
        
        let navBtn = UIButton(type: UIButtonType.Custom)
        navBtn.frame = CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height)
        navBtn.backgroundColor = UIColor.clearColor()
        navBtn.addTarget(self, action:#selector(navBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        bg.addSubview(navBtn)
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, navBarView.frame.size.height-0.5, navBarView.frame.size.width, 0.5)
        line.backgroundColor = UIColor.init(white: 0.80, alpha: 1.0)
        //navBarView.addSubview(line)
        
        view.addSubview(navBarView)
        
        //
        //
        //
        
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        //theTableView.contentOffset = CGPoint(x: 0, y: 44)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(PeopleCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        //
        
        let heroHeight = theTableView.frame.size.width/2
        
        let gearContainerHeight = CGFloat(35+150+35)
        
        let headerHeight = heroHeight+gearContainerHeight
        
        theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, headerHeight))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let heroBtn = UIButton.init(type: UIButtonType.Custom)
        heroBtn.frame = CGRectMake(0, 0, (theTableView.tableHeaderView?.frame.size.width)!, heroHeight)
        heroBtn.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        heroBtn.addTarget(self, action:#selector(heroBtnAction), forControlEvents:.TouchUpInside)
        heroBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        heroBtn.titleLabel?.numberOfLines = 1
        heroBtn.contentHorizontalAlignment = .Center
        heroBtn.contentVerticalAlignment = .Center
        heroBtn.titleLabel?.textAlignment = .Center
        heroBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        heroBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        heroBtn.setTitle("POPULAR TODAY", forState: .Normal)
        theTableView.tableHeaderView?.addSubview(heroBtn)
        
        let gearContainerView = UIView(frame: CGRectMake(0, heroHeight, view.frame.size.width, gearContainerHeight))
        gearContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.tableHeaderView?.addSubview(gearContainerView)
        
        gearScrollView.frame = CGRectMake(0, 35, gearContainerView.frame.size.width, 150)
        gearScrollView.backgroundColor = UIColor.redColor()
        gearScrollView.delegate = self
        gearScrollView.pagingEnabled = false
        gearScrollView.showsHorizontalScrollIndicator = true
        gearScrollView.showsVerticalScrollIndicator = false
        gearScrollView.scrollsToTop = true
        gearScrollView.scrollEnabled = true
        gearScrollView.bounces = true
        gearScrollView.alwaysBounceVertical = false
        gearScrollView.alwaysBounceHorizontal = true
        gearScrollView.userInteractionEnabled = true
        gearContainerView.addSubview(gearScrollView)
        
        let padding = CGFloat(2*10) //sportsArray.count
        let width = CGFloat(140*10) //sportsArray.count
        let totalWidth = CGFloat(width+padding+20+20)
        gearScrollView.contentSize = CGSize(width: totalWidth, height: gearScrollView.frame.size.height)
        
        //
        
        let exploreGearBtn = UIButton.init(type: UIButtonType.Custom)
        exploreGearBtn.frame = CGRectMake(gearContainerView.frame.size.width-100, 0, 100, 35)
        exploreGearBtn.backgroundColor = UIColor.greenColor()
        exploreGearBtn.addTarget(self, action:#selector(exploreGearBtnAction), forControlEvents:.TouchUpInside)
        exploreGearBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        exploreGearBtn.titleLabel?.numberOfLines = 1
        exploreGearBtn.contentHorizontalAlignment = .Center
        exploreGearBtn.contentVerticalAlignment = .Center
        exploreGearBtn.titleLabel?.textAlignment = .Center
        exploreGearBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exploreGearBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        exploreGearBtn.setTitle("EXPLORE GEAR", forState: .Normal)
        gearContainerView.addSubview(exploreGearBtn)
        
        let explorePeopleBtn = UIButton.init(type: UIButtonType.Custom)
        explorePeopleBtn.frame = CGRectMake(gearContainerView.frame.size.width-100, 35+gearScrollView.frame.size.height, 100, 35)
        explorePeopleBtn.backgroundColor = UIColor.greenColor()
        explorePeopleBtn.addTarget(self, action:#selector(explorePeopleBtnAction), forControlEvents:.TouchUpInside)
        explorePeopleBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        explorePeopleBtn.titleLabel?.numberOfLines = 1
        explorePeopleBtn.contentHorizontalAlignment = .Center
        explorePeopleBtn.contentVerticalAlignment = .Center
        explorePeopleBtn.titleLabel?.textAlignment = .Center
        explorePeopleBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        explorePeopleBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        explorePeopleBtn.setTitle("EXPLORE PEOPLE", forState: .Normal)
        gearContainerView.addSubview(explorePeopleBtn)
        
        //
        
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, 0))
        
        //
        
        queryForGear()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore = false
            //queryForFeatured()
        }
        
        isSearching = false
    }
    
    
    func queryForGear() {
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/discover/gear"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "pageNumber=1"
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
                    
                    self.gearData = dataFromString
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.buildGearScrollView()
                        
                    })
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription)
                    
                }
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    func buildGearScrollView() {
        
        print("buildGearScrollView hit")
        
        let gearArray = JSON(data: gearData)
        //let results = gearArray["results"]
        //print("results: \(gearArray["results"])")
        
        for (index, element) in gearArray["results"].enumerate() {
            
            print("item \(index): \(element)")
            
            //let sport = element as! String
            let i = CGFloat(index)
            let x = 20+(140*i)
            let pad = 2*i
            let f = CGRectMake(x+pad, 0, 140, 140)
            
            let gearBtn = UIButton(type: UIButtonType.Custom)
            gearBtn.frame = f
            gearBtn.setImage(UIImage(named: "gearBtn-sport.png"), forState: .Normal)
            gearBtn.setImage(UIImage(named: "gearBtn-sport.png"), forState: .Highlighted)
            gearBtn.setImage(UIImage(named: "gearBtn-sport.png"), forState: .Selected)
            
            gearBtn.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            gearBtn.setBackgroundImage(UIImage(named: "goldTabBar.png"), forState: .Selected)
            
            gearBtn.backgroundColor = UIColor.blueColor()
            gearBtn.addTarget(self, action:#selector(gearBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            gearBtn.titleLabel?.numberOfLines = 1
            gearBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 13)
            gearBtn.contentHorizontalAlignment = .Center
            gearBtn.contentVerticalAlignment = .Bottom
            gearBtn.titleLabel?.textAlignment = .Center
            gearBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            gearBtn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            gearBtn.setTitle("hmmm", forState: UIControlState.Normal)
            
            gearBtn.tag = NSInteger(i)
            
            gearScrollView.addSubview(gearBtn)
            
            if (index == 9) {
                break
            }
            
        }
        
        
        //
        
        // now load people ??? on main thread
        
        queryForPeople()
        
    }
    
    func queryForPeople() {
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/discover/people"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "pageNumber=1"
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
                    
                    self.peopleData = dataFromString
                    print("self.peopleData hit")
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        
                        self.theTableView.reloadData()
                        
                    })
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription)
                    
                }
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    
    func navBtnAction() {
        
        navigationController?.pushViewController(SearchViewController(), animated: false)
        
        isSearching = true
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let people = JSON(data: peopleData)
        return people["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 15+44+15
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        let cell:PeopleCell = PeopleCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        
        let people = JSON(data: peopleData)
        let results = people["results"]
        
        if let person = results[indexPath.row]["username"].string {
            cell.usernameLbl.text = person
        }
        
        if let name = results[indexPath.row]["firstName"].string {
            cell.nameLbl.text = ("\(name) \(results[indexPath.row]["lastName"])")
        }
        
        if let id = results[indexPath.row]["imageUrl"].string {
            let fileUrl = NSURL(string: id)
            
            cell.userImgView.frame = CGRectMake(15, 10, 44, 44)
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
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
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
    
    func heroBtnAction() {
        navigationController?.pushViewController(PopularMomentsViewController(), animated: true)
    }
    
    func exploreGearBtnAction() {
        navigationController?.pushViewController(ExploreGearViewController(), animated: true)
    }
    
    func explorePeopleBtnAction() {
        navigationController?.pushViewController(ExplorePeopleViewController(), animated: true)
    }
    
    func gearBtnAction(sender: UIButton) {
        print("sender.tag: \(sender.tag)")
        
        // get specific gear obj
        
        let gearArray = JSON(data: gearData)
        let results = gearArray["results"]
        
        let vc = GearDetailViewController()
        vc.passedGearData = results[sender.tag] 
        navigationController?.pushViewController(vc, animated: true)
        
    }
    


}
