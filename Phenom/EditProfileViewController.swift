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
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor.blackColor()
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(self.xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        //titleLbl.text = "EDIT PROFILE"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        let saveBtn = UIButton(type: UIButtonType.Custom)
        saveBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        saveBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //saveBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        saveBtn.backgroundColor = UIColor.blueColor()
        saveBtn.addTarget(self, action:#selector(self.saveBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(saveBtn)
        
        textField1.frame = CGRectMake(20, 64, self.view.frame.size.width-40, 64)
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
        
        textField2.frame = CGRectMake(20, 64+64, self.view.frame.size.width-40, 64)
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
        lineview1.frame = CGRectMake(0, 64+63.5, self.view.frame.size.width, 0.5)
        lineview1.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.view.addSubview(lineview1)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, self.view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        
        
        
        
        if (passedEditType == "name") {
            titleLbl.text = "NAME"
            textField1.placeholder = "your first name"
            textField2.placeholder = "your last name"
            self.view.addSubview(textField1)
            self.view.addSubview(textField2)
            self.view.addSubview(lineview2)
        } else if (passedEditType == "username") {
            titleLbl.text = "USERNAME"
            textField1.placeholder = "username"
            self.view.addSubview(textField1)
        } else if (passedEditType == "birthday") {
            titleLbl.text = "BIRTHDAY"
            textField1.placeholder = "your birthday"
            self.view.addSubview(textField1)
        } else if (passedEditType == "hometown") {
            titleLbl.text = "HOMETOWN"
            textField1.placeholder = "your hometown"
            self.view.addSubview(textField1)
        } else if (passedEditType == "sports") {
            
            titleLbl.text = "SPORTS"
            
            // show tableview
            
            
            
        } else if (passedEditType == "bio") {
            
            titleLbl.text = "BIO"
            textField1.placeholder = "bio"
            self.view.addSubview(textField1)
            
            
        } else if (passedEditType == "email") {
            titleLbl.text = "EMAIL"
            textField1.placeholder = "your email"
            self.view.addSubview(textField1)
        } else if (passedEditType == "password") {
            titleLbl.text = "PASSWORD"
            textField1.placeholder = "confirm your password"
            self.view.addSubview(textField1)
        } else {
            print("something is wrongggg")
        }
        
        
        
        
        
        
        
        
        
        
        let sportsScrollViewY = CGFloat(64+64+64+30)
        self.sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
        self.sportsScrollView.frame = CGRectMake(0, sportsScrollViewY+64+30, self.view.frame.size.width, 120) 
        self.sportsScrollView.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        self.sportsScrollView.delegate = self
        self.sportsScrollView.pagingEnabled = false
        self.sportsScrollView.showsHorizontalScrollIndicator = true
        self.sportsScrollView.showsVerticalScrollIndicator = false
        self.sportsScrollView.scrollsToTop = true
        self.sportsScrollView.scrollEnabled = true
        self.sportsScrollView.bounces = true
        self.sportsScrollView.alwaysBounceVertical = false
        self.sportsScrollView.alwaysBounceHorizontal = true
        self.sportsScrollView.userInteractionEnabled = true
        self.view.addSubview(self.sportsScrollView)
        
        let padding = 2*self.sportsArray.count
        let width = 100*self.sportsArray.count
        let totalWidth = CGFloat(width+padding+20+20)
        self.sportsScrollView.contentSize = CGSize(width: totalWidth, height: self.sportsScrollView.frame.size.height)
        self.sportsScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        //
        
        self.buildSportsScrollView()

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
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buildSportsScrollView() {
        
        for (index, element) in self.sportsArray.enumerate() {
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
            sportBtn.addTarget(self, action:#selector(self.sportBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
            
            sportBtn.tag = NSInteger(i)
            
            sportBtn.titleLabel?.numberOfLines = 1
            sportBtn.titleLabel?.font = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
            sportBtn.contentHorizontalAlignment = .Center
            sportBtn.contentVerticalAlignment = .Bottom
            sportBtn.titleLabel?.textAlignment = .Center
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            sportBtn.setTitle(sport, forState: UIControlState.Normal)
            
            
            self.sportsScrollView.addSubview(sportBtn)
            
            
            
        }
        
        
    }
    
    func sportBtnAction(sender: UIButton) {
        print(sender.tag)
        print(sender.currentTitle!)
        
        if (sender.selected) {
            sender.selected = false
            self.selectedSportsArray.removeObject(sender.currentTitle!)
        } else {
            sender.selected = true
            self.selectedSportsArray.addObject(sender.currentTitle!)
        }
        
    }
    
    
    func saveBtnAction() {
        
        
        
        
        // if logged in correctly
        
        //
        
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(false, completion: nil)
        (UIApplication.sharedApplication().delegate as! AppDelegate).presentTabBarViewController()
        
        
    }



}
