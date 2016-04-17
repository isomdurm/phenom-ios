//
//  EditProfileViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    var navBarView = UIView()
    
    var passedEditType = ""
    
    var textField1: UITextField = UITextField()
    var textField2: UITextField = UITextField()

    var sportsArray = NSMutableArray()
    var sportsScrollView = UIScrollView()
    var selectedSportsArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor.blackColor()
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor.blackColor()
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(15, 20, 44, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        //titleLbl.text = "EDIT PROFILE"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let saveBtn = UIButton(type: UIButtonType.Custom)
        saveBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
        saveBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //saveBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        saveBtn.backgroundColor = UIColor.blueColor()
        saveBtn.addTarget(self, action:#selector(saveBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(saveBtn)
        
        textField1.frame = CGRectMake(20, 64, view.frame.size.width-40, 64)
        textField1.backgroundColor = UIColor.clearColor()
        textField1.delegate = self
        textField1.textColor = UIColor(red:51/255, green:51/255, blue:51/255, alpha:1)
        textField1.keyboardType = UIKeyboardType.Default
        textField1.returnKeyType = UIReturnKeyType.Next
        textField1.enablesReturnKeyAutomatically = true
        textField1.font = UIFont.systemFontOfSize(17)
        textField1.autocapitalizationType = UITextAutocapitalizationType.None
        textField1.autocorrectionType = UITextAutocorrectionType.No
        textField1.text = ""
        
        textField2.frame = CGRectMake(20, 64+64, view.frame.size.width-40, 64)
        textField2.backgroundColor = UIColor.clearColor()
        textField2.delegate = self
        textField2.textColor = UIColor(red:51/255, green:51/255, blue:51/255, alpha:1)
        textField2.keyboardType = UIKeyboardType.Default
        textField2.returnKeyType = UIReturnKeyType.Go
        textField2.enablesReturnKeyAutomatically = true
        textField2.font = UIFont.systemFontOfSize(17)
        textField2.autocapitalizationType = UITextAutocapitalizationType.None
        textField2.autocorrectionType = UITextAutocorrectionType.No
        textField2.secureTextEntry = true
        textField2.text = ""
        
        let lineview1 = UIView()
        lineview1.frame = CGRectMake(0, 64+63.5, view.frame.size.width, 0.5)
        lineview1.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        view.addSubview(lineview1)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        
        
        
        
        if (passedEditType == "name") {
            titleLbl.text = "NAME"
            textField1.placeholder = "your first name"
            textField2.placeholder = "your last name"
            view.addSubview(textField1)
            view.addSubview(textField2)
            view.addSubview(lineview2)
        } else if (passedEditType == "username") {
            titleLbl.text = "USERNAME"
            textField1.placeholder = "username"
            view.addSubview(textField1)
        } else if (passedEditType == "birthday") {
            titleLbl.text = "BIRTHDAY"
            textField1.placeholder = "your birthday"
            view.addSubview(textField1)
        } else if (passedEditType == "hometown") {
            titleLbl.text = "HOMETOWN"
            textField1.placeholder = "your hometown"
            view.addSubview(textField1)
        } else if (passedEditType == "sports") {
            
            titleLbl.text = "SPORTS"
            
            // show tableview
            
            
            
        } else if (passedEditType == "bio") {
            
            titleLbl.text = "BIO"
            textField1.placeholder = "bio"
            view.addSubview(textField1)
            
            
        } else if (passedEditType == "email") {
            titleLbl.text = "EMAIL"
            textField1.placeholder = "your email"
            view.addSubview(textField1)
        } else if (passedEditType == "password") {
            titleLbl.text = "PASSWORD"
            textField1.placeholder = "confirm your password"
            view.addSubview(textField1)
        } else {
            print("something is wrongggg")
        }
        
        
        
        
        
        
        
        
        
        
        let sportsScrollViewY = CGFloat(64+64+64+30)
        sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
        sportsScrollView.frame = CGRectMake(0, sportsScrollViewY+64+30, view.frame.size.width, 120) 
        sportsScrollView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        sportsScrollView.delegate = self
        sportsScrollView.pagingEnabled = false
        sportsScrollView.showsHorizontalScrollIndicator = true
        sportsScrollView.showsVerticalScrollIndicator = false
        sportsScrollView.scrollsToTop = true
        sportsScrollView.scrollEnabled = true
        sportsScrollView.bounces = true
        sportsScrollView.alwaysBounceVertical = false
        sportsScrollView.alwaysBounceHorizontal = true
        sportsScrollView.userInteractionEnabled = true
        view.addSubview(sportsScrollView)
        
        let padding = 2*sportsArray.count
        let width = 100*sportsArray.count
        let totalWidth = CGFloat(width+padding+20+20)
        sportsScrollView.contentSize = CGSize(width: totalWidth, height: sportsScrollView.frame.size.height)
        sportsScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        //
        
        buildSportsScrollView()

        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textField1.becomeFirstResponder()
    }
    
    func xBtnAction() {
        view.endEditing(true)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buildSportsScrollView() {
        
        for (index, element) in sportsArray.enumerate() {
            print("Item \(index): \(element)")
            
            let sport = element as! String
            let i = CGFloat(index)
            let x = 20+(100*i)
            let pad = 2*i
            let f = CGRectMake(x+pad, 0, 100, 120)
            
            let sportBtn = UIButton(type: UIButtonType.Custom)
            sportBtn.frame = f
            sportBtn.setImage(UIImage(named: "sportBtn-sport.png"), forState: .Normal)
            sportBtn.setImage(UIImage(named: "sportBtn-sport.png"), forState: .Highlighted)
            sportBtn.setImage(UIImage(named: "sportBtn-sport.png"), forState: .Selected)
            
            sportBtn.setBackgroundImage(UIImage(named: ""), forState: .Normal)
            sportBtn.setBackgroundImage(UIImage(named: "goldTabBar.png"), forState: .Selected)
            
            sportBtn.backgroundColor = UIColor.blueColor()
            sportBtn.addTarget(self, action:#selector(sportBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            
            sportBtn.tag = NSInteger(i)
            
            sportBtn.titleLabel?.numberOfLines = 1
            sportBtn.titleLabel?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
            sportBtn.contentHorizontalAlignment = .Center
            sportBtn.contentVerticalAlignment = .Bottom
            sportBtn.titleLabel?.textAlignment = .Center
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            sportBtn.setTitle(sport, forState: UIControlState.Normal)
            
            
            sportsScrollView.addSubview(sportBtn)
            
            
            
        }
        
        
    }
    
    func sportBtnAction(sender: UIButton) {
        print(sender.tag)
        print(sender.currentTitle!)
        
        if (sender.selected) {
            sender.selected = false
            selectedSportsArray.removeObject(sender.currentTitle!)
        } else {
            sender.selected = true
            selectedSportsArray.addObject(sender.currentTitle!)
        }
        
    }
    
    
    func saveBtnAction() {
        
        
        
        
        // if logged in correctly
        
        //
        
        view.endEditing(true)
        navigationController?.dismissViewControllerAnimated(false, completion: nil)
        (UIApplication.sharedApplication().delegate as! AppDelegate).presentTabBarViewController()
        
        
    }



}
