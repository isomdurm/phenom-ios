//
//  SingleMomentViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/16/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import SwiftyJSON
import Haneke

class SingleMomentViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {

    var navBarView = UIView()
    
    var theScrollView = UIScrollView()
    
    var passedMomentId = ""
    
    var momentData = NSData()
    
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
        backBtn.frame = CGRectMake(15, 20, 44, 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.clearColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.text = "MOMENT"
        navBarView.addSubview(titleLbl)
        
        
        theScrollView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theScrollView.backgroundColor = UIColor.clearColor()
        theScrollView.delegate = self
        theScrollView.pagingEnabled = false
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = true
        theScrollView.scrollsToTop = true
        theScrollView.scrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = true
        theScrollView.userInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        //
        
        self.queryForMoment()

    
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func queryForMoment() {
        
        
        let bearerToken = NSUserDefaults.standardUserDefaults().objectForKey("bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)"
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
                    
                    
                    self.momentData = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.reloadAction()
                        
                    })
                    
                }
        }
    
    }
    
    
    func reloadAction() {
        
        let json = JSON(data: momentData)
        let results = json["results"]

        print("results: \(results)")
        
        
        
    }
    
    
    

}
