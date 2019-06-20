//
//  SingleMomentViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/16/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
    
    var momentData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), for: UIControlState())
        backBtn.backgroundColor = UIColor.clear
        backBtn.addTarget(self, action:#selector(backAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(backBtn)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        titleLbl.text = "MOMENT"
        navBarView.addSubview(titleLbl)
        
        
        theScrollView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        theScrollView.backgroundColor = UIColor.clear
        theScrollView.delegate = self
        theScrollView.isPagingEnabled = false
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = true
        theScrollView.scrollsToTop = true
        theScrollView.isScrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = true
        theScrollView.isUserInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        //
        
        self.queryForMoment()

    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
        
    }
    
    func queryForMoment() {
        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)"
        
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
