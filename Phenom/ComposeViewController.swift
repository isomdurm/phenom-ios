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
    var passedHeadline = ""
    
    var tabBtn1 = UIButton(type: UIButtonType.Custom)
    var tabBtn2 = UIButton(type: UIButtonType.Custom)
    var tabBtn3 = UIButton(type: UIButtonType.Custom)
    
    var theTextView = KMPlaceholderTextView()
    var textFieldAtTop: Bool = false
    
    var statusOnly: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBarHidden = true
        //edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
//        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
//        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        view.addSubview(navBarView)
//
//        let backBtn = UIButton(type: UIButtonType.Custom)
//        backBtn.frame = CGRectMake(15, 20, 44, 44)
//        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
//        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
//        backBtn.backgroundColor = UIColor.redColor()
//        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
//        navBarView.addSubview(backBtn)
//        
//        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
//        titleLbl.textAlignment = NSTextAlignment.Center
//        titleLbl.font = UIFont.boldSystemFontOfSize(16)
//        titleLbl.textColor = UIColor.whiteColor()
//        titleLbl.text = "I AM"
//        navBarView.addSubview(titleLbl)
//        
//        let shareBtn = UIButton()
//        shareBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
//        shareBtn.backgroundColor = UIColor.blueColor()
//        shareBtn.addTarget(self, action:#selector(shareBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
//        shareBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
//        shareBtn.titleLabel?.numberOfLines = 1
//        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
//        shareBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
//        shareBtn.titleLabel?.textAlignment = NSTextAlignment.Center
//        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
//        shareBtn.setTitle("SHARE", forState: UIControlState.Normal)
//        navBarView.addSubview(shareBtn)
        
        //
        
        let mediaHeight = view.frame.size.width+110
        
        let theImageView = UIImageView(frame: CGRectMake(0, 0, view.frame.size.width, mediaHeight))
        theImageView.image  = passedImage
        theImageView.contentMode = UIViewContentMode.ScaleAspectFit
        theImageView.userInteractionEnabled = true
        view.addSubview(theImageView)
        theImageView.layer.masksToBounds = true
        
        //
        
        theScrollView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        theScrollView.backgroundColor = UIColor.clearColor()
        theScrollView.delegate = self
        theScrollView.pagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = true
        theScrollView.scrollsToTop = true
        theScrollView.scrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = true
        theScrollView.userInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        theScrollView.contentInset = UIEdgeInsets(top: mediaHeight, left: 0, bottom: 0, right: 0)
        
        // measure necessary height
        theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRectMake(0, 0, view.frame.size.width, 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let tabWidth = view.frame.width/3
        tabBtn1.frame = CGRectMake(0, 0, tabWidth, 44)
        tabBtn1.backgroundColor = UIColor.clearColor()
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn1.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn1.setTitle("TRAINING", forState: UIControlState.Normal)
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn1.selected = true
        
        tabBtn2.frame = CGRectMake(tabWidth*1, 0, tabWidth, 44)
        tabBtn2.backgroundColor = UIColor.clearColor()
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn2.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn2.setTitle("GAMING", forState: UIControlState.Normal)
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn2)
        
        tabBtn3.frame = CGRectMake(tabWidth*2, 0, tabWidth, 44)
        tabBtn3.backgroundColor = UIColor.clearColor()
        tabBtn3.titleLabel?.numberOfLines = 1
        tabBtn3.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.Center
        tabBtn3.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        tabBtn3.setTitleColor(UINavigationBar.appearance().tintColor, forState: UIControlState.Selected)
        tabBtn3.setTitle("STYLING", forState: UIControlState.Normal)
        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), forControlEvents:UIControlEvents.TouchUpInside)
        tabView.addSubview(tabBtn3)
        
        let line2:UIView = UIView()
        line2.frame = CGRectMake(0, tabView.frame.size.height-0.5, tabView.frame.size.width, 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        theScrollView.addSubview(tabView)
 
        //
        
        // add caption
        
        theTextView.frame = CGRectMake(0, 44, view.frame.width, 150)
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
        theScrollView.addSubview(theTextView)
        
        if (passedHeadline == "") {
            theTextView.text = ""
        } else {
            theTextView.text = passedHeadline
        }
        //theTextView.text = ""
        theTextView.placeholder = "Add a caption..."
        
        theTextView.placeholderColor = UIColor.init(white: 1.0, alpha: 0.8)
        
        theTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        
        // add gear - show 3 and a + button
        
        let gearView = UIView()
        gearView.frame = CGRectMake(0, 44+100, view.frame.size.width, 100)
        gearView.backgroundColor = UIColor.blueColor()
        theScrollView.addSubview(gearView)
        
        
        // add music - show 3 and a + button
        
        let musicView = UIView()
        musicView.frame = CGRectMake(0, 44+100+100, view.frame.size.width, 100)
        musicView.backgroundColor = UIColor.greenColor()
        theScrollView.addSubview(musicView)
        
        //
        // to hide clear background
        let fakeView = UIView()
        fakeView.frame = CGRectMake(0, 44+100+100+100, view.frame.size.width, 100*10)
        fakeView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theScrollView.addSubview(fakeView)
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIKeyboardWillShowNotification ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow(_:)), name:UIKeyboardDidShowNotification ,object: nil)
        
        //
        
        if (statusOnly) {
            
            theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            theScrollView.scrollEnabled = false
            theScrollView.bounces = false
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        
    }

    
    func backAction() {        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tabBtn1Action() {
        tabBtn1.selected = true
        tabBtn2.selected = false
        tabBtn3.selected = false
        
    }
    
    func tabBtn2Action() {
        tabBtn1.selected = false
        tabBtn2.selected = true
        tabBtn3.selected = false
        
    }
    
    func tabBtn3Action() {
        tabBtn1.selected = false
        tabBtn2.selected = false
        tabBtn3.selected = true
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if (textFieldAtTop && theTextView.isFirstResponder()) {
            view.endEditing(true)
        }
        
        if (theScrollView.contentOffset.y != 0) {
            textFieldAtTop = false
        }
        
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")

    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewDidEndDecelerating at x: \(scrollView.contentOffset.x)")
        
        if (theScrollView.contentOffset.y == 0) {
            print("scrollViewDidEndDecelerating hit")
            textFieldAtTop = true
        }
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("keyboardWillShow hit")
        theScrollView.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
        
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
        print("keyboardDidShow hit")
        textFieldAtTop = true
        
    }
    
    // UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (theTextView.text == "") {
            if (text == " ") {
                return false;
            }
        }
        if (text == "\n")
        {
            //return false;
        }
        
        //
        
        let maxLength = 200
        let currentString: NSString = textView.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: text)
        
        return newString.length <= maxLength
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        //        // adjust height
        //
        //        let maxFloat = CGFloat(MAXFLOAT)
        //        let newSize = textView.sizeThatFits(CGSizeMake(view.frame.size.width-40, maxFloat))
        //
        //        var newFrame = textView.frame
        //        newFrame.size = CGSizeMake(view.frame.size.width-40, newSize.height)
        //
        //        textView.frame = newFrame
        
    }
    
    
    func shareBtnAction() {
//        print("shareBtnAction hit")
        
        view.endEditing(true)
        
        //
        
        print("passedImage: \(passedImage)")
        print("passedImage.size: \(passedImage.size)")
        
        //
        
        var mode = NSString()
        
        if (tabBtn1.selected) {
            mode = (tabBtn1.titleLabel?.text)!
        } else if (tabBtn2.selected) {
            mode = (tabBtn2.titleLabel?.text)!
        } else if (tabBtn3.selected) {
            mode = (tabBtn3.titleLabel?.text)!
        } else {
            // error
            return
        }
        
        print("mode: \(mode)")
        
        //
        
        print("theTextField: \(theTextView.text)")
        
        //
        
        
    }

}
