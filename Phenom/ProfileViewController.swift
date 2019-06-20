//
//  ProfileViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import QuartzCore
import AVFoundation
import MobileCoreServices

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var initialProfile: Bool = false
    
    var navBarView = UIView()
    
    var passedUserJson = JSON(data: Data())
    
    var teamData = Data()
    var momentsData = Data()
    var gearData = Data()
    
    var userId = ""
    var username = ""
    var imageUrl = ""
    var firstName = ""
    var lastName = ""
    var sports = []
    var hometown = ""
    var bio = ""
    var userFollows: Bool = false
    var lockerProductCount = NSNumber()
    var followingCount = NSNumber()
    var followersCount = NSNumber()
    var momentCount = NSNumber()
    
    
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    var activityArray = NSArray()
    
    var profileImgView = UIImageView()
    var nameLbl = UILabel()
    var sportHometownLbl = UILabel()
    var descriptionLbl = UILabel()
    var fansNumBtn = UIButton.init(type: UIButtonType.custom)
    var followingNumBtn = UIButton.init(type: UIButtonType.custom)
    
    let inviteBtn = UIButton.init(type: UIButtonType.custom)
    
    var isPushed: Bool = false
    
    var tabBtn1 = UIButton(type: UIButtonType.custom)
    var tabBtn2 = UIButton(type: UIButtonType.custom)
    var tabBtn3 = UIButton(type: UIButtonType.custom)
    
    var queriedForTimeline: Bool = false
    var queriedForGear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        // parse user json
        
        if (!self.initialProfile) {
            
            let ht = passedUserJson["hometown"].string
            
            userId = passedUserJson["id"].string!
            username = passedUserJson["username"].string!
            imageUrl = passedUserJson["imageUrl"].string!
            firstName = passedUserJson["firstName"].string!
            lastName = passedUserJson["lastName"].string!
            
            if (passedUserJson["sports"].arrayObject != nil) {
                sports = passedUserJson["sports"].arrayObject!
            } else {
                sports = [passedUserJson["sport"].string!]
            }
            //sports = [passedUserJson["sport"].string!]
            
            hometown = ht != nil ? ht! : ""
            bio = passedUserJson["description"].string!
            
            userFollows = passedUserJson["userFollows"].bool!
            
            lockerProductCount = passedUserJson["lockerProductCount"].number!
            followingCount = passedUserJson["followingCount"].number!
            followersCount = passedUserJson["followersCount"].number!
            momentCount = passedUserJson["momentCount"].number!
            
        }
        
        //
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = username.uppercased()
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorStyle = .none
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(MainCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        let padding = CGFloat(10)
        let headerViewWidth = view.frame.size.width
        
        let fansWidth = (headerViewWidth/2)/2
        let fansHeight = CGFloat(50)
        
        let profilePicWidth = headerViewWidth/3
        let nameHeight = CGFloat(30)
        let sportHomeTownHeight = CGFloat(28)
        
        let bioWidth = view.frame.size.width-50
        let bioHeight = (UIApplication.shared.delegate as! AppDelegate).heightForView(bio, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: bioWidth)+padding+padding

        
        let headerContainerViewHeight = profilePicWidth+padding+nameHeight+sportHomeTownHeight+bioHeight+padding+padding+fansHeight
        let headerContainerView = UIView(frame: CGRect(x: 0, y: 50, width: headerViewWidth, height: headerContainerViewHeight))
        
        
        //
        // profile pic, name, hometown,
        //
        
        let profileContainerViewHeight = profilePicWidth+padding+nameHeight+sportHomeTownHeight+bioHeight+padding+padding
        let profileContainerView = UIView(frame: CGRect(x: 0, y: 0,  width: headerViewWidth, height: profileContainerViewHeight))
        
        profileImgView.frame = CGRect(x: profilePicWidth, y: 0, width: profilePicWidth, height: profilePicWidth)
        profileImgView.backgroundColor = UIColor.lightGray
        profileImgView.contentMode = UIViewContentMode.scaleAspectFill
        profileContainerView.addSubview(profileImgView)
        let fileUrl = URL(string: imageUrl)
        profileImgView.setNeedsLayout()
        profileImgView.layer.masksToBounds = true
        profileImgView.isUserInteractionEnabled = true
        
        //profileImgView.hnk_setImageFromURL(fileUrl!)
        profileImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
            success: { image in
                //print("image here: \(image)")
                self.profileImgView.image = image
            },
            failure: { error in
                if ((error) != nil) {
                    print("error here: \(error)")
                    // collapse, this cell - it was prob deleted - error 402
                }
        })
        
        
        
        
        nameLbl.frame = CGRect(x: 0, y: profileImgView.frame.origin.y+profileImgView.frame.size.height+padding, width: headerViewWidth, height: nameHeight)
        nameLbl.backgroundColor = UIColor.clear
        nameLbl.textAlignment = .center
        nameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 24)
        nameLbl.textColor = UIColor.white
        profileContainerView.addSubview(nameLbl)
        nameLbl.text = "\(firstName) \(lastName)".uppercased()
        
        sportHometownLbl.frame = CGRect(x: 0, y: profileImgView.frame.origin.y+profileImgView.frame.size.height+padding+nameLbl.frame.size.height, width: headerViewWidth, height: sportHomeTownHeight)
        sportHometownLbl.backgroundColor = UIColor.clear
        sportHometownLbl.textAlignment = .center
        sportHometownLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 13)
        sportHometownLbl.textColor = UIColor.white
        profileContainerView.addSubview(sportHometownLbl)
        let sportsStr = sports.componentsJoined(by: ", ")
        sportHometownLbl.text = String("\(sportsStr)").uppercased() // IN \(hometown)
        
        descriptionLbl.frame = CGRect(x: (headerViewWidth/2)-(bioWidth/2), y: profileImgView.frame.origin.y+profileImgView.frame.size.height+padding+nameLbl.frame.size.height+sportHometownLbl.frame.size.height, width: bioWidth, height: bioHeight)
        descriptionLbl.backgroundColor = UIColor.clear
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        descriptionLbl.textColor = UIColor.init(white: 0.5, alpha: 1.0)
        descriptionLbl.textAlignment = NSTextAlignment.center
        profileContainerView.addSubview(descriptionLbl)
        descriptionLbl.text = bio
        
        headerContainerView.addSubview(profileContainerView)
        
        
        //
        // fans/following/invite
        //
        let fansFollowingInviteContainerView = UIView(frame: CGRect(x: 0, y: profileContainerViewHeight,  width: headerViewWidth, height: fansHeight))
        
        fansNumBtn.frame = CGRect(x: 0, y: 0, width: fansWidth, height: 30)
        fansNumBtn.backgroundColor = UIColor.clear
        fansNumBtn.addTarget(self, action:#selector(fansBtnAction), for:.touchUpInside)
        fansNumBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        fansNumBtn.titleLabel?.numberOfLines = 1
        fansNumBtn.contentHorizontalAlignment = .center
        fansNumBtn.contentVerticalAlignment = .center
        fansNumBtn.titleLabel?.textAlignment = .center
        fansNumBtn.setTitleColor(UIColor.white, for: UIControlState())
        fansNumBtn.setTitleColor(UIColor.white, for: .highlighted)
        fansFollowingInviteContainerView.addSubview(fansNumBtn)
        fansNumBtn.setTitle(String("\(followersCount)").uppercased(), for: UIControlState())
        
        let fansBtn = UIButton.init(type: UIButtonType.custom)
        fansBtn.frame = CGRect(x: 0, y: 30, width: fansWidth, height: 20)
        fansBtn.backgroundColor = UIColor.clear
        fansBtn.addTarget(self, action:#selector(fansBtnAction), for:.touchUpInside)
        fansBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Demi", size: 10)
        fansBtn.titleLabel?.numberOfLines = 1
        fansBtn.contentHorizontalAlignment = .center
        fansBtn.contentVerticalAlignment = .center
        fansBtn.titleLabel?.textAlignment = .center
        fansBtn.setTitleColor(UIColor.white, for: UIControlState())
        fansBtn.setTitleColor(UIColor.white, for: .highlighted)
        fansBtn.setTitle("FANS", for: UIControlState())
        fansFollowingInviteContainerView.addSubview(fansBtn)
        
        followingNumBtn.frame = CGRect(x: fansWidth, y: 0, width: fansWidth, height: 30)
        followingNumBtn.backgroundColor = UIColor.clear
        followingNumBtn.addTarget(self, action:#selector(followingBtnAction), for:.touchUpInside)
        followingNumBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        followingNumBtn.titleLabel?.numberOfLines = 1
        followingNumBtn.contentHorizontalAlignment = .center
        followingNumBtn.contentVerticalAlignment = .center
        followingNumBtn.titleLabel?.textAlignment = .center
        followingNumBtn.setTitleColor(UIColor.white, for: UIControlState())
        followingNumBtn.setTitleColor(UIColor.white, for: .highlighted)
        fansFollowingInviteContainerView.addSubview(followingNumBtn)
        followingNumBtn.setTitle(String("\(followingCount)").uppercased(), for: UIControlState())
        
        let followingBtn = UIButton.init(type: UIButtonType.custom)
        followingBtn.frame = CGRect(x: fansWidth, y: 30, width: fansWidth, height: 20)
        followingBtn.backgroundColor = UIColor.clear
        followingBtn.addTarget(self, action:#selector(followingBtnAction), for:.touchUpInside)
        followingBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Demi", size: 10)
        followingBtn.titleLabel?.numberOfLines = 1
        followingBtn.contentHorizontalAlignment = .center
        followingBtn.contentVerticalAlignment = .center
        followingBtn.titleLabel?.textAlignment = .center
        followingBtn.setTitleColor(UIColor.white, for: UIControlState())
        followingBtn.setTitleColor(UIColor.white, for: .highlighted)
        followingBtn.setTitle("FOLLOWING", for: UIControlState())
        fansFollowingInviteContainerView.addSubview(followingBtn)
        
        let inviteBtnWidth = ((headerViewWidth/2)/4)*3
        let half = headerViewWidth/2
        let dif = half - inviteBtnWidth
        
        inviteBtn.frame = CGRect(x: headerViewWidth/2+(dif/2), y: 0, width: inviteBtnWidth, height: fansHeight)
        inviteBtn.backgroundColor = UIColor.green
        inviteBtn.setBackgroundImage(UIImage(named: "goldNav.png"), for: UIControlState())
        inviteBtn.addTarget(self, action:#selector(inviteBtnAction), for:.touchUpInside)
        inviteBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        inviteBtn.titleLabel?.numberOfLines = 1
        inviteBtn.contentHorizontalAlignment = .center
        inviteBtn.contentVerticalAlignment = .center
        inviteBtn.titleLabel?.textAlignment = .center
        inviteBtn.setTitleColor(UIColor.white, for: UIControlState())
        inviteBtn.setTitleColor(UIColor.white, for: .highlighted)
        fansFollowingInviteContainerView.addSubview(inviteBtn)
        
        headerContainerView.addSubview(fansFollowingInviteContainerView)
        
        //
        //
        
        let headerViewHeight = CGFloat(50+headerContainerViewHeight+40)
        
        ////
        
        //let tabContainerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 64))
        let tabContainerView = UIView(frame: CGRect(x: 0, y: headerViewHeight, width: self.view.frame.size.width, height: 64))
        tabContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        //let tabWidth = view.frame.width/3
        let tabWidth = view.frame.width/2
        
        tabBtn1.frame = CGRect(x: 0, y: 0, width: tabWidth, height: 64)
        tabBtn1.backgroundColor = UIColor.clear
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn1.setTitleColor(UIColor.lightGray, for: UIControlState())
        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), for:UIControlEvents.touchUpInside)
        //tabContainerView.addSubview(tabBtn1)
        tabBtn1.setTitle("0 STATS", for: UIControlState())
        
        tabBtn2.frame = CGRect(x: tabWidth*0, y: 0, width: tabWidth, height: 64)
        tabBtn2.backgroundColor = UIColor.clear
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn2.setTitleColor(UIColor.lightGray, for: UIControlState())
        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), for:UIControlEvents.touchUpInside)
        tabContainerView.addSubview(tabBtn2)
        let s = momentCount == 1 ? "" : "S"
        tabBtn2.setTitle("\(momentCount) MOMENT\(s)", for: UIControlState())
        
        tabBtn3.frame = CGRect(x: tabWidth*1, y: 0, width: tabWidth, height: 64)
        tabBtn3.backgroundColor = UIColor.clear
        tabBtn3.titleLabel?.numberOfLines = 1
        tabBtn3.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn3.setTitleColor(UIColor.lightGray, for: UIControlState())
        tabBtn3.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), for:UIControlEvents.touchUpInside)
        tabContainerView.addSubview(tabBtn3)
        tabBtn3.setTitle("\(lockerProductCount) GEAR", for: UIControlState())
        
        ////
        
        theTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: headerViewWidth, height: headerViewHeight+64))
        theTableView.tableHeaderView?.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        
        theTableView.tableHeaderView?.addSubview(headerContainerView)
        
        theTableView.tableHeaderView?.addSubview(tabContainerView)
        
        //
        //
        //
        
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        theTableView.addSubview(refreshControl)
        
        //
        
        //self.tabBtn1Action()
        self.tabBtn2Action()
        
        //
        
        queryForUser()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isPushed = false
        
        if (!initialProfile) {

            navigationController?.interactivePopGestureRecognizer!.delegate = self
        }
        
        //
        // to update user defaults
        //
        self.theTableView.reloadData()
        //
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ((UIApplication.shared.delegate as! AppDelegate).addMomentView != nil) {
            (UIApplication.shared.delegate as! AppDelegate).removeAddMomentView()
        }
        
    }
    
    func searchBtnAction() {
        
        self.navigationController?.pushViewController(ExploreViewController(), animated: true)
        
        self.isPushed = true
        
    }
    
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    func refreshControlAction() {
        
        if (tabBtn1.isSelected) {
            
            self.queryForUser()
            
        } else if (tabBtn2.isSelected) {
            
            self.queryForTimeline()
            
        } else if (tabBtn3.isSelected) {
            
            self.queryForGear()
            
        } else {
            print("no tab selected")
        }
        
    }
    
    
    
    func queryForUser() {
        
        let defaults = UserDefaults.standard
        let uid = defaults.string(forKey: "userId")! as String
        
        if (initialProfile) {
            
            let searchBtn = UIButton(type: UIButtonType.custom)
            searchBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
            searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), for: UIControlState())
            //searchBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
            searchBtn.backgroundColor = UIColor.clear
            searchBtn.addTarget(self, action:#selector(searchBtnAction), for:UIControlEvents.touchUpInside)
            navBarView.addSubview(searchBtn)
            
            let settingsBtn = UIButton(type: UIButtonType.custom)
            settingsBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
            settingsBtn.setImage(UIImage(named: "settingsBtn.png"), for: UIControlState())
            //settingsBtn.setBackgroundImage(UIImage(named: "settingsBtn.png"), forState: UIControlState.Normal)
            settingsBtn.backgroundColor = UIColor.blue
            settingsBtn.addTarget(self, action:#selector(settingsBtnAction), for:UIControlEvents.touchUpInside)
            navBarView.addSubview(settingsBtn)
            
            let profileBtn = UIButton(type: UIButtonType.custom)
            profileBtn.frame = CGRect(x: 0, y: 0, width: profileImgView.frame.size.width, height: profileImgView.frame.size.height)
            profileBtn.backgroundColor = UIColor.clear
            profileBtn.addTarget(self, action:#selector(profileBtnAction), for:UIControlEvents.touchUpInside)
            profileImgView.addSubview(profileBtn)
            
            inviteBtn.setTitle("INVITE TEAM", for: UIControlState())
            
        } else {
            
            if (userId == uid) {
                print("currentUser")
                
                inviteBtn.setTitle("INVITE TEAM", for: UIControlState())
                
            } else {
                
                if (userFollows) {
                    inviteBtn.isSelected = true
                    inviteBtn.setTitle("UNFOLLOW", for: UIControlState())
                } else {
                    inviteBtn.isSelected = false
                    inviteBtn.setTitle("FOLLOW", for: UIControlState())
                }
            }
            
            // need back action
            
            let backBtn = UIButton(type: UIButtonType.custom)
            backBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
            backBtn.setImage(UIImage(named: "back-arrow.png"), for: UIControlState())
            backBtn.backgroundColor = UIColor.clear
            backBtn.addTarget(self, action:#selector(backAction), for:UIControlEvents.touchUpInside)
            navBarView.addSubview(backBtn)
            backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
            rightSwipe.direction = .right
            view.addGestureRecognizer(rightSwipe)
            
        }
        
        
        //
        // now get user
        //
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(userId)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    //print("JSON: \(JSON)")
                    print("response.request: \(response.request)")  // original URL request
                    print("response.response: \(response.response)") // URL response
                    print("response.data: \(response.data)")     // server data
                    print("response.result: \(response.result)")   // result of response serialization
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    //
                    
                    let json = JSON(data: response.data!)
                    self.passedUserJson = json["results"]
                    
                    //
                    
                    // success, save user defaults
                    self.userId = self.passedUserJson["id"].string!
                    self.username = self.passedUserJson["username"].string!
                    
                    if let _ = self.passedUserJson["hometown"].string {
                        self.hometown = self.passedUserJson["hometown"].string!
                    } else {
                        self.hometown = ""
                    }
                    
                    self.imageUrl = self.passedUserJson["imageUrl"].string!
                    self.bio = self.passedUserJson["description"].string!
                    self.firstName = self.passedUserJson["firstName"].string! 
                    self.lastName = self.passedUserJson["lastName"].string!
                    
                    self.followersCount = self.passedUserJson["followersCount"].number!
                    self.followingCount = self.passedUserJson["followingCount"].number!
                    
                    self.momentCount = self.passedUserJson["momentCount"].number!
                    self.lockerProductCount = self.passedUserJson["lockerProductCount"].number!
                    
                    //let sport = self.passedUserJson["sport"].string! // make an array
                    //self.sports = [sport]
                    
                    if (self.passedUserJson["sports"].arrayObject != nil) {
                        self.sports = self.passedUserJson["sports"].arrayObject!
                    } else {
                        self.sports = [self.passedUserJson["sport"].string!]
                    }
                    //self.sports = self.passedUserJson["sports"].arrayObject!
                    
                    
                    if (self.userId == uid) {
                        
                        // update current user defaults
                        
                        defaults.setObject(self.userId, forKey: "userId")
                        defaults.setObject(self.username, forKey: "username")
                        defaults.setObject(self.hometown, forKey: "hometown")
                        defaults.setObject(self.imageUrl, forKey: "imageUrl")
                        defaults.setObject(self.bio, forKey: "description")
                        defaults.setObject(self.firstName, forKey: "firstName")
                        defaults.setObject(self.lastName, forKey: "lastName")
                        defaults.setObject(self.followersCount, forKey: "followersCount")
                        defaults.setObject(self.followingCount, forKey: "followingCount")
                        defaults.setObject(self.momentCount, forKey: "momentCount")
                        defaults.setObject(self.lockerProductCount, forKey: "lockerProductCount")
                        defaults.setObject(self.sports, forKey: "sports")
                        defaults.synchronize()
                        
                    }
                                        
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("got here")
                        self.reloadAction()
                        
                    })
                    
                }
        }
        
        refreshControl.endRefreshing()
        
    }
    
    func reloadAction() {
        
        let fileUrl = URL(string: self.imageUrl)
        self.profileImgView.setNeedsLayout()
        self.profileImgView.layer.masksToBounds = true
        self.profileImgView.isUserInteractionEnabled = true
        
        //profileImgView.hnk_setImageFromURL(fileUrl!)
        self.profileImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
            success: { image in
                //print("image here: \(image)")
                self.profileImgView.image = image
            },
            failure: { error in
                if ((error) != nil) {
                    print("error here: \(error)")
                    // collapse, this cell - it was prob deleted - error 402
                }
        })
        
        theTableView.reloadData()
        
        refreshControl.endRefreshing()
        
    }
    
    func fansBtnAction() {
        
        // push to fans
        
        if (Int(followersCount) > 0) {
            let vc = PeopleListViewController()
            vc.passedTitle = "FANS"
            vc.passedUserId = userId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func followingBtnAction() {
        
        // push to following
        
        if (Int(followingCount) > 0) {
            let vc = PeopleListViewController()
            vc.passedTitle = "FOLLOWING"
            vc.passedUserId = userId
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func inviteBtnAction(_ sender : UIButton) {
        
        // if currentUser, invite
        //
        // if not currentUser - follow / un-follow
        
        let defaults = UserDefaults.standard
        let uid = defaults.string(forKey: "userId")! as String
        
        if (userId == uid) {
            print("currentUser")
            
            // present invite
            let defaults = UserDefaults.standard
            let username = defaults.string(forKey: "username")! as String
            
            let textToShare = String("Add me on Phenom! 🆕🔥 (username: \(username))")
            let myWebsite = "http://phenom.co/download"
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToFlickr,UIActivityType.postToVimeo]
            self.present(activityVC, animated: true, completion: nil)
            
        } else {
            
            if (inviteBtn.isSelected) {
                
                // already following
                
                areyousureyouwanttounfollow(sender)
                                
            } else {
                
                // not following
                
                inviteBtn.isSelected = true
                
                inviteBtn.setTitle("FOLLOW", for: UIControlState())
                theTableView.reloadData()
                
                followAction(sender)
                
            }
            
        }
    }
    
    func tabBtn1Action() {
        
        tabBtn1.isSelected = true
        tabBtn2.isSelected = false
        tabBtn3.isSelected = false
        
        // refresh view to show teams
        
        let defaults = UserDefaults.standard
        let uid = defaults.string(forKey: "userId")! as String
        
        if (userId == uid && initialProfile) {
            print("currentUser")
            
            self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
            self.theTableView.tableFooterView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
            
            let addBtn = UIButton(frame: CGRect(x: 15, y: 0, width: self.view.frame.size.width-30, height: 50))
            addBtn.backgroundColor = UINavigationBar.appearance().tintColor
            addBtn.addTarget(self, action:#selector(addTeamBtnAction), for:UIControlEvents.touchUpInside)
            addBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
            addBtn.titleLabel?.numberOfLines = 1
            addBtn.contentHorizontalAlignment = .center
            addBtn.contentVerticalAlignment = .center
            addBtn.titleLabel?.textAlignment = .center
            addBtn.setTitleColor(UIColor.white, for: UIControlState())
            addBtn.setTitleColor(UIColor.white, for: .highlighted)
            addBtn.setTitle("ADD TEAM", for: UIControlState())
            self.theTableView.tableFooterView?.addSubview(addBtn)
            
        } else {
            
            self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0))
            self.theTableView.tableFooterView?.backgroundColor = UIColor.clear
            
        }
        
        
        self.theTableView.reloadData()
        
        
    }
    
    func tabBtn2Action() {
        
        tabBtn1.isSelected = false
        tabBtn2.isSelected = true
        tabBtn3.isSelected = false
        
        self.theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0))
        self.theTableView.tableFooterView?.backgroundColor = UIColor.clear
        
        // refresh view to show moments
        
        if (self.queriedForTimeline) {
            // do nothing
            self.theTableView.reloadData()
        } else {
            // query!
            self.theTableView.reloadData()
            self.queryForTimeline()
        }
        
    }
    
    func tabBtn3Action() {
        
        tabBtn1.isSelected = false
        tabBtn2.isSelected = false
        tabBtn3.isSelected = true
    
        
        // refresh view to show gear
        
        if (self.queriedForGear) {
            // do nothing
            self.theTableView.reloadData()
        } else {
            // query!
            self.theTableView.reloadData()
            self.queryForGear()
        }
        
    }

    
    func queryForTimeline() {
        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        let date = Date().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(userId)/moments?since=\(date)&limit=20"
        
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
                    
                    
                    self.momentsData = response.data!
                    
                    self.queriedForTimeline = true
                    
                    // done, reload tableView
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // footer
                        //
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let uid = defaults.stringForKey("userId")! as String
                        
                        if (self.userId == uid && self.initialProfile) {
                            print("currentUser")
                            
                            let json = JSON(data: self.momentsData)
                            if (json["results"].count == 0) {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
                                
                                let addBtn = UIButton(frame: CGRectMake(15, 0, self.view.frame.size.width-30, 50))
                                addBtn.backgroundColor = UINavigationBar.appearance().tintColor
                                addBtn.addTarget(self, action:#selector(self.addMomentBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
                                addBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
                                addBtn.titleLabel?.numberOfLines = 1
                                addBtn.contentHorizontalAlignment = .Center
                                addBtn.contentVerticalAlignment = .Center
                                addBtn.titleLabel?.textAlignment = .Center
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                                addBtn.setTitle("ADD A MOMENT", forState: .Normal)
                                self.theTableView.tableFooterView?.addSubview(addBtn)
                                
                            } else {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                                
                            }
                        } else {
                            
                            // no momments
                            self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                            self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                        }
                        //
                        //
                        
                        self.refreshControl.endRefreshing()
                        self.theTableView.reloadData()
                        
                        
                    })
                    
                }
        }
        
    }
    
    func queryForGear() {
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        let date = Date().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(userId)/locker?since=\(date)&limit=20"
        
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
                    
                    self.queriedForGear = true
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // footer
                        //
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let uid = defaults.stringForKey("userId")! as String
                        
                        if (self.userId == uid && self.initialProfile) {
                            print("currentUser")
                            
                            let json = JSON(data: self.gearData)
                            if (json["results"].count == 0) {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
                                
                                let addBtn = UIButton(frame: CGRectMake(15, 0, self.view.frame.size.width-30, 50))
                                addBtn.backgroundColor = UINavigationBar.appearance().tintColor
                                addBtn.addTarget(self, action:#selector(self.addGearBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
                                addBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
                                addBtn.titleLabel?.numberOfLines = 1
                                addBtn.contentHorizontalAlignment = .Center
                                addBtn.contentVerticalAlignment = .Center
                                addBtn.titleLabel?.textAlignment = .Center
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                                addBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
                                addBtn.setTitle("ADD GEAR", forState: .Normal)
                                self.theTableView.tableFooterView?.addSubview(addBtn)
                                
                            } else {
                                
                                self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                                self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                            }
                        } else {
                            
                            // no gear
                            
                            self.theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
                            self.theTableView.tableFooterView?.backgroundColor = UIColor.clearColor()
                        }
                        //
                        //
                        
                        
                        self.refreshControl.endRefreshing()
                        self.theTableView.reloadData()
                        
                    })
                    
                    
                }
        }
        
    }
   
    func emptyTimelineBtnAction() {

        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
        
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func profileBtnAction() {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true,
                                   completion: nil)
        
    }
    
    func settingsBtnAction() {
        
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    
    func followAction(_ sender: UIButton) {
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(self.userId)/follow"
        
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
                    if (ma.containsObject(self.userId)) {
                        // in followingUserIds, do nothing
                    } else {
                        let followingCount = NSUserDefaults.standardUserDefaults().objectForKey("followingCount") as! Int
                        let newcount = followingCount+1
                        
                        ma.addObject(self.userId)
                        let newarray = ma as NSArray
                        NSUserDefaults.standardUserDefaults().setObject(newarray, forKey: "followingUserIds")
                        NSUserDefaults.standardUserDefaults().setObject(newcount, forKey: "followingCount")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("followed")
                        
                        let newCount = self.followersCount as Int
                        let newNewCount = newCount+1
                        self.followersCount = NSNumber(integer: newNewCount)
                        self.fansNumBtn.setTitle(String("\(self.followersCount)").uppercaseString, forState: .Normal)
                        
                        
                        
                        sender.selected = true
                        self.theTableView.reloadData()
                        
                        (UIApplication.sharedApplication().delegate as! AppDelegate).reloadTimeline = true
                    })
                    
                    
                    
                }
        }
        
    }
    
    func areyousureyouwanttounfollow(_ sender: UIButton) {
        
        let alertController = UIAlertController(title:"Are you sure you want to unfollow \(self.username)?", message:nil, preferredStyle:.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let clearAction = UIAlertAction(title: "Unfollow", style: .default) { (action) in
            
            self.inviteBtn.isSelected = false
            
            self.inviteBtn.setTitle("UNFOLLOW", for: UIControlState())
            self.theTableView.reloadData()
            
            self.unfollowAction(sender)
            
        }
        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func unfollowAction(_ sender: UIButton) {

        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(self.userId)/unfollow"
        
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
                    
                   
                    print("unfollowed")
                    
                    sender.selected = false
                    
                    (UIApplication.sharedApplication().delegate as! AppDelegate).reloadTimeline = true
                    
                    
                }
        }
        
    }
    
    
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tabBtn1.isSelected) {
            return 3
        } else if (tabBtn2.isSelected) {
            let json = JSON(data: momentsData)
            return json["results"].count
        } else if (tabBtn3.isSelected) {
            let json = JSON(data: gearData)
            return json["results"].count
        } else {
            return 0
        }
    }
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 64
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let tabContainerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
//        tabContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        
//        //let tabWidth = view.frame.width/3
//        let tabWidth = view.frame.width/2
//        
//        tabBtn1.frame = CGRectMake(0, 0, tabWidth, 64)
//        tabBtn1.backgroundColor = UIColor.clearColor()
//        tabBtn1.titleLabel?.numberOfLines = 1
//        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
//        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
//        tabBtn1.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
//        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
//        //tabContainerView.addSubview(tabBtn1)
//        tabBtn1.setTitle("0 STATS", forState: UIControlState.Normal)
//        
//        tabBtn2.frame = CGRectMake(tabWidth*0, 0, tabWidth, 64)
//        tabBtn2.backgroundColor = UIColor.clearColor()
//        tabBtn2.titleLabel?.numberOfLines = 1
//        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
//        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
//        tabBtn2.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
//        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
//        tabContainerView.addSubview(tabBtn2)
//        let s = momentCount == 1 ? "" : "S"
//        tabBtn2.setTitle("\(momentCount) MOMENT\(s)", forState: UIControlState.Normal)
//        
//        tabBtn3.frame = CGRectMake(tabWidth*1, 0, tabWidth, 64)
//        tabBtn3.backgroundColor = UIColor.clearColor()
//        tabBtn3.titleLabel?.numberOfLines = 1
//        tabBtn3.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
//        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.Center
//        tabBtn3.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
//        tabBtn3.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
//        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), forControlEvents:UIControlEvents.TouchUpInside)
//        tabContainerView.addSubview(tabBtn3)
//        tabBtn3.setTitle("\(lockerProductCount) GEAR", forState: UIControlState.Normal)
//        
//        return tabContainerView
//        
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return view.frame.size.width+164 // probably 150 by default then raise to second line of text if necessary
        
        if (tabBtn1.isSelected) {
            
            // for stats
            return (view.frame.size.width/3)*2
            
        } else if (tabBtn2.isSelected) {
            
            // for moments - measure height
            
            let json = JSON(data: momentsData)
            let results = json["results"]
            
            let h = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForTimelineMoment(results, ip: indexPath, cellWidth: view.frame.size.width) 
            return h
            
        } else if (tabBtn3.isSelected) {
            
            // for gear
            
            let json = JSON(data: gearData)
            let results = json["results"]
            
            var brandHeight = CGFloat()
            var nameHeight = CGFloat()
            
            if let id = results[indexPath.row]["brand"].string {
                if (id == "") {
                    brandHeight = 0
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 16)!, width: self.view.frame.size.width-15-15-50-15)
                    brandHeight = height
                }
            } else {
                brandHeight = 0
            }
            
            if let id = results[indexPath.row]["name"].string {
                if (id == "") {
                    nameHeight = 0
                } else {
                    let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 16)!, width: self.view.frame.size.width-15-15-50-15)
                    nameHeight = height
                }
            } else {
                nameHeight = 0
            }
            
            if (brandHeight == 0) {
                
                let contentHeight = view.frame.size.width+15+nameHeight+15
                
                if (contentHeight > view.frame.size.width+15+38+15+15) {
                    return view.frame.size.width+15+nameHeight+15
                } else {
                    return view.frame.size.width+15+38+15+15 // default height with add btn, 38 height
                }
                
            } else {
                return view.frame.size.width+15+brandHeight+5+nameHeight+15+15
            }
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MainCell = MainCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        
        if (tabBtn1.isSelected) {
            
            // for stats
            cell.teamBannerView.isHidden = false
            cell.teamNameLbl.isHidden = false
            cell.teamSportLbl.isHidden = false
            cell.teamNumLbl.isHidden = false
            cell.teamPositionLbl.isHidden = false
            
            cell.timelineImgView.isHidden = true
            cell.timelineMusicLbl.isHidden = true
            cell.timelineModeLbl.isHidden = true
            cell.timelineRankLbl.isHidden = true
            cell.timelineTinyHeartBtn.isHidden = true
            cell.timelineLikeLblBtn.isHidden = true
            cell.timelineUserImgView.isHidden = true
            cell.timelineUserImgViewBtn.isHidden = true
            cell.timelineNameLbl.isHidden = true
            cell.timelineTimeLbl.isHidden = true
            cell.timelineFollowBtn.isHidden = true
            cell.timelineHeadlineLbl.isHidden = true
            cell.timelineLikeBtn.isHidden = true
            cell.timelineChatBtn.isHidden = true
            cell.timelineGearBtn.isHidden = true
            cell.timelineMoreBtn.isHidden = true
            
            cell.gearImgView.isHidden = true
            cell.gearBrandLbl.isHidden = true
            cell.gearNameLbl.isHidden = true
            cell.gearAddBtn.isHidden = true

            
            let padding = CGFloat(10)
            
            let teamName = "West Chester Vikings"
            let mySport = "Lacrosse"
            let myNumber = "38"
            let myPosition = "Attack"
            
            
            let teamBannerHeight = ((cell.cellWidth/3)*2)-15
            let nameHeight = (UIApplication.shared.delegate as! AppDelegate).heightForView(teamName, font: cell.teamNameLbl.font, width: cell.cellWidth-60)+padding
            let totalContentHeight = nameHeight+padding+(padding/2)+50
            let nameY = (teamBannerHeight/2)-(totalContentHeight/2)
            let detailsY = nameY+nameHeight+padding+(padding/2)
            
            let sportWidth = (UIApplication.shared.delegate as! AppDelegate).widthForView(mySport, font: cell.teamSportLbl.font, height: 40)
            let positionWidth = (UIApplication.shared.delegate as! AppDelegate).widthForView(myPosition, font: cell.teamPositionLbl.font, height: 40)
            
            cell.teamBannerView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: teamBannerHeight)
            cell.teamNameLbl.frame = CGRect(x: 30, y: nameY, width: cell.cellWidth-60, height: nameHeight)
            cell.teamSportLbl.frame = CGRect(x: cell.cellWidth/2-sportWidth-20-padding, y: detailsY, width: sportWidth, height: 40)
            cell.teamNumLbl.frame = CGRect(x: cell.cellWidth/2-20, y: detailsY, width: 40, height: 40)
            cell.teamPositionLbl.frame = CGRect(x: cell.cellWidth/2+20+padding, y: detailsY, width: positionWidth, height: 40)

            cell.teamNameLbl.text = teamName
            cell.teamSportLbl.text = mySport
            cell.teamNumLbl.text = myNumber
            cell.teamPositionLbl.text = myPosition
            
            
            
        } else if (tabBtn2.isSelected) {
            
            // for moments - measure height

            cell.teamBannerView.isHidden = true
            cell.teamNameLbl.isHidden = true
            cell.teamSportLbl.isHidden = true
            cell.teamNumLbl.isHidden = true
            cell.teamPositionLbl.isHidden = true
            
            cell.timelineImgView.isHidden = false
            cell.timelineMusicLbl.isHidden = false
            cell.timelineModeLbl.isHidden = false
            cell.timelineRankLbl.isHidden = true // odd one out
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
            
            if let id = results[indexPath.row]["imageUrl"].string {
                let fileUrl = URL(string: id)
                
                cell.timelineImgView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: mediaHeight)
                cell.timelineImgView.setNeedsLayout()
                
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
            cell.timelineFollowBtn.isHidden = true
            
            // taps
            
            cell.timelineSingleTapRecognizer.addTarget(self, action: #selector(timelineSingleTapAction(_:)))
            cell.timelineDoubleTapRecognizer.addTarget(self, action: #selector(timelineDoubleTapAction(_:)))
            
            
            
        } else if (tabBtn3.isSelected) {
            
            // for gear

            cell.teamNameLbl.isHidden = true
            cell.teamSportLbl.isHidden = true
            cell.teamNumLbl.isHidden = true
            cell.teamPositionLbl.isHidden = true
            
            cell.timelineImgView.isHidden = true
            cell.timelineMusicLbl.isHidden = true
            cell.timelineModeLbl.isHidden = true
            cell.timelineRankLbl.isHidden = true
            cell.timelineTinyHeartBtn.isHidden = true
            cell.timelineLikeLblBtn.isHidden = true
            cell.timelineUserImgView.isHidden = true
            cell.timelineUserImgViewBtn.isHidden = true
            cell.timelineNameLbl.isHidden = true
            cell.timelineTimeLbl.isHidden = true
            cell.timelineFollowBtn.isHidden = true
            cell.timelineHeadlineLbl.isHidden = true
            cell.timelineLikeBtn.isHidden = true
            cell.timelineChatBtn.isHidden = true
            cell.timelineGearBtn.isHidden = true
            cell.timelineMoreBtn.isHidden = true
            
            cell.gearImgView.isHidden = false
            cell.gearBrandLbl.isHidden = false
            cell.gearNameLbl.isHidden = false
            cell.gearAddBtn.isHidden = false
            
            
            cell.gearImgView.frame = CGRect(x: 0, y: 0, width: cell.cellWidth, height: cell.cellWidth)
            cell.gearBrandLbl.frame = CGRect(x: 15, y: cell.cellWidth+10, width: cell.cellWidth-15-15-65-15, height: 25)
            cell.gearAddBtn.frame = CGRect(x: cell.cellWidth-65-15, y: cell.cellWidth+15, width: 65, height: 38)
            
            let json = JSON(data: gearData)
            let results = json["results"]
            
            if let id = results[indexPath.row]["imageUrl"].string {
                
                let fileUrl = URL(string: id)
                cell.gearImgView.setNeedsLayout()
                
                //cell.timelineUserImgView.hnk_setImageFromURL(fileUrl!)
                cell.gearImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                                                             success: { image in
                                                                
                                                                //print("image here: \(image)")
                                                                cell.gearImgView.image = image
                                                                
                    },
                                                             failure: { error in
                                                                
                                                                if ((error) != nil) {
                                                                    print("error here: \(error)")
                                                                    
                                                                }
                })
            }
            
            
            var brandHeight = CGFloat()
            var nameHeight = CGFloat()
            
            if let id = results[indexPath.row]["brand"].string {
                cell.gearBrandLbl.text = id
                brandHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearBrandLbl.font, width: self.view.frame.size.width-15-15-65-15)
            } else {
                brandHeight = 0
                cell.gearBrandLbl.text = ""
            }
            
            if let id = results[indexPath.row]["name"].string {
                cell.gearNameLbl.text = id
                nameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearNameLbl.font, width: self.view.frame.size.width-15-15-65-15)
            } else {
                cell.gearNameLbl.text = ""
            }

            if let id = results[indexPath.row]["existsInLocker"].bool {
                if (id) {
                    cell.gearAddBtn.isSelected = true
                } else {
                    cell.gearAddBtn.isSelected = false
                }
            }

            cell.gearBrandLbl.frame = CGRect(x: 15, y: cell.cellWidth+15, width: cell.cellWidth-15-15-65-15, height: brandHeight)
            
            if (cell.gearBrandLbl.text == "") {
                cell.gearNameLbl.frame = CGRect(x: 15, y: cell.cellWidth+15, width: cell.cellWidth-15-15-65-15, height: nameHeight)
            } else {
                cell.gearNameLbl.frame = CGRect(x: 15, y: cell.cellWidth+15+brandHeight+5, width: cell.cellWidth-15-15-65-15, height: nameHeight)
            }
            
            cell.gearAddBtn.tag = indexPath.row
            cell.gearAddBtn.addTarget(self, action: #selector(gearAddBtnAction), for: .touchUpInside)
            
            cell.gearSingleTapRecognizer.addTarget(self, action: #selector(gearSingleTapAction(_:)))
            cell.gearDoubleTapRecognizer.addTarget(self, action: #selector(gearDoubleTapAction(_:)))
            
            
            
        } else {
            
            cell.teamBannerView.isHidden = true
            cell.teamNameLbl.isHidden = true
            cell.teamSportLbl.isHidden = true
            cell.teamNumLbl.isHidden = true
            cell.teamPositionLbl.isHidden = true
            
            cell.timelineImgView.isHidden = true
            cell.timelineMusicLbl.isHidden = true
            cell.timelineModeLbl.isHidden = true
            cell.timelineRankLbl.isHidden = true 
            cell.timelineTinyHeartBtn.isHidden = true
            cell.timelineLikeLblBtn.isHidden = true
            cell.timelineUserImgView.isHidden = true
            cell.timelineUserImgViewBtn.isHidden = true
            cell.timelineNameLbl.isHidden = true
            cell.timelineTimeLbl.isHidden = true
            cell.timelineFollowBtn.isHidden = true
            cell.timelineHeadlineLbl.isHidden = true
            cell.timelineLikeBtn.isHidden = true
            cell.timelineChatBtn.isHidden = true
            cell.timelineGearBtn.isHidden = true
            cell.timelineMoreBtn.isHidden = true
            
            cell.gearImgView.isHidden = true
            cell.gearBrandLbl.isHidden = true
            cell.gearNameLbl.isHidden = true
            cell.gearAddBtn.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1) 
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        if (tabBtn1.isSelected) {
            
            // for stats

            
        } else if (tabBtn2.isSelected) {
            
            // for moments - measure height

            
        } else if (tabBtn3.isSelected) {
            
            // for gear

            
        } else {

        }
        
    }

    
    func getNextPage() {
        
        //pageNumber = pageNumber + 1
        
        queryForTimeline()
        
    }
    
    func timelineUserImgViewBtnAction(_ sender: UIButton){
        
        let json = JSON(data: momentsData)
        let results = json["results"]
        
        if let id = results[sender.tag]["user"]["id"].string {
            
            if (id != userId) {
                let vc = ProfileViewController()
                vc.passedUserJson = results[sender.tag]["user"]
                navigationController?.pushViewController(vc, animated: true)
            }
            
            isPushed = true
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
        
        let defaults = UserDefaults.standard
        
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
            
            isPushed = true
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
                    
                    isPushed = true
                    
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
    
    //
    // gear actions
    //
    
    func gearSingleTapAction(_ sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.ended {
            let tappedLocation = sender.location(in: theTableView)
            if let tappedIndexPath = theTableView.indexPathForRow(at: tappedLocation) {
                if let tappedCell = theTableView.cellForRow(at: tappedIndexPath) {
                    
                    print("single tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    let json = JSON(data: gearData)
                    let results = json["results"]
                    //print("hmm: \(results)")
                    
                    let vc = GearDetailViewController()
                    vc.passedGearData = results[tappedIndexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                    
                    isPushed = true                    
                    
                }
            }
        }
    }
    
    func gearDoubleTapAction(_ sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.ended {
            let tappedLocation = sender.location(in: theTableView)
            if let tappedIndexPath = theTableView.indexPathForRow(at: tappedLocation) {
                if let tappedCell = theTableView.cellForRow(at: tappedIndexPath) {
                    
                    print("double tapped: \(tappedIndexPath.row), \(tappedCell)")
                    
                    // if not added - add gear
                    
                    
                    
                }
            }
        }
    }
    
    func gearAddBtnAction(_ sender : UIButton) {
        
        if (sender.isSelected) {
            
            sender.isSelected = false
            removeGearFromLocker(sender)
            
        } else {
            
            sender.isSelected = true
            addGearToLocker(sender)
            
        }
    }
    
    func addGearToLocker(_ sender : UIButton) {
        
        let json = JSON(data: gearData)
        let results = json["results"]
        
        let productJson = results[sender.tag]
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/locker?product=\(productJson)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.PUT, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    print("+1 added to locker")
                    
                    sender.selected = true
                    
                    let followingCount = NSUserDefaults.standardUserDefaults().objectForKey("lockerProductCount") as! Int
                    let newcount = followingCount+1
                    NSUserDefaults.standardUserDefaults().setObject(newcount, forKey: "lockerProductCount")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
    }
    
    func removeGearFromLocker(_ sender : UIButton) {
        
        
    }
    
    //
    // team actions
    //
    
    func addTeamBtnAction() {
        
        let newnav = UINavigationController(rootViewController: AddTeamViewController())
        navigationController?.present(newnav, animated: true, completion: nil)
    }
    
    func addMomentBtnAction() {
        
        (UIApplication.shared.delegate as! AppDelegate).tabbarvc!.centerBtnAction()
    }
    
    func addGearBtnAction() {
        
        let newnav = UINavigationController(rootViewController: AddTeamViewController())
        navigationController?.present(newnav, animated: true, completion: nil)
    }

    
    
    
    
    //
    //
    //
    
    // testing photo picker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            
            //print("mediaType: \(mediaType)")
            let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            self.savePhoto(selectedImage)
            
        } else if mediaType.isEqual(to: kUTTypeVideo as String) {
            
            print("mediaType: \(mediaType)")
            //let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
            //self.savePhoto(selectedImage)
            
        } else {
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func savePhoto(_ image:UIImage) {
        
        // maxHeight
        // maxWidth
        
        let resizedimage = (UIApplication.shared.delegate as! AppDelegate).resizeImage(image, newWidth: 600)
        //let resizedimagesmall = self.resizeImage(image, newWidth: 300)
        
        self.uploadImage(resizedimage)
        
    }
    
    func uploadImage(_ image : UIImage) {
        
        func sendFile(
            _ urlPath:String,
            fileName:String,
            data:Data,
            completionHandler: (URLResponse?, Data?, NSError?) -> Void){
            
            let url: URL = URL(string: urlPath)!
            let request1: NSMutableURLRequest = NSMutableURLRequest(url: url)
            
            request1.httpMethod = "PUT"
            
            let boundary = generateBoundaryString()
            
            let fullData = photoDataToFormData(data,boundary:boundary,fileName:fileName)
            
            request1.setValue("multipart/form-data; boundary=" + boundary,
                              forHTTPHeaderField: "Content-Type")
            
            // REQUIRED!
            request1.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
            
            request1.httpBody = fullData
            request1.httpShouldHandleCookies = false
            let defaults = UserDefaults.standard
            let bearerToken = defaults.string(forKey: "bearerToken")! as String
            request1.addValue("\((UIApplication.shared.delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
            request1.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            
//            let queue:NSOperationQueue = NSOperationQueue()
//            NSURLConnection.sendAsynchronousRequest(
//                request1,
//                queue: queue,
//                completionHandler: completionHandler)
            
            let session = URLSession.shared
            //let task = session.dataTaskWithRequest(request, completionHandler:completionHandler)
            //task.resume()
            let task = session.dataTask(with: request1, completionHandler: {(data, response, error) in
                
                // notice that I can omit the types of data, response and error
                // your code
                
                if (error != nil) {
                    print("hmmm error w img upload: \(error?.code)")
                    
                    
                } else {
                    
                    // success
                    print("success w response: \(response?.description)")
                    self.queryForUser()
                    
                }
                
                
            });
            
            // do whatever you need with the task e.g. run
            task.resume()
            
            
        }
        
        
        //let url = "https://api1.phenomapp.com:8081/user"
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user"
        //        let img = UIImage(contentsOfFile: fullPath)
        let data: Data = UIImageJPEGRepresentation(image, 0.7)!
        
        sendFile(url,
                 fileName:"image.jpeg",
                 data:data,
                 completionHandler: {
                    (result:URLResponse?, isNoInternetConnection:Data?, err: NSError?) -> Void in
                    
                    // ...
                    NSLog("Complete: \(result)")
            }
        )
        
        // this is a very verbose version of that function
        // you can shorten it, but i left it as-is for clarity
        // and as an example
        func photoDataToFormData(_ data:Data,boundary:String,fileName:String) -> Data {
            let fullData = NSMutableData()
            
            // 1 - Boundary should start with --
            let lineOne = "--" + boundary + "\r\n"
            fullData.append(lineOne.data(
                using: String.Encoding.utf8,
                allowLossyConversion: false)!)
            
            // 2
            let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
            NSLog(lineTwo)
            fullData.append(lineTwo.data(
                using: String.Encoding.utf8,
                allowLossyConversion: false)!)
            
            // 3
            let lineThree = "Content-Type: image/jpg\r\n\r\n"
            fullData.append(lineThree.data(
                using: String.Encoding.utf8,
                allowLossyConversion: false)!)
            
            // 4
            fullData.append(data)
            
            // 5
            let lineFive = "\r\n"
            fullData.append(lineFive.data(
                using: String.Encoding.utf8,
                allowLossyConversion: false)!)
            
            // 6 - The end. Notice -- at the start and at the end
            let lineSix = "--" + boundary + "--\r\n"
            fullData.append(lineSix.data(
                using: String.Encoding.utf8,
                allowLossyConversion: false)!)
            
            return fullData
        }
        
    }
    
    func generateBoundaryString() -> String {
        
        return "Boundary-\(UUID().uuidString)"
    }

    
}
