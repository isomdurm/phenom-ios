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
    var phenomApiUrl = "https://api1.phenomapp.com:8081" //https://phenomapp-test-1-2-3.elasticbeanstalk.com:8081
    
    var window: UIWindow?

    var tabbarvc:TabBarViewController?
    var timelinevc:TimelineViewController?
    var explorevc:ExploreViewController?
    var myactivityvc:MyActivityViewController?
    var profilevc:ProfileViewController?
    
    var previousController = UIViewController()
    var nav: UINavigationController?
    
    var reloadExplore: Bool = false
    var reloadMyActivity: Bool = false
    var reloadFriendsActivity: Bool = false
    var reloadProfile: Bool = false
    
    var lastVisitedDate = NSDate()
    var justCreatedPost: Bool = false
    
    var bannerView = UIView?()
    var activityDotView = UIView?()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = window {
            window.backgroundColor = UIColor.blackColor()
            
            UINavigationBar.appearance().setBackgroundImage(UIImage(named: "blackNav.png"), forBarMetrics:UIBarMetrics.Default)
            UINavigationBar.appearance().tintColor = UIColor.blackColor() // UIColor(red:165/255, green:95/255, blue:170/255, alpha:1) //purple
            UITabBar.appearance().tintColor = UINavigationBar.appearance().tintColor
            
            self.setupDefaults()

            //
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let bearerToken = defaults.stringForKey("bearerToken")! as NSString
            let username = defaults.stringForKey("username")! as NSString
            
            if (bearerToken == "" || username == "") {
                // log in
                self.presentWelcomeViewController()
            } else {
                // we have a user
                self.presentTabBarViewController()
                
            }
//
            
//            let oldPushHandlerOnly = !self.respondsToSelector(Selector("application:didReceiveRemoteNotification:fetchCompletionHandler:"))
//            let noPushPayload: AnyObject? = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey]
//            if oldPushHandlerOnly || noPushPayload != nil {
//                PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
//            }
        }
        
        return true
        //return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

//    func applicationWillTerminate(application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
//    }

    
    // MARK: - Navigation
    
    func presentWelcomeViewController() {
        nav = UINavigationController(rootViewController: WelcomeViewController())
        nav?.navigationBarHidden = true
        window!.rootViewController = nav
        window!.makeKeyAndVisible()
    }
    
    func presentTabBarViewController() {
        
        self.setupNotifications()
        
        self.timelinevc = TimelineViewController()
        self.explorevc = ExploreViewController()
        self.myactivityvc = MyActivityViewController()
        
        
        self.profilevc = ProfileViewController()
        let defaults = NSUserDefaults.standardUserDefaults()
        let userId = defaults.stringForKey("userId")! as String
        let username = defaults.stringForKey("username")! as String
        self.profilevc!.userId = userId
        self.profilevc!.username = username
        self.profilevc!.firstName = defaults.objectForKey("firstName") as! String
        self.profilevc!.lastName = defaults.objectForKey("lastName") as! String
        self.profilevc!.sports = defaults.objectForKey("sports") as! NSArray
        self.profilevc!.hometown = defaults.objectForKey("hometown") as! String
        self.profilevc!.bio = defaults.objectForKey("description") as! String
        self.profilevc!.followersCount = defaults.objectForKey("followersCount") as! NSNumber
        self.profilevc!.followingCount = defaults.objectForKey("followingCount") as! NSNumber
        //self.profilevc!.showingTabbar = true
        
        let nav1 = UINavigationController(rootViewController: self.timelinevc!)
        let nav2 = UINavigationController(rootViewController: self.explorevc!)
        let nav3 = UINavigationController(rootViewController: UIViewController())
        let nav4 = UINavigationController(rootViewController: self.myactivityvc!)
        let nav5 = UINavigationController(rootViewController: self.profilevc!)
        
        self.previousController = nav1
        
        //let offset2 = CGFloat(6)
        //let imageInset2 = UIEdgeInsetsMake(offset2, 0, -offset2, 0)
        
        let homeInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let homeimg = UIImage(named: "269-happyface.png")
        let homeimgselected = UIImage(named: "269-happyface.png")
        let tabitem1 = UITabBarItem(title: "", image: homeimg, selectedImage: homeimgselected)
        tabitem1.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem1.imageInsets = homeInsets
        
        let discoveryInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        let discoverimg = UIImage(named: "28-star-rounded2.png") //"06-magnify.png"
        let discoverimgselected = UIImage(named: "28-star-rounded2.png") //"06-magnify.png"
        let tabitem2 = UITabBarItem(title: "", image: discoverimg, selectedImage: discoverimgselected)
        tabitem2.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem2.imageInsets = discoveryInsets
        
        let activityInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let activityimg = UIImage(named: "29-heart.png")
        let activityimgselected = UIImage(named: "29-heart.png")
        let tabitem4 = UITabBarItem(title: "", image: activityimg, selectedImage: activityimgselected)
        tabitem4.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem4.imageInsets = activityInsets
        
        let profileInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        let profileimg = UIImage(named: "145-persondot2.png")  //19-gear.png
        let profileimgselected = UIImage(named: "145-persondot2.png")  //19-gear.png
        let tabitem5 = UITabBarItem(title: "", image: profileimg, selectedImage: profileimgselected)
        tabitem5.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: 25)
        tabitem5.imageInsets = profileInsets
        
        nav1.tabBarItem = tabitem1
        nav2.tabBarItem = tabitem2
        nav3.tabBarItem = nil
        nav4.tabBarItem = tabitem4
        nav5.tabBarItem = tabitem5
        
        let array = [nav1, nav2, nav3, nav4, nav5]
        
        self.tabbarvc = TabBarViewController()
        self.tabbarvc!.viewControllers = array
        self.tabbarvc!.delegate = self
        
        window!.rootViewController = self.tabbarvc
        window!.makeKeyAndVisible()
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if (viewController.isEqual(self.tabbarvc!.viewControllers?[self.tabbarvc!.selectedIndex])) {
            
            // already selected
            //print("already selected: \(tabBarController.selectedIndex)")
            
            if (viewController.isEqual(self.tabbarvc!.viewControllers?[1])) {
                if (self.explorevc!.isSearching) {
                    return false
                } else {
                    return true
                }
            } else {
                return true
            }
        } else {
            return !viewController.isEqual(self.tabbarvc!.viewControllers?[2])
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if (previousController == viewController) {
            
            if (tabBarController.selectedIndex == 0) {
                if (!self.timelinevc!.isPushed) {
                    self.timelinevc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
            } else if (tabBarController.selectedIndex == 1) {
                if (self.explorevc!.isSearching) {
                    //
                } else {
                    //self.explorevc!.theCollectionView.setContentOffset(CGPoint.zero, animated: true)
                    self.explorevc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
            } else if (tabBarController.selectedIndex == 2) {
                // empty
            } else if (tabBarController.selectedIndex == 3) {
                if (!self.myactivityvc!.isPushed) {
                    self.myactivityvc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
            } else if (tabBarController.selectedIndex == 4) {
                if (!self.profilevc!.isPushed) {
                    self.profilevc!.theTableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
                }
                
            }
        }
        self.previousController = viewController
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
            "followersCount" : 0,
            "followingCount" : 0,
            "momentCount" : 0,
            "lockerProductCount" : 0,
            
            "viewedPostIds" : [],
            "likedPostIds" : [],
            "savedSearchGear" : [],
            "savedSearchNames" : [],
            "followingIds" : [],
            "rateAlertShown" : false
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
            self.self.tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
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
    
    
    func logoutAction() {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let username = defaults.stringForKey("username")! as NSString
        let password = defaults.stringForKey("password")! as NSString
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/oauth/token") else {return}
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")        
        
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
                
            } else {
                print("URL Session Task Failed: %@", error!.localizedDescription);
                
            }
        })
        task.resume()
        
    }
    
}

