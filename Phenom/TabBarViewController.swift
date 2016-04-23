//
//  TabBarViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        tabBar.tintColor = UINavigationBar.appearance().tintColor
        tabBar.backgroundImage = UIImage(named: "blackTabBar.png") //goldTabBar.png
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setViewControllers(viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        let centerBtn = UIButton(type: UIButtonType.Custom)
        centerBtn.frame = CGRectMake(tabBar.bounds.size.width/5*2, 0, tabBar.bounds.size.width/5, tabBar.bounds.size.height)
        centerBtn.backgroundColor = UIColor.blackColor()
        //centerBtn.setBackgroundImage(UIImage.init(named: "blueNav.png") , forState: UIControlState.Normal)
        //centerBtn.setBackgroundImage(UIImage.init(named: "blueNavHighlighted.png") , forState: UIControlState.Highlighted)
        centerBtn.addTarget(self, action:#selector(centerBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        centerBtn.titleLabel?.numberOfLines = 1
        centerBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 40)
        centerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        centerBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        centerBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        centerBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //centerBtn.setTitleColor(UIColor(red:195/255, green:125/255, blue:200/255, alpha:1), forState: UIControlState.Highlighted)
        centerBtn.setTitle("+", forState: UIControlState.Normal)
        tabBar.addSubview(centerBtn)
        centerBtn.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        
    }
    
    func centerBtnAction() {
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).addMomentView != nil) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).removeAddMomentView()
        }
        
        UIView.animateWithDuration(0.38, delay:0.0, options: .CurveEaseOut, animations: {
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.92, 0.92)
            
            }, completion: { finished in
                if (finished) {
                    
                    //let newnav = UINavigationController(rootViewController: CreateViewController()) //PickerViewController() //CameraViewController()  //
                    //newnav.navigationController?.navigationBarHidden = true
                    
                    self.presentViewController(PickMediaViewController(), animated: true, completion: nil)
                    
                    
                }
        })
        
    }
    
    
    
}
