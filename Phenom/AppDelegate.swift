//
//  AppDelegate.swift
//  Phenom
//
//  Created by Clay Zug on 3/23/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

    var clientId = "chLsgAqWLqXGPsWDKACcAhobUmZrxpdZowOOwyPpFEBPHDQYGO"
    var clientSecret = "YlVsbkxaeFFtZVhDY3ZaU2dIRWFCYmtUcWZhcXFPYldsT2JSaU1NZ2tjcm1MWEVKeko="
    var apiVersion = "1.2.3"
    var phenomApiUrl = "https://api1.phenomapp.com:8081" //"http://192.168.129.253:8081" // "http://192.168.129.95:8081" //"http://localhost:8081" //"https://ec2-52-73-17-149.compute-1.amazonaws.com:8081" //"https://phenomapp-test-1-2-3.elasticbeanstalk.com:8081" //
    
    var window: UIWindow?

    var tabbarvc:TabBarViewController?
    var timelinevc:TimelineViewController?
    var explorevc:PopularViewController?
    var myactivityvc:MyActivityViewController?
    var profilevc:ProfileViewController?
    
    var previousController = UIViewController()
    var nav: UINavigationController?
    
    var reloadTimeline: Bool = false
    var reloadExplore: Bool = false
    var reloadMyActivity: Bool = false
    var reloadFriendsActivity: Bool = false
    var reloadProfile: Bool = false
    
    var lastVisitedDate = NSDate()
    var justCreatedPost: Bool = false
    
    var bannerView = UIView?()
    var activityDotView = UIView?()
    
    var tempUnLikedIdsArray = NSMutableArray()
    
    var addMomentView = AddMomentView?()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
            
            UINavigationBar.appearance().setBackgroundImage(UIImage(named: "blackNav.png"), forBarMetrics:UIBarMetrics.Default)
            UINavigationBar.appearance().tintColor = UIColor(red:177/255, green:155/255, blue:84/255, alpha:1) //UIColor(red:157/255, green:135/255, blue:64/255, alpha:1) //actually gold
            UITabBar.appearance().tintColor = UINavigationBar.appearance().tintColor

            //
            
            setupDefaults()

            //
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let bearerToken = defaults.stringForKey("bearerToken")! as String
            let username = defaults.stringForKey("username")! as String
            
            if (bearerToken == "" || username == "") {
                // log in
                presentWelcomeViewController()
            } else {
                // we have a user
                presentTabBarViewController()
            }
//
            
//            let oldPushHandlerOnly = !respondsToSelector(Selector("application:didReceiveRemoteNotification:fetchCompletionHandler:"))
//            let noPushPayload: AnyObject? = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]
//            if oldPushHandlerOnly || noPushPayload != nil {
//                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
//            }
        }
        
        return true
        //return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        //        if ((PFUser.currentUser()) != nil) {
        //            if (self.mainvc != nil) {
        //                // update
        //                self.lastvisiteddate = NSDate()
        //                let newme = PFUser.currentUser()
        //                newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //                newme!.saveInBackground()
        //            } else {
        //                // signed up but did not finish onboarding
        //            }
        //        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        self.nav?.popToRootViewControllerAnimated(false)
        
        //        if ((PFUser.currentUser()) != nil) {
        //            if (self.mainvc != nil) {
        //                let ip = NSIndexPath(forRow: 0, inSection: 0)
        //                self.mainvc!.theTableView.scrollToRowAtIndexPath(ip, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        //            } else {
        //                // signed up but did not finish onboarding
        //                self.nav?.popToRootViewControllerAnimated(false)
        //                self.presentTabBarViewController()
        //            }
        //        }
        
    }
    func applicationWillEnterForeground(application: UIApplication) {
        
        //        if ("currentUser") != nil) {
        //
        //            if (self.mainvc!.isOpen) {
        //
        //                self.justcreatedpost = false
        //                self.reloadDiscovery = true // reload until proven not
        //                self.reloadMyActivity = true
        //                self.reloadFriendsActivity = true
        //                //
        //                let date = PFUser.currentUser()!.objectForKey("lastvisiteddate") as! NSDate
        //                self.lastvisiteddate = date
        //                //
        //                let newme = PFUser.currentUser()
        //                newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //                newme!.saveInBackground()
        //                //
        //                // IF ACTIVITY VC IS OPEN, GET RID OF OLD BLUE CELLS
        //                if (self.activityvc!.isOpen) {
        //                    self.activityvc!.myactivityvc.theTableView.reloadData()
        //                    if (self.activityvc!.friendsactivityvc.isOpen) {
        //                        self.activityvc!.friendsactivityvc.theTableView.reloadData()
        //                    }
        //                }
        //                //
        //                // reload mainvc
        //                //
        //                self.mainvc!.refreshControlAction()
        //                //
        //                //
        //            }
        //        }
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        
    }

    
    // MARK: - Navigation
    
    func presentWelcomeViewController() {
        nav = UINavigationController(rootViewController: WelcomeViewController())
        nav?.navigationBarHidden = true
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    }
    
    func presentTabBarViewController() {
        
        setupNotifications()
        
        timelinevc = TimelineViewController()
        explorevc = PopularViewController()
        myactivityvc = MyActivityViewController()
        
        
        profilevc = ProfileViewController()
        profilevc!.initialProfile = true 
        let defaults = NSUserDefaults.standardUserDefaults()
        let userId = defaults.stringForKey("userId")! as String
        let username = defaults.stringForKey("username")! as String
        profilevc!.userId = userId
        profilevc!.username = username
        profilevc!.imageUrl = defaults.objectForKey("imageUrl") as! String
        profilevc!.firstName = defaults.objectForKey("firstName") as! String
        profilevc!.lastName = defaults.objectForKey("lastName") as! String
        profilevc!.sports = defaults.objectForKey("sports") as! NSArray
        profilevc!.hometown = defaults.objectForKey("hometown") as! String
        profilevc!.bio = defaults.objectForKey("description") as! String
        profilevc!.followersCount = defaults.objectForKey("followersCount") as! NSNumber
        profilevc!.followingCount = defaults.objectForKey("followingCount") as! NSNumber
        profilevc!.momentCount = defaults.objectForKey("momentCount") as! NSNumber
        profilevc!.lockerProductCount = defaults.objectForKey("lockerProductCount") as! NSNumber
        //profilevc!.showingTabbar = true
        
        let nav1 = UINavigationController(rootViewController: timelinevc!)
        let nav2 = UINavigationController(rootViewController: explorevc!)
        let nav3 = UINavigationController(rootViewController: UIViewController())
        let nav4 = UINavigationController(rootViewController: myactivityvc!)
        let nav5 = UINavigationController(rootViewController: profilevc!)
        
        previousController = nav1
        
        //let offset2 = CGFloat(6)
        //let imageInset2 = UIEdgeInsetsMake(offset2, 0, -offset2, 0)
        
        let homeInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let homeimg = UIImage(named: "tabbar-timeline-icon.png")
        let homeimgselected = UIImage(named: "tabbar-timeline-icon.png")
        let tabitem1 = UITabBarItem(title: "", image: homeimg, selectedImage: homeimgselected)
        tabitem1.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem1.imageInsets = homeInsets
        
        let discoveryInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        let discoverimg = UIImage(named: "28-star-rounded2.png") //tabbar-explore-icon.png
        let discoverimgselected = UIImage(named: "28-star-rounded2.png")
        let tabitem2 = UITabBarItem(title: "", image: discoverimg, selectedImage: discoverimgselected)
        tabitem2.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem2.imageInsets = discoveryInsets
        
        let activityInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let activityimg = UIImage(named: "tabbar-activity-icon")
        let activityimgselected = UIImage(named: "tabbar-activity-icon.png")
        let tabitem4 = UITabBarItem(title: "", image: activityimg, selectedImage: activityimgselected)
        tabitem4.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem4.imageInsets = activityInsets
        
        let profileInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let profileimg = UIImage(named: "tabbar-profile-icon.png")
        let profileimgselected = UIImage(named: "tabbar-profile-icon.png")
        let tabitem5 = UITabBarItem(title: "", image: profileimg, selectedImage: profileimgselected)
        tabitem5.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem5.imageInsets = profileInsets
        
        nav1.tabBarItem = tabitem1
        nav2.tabBarItem = tabitem2
        nav3.tabBarItem = nil
        nav4.tabBarItem = tabitem4
        nav5.tabBarItem = tabitem5
        
        let array = [nav1, nav2, nav3, nav4, nav5]
        
        tabbarvc = TabBarViewController()
        tabbarvc!.viewControllers = array
        tabbarvc!.delegate = self
        
        window!.rootViewController = tabbarvc
        window!.makeKeyAndVisible()
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if (viewController.isEqual(tabbarvc!.viewControllers?[tabbarvc!.selectedIndex])) {
            
            // already selected
            //print("already selected: \(tabBarController.selectedIndex)")
            
            return true
        } else {
            return !viewController.isEqual(tabbarvc!.viewControllers?[2])
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if (previousController == viewController) {
            
            if (tabBarController.selectedIndex == 0) {
                if (!timelinevc!.isPushed) {
                    timelinevc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
            } else if (tabBarController.selectedIndex == 1) {
                if (!explorevc!.isPushed) {
                    //explorevc!.theCollectionView.setContentOffset(CGPoint.zero, animated: true)
                    explorevc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
            } else if (tabBarController.selectedIndex == 2) {
                // empty
            } else if (tabBarController.selectedIndex == 3) {
                if (!myactivityvc!.isPushed) {
                    myactivityvc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
            } else if (tabBarController.selectedIndex == 4) {
                if (!profilevc!.isPushed) {
                    profilevc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
                
            }
        }
        previousController = viewController
    }
    
    func setupDefaults() {
        
        let dict = [
            "bearerToken" : "",
            "refreshToken" : "",
            "userId" : "",
            "username" : "",
            "password" : "",
            "hometown" : "",
            "sports" : [],
            "imageUrl" : "",
            "description" : "",
            "firstName" : "",
            "lastName" : "",
            "email" : "",
            "birthday" : NSDate(),
            "gender" : "",
            "followersCount" : 0,
            "followingCount" : 0,
            "momentCount" : 0,
            "lockerProductCount" : 0,
            
            "likedMomentIds" : [],
            "followingUserIds" : [],
            "searchedGearWords" : [],
            "searchedPeopleWords" : [],
            
            "rateAlertShown" : false,
            
            "hasAddedAMoment" : false
        ]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.registerDefaults(dict)
        
    }
    
    func widthForView(text:String, font:UIFont, height:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        let size = CGSizeMake(rect.size.width, rect.size.height)
        return size
    }
    
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.Minute
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components(unitFlags, fromDate: earliest, toDate: latest, options: [])
        
        if (components.minute >= 60) {
            
            let hours = components.minute/60
            if (hours > 1) {
                
                if (hours > 24) {
                    let days = hours/24
                    if (days > 6) {
                        let weeks = days/7
                        return "\(weeks)w" // wks ago
                    } else {
                        return "\(days)d" // days ago
                    }
                } else {
                    return "\(hours)h" // hrs ago"
                }
            } else {
                return "\(hours)h" // hr ago"
            }
        } else if (components.minute >= 2) {
            return "\(components.minute)m" // mins ago"
        } else if (components.minute >= 1){
            return "1m" //"1 min ago"
        } else {
            return "now"
        }
    }
    
    //
    
    func capturePresentAnimation() {
        
        
    }
    
    func captureDismissAnimation() {
        
        UIView.animateWithDuration(0.18, animations: {
            self.tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
            }, completion: { finished in
        })
    }
    
    func setupNotifications() {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func saveNewDeviceToken() {
        
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
//        print("deviceToken: \(deviceToken)")
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
//        print("tokenString: \(tokenString)")
        
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
       
//        let e = error.code
//        print("error: \(e)")
        
    }
    
    //
    //
    //
    //func sendRequest(url: String, parameters: [String: AnyObject], type: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) ->
    func sendRequest(url: String, parameters: String, type: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionTask {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let bearerToken = defaults.objectForKey("bearerToken") as! String
        
        //let requestURL = NSURL(string:"\(url)?\(parameters)")!
        let urlStr = "\(url)?\(parameters)"
        let urlEncoded : NSString = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let requestURL : NSURL = NSURL(string: urlEncoded as String)!
        
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = type // "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization") 
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler:completionHandler)
        task.resume()
        
        return task
    }
    //
    //
    //
    
    
    func logoutAction() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")! as String
        let password = defaults.stringForKey("password")! as String
        let bearerToken = defaults.stringForKey("bearerToken")! as String
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"
                
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")        
        // need this
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        //
        
        let bodyObject = [
            "username": username,
            "password": password,
            "client_id": (UIApplication.sharedApplication().delegate as! AppDelegate).clientId,
            "client_secret": (UIApplication.sharedApplication().delegate as! AppDelegate).clientSecret,
            "grant_type": "password"
        ]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyObject, options: [])
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if (json["errorCode"].number == nil) {
                        
                        print("u shall pass")
                        
                    } else {
                        // double check
                        if json["errorCode"].number != 200 {
                            print("json: \(json)")
                            print("error: \(json["errorCode"].number)")
                            return
                        }
                    }
                    
                    //
                    
                    if (error == 404) {
                        
                    }
                    
                    print("error: \(error)")
                    
                    // logged out
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        let appDomain = NSBundle.mainBundle().bundleIdentifier!
                        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
                        
                        self.setupDefaults()
                        
                        self.nav?.popToRootViewControllerAnimated(false)
                        
                        self.presentWelcomeViewController()
                        
                    })
                    
                    
                }
                
            } else {
                print("URL Session Task Failed: %@", error!.localizedDescription);
                
            }
        })
        task.resume()
        
    }
    
    func likedMomentId(str : String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.arrayForKey("likedMomentIds")
        let ma = NSMutableArray(array: array!)
        if (ma.containsObject(str)) {
            return true
        } else {
            return false
        }
    }
    
    func addLikedMomentId(str : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.arrayForKey("likedMomentIds")
        let ma = NSMutableArray(array: array!)
        if (ma.containsObject(str)) {
            // in likedMomentIds, do nothing
        } else {
            // add it
            ma.addObject(str) 
            let newarray = ma as NSArray
            defaults.setObject(newarray, forKey: "likedMomentIds")
            defaults.synchronize()
        }
    }
    
    func followingUserId(str : String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.arrayForKey("followingUserIds")
        let ma = NSMutableArray(array: array!)
        if (ma.containsObject(str)) {
            return true
        } else {
            return false
        }
    }
    
    func followUserId(str : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let array = defaults.arrayForKey("followingUserIds")
        let ma = NSMutableArray(array: array!)
        if (ma.containsObject(str)) {
            // in followingUserIds, do nothing
        } else {
            // add it
            ma.addObject(str)
            let newarray = ma as NSArray
            defaults.setObject(newarray, forKey: "followingUserIds")
            defaults.synchronize()
        }
    }

    func heightForTimelineMoment(results : JSON, ip : NSIndexPath, cellWidth : CGFloat) -> CGFloat {
        
        let padding = CGFloat(15)
        var mediaHeight = CGFloat()
        var headlineHeight = CGFloat()
        
        
//        if let id = results[ip.row]["mediaHeight"].number {
//            mediaHeight = CGFloat(id)
//        } else {
//            mediaHeight = cellWidth+140
//        }
        mediaHeight = cellWidth+110
        
        if let id = results[ip.row]["headline"].string {
            let trimmedString = id.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if (trimmedString == "") {
                headlineHeight = 0
            } else {
                let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(trimmedString, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: cellWidth-30)
                headlineHeight = height+10
            }
        } else {
            headlineHeight = 0
        }
        
        if (headlineHeight == 0) {
            return mediaHeight+padding+38+padding+38+padding+padding
        } else {
            return mediaHeight+padding+38+padding+headlineHeight+padding+38+padding+padding
        }
    }
    
    func showAddMomentView() {
        
        //let window = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
        addMomentView = AddMomentView(frame: CGRectMake(self.window!.frame.size.width/2-75, self.window!.frame.size.height-49-60, 150, 60))
        addMomentView!.layoutSubviews()
        addMomentView!.btn?.addTarget(self, action:#selector(addMomentViewBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        addMomentView!.alpha = 0.0
        self.window!.addSubview(addMomentView!)
        //addMomentView!.layer.cornerRadius = 5
        //addMomentView!.layer.masksToBounds = true
        addMomentView!.layer.shadowColor = UIColor.blackColor().CGColor
        addMomentView!.layer.shadowOpacity = 0.5
        addMomentView!.layer.shadowOffset = CGSizeZero
        addMomentView!.layer.shadowRadius = 10
        
        
        UIView.animateWithDuration(1.0, delay:1.5, options: .CurveEaseOut, animations: {
            
            self.addMomentView!.alpha = 1.0
            
            var viewFrame = self.addMomentView!.frame
            viewFrame.origin.y = self.window!.frame.size.height-49-60-10
            self.addMomentView!.frame = viewFrame
            
            }, completion: { finished in
                if (finished) {
                    
//                    UIView.animateWithDuration(1.0, delay:0, options: [.Repeat, .Autoreverse], animations: {
//                        
//                        var viewFrame = self.addMomentView!.frame
//                        viewFrame.origin.y = self.window!.frame.size.height-49-50-5
//                        self.addMomentView!.frame = viewFrame
//                        
//                        }, completion: nil)
                    
                }
                
        })
    }
    
    func addMomentViewBtnAction() {
        
        self.tabbarvc?.centerBtnAction()
        self.removeAddMomentView()
    }
    
    func removeAddMomentView() {
        
        self.addMomentView?.removeFromSuperview()
        self.addMomentView = AddMomentView?()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}

