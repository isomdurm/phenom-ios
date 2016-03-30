//
//  ComposeViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/29/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    var navBarView = UIView()
    
    var theScrollView = UIScrollView()
    
    var passedImage = UIImage()
    
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
        backBtn.addTarget(self, action:#selector(ComposeViewController.backAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.text = "I AM"
        self.navBarView.addSubview(titleLbl)
        
        let shareBtn = UIButton()
        shareBtn.frame = CGRectMake(self.view.frame.size.width-70, 20, 70, 44)
        shareBtn.backgroundColor = UIColor.blueColor()
        shareBtn.addTarget(self, action:#selector(ComposeViewController.shareBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        shareBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        shareBtn.titleLabel?.numberOfLines = 1
        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        shareBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        shareBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        shareBtn.setTitle("SHARE", forState: UIControlState.Normal)
        self.navBarView.addSubview(shareBtn)
        
        //
        
        let theImageView = UIImageView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width))
        theImageView.image  = self.passedImage
        theImageView.contentMode = UIViewContentMode.ScaleAspectFit
        theImageView.userInteractionEnabled = true
        self.view.addSubview(theImageView)
        theImageView.layer.masksToBounds = true
        
        //
        
        self.theScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)
        self.theScrollView.backgroundColor = UIColor.clearColor()
        self.theScrollView.delegate = self
        self.theScrollView.pagingEnabled = true
        self.theScrollView.showsHorizontalScrollIndicator = false
        self.theScrollView.showsVerticalScrollIndicator = true
        self.theScrollView.scrollsToTop = true
        self.theScrollView.scrollEnabled = true
        self.theScrollView.bounces = true
        self.theScrollView.alwaysBounceVertical = true
        self.theScrollView.userInteractionEnabled = true
        self.view.addSubview(self.theScrollView)
        self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.theScrollView.contentInset = UIEdgeInsets(top: self.view.frame.size.width, left: 0, bottom: 0, right: 0)
        
        // measure necessary height
        self.theScrollView.contentSize = CGSize(width: self.theScrollView.frame.size.width, height: self.theScrollView.frame.size.height)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let tabWidth = self.view.frame.width/3
        let tabBtn1 = UIButton(type: UIButtonType.Custom)
        tabBtn1.frame = CGRectMake(0, 0, tabWidth, 44)
        tabBtn1.backgroundColor = UIColor.clearColor()
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn1.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn1.setTitle("TRAINING", forState: UIControlState.Normal)
        tabBtn1.addTarget(self, action:#selector(ComposeViewController.tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn1.selected = true
        
        let tabBtn2 = UIButton(type: UIButtonType.Custom)
        tabBtn2.frame = CGRectMake(tabWidth*1, 0, tabWidth, 44)
        tabBtn2.backgroundColor = UIColor.clearColor()
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn2.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn2.setTitle("GAMING", forState: UIControlState.Normal)
        tabBtn2.addTarget(self, action:#selector(ComposeViewController.tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn2)
        
        let tabBtn3 = UIButton(type: UIButtonType.Custom)
        tabBtn3.frame = CGRectMake(tabWidth*2, 0, tabWidth, 44)
        tabBtn3.backgroundColor = UIColor.clearColor()
        tabBtn3.titleLabel?.numberOfLines = 1
        tabBtn3.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn3.setTitleColor(UIColor(red:157/255, green:135/255, blue:64/255, alpha:1), forState: UIControlState.Selected)
        tabBtn3.setTitle("STYLING", forState: UIControlState.Normal)
        tabBtn3.addTarget(self, action:#selector(ComposeViewController.tabBtn3Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn3)
        
        let line2:UIView = UIView()
        line2.frame = CGRectMake(0, tabView.frame.size.height-0.5, tabView.frame.size.width, 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        self.theScrollView.addSubview(tabView)
 
        //
        
        // add caption
        
        let theTextView = KMPlaceholderTextView()
        theTextView.frame = CGRectMake(0, 44, self.view.frame.width, 150)
        theTextView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTextView.delegate = self
        theTextView.textColor = UIColor.whiteColor()
        theTextView.keyboardType = UIKeyboardType.Twitter
        theTextView.returnKeyType = UIReturnKeyType.Default
        theTextView.font = UIFont.systemFontOfSize(15)
        theTextView.enablesReturnKeyAutomatically = true
        theTextView.textAlignment = NSTextAlignment.Left
        //theTextView.autocapitalizationType = UITextAutocapitalizationType.None
        //theTextView.autocorrectionType = UITextAutocorrectionType.No
        theTextView.scrollEnabled = true
        theTextView.scrollsToTop = false
        self.theScrollView.addSubview(theTextView)
        
        theTextView.text = ""
        theTextView.placeholder = "Add a caption..."
        
        theTextView.placeholderColor = UIColor.init(white: 1.0, alpha: 0.8)
        
        theTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        
        // add gear - show 3 and a + button
        
        let gearView = UIView()
        gearView.frame = CGRectMake(0, 44+150, self.view.frame.size.width, 150)
        gearView.backgroundColor = UIColor.blueColor()
        self.theScrollView.addSubview(gearView)
        
        
        // add music - show 3 and a + button
        
        let musicView = UIView()
        musicView.frame = CGRectMake(0, 44+150+150, self.view.frame.size.width, 150)
        musicView.backgroundColor = UIColor.greenColor()
        self.theScrollView.addSubview(musicView)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tabBtn1Action() {
        
    }
    
    func tabBtn2Action() {
        
    }
    
    func tabBtn3Action() {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        self.view.endEditing(true)
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewDidEndDecelerating at x: \(scrollView.contentOffset.x)")
        
        if (scrollView == self.theScrollView) {
            
            
        }
    }
    
    
    
    
    
    func shareBtnAction() {
        print("shareBtnAction hit")
        
        
    }

}
