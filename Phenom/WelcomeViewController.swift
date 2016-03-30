//
//  WelcomeViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

    var theScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor.blackColor()
    
        self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200)
        self.theScrollView.backgroundColor = UIColor.yellowColor()
        self.theScrollView.delegate = self
        self.theScrollView.pagingEnabled = true
        self.theScrollView.showsHorizontalScrollIndicator = false
        self.theScrollView.showsVerticalScrollIndicator = false
        self.theScrollView.scrollsToTop = false //true
        self.theScrollView.scrollEnabled = false //true
        self.theScrollView.bounces = false //true
        self.theScrollView.alwaysBounceHorizontal = false // true
        self.theScrollView.userInteractionEnabled = true
        self.view.addSubview(self.theScrollView)
        self.theScrollView.contentSize = CGSize(width: self.theScrollView.frame.size.width, height: self.theScrollView.frame.size.height)
        self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        self.theScrollView.alpha = 0.0

        let imgView1 = UIImageView()
        imgView1.frame = CGRectMake(0, 0, self.theScrollView.frame.size.width, self.theScrollView.frame.size.height)
        imgView1.backgroundColor = UIColor.greenColor()
        self.theScrollView.addSubview(imgView1)
        
        
        //
        
        let containerView = UIView(frame: CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 200))
        containerView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(containerView)
        
        let fbBtn = UIButton(type: UIButtonType.Custom)
        fbBtn.frame = CGRectMake(containerView.frame.width/2-50, 11, 100, 52)
        fbBtn.setImage(UIImage(named: "fb-signin.png"), forState: UIControlState.Normal)
        //addBtn.setBackgroundImage(UIImage(named: "plus60.png"), forState: UIControlState.Normal)
        fbBtn.backgroundColor = UIColor.blueColor()
        fbBtn.addTarget(self, action:#selector(WelcomeViewController.fbBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        containerView.addSubview(fbBtn)
        
        let signinBtn = UIButton(type: UIButtonType.Custom)
        signinBtn.backgroundColor = UIColor.blueColor()
        signinBtn.frame = CGRectMake(containerView.frame.width/2-50, 11+52+11, 100, 52)
        signinBtn.addTarget(self, action:#selector(WelcomeViewController.signinBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        signinBtn.titleLabel?.numberOfLines = 1
        signinBtn.titleLabel?.font = UIFont.systemFontOfSize(22)
        signinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        signinBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        signinBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        signinBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signinBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        containerView.addSubview(signinBtn)
        signinBtn.setTitle("Sign In", forState: UIControlState.Normal)
        
        let signupBtn = UIButton(type: UIButtonType.Custom)
        signupBtn.backgroundColor = UIColor.blueColor()
        signupBtn.frame = CGRectMake(containerView.frame.width/2-50, 11+52+11+52+11, 100, 52)
        signupBtn.addTarget(self, action:#selector(WelcomeViewController.signupBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        signupBtn.titleLabel?.numberOfLines = 1
        signupBtn.titleLabel?.font = UIFont.systemFontOfSize(22)
        signupBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        signupBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        signupBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        signupBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        signupBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        containerView.addSubview(signupBtn)
        signupBtn.setTitle("Sign Up", forState: UIControlState.Normal)
        
        //

        self.animateScrollViewToPostition()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func animateScrollViewToPostition() {
        
        UIView.animateWithDuration(0.80, delay:0.0, options: .CurveEaseInOut, animations: {
            
            self.theScrollView.alpha = 1.0
            
            }, completion: { finished in
                
                
        })
        
        
    }
    
    func fbBtnAction() {
        
    }
    
    func signinBtnAction() {
        let newnav = UINavigationController(rootViewController: SignInViewController())
        self.navigationController?.presentViewController(newnav, animated: true, completion: nil)
    }
    
    func signupBtnAction() {
        let newnav = UINavigationController(rootViewController: SignUpViewController())
        self.navigationController?.presentViewController(newnav, animated: true, completion: nil)
        
    }


}
