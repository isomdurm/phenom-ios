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
        self.view.backgroundColor = UIColor.blackColor()
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.tabBar.tintColor = UINavigationBar.appearance().tintColor
        self.tabBar.backgroundImage = UIImage(named: "goldTabBar.png")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setViewControllers(viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        let centerBtn = UIButton(type: UIButtonType.Custom)
        centerBtn.frame = CGRectMake(self.tabBar.bounds.size.width/5*2, -10, self.tabBar.bounds.size.width/5, self.tabBar.bounds.size.height+10)
        centerBtn.backgroundColor = UIColor.blackColor()
        //centerBtn.setBackgroundImage(UIImage.init(named: "blueNav.png") , forState: UIControlState.Normal)
        //centerBtn.setBackgroundImage(UIImage.init(named: "blueNavHighlighted.png") , forState: UIControlState.Highlighted)
        centerBtn.addTarget(self, action:#selector(TabBarViewController.centerBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        centerBtn.titleLabel?.numberOfLines = 1
        centerBtn.titleLabel?.font = UIFont.systemFontOfSize(40, weight: UIFontWeightBold)
        centerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        centerBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        centerBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        centerBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //centerBtn.setTitleColor(UIColor(red:195/255, green:125/255, blue:200/255, alpha:1), forState: UIControlState.Highlighted)
        centerBtn.setTitle("+", forState: UIControlState.Normal)
        self.tabBar.addSubview(centerBtn)
        centerBtn.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
    }
    
    func centerBtnAction() {
        
        UIView.animateWithDuration(0.35, delay:0.0, options: .CurveEaseInOut, animations: {
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95, 0.95)
            
            }, completion: { finished in
                if (finished) {
                    let newnav = UINavigationController(rootViewController: CameraViewController())
                    self.presentViewController(newnav, animated: true, completion: nil)
                }
        })
        
    }
    
}
