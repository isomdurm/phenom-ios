//
//  ActivityViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, UIScrollViewDelegate {

    var navBarView = UIView()
    
    var theSegmentedControl = UISegmentedControl()
    var isPushed: Bool = false
    var isOpen: Bool = false
    
    var theScrollView = UIScrollView()
    
    var myactivityvc = MyActivityViewController()
    var followingactivityvc = FollowingActivityViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "NOTIFICATIONS"
        titleLbl.font = UIFont.boldSystemFontOfSize(17)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
//        self.theSegmentedControl = UISegmentedControl (items: ["Following","Me"])
//        self.theSegmentedControl.frame = CGRectMake(self.view.frame.size.width/2-100, 27, 200, 30)
//        self.theSegmentedControl.selectedSegmentIndex = 1
//        self.theSegmentedControl.addTarget(self, action: #selector(ActivityViewController.segmentedControlAction(_:)), forControlEvents: .ValueChanged)
//        self.theSegmentedControl.tintColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1) // UIColor.yellowColor()
//        //self.navigationItem.titleView = self.theSegmentedControl
//        self.navBarView.addSubview(self.theSegmentedControl)
//        self.theSegmentedControl.selectedSegmentIndex = 1
        
        self.theScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49)
        self.theScrollView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        self.theScrollView.delegate = self
        self.theScrollView.pagingEnabled = false
        self.theScrollView.showsHorizontalScrollIndicator = false
        self.theScrollView.showsVerticalScrollIndicator = false
        self.theScrollView.scrollsToTop = true
        self.theScrollView.scrollEnabled = false
        self.theScrollView.bounces = false
        self.theScrollView.alwaysBounceVertical = false
        self.theScrollView.alwaysBounceHorizontal = false
        self.theScrollView.userInteractionEnabled = true
        self.view.addSubview(self.theScrollView)
        self.theScrollView.contentSize = CGSize(width: self.theScrollView.frame.size.width*1, height: self.theScrollView.frame.size.height)
        self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        //self.followingactivityvc.view.frame = CGRectMake(0, 0, self.theScrollView.frame.size.width, self.theScrollView.frame.size.height)
        //self.theScrollView.addSubview(self.followingactivityvc.view)
        
        //self.myactivityvc.view.frame = CGRectMake(self.theScrollView.frame.size.width, 0, self.theScrollView.frame.size.width, self.theScrollView.frame.size.height)
        //self.theScrollView.addSubview(self.myactivityvc.view)
        
        self.myactivityvc.view.frame = CGRectMake(0, 0, self.theScrollView.frame.size.width, self.theScrollView.frame.size.height)
        self.theScrollView.addSubview(self.myactivityvc.view)
        
        self.isOpen = true
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isPushed = false
        
        
    }
    
    func segmentedControlAction(sender: AnyObject) {
        if (self.theSegmentedControl.selectedSegmentIndex == 0) {
            //
            self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
            //
//            if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadFriendsActivity || self.friendsactivityvc.isOpen == false) {
//                (UIApplication.sharedApplication().delegate as! AppDelegate).reloadFriendsActivity = false
//                self.friendsactivityvc.isOpen = true
//                self.friendsactivityvc.refreshControlAction()
//            }
            //
        } else if (self.theSegmentedControl.selectedSegmentIndex == 1) {
            self.theScrollView.contentOffset = CGPoint(x: self.view.frame.size.width, y: 0)
        } else {
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (scrollView == self.theScrollView) {
//            if (scrollView.contentOffset.x < self.view.frame.size.width) {
//                if (self.friendsactivityvc.activityIndicator == nil) {
//                    self.friendsactivityvc.activityIndicator = UIActivityIndicatorView()
//                    self.friendsactivityvc.activityIndicator!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//                    self.friendsactivityvc.activityIndicator!.center = CGPoint(x: self.view.frame.size.width/2, y: 30)
//                    self.friendsactivityvc.view.addSubview(self.friendsactivityvc.activityIndicator!)
//                    self.friendsactivityvc.activityIndicator!.startAnimating()
//                }
//            } else {
//            }
//            
//            if (scrollView.contentOffset.x <= self.view.frame.size.width/2) {
//                self.theSegmentedControl.selectedSegmentIndex = 0
//            } else if (scrollView.contentOffset.x >= self.view.frame.size.width/2) {
//                self.theSegmentedControl.selectedSegmentIndex = 1
//            } else {
//                
//            }
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewDidEndDecelerating at x: \(scrollView.contentOffset.x)")
        
        if (scrollView == self.theScrollView) {
            if (scrollView.contentOffset.x == 0) {
                //
                self.theSegmentedControl.selectedSegmentIndex = 0
                // load friendsActivityVC
//                if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadFriendsActivity || self.friendsactivityvc.isOpen == false) {
//                    (UIApplication.sharedApplication().delegate as! AppDelegate).reloadFriendsActivity = false
//                    self.friendsactivityvc.isOpen = true
//                    self.friendsactivityvc.querySkip = 0
//                    self.friendsactivityvc.queryForActivity(self.friendsactivityvc.querySkip)
//                }
            } else if (scrollView.contentOffset.x == self.view.frame.size.width) {
                //
                self.theSegmentedControl.selectedSegmentIndex = 1
                //
//                if (self.friendsactivityvc.activityIndicator != nil) {
//                    self.friendsactivityvc.activityIndicator!.stopAnimating()
//                    self.friendsactivityvc.activityIndicator!.removeFromSuperview()
//                    //self.friendsactivityvc.activityIndicator = nil
//                }
//                //
//                if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadMyActivity) {
//                    (UIApplication.sharedApplication().delegate as! AppDelegate).reloadMyActivity = false
//                    self.myactivityvc.querySkip = 0
//                    self.myactivityvc.queryForActivity(self.myactivityvc.querySkip)
//                }
            } else {
            }
        }
    }

}
