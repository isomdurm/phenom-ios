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
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
    
        theScrollView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-200)
        theScrollView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theScrollView.delegate = self
        theScrollView.pagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = false
        theScrollView.scrollsToTop = false //true
        theScrollView.scrollEnabled = false //true
        theScrollView.bounces = false //true
        theScrollView.alwaysBounceHorizontal = false // true
        theScrollView.userInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        theScrollView.alpha = 0.0

        let imgView1 = UIImageView()
        imgView1.frame = CGRectMake(0, 0, theScrollView.frame.size.width, theScrollView.frame.size.height)
        imgView1.backgroundColor = UIColor.greenColor()
        theScrollView.addSubview(imgView1)
        
        
        //
        
        let containerView = UIView(frame: CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200))
        containerView.backgroundColor = UIColor.grayColor()
        view.addSubview(containerView)
        
        let fbBtn = UIButton(type: UIButtonType.Custom)
        fbBtn.frame = CGRectMake(containerView.frame.width/2-50, 11, 100, 52)
        fbBtn.setImage(UIImage(named: "fb-signin.png"), forState: UIControlState.Normal)
        //addBtn.setBackgroundImage(UIImage(named: "plus60.png"), forState: UIControlState.Normal)
        fbBtn.backgroundColor = UIColor.blueColor()
        fbBtn.addTarget(self, action:#selector(fbBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        containerView.addSubview(fbBtn)
        
        let signinBtn = UIButton(type: UIButtonType.Custom)
        signinBtn.backgroundColor = UIColor.blueColor()
        signinBtn.frame = CGRectMake(containerView.frame.width/2-50, 11+52+11, 100, 52)
        signinBtn.addTarget(self, action:#selector(signinBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
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
        signupBtn.addTarget(self, action:#selector(signupBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
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

        animateScrollViewToPostition()
        
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
        navigationController?.presentViewController(newnav, animated: true, completion: nil)
    }
    
    func signupBtnAction() {
        let newnav = UINavigationController(rootViewController: SignUpEmailViewController())
        navigationController?.presentViewController(newnav, animated: true, completion: nil)
        
    }


}
