//
//  SignUpDetailViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class SignUpDetailViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {

    var navBarView = UIView()
    var profileImgView = UIImageView()
    var locationField: UITextField = UITextField()
    
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
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.blueColor()
        backBtn.addTarget(self, action:#selector(self.backBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PROFILE"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        let signUpBtn = UIButton(type: UIButtonType.Custom)
        signUpBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        signUpBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //signUpBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signUpBtn.backgroundColor = UIColor.blueColor()
        signUpBtn.addTarget(self, action:#selector(self.signUpBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(signUpBtn)
        
        
        let profileWidth = self.view.frame.size.width/3
        let profileY = 64+(profileWidth/3)
        
        self.profileImgView.frame = CGRectMake(self.view.frame.size.width/2-(profileWidth/2), profileY, profileWidth, profileWidth)
        self.profileImgView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(self.profileImgView)
        
        let locationY = profileY+profileWidth+30
        locationField.frame = CGRectMake(20, locationY, self.view.frame.size.width-40, 64)
        locationField.backgroundColor = UIColor.clearColor()
        locationField.delegate = self
        locationField.textColor = UIColor.whiteColor()
        locationField.attributedPlaceholder = NSAttributedString(string:"your location",attributes:[NSForegroundColorAttributeName: UIColor(red:61/255, green:61/255, blue:61/255, alpha:1)])
        locationField.keyboardType = UIKeyboardType.Default
        locationField.returnKeyType = UIReturnKeyType.Next
        locationField.enablesReturnKeyAutomatically = true
        locationField.font = UIFont.systemFontOfSize(17)
        locationField.placeholder = "your location"
        locationField.autocapitalizationType = UITextAutocapitalizationType.None
        locationField.autocorrectionType = UITextAutocorrectionType.No
        self.view.addSubview(locationField)
        locationField.text = ""
        
        self.sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
        self.sportsScrollView.frame = CGRectMake(0, locationY+64+30, self.view.frame.size.width, 120)
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
        
        self.buildSportsScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backBtnAction() {
        self.navigationController?.popViewControllerAnimated(true)
        
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
    
    func signUpBtnAction() {
        
        
    }



}
