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
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.blueColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "PROFILE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let signUpBtn = UIButton(type: UIButtonType.Custom)
        signUpBtn.frame = CGRectMake(view.frame.size.width-70-20, 20, 70, 44)
        signUpBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //signUpBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        signUpBtn.backgroundColor = UIColor.blueColor()
        signUpBtn.addTarget(self, action:#selector(signUpBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(signUpBtn)
        
        
        let profileWidth = view.frame.size.width/3
        let profileY = 64+(profileWidth/3)
        
        profileImgView.frame = CGRectMake(view.frame.size.width/2-(profileWidth/2), profileY, profileWidth, profileWidth)
        profileImgView.backgroundColor = UIColor.blueColor()
        view.addSubview(profileImgView)
        
        let locationY = profileY+profileWidth+30
        locationField.frame = CGRectMake(20, locationY, view.frame.size.width-40, 64)
        locationField.backgroundColor = UIColor.clearColor()
        locationField.delegate = self
        locationField.textColor = UIColor.whiteColor()
        locationField.attributedPlaceholder = NSAttributedString(string:"your location",attributes:[NSForegroundColorAttributeName: UIColor(red:73/255, green:73/255, blue:75/255, alpha:1)])
        locationField.keyboardType = UIKeyboardType.Default
        locationField.returnKeyType = UIReturnKeyType.Next
        locationField.enablesReturnKeyAutomatically = true
        locationField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        locationField.placeholder = "your location"
        locationField.autocapitalizationType = UITextAutocapitalizationType.None
        locationField.autocorrectionType = UITextAutocorrectionType.No
        view.addSubview(locationField)
        locationField.text = ""
        
        sportsArray = NSMutableArray(array: ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"])
        sportsScrollView.frame = CGRectMake(0, locationY+64+30, view.frame.size.width, 120)
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
        
        buildSportsScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
        
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
            sportBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 13)
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
    
    func signUpBtnAction() {
        
        
    }



}
