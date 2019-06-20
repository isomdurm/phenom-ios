//
//  WelcomeViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

    var theScrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
    
        //theScrollView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-200)
        theScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-160)
        theScrollView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theScrollView.delegate = self
        theScrollView.isPagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = false
        theScrollView.scrollsToTop = false //true
        theScrollView.isScrollEnabled = false //true
        theScrollView.bounces = false //true
        theScrollView.alwaysBounceHorizontal = false // true
        theScrollView.isUserInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        theScrollView.alpha = 0.0

        let imgView1 = UIImageView()
        imgView1.frame = CGRect(x: 0, y: 0, width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
        imgView1.backgroundColor = UIColor.orange
        theScrollView.addSubview(imgView1)
        
        //
        
        
//        let btnWidth = (view.frame.size.width/3)*2
//        
//        //let containerView = UIView(frame: CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200))
//        //containerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
//        //view.addSubview(containerView)
//        
//        let fbBtn = UIButton(type: UIButtonType.Custom)
//        fbBtn.frame = CGRectMake((view.frame.size.width/2)-(btnWidth/2), 11, btnWidth, 52)
//        fbBtn.setImage(UIImage(named: "fb-signin.png"), forState: UIControlState.Normal)
//        //addBtn.setBackgroundImage(UIImage(named: "plus60.png"), forState: UIControlState.Normal)
//        fbBtn.backgroundColor = UIColor.blueColor()
//        fbBtn.addTarget(self, action:#selector(fbBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
//        //containerView.addSubview(fbBtn)
        
        let signinBtn = UIButton(type: UIButtonType.custom)
        signinBtn.backgroundColor = UIColor.red // UINavigationBar.appearance().tintColor
        //signinBtn.frame = CGRectMake((view.frame.size.width/2)-(btnWidth/2), containerView.frame.size.height/2-70, btnWidth, 60)
        signinBtn.frame = CGRect(x: 0, y: view.frame.size.height-80-80, width: view.frame.size.width, height: 80)
        signinBtn.addTarget(self, action:#selector(signinBtnAction), for:UIControlEvents.touchUpInside)
        signinBtn.titleLabel?.numberOfLines = 1
        signinBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 20)
        signinBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        signinBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        signinBtn.titleLabel?.textAlignment = NSTextAlignment.center
        signinBtn.setTitleColor(UIColor.white, for: UIControlState())
        signinBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        view.addSubview(signinBtn)
        signinBtn.setTitle("LOG IN", for: UIControlState())
        
        let signupBtn = UIButton(type: UIButtonType.custom)
        signupBtn.backgroundColor = UINavigationBar.appearance().tintColor
        //signupBtn.frame = CGRectMake((view.frame.size.width/2)-(btnWidth/2), containerView.frame.size.height/2+10, btnWidth, 60)
        signupBtn.frame = CGRect(x: 0, y: view.frame.size.height-80, width: view.frame.size.width, height: 80)
        signupBtn.addTarget(self, action:#selector(signupBtnAction), for:UIControlEvents.touchUpInside)
        signupBtn.titleLabel?.numberOfLines = 1
        signupBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 20)
        signupBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        signupBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        signupBtn.titleLabel?.textAlignment = NSTextAlignment.center
        signupBtn.setTitleColor(UIColor.white, for: UIControlState())
        signupBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        view.addSubview(signupBtn)
        signupBtn.setTitle("SIGN UP", for: UIControlState())
        
        //

        animateScrollViewToPostition()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func animateScrollViewToPostition() {
        
        UIView.animate(withDuration: 0.80, delay:0.0, options: UIViewAnimationOptions(), animations: {
            
            self.theScrollView.alpha = 1.0
            
            }, completion: { finished in
                
                
        })
        
        
    }
    
    func fbBtnAction() {
        
    }
    
    func signinBtnAction() {
        let newnav = UINavigationController(rootViewController: SignInViewController())
        navigationController?.present(newnav, animated: true, completion: nil)
    }
    
    func signupBtnAction() {
        let newnav = UINavigationController(rootViewController: SignUpEmailViewController())
        navigationController?.present(newnav, animated: true, completion: nil)
        
    }


}
