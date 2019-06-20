//
//  DiscoverViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/16/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore
import SwiftyJSON
import Haneke

class DiscoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var peopleData = Data()
    
    var gearScrollView = UIScrollView()
    var gearData = Data()
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let bg = UIView()
        bg.frame = CGRect(x: 14, y: 20+7, width: view.frame.size.width-28, height: 30)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        navBarView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        let searchWidth = (UIApplication.shared.delegate as! AppDelegate).widthForView("Search", font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, height: 30)
        
        let icon = UIImageView()
        icon.frame = CGRect(x: (view.frame.size.width/2)-(searchWidth/2)-7, y: 20+7+10, width: 12, height: 12)
        icon.backgroundColor = UIColor.clear
        icon.image = UIImage(named:"miniSearchImg.png")
        navBarView.addSubview(icon)
        
        let lbl = UILabel(frame: CGRect(x: icon.frame.origin.x+icon.frame.size.width+6, y: 28, width: searchWidth, height: 30))
        lbl.textAlignment = NSTextAlignment.center
        lbl.text = "Search"
        lbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        lbl.textColor = UIColor.lightGray
        navBarView.addSubview(lbl)
        
        let navBtn = UIButton(type: UIButtonType.custom)
        navBtn.frame = CGRect(x: 0, y: 0, width: bg.frame.size.width, height: bg.frame.size.height)
        navBtn.backgroundColor = UIColor.clear
        navBtn.addTarget(self, action:#selector(navBtnAction), for:UIControlEvents.touchUpInside)
        bg.addSubview(navBtn)
        
        let line:UIView = UIView()
        line.frame = CGRect(x: 0, y: navBarView.frame.size.height-0.5, width: navBarView.frame.size.width, height: 0.5)
        line.backgroundColor = UIColor.init(white: 0.80, alpha: 1.0)
        //navBarView.addSubview(line)
        
        view.addSubview(navBarView)
        
        //
        //
        //
        
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        //theTableView.contentOffset = CGPoint(x: 0, y: 44)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(PeopleCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        //
        
        let heroHeight = theTableView.frame.size.width/2
        
        let gearContainerHeight = CGFloat(35+150+35)
        
        let headerHeight = heroHeight+gearContainerHeight
        
        theTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: headerHeight))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let heroBtn = UIButton.init(type: UIButtonType.custom)
        heroBtn.frame = CGRect(x: 0, y: 0, width: (theTableView.tableHeaderView?.frame.size.width)!, height: heroHeight)
        heroBtn.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        heroBtn.addTarget(self, action:#selector(heroBtnAction), for:.touchUpInside)
        heroBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        heroBtn.titleLabel?.numberOfLines = 1
        heroBtn.contentHorizontalAlignment = .center
        heroBtn.contentVerticalAlignment = .center
        heroBtn.titleLabel?.textAlignment = .center
        heroBtn.setTitleColor(UIColor.white, for: UIControlState())
        heroBtn.setTitleColor(UIColor.white, for: .highlighted)
        heroBtn.setTitle("POPULAR TODAY", for: UIControlState())
        theTableView.tableHeaderView?.addSubview(heroBtn)
        
        let gearContainerView = UIView(frame: CGRect(x: 0, y: heroHeight, width: view.frame.size.width, height: gearContainerHeight))
        gearContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.tableHeaderView?.addSubview(gearContainerView)
        
        gearScrollView.frame = CGRect(x: 0, y: 35, width: gearContainerView.frame.size.width, height: 150)
        gearScrollView.backgroundColor = UIColor.red
        gearScrollView.delegate = self
        gearScrollView.isPagingEnabled = false
        gearScrollView.showsHorizontalScrollIndicator = true
        gearScrollView.showsVerticalScrollIndicator = false
        gearScrollView.scrollsToTop = true
        gearScrollView.isScrollEnabled = true
        gearScrollView.bounces = true
        gearScrollView.alwaysBounceVertical = false
        gearScrollView.alwaysBounceHorizontal = true
        gearScrollView.isUserInteractionEnabled = true
        gearContainerView.addSubview(gearScrollView)
        
        let padding = CGFloat(2*10) //sportsArray.count
        let width = CGFloat(140*10) //sportsArray.count
        let totalWidth = CGFloat(width+padding+20+20)
        gearScrollView.contentSize = CGSize(width: totalWidth, height: gearScrollView.frame.size.height)
        
        //
        
        let exploreGearBtn = UIButton.init(type: UIButtonType.custom)
        exploreGearBtn.frame = CGRect(x: gearContainerView.frame.size.width-100, y: 0, width: 100, height: 35)
        exploreGearBtn.backgroundColor = UIColor.green
        exploreGearBtn.addTarget(self, action:#selector(exploreGearBtnAction), for:.touchUpInside)
        exploreGearBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        exploreGearBtn.titleLabel?.numberOfLines = 1
        exploreGearBtn.contentHorizontalAlignment = .center
        exploreGearBtn.contentVerticalAlignment = .center
        exploreGearBtn.titleLabel?.textAlignment = .center
        exploreGearBtn.setTitleColor(UIColor.white, for: UIControlState())
        exploreGearBtn.setTitleColor(UIColor.white, for: .highlighted)
        exploreGearBtn.setTitle("EXPLORE GEAR", for: UIControlState())
        gearContainerView.addSubview(exploreGearBtn)
        
        let explorePeopleBtn = UIButton.init(type: UIButtonType.custom)
        explorePeopleBtn.frame = CGRect(x: gearContainerView.frame.size.width-100, y: 35+gearScrollView.frame.size.height, width: 100, height: 35)
        explorePeopleBtn.backgroundColor = UIColor.green
        explorePeopleBtn.addTarget(self, action:#selector(explorePeopleBtnAction), for:.touchUpInside)
        explorePeopleBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        explorePeopleBtn.titleLabel?.numberOfLines = 1
        explorePeopleBtn.contentHorizontalAlignment = .center
        explorePeopleBtn.contentVerticalAlignment = .center
        explorePeopleBtn.titleLabel?.textAlignment = .center
        explorePeopleBtn.setTitleColor(UIColor.white, for: UIControlState())
        explorePeopleBtn.setTitleColor(UIColor.white, for: .highlighted)
        explorePeopleBtn.setTitle("EXPLORE PEOPLE", for: UIControlState())
        gearContainerView.addSubview(explorePeopleBtn)
        
        //
        
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        //
        
        queryForGear()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.shared.delegate as! AppDelegate).reloadExplore) {
            (UIApplication.shared.delegate as! AppDelegate).reloadExplore = false
            //queryForFeatured()
        }
        
        isSearching = false
    }
    
    
    func queryForGear() {
        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/discover/gear?pageNumber=1"
        
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
                    
                    self.gearData = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.buildGearScrollView()
                        
                    })
                    
                }
        }
        
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
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/discover/people?pageNumber=1"
        
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
                    
                    self.peopleData = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        
                        self.theTableView.reloadData()
                        
                    })
                    
                }
        }
        
    }
    
    
    func navBtnAction() {
        
        navigationController?.pushViewController(SearchViewController(), animated: false)
        
        isSearching = true
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let people = JSON(data: peopleData)
        return people["results"].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15+44+15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        let cell:PeopleCell = PeopleCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
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
            let fileUrl = URL(string: id)
            
            cell.userImgView.frame = CGRect(x: 15, y: 10, width: 44, height: 44)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        
        if let _ = results[indexPath.row]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserJson = results[indexPath.row]
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
    
    func gearBtnAction(_ sender: UIButton) {
        print("sender.tag: \(sender.tag)")
        
        // get specific gear obj
        
        let gearArray = JSON(data: gearData)
        let results = gearArray["results"]
        
        let vc = GearDetailViewController()
        vc.passedGearData = results[sender.tag] 
        navigationController?.pushViewController(vc, animated: true)
        
    }
    


}
