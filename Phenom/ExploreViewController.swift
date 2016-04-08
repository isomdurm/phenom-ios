//
//  ExploreViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//


import UIKit
import SwiftyJSON
import Haneke

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var peopleData = NSData()
    
    var gearScrollView = UIScrollView()
    var gearData = NSData()
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let bg = UIView()
        bg.frame = CGRectMake(14, 20+7, self.view.frame.size.width-28, 30)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0) // UIColor.init(white: 0.94, alpha: 1.0)
        self.navBarView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        let searchWidth = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView("Search", font: UIFont.systemFontOfSize(15), height: 30)
        
        let icon = UIImageView()
        icon.frame = CGRectMake((self.view.frame.size.width/2)-(searchWidth/2)-7, 20+7+10, 12, 12)
        icon.backgroundColor = UIColor.clearColor()
        icon.image = UIImage(named:"miniSearchImg.png")
        self.navBarView.addSubview(icon)
        
        let lbl = UILabel(frame: CGRectMake(icon.frame.origin.x+icon.frame.size.width+6, 28, searchWidth, 30))
        lbl.textAlignment = NSTextAlignment.Center
        lbl.text = "Search"
        lbl.font = UIFont.systemFontOfSize(15)
        lbl.textColor = UIColor.lightGrayColor()
        self.navBarView.addSubview(lbl)
        
        let navBtn = UIButton(type: UIButtonType.Custom)
        navBtn.frame = CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height)
        navBtn.backgroundColor = UIColor.clearColor()
        navBtn.addTarget(self, action:#selector(self.navBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        bg.addSubview(navBtn)
        
        let line:UIView = UIView()
        line.frame = CGRectMake(0, self.navBarView.frame.size.height-0.5, self.navBarView.frame.size.width, 0.5)
        line.backgroundColor = UIColor.init(white: 0.80, alpha: 1.0)
        //self.navBarView.addSubview(line)
        
        self.view.addSubview(self.navBarView)
        
        //
        //
        //
    
        
        self.theTableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49) 
        //self.theTableView.contentOffset = CGPoint(x: 0, y: 44)
        self.theTableView.backgroundColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:1)
        self.theTableView.separatorColor = UIColor(red:235/255, green:23/255, blue:25/255, alpha:0.5)
        self.theTableView.delegate = self
        self.theTableView.dataSource = self
        self.theTableView.showsVerticalScrollIndicator = true
        self.theTableView.registerClass(ExploreCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.theTableView)
        
        //
        
        let heroHeight = self.theTableView.frame.size.width/2
        
        let gearContainerHeight = CGFloat(35+150+35)
        
        let headerHeight = heroHeight+gearContainerHeight
        
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, headerHeight))
        self.theTableView.tableHeaderView?.backgroundColor = UIColor.lightGrayColor()
        
        let heroBtn = UIButton.init(type: UIButtonType.Custom)
        heroBtn.frame = CGRectMake(0, 0, (self.theTableView.tableHeaderView?.frame.size.width)!, heroHeight)
        heroBtn.backgroundColor = UIColor.lightGrayColor()
        heroBtn.addTarget(self, action:#selector(self.heroBtnAction), forControlEvents:.TouchUpInside)
        heroBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(30)
        heroBtn.titleLabel?.numberOfLines = 1
        heroBtn.contentHorizontalAlignment = .Center
        heroBtn.contentVerticalAlignment = .Center
        heroBtn.titleLabel?.textAlignment = .Center
        heroBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        heroBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        heroBtn.setTitle("POPULAR TODAY", forState: .Normal)
        self.theTableView.tableHeaderView?.addSubview(heroBtn)
        
        let gearContainerView = UIView(frame: CGRectMake(0, heroHeight, self.view.frame.size.width, gearContainerHeight))
        gearContainerView.backgroundColor = UIColor.darkGrayColor()
        self.theTableView.tableHeaderView?.addSubview(gearContainerView)
        
        self.gearScrollView.frame = CGRectMake(0, 35, gearContainerView.frame.size.width, 150)
        self.gearScrollView.backgroundColor = UIColor.redColor()
        self.gearScrollView.delegate = self
        self.gearScrollView.pagingEnabled = false
        self.gearScrollView.showsHorizontalScrollIndicator = true
        self.gearScrollView.showsVerticalScrollIndicator = false
        self.gearScrollView.scrollsToTop = true
        self.gearScrollView.scrollEnabled = true
        self.gearScrollView.bounces = true
        self.gearScrollView.alwaysBounceVertical = false
        self.gearScrollView.alwaysBounceHorizontal = true
        self.gearScrollView.userInteractionEnabled = true
        gearContainerView.addSubview(self.gearScrollView)
        
        let padding = CGFloat(2*10) //self.sportsArray.count
        let width = CGFloat(140*10) //self.sportsArray.count
        let totalWidth = CGFloat(width+padding+20+20)
        self.gearScrollView.contentSize = CGSize(width: totalWidth, height: self.gearScrollView.frame.size.height)
        
        //
        
        let exploreGearBtn = UIButton.init(type: UIButtonType.Custom)
        exploreGearBtn.frame = CGRectMake(gearContainerView.frame.size.width-100, 0, 100, 35)
        exploreGearBtn.backgroundColor = UIColor.greenColor()
        exploreGearBtn.addTarget(self, action:#selector(self.exploreGearBtnAction), forControlEvents:.TouchUpInside)
        exploreGearBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        exploreGearBtn.titleLabel?.numberOfLines = 1
        exploreGearBtn.contentHorizontalAlignment = .Center
        exploreGearBtn.contentVerticalAlignment = .Center
        exploreGearBtn.titleLabel?.textAlignment = .Center
        exploreGearBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exploreGearBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        exploreGearBtn.setTitle("EXPLORE GEAR", forState: .Normal)
        gearContainerView.addSubview(exploreGearBtn)
        
        let explorePeopleBtn = UIButton.init(type: UIButtonType.Custom)
        explorePeopleBtn.frame = CGRectMake(gearContainerView.frame.size.width-100, 35+self.gearScrollView.frame.size.height, 100, 35)
        explorePeopleBtn.backgroundColor = UIColor.greenColor()
        explorePeopleBtn.addTarget(self, action:#selector(self.explorePeopleBtnAction), forControlEvents:.TouchUpInside)
        explorePeopleBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        explorePeopleBtn.titleLabel?.numberOfLines = 1
        explorePeopleBtn.contentHorizontalAlignment = .Center
        explorePeopleBtn.contentVerticalAlignment = .Center
        explorePeopleBtn.titleLabel?.textAlignment = .Center
        explorePeopleBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        explorePeopleBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        explorePeopleBtn.setTitle("EXPLORE PEOPLE", forState: .Normal)
        gearContainerView.addSubview(explorePeopleBtn)
        
        //
        
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        //
        
        self.queryForGear()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore = false
            //self.queryForFeatured()
        }
        
        self.isSearching = false
    }
    
    
    func queryForGear() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/discover/gear?pageNumber=1") else {return}
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
                        
                        self.gearData = dataFromString                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.buildGearScrollView()
                            
                        })
                        
                    } else {
                        print("URL Session Task Failed: %@", error!.localizedDescription)
                        
                    }
                    
                }
                
            })
            task.resume()
        })
    }
    
    func buildGearScrollView() {
        
        print("buildGearScrollView hit")
        
        let gearArray = JSON(data: self.gearData)
        //let results = gearArray["results"]
        
        //print("results: \(gearArray["results"])")
        
        for (index, element) in gearArray["results"].enumerate() {
            
            //print("Item \(index): \(element)")
            
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
            gearBtn.addTarget(self, action:#selector(self.gearBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            gearBtn.titleLabel?.numberOfLines = 1
            gearBtn.titleLabel?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
            gearBtn.contentHorizontalAlignment = .Center
            gearBtn.contentVerticalAlignment = .Bottom
            gearBtn.titleLabel?.textAlignment = .Center
            gearBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            gearBtn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            gearBtn.setTitle("hmmm", forState: UIControlState.Normal)
            
            gearBtn.tag = NSInteger(i)
            
            self.gearScrollView.addSubview(gearBtn)
            
            if (index == 9) {
                break
            }
            
        }
        
        
        // 
        
        // now load people ??? on main thread
        
        self.queryForPeople()
        
    }
    
    func queryForPeople() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/discover/people?pageNumber=1") else {return}
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
    

    func navBtnAction() {
        
        self.navigationController?.pushViewController(SearchViewController(), animated: false)
        
        self.isSearching = true
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let people = JSON(data: self.peopleData)
        return people["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        let cell:ExploreCell = ExploreCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        // people section
        
        cell.userImgView.hidden = false
        cell.nameLbl.hidden = false
        cell.usernameLbl.hidden = false
        cell.followBtn.hidden = false
        
        let people = JSON(data: self.peopleData)
        
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
            cell.userImgView.hnk_setImageFromURL(fileUrl!)
        }
        
        cell.theScrollView.hidden = true
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        
        
    }
    
    func heroBtnAction() {
        self.navigationController?.pushViewController(PopularMomentsViewController(), animated: true)
    }
    
    func exploreGearBtnAction() {
        self.navigationController?.pushViewController(ExploreGearViewController(), animated: true)
    }

    func explorePeopleBtnAction() {
        self.navigationController?.pushViewController(ExplorePeopleViewController(), animated: true)
    }
    
    func gearBtnAction(sender: UIButton) {
        print("sender.tag: \(sender.tag)")
        
        // get specific gear obj
        
        let gearArray = JSON(data: self.gearData)
        let results = gearArray["results"]
        
        
        
        let vc = GearDetailViewController()
        
        
        let id = results[sender.tag]["id"].number
        let sku = results[sender.tag]["sku"].string
        let sourceId = results[sender.tag]["sourceId"].number
        let sourceProductId = results[sender.tag]["sourceProductId"].string
        
        let name = results[sender.tag]["name"].string
        let brand = results[sender.tag]["brand"].string

        let productDescription = results[sender.tag]["description"].string
        let productUrl = results[sender.tag]["productUrl"].string
        let imageUrl = results[sender.tag]["imageUrl"].string
        
        let lockerCount = results[sender.tag]["lockerCount"].number
        let trainingMomentCount = results[sender.tag]["trainingMomentCount"].number
        let gamingMomentCount = results[sender.tag]["gamingMomentCount"].number
        let stylingMomentCount = results[sender.tag]["stylingMomentCount"].number
        
        let existsInLocker = results[sender.tag]["existsInLocker"].bool
        
        
        vc.id = "\(id!)"
        vc.sku = sku!
        vc.sourceId = "\(sourceId!)"
        vc.sourceProductId = sourceProductId!
        vc.name = name!
        vc.brand = brand!
        
        if let brandLogoImageUrl = results[sender.tag]["brandLogoImageUrl"].string {
            vc.brandLogoImageUrl = brandLogoImageUrl
        }
        
        vc.productDescription = productDescription!
        vc.productUrl = productUrl!
        vc.imageUrl = imageUrl!
        vc.lockerCount = lockerCount!
        vc.trainingMomentCount = trainingMomentCount!
        vc.gamingMomentCount = gamingMomentCount!
        vc.stylingMomentCount = stylingMomentCount!
        vc.existsInLocker = existsInLocker!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }

    
    
}
