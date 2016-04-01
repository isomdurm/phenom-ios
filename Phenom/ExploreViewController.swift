//
//  ExploreViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import SwiftyJSON
import UIKit
import Haneke

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var discoverPeople = NSData()

    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
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
        
        let width = (UIApplication.sharedApplication().delegate as! AppDelegate).widthForView("Search", font: UIFont.systemFontOfSize(15), height: 30)
        
        let icon = UIImageView()
        icon.frame = CGRectMake((self.view.frame.size.width/2)-(width/2)-7, 20+7+10, 12, 12)
        icon.backgroundColor = UIColor.clearColor()
        icon.image = UIImage(named:"miniSearchImg.png")
        self.navBarView.addSubview(icon)
        
        let lbl = UILabel(frame: CGRectMake(icon.frame.origin.x+icon.frame.size.width+6, 28, width, 30))
        lbl.textAlignment = NSTextAlignment.Center
        lbl.text = "Search"
        lbl.font = UIFont.systemFontOfSize(15)
        lbl.textColor = UIColor.lightGrayColor()
        self.navBarView.addSubview(lbl)
        
        let navBtn = UIButton(type: UIButtonType.Custom)
        navBtn.frame = CGRectMake(0, 0, bg.frame.size.width, bg.frame.size.height)
        navBtn.backgroundColor = UIColor.clearColor()
        navBtn.addTarget(self, action:#selector(ExploreViewController.navBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
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
        
        let headerHeight = self.theTableView.frame.size.width/2
        self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, headerHeight))
        self.theTableView.tableHeaderView?.backgroundColor = UIColor.lightGrayColor()
        
        self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, 0))
        
        //
        
        self.findSuggestedFollowers()
        
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
    
    func findSuggestedFollowers() {
        
        let bearer = "Bearer O31VCYHpKrCvoqJ+3iN7MeH7b/Dvok6394eR+LZoKhI="
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "https://api1.phenomapp.com:8081/discover/people?pageNumber=1") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("1.2.3", forHTTPHeaderField: "apiVersion")
        request.addValue(bearer, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    self.discoverPeople = dataFromString
                    //print("self.discoverPeople: \(self.discoverPeople)")
                    
                    self.theTableView.reloadData()
                    
                } else {
                    //                    print("URL Session Task Failed: %@", error!.localizedDescription);
                }
            }
            
        })
        task.resume()
    }
    

    func navBtnAction() {
//        print("navBtnAction hit")
        
        self.navigationController?.pushViewController(SearchViewController(), animated: false)
        
        self.isSearching = true
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: return 50
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRectMake(20, 0, self.view.frame.size.width, 35))
        aLbl.textAlignment = NSTextAlignment.Left
        
        switch (section) {
        case 0: aLbl.text = "EXPLORE GEAR"
        case 1: aLbl.text = "EXPLORE PEOPLE"
        default: aLbl.text = ""}
        
        aLbl.font = UIFont.boldSystemFontOfSize(12)
        aLbl.textColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1) //

        let aView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        aView.addSubview(aLbl)
        
        return aView;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let rowHeight = self.view.frame.size.width/3.5
        //return 150
        if (indexPath.section == 0) {
            return 150
        } else {
            return 80
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        let cell:ExploreCell = ExploreCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        if (indexPath.section == 0) {
            // gear section
            cell.nameLbl.text = ""
            
        } else if (indexPath.section == 1) {
            // people section
            
            let people = JSON(data: self.discoverPeople)
            
            let haha = people["results"]
            
            if let person = haha[indexPath.row]["username"].string {
                cell.usernameLbl.text = person
            }
            
            if let name = haha[indexPath.row]["firstName"].string {
                cell.nameLbl.text = ("\(name) \(haha[indexPath.row]["lastName"])")
            }
            
            if let id = haha[indexPath.row]["imageUrl"].string {
                let fileUrl = NSURL(string: id)
                
                cell.userImgView.frame = CGRectMake(15, 10, 44, 44)
                cell.userImgView.setNeedsLayout()
                cell.userImgView.hnk_setImageFromURL(fileUrl!)
            }
            
        } else {
            
            cell.nameLbl.text = ""
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:29/255, green:29/255, blue:32/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        if (indexPath.section == 0) {
            
            self.navigationController?.pushViewController(GearViewController(), animated: true)
            
        } else if (indexPath.section == 1) {
            
            
        
        } else {
            
        }
        
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        let url = NSURL(string: url)!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            
            if let data = responseData {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        task.resume()
    }
    
    
}
