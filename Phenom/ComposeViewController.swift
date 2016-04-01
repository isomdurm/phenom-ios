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
    
    var tabBtn1 = UIButton(type: UIButtonType.Custom)
    var tabBtn2 = UIButton(type: UIButtonType.Custom)
    var tabBtn3 = UIButton(type: UIButtonType.Custom)
    
    var theTextView = KMPlaceholderTextView()
    var textFieldAtTop: Bool = false
    
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
        shareBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
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
        gearView.frame = CGRectMake(0, 44+100, self.view.frame.size.width, 100)
        gearView.backgroundColor = UIColor.blueColor()
        self.theScrollView.addSubview(gearView)
        
        
        // add music - show 3 and a + button
        
        let musicView = UIView()
        musicView.frame = CGRectMake(0, 44+100+100, self.view.frame.size.width, 100)
        musicView.backgroundColor = UIColor.greenColor()
        self.theScrollView.addSubview(musicView)
        
        //
        // to hide clear background
        let fakeView = UIView()
        fakeView.frame = CGRectMake(0, 44+100+100+100, self.view.frame.size.width, 100*10)
        fakeView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.theScrollView.addSubview(fakeView)
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification ,object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ComposeViewController.keyboardDidShow(_:)), name:UIKeyboardDidShowNotification ,object: nil)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        
    }

    
    func backAction() {        
        self.navigationController?.popViewControllerAnimated(true)
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
        
        if (textFieldAtTop && self.theTextView.isFirstResponder()) {
            self.view.endEditing(true)
        }
        
        if (self.theScrollView.contentOffset.y != 0) {
            textFieldAtTop = false
        }
        
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")

    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        //print("scrollViewDidEndDecelerating at x: \(scrollView.contentOffset.x)")
        
        if (self.theScrollView.contentOffset.y == 0) {
            print("scrollViewDidEndDecelerating hit")
            textFieldAtTop = true
        }
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        print("keyboardWillShow hit")
        self.theScrollView.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
        
    }
    
    func keyboardDidShow(notification: NSNotification) {
        
        print("keyboardDidShow hit")
        textFieldAtTop = true
        
    }
    
    // UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (self.theTextView.text == "") {
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
        //        let newSize = textView.sizeThatFits(CGSizeMake(self.view.frame.size.width-40, maxFloat))
        //
        //        var newFrame = textView.frame
        //        newFrame.size = CGSizeMake(self.view.frame.size.width-40, newSize.height)
        //
        //        textView.frame = newFrame
        
    }
    
    
    func shareBtnAction() {
        print("shareBtnAction hit")
        
        self.view.endEditing(true)
        
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
