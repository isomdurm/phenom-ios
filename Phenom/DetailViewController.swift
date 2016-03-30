//
//  DetailViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/27/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    var isGear: Bool = false
    
    var navBarView = UIView()
    
    var theScrollView = UIScrollView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(DetailViewController.backAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        
//        self.theScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49)
//        self.theScrollView.backgroundColor = UIColor.blackColor()
//        self.theScrollView.delegate = self
//        self.theScrollView.pagingEnabled = true
//        self.theScrollView.showsHorizontalScrollIndicator = true // false
//        self.theScrollView.showsVerticalScrollIndicator = false
//        self.theScrollView.scrollsToTop = true
//        self.theScrollView.scrollEnabled = true
//        self.theScrollView.bounces = true
//        self.theScrollView.alwaysBounceHorizontal = true
//        self.theScrollView.userInteractionEnabled = true
//        self.view.addSubview(self.theScrollView)
//        self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
//        
//        
//        // measure necessary height
//        self.theScrollView.contentSize = CGSize(width: self.theScrollView.frame.size.width, height: self.theScrollView.frame.size.height)
        
        
        
        if (self.isGear) {
            
            titleLbl.text = "GEAR"
            
            
            
            
        } else {
            
            titleLbl.text = "PHOTO"
            
        }
        
        self.navBarView.addSubview(titleLbl)
        
        
        
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(DetailViewController.backAction))
        swipeBack.direction = .Right
        self.view.addGestureRecognizer(swipeBack)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
