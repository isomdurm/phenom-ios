//
//  TabBarViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        tabBar.tintColor = UINavigationBar.appearance().tintColor
        tabBar.backgroundImage = UIImage(named: "blackTabBar.png") //goldTabBar.png
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        let centerBtn = UIButton(type: UIButtonType.custom)
        centerBtn.frame = CGRect(x: tabBar.bounds.size.width/5*2, y: 0, width: tabBar.bounds.size.width/5, height: tabBar.bounds.size.height)
        centerBtn.backgroundColor = UIColor.black
        //centerBtn.setBackgroundImage(UIImage.init(named: "blueNav.png") , forState: UIControlState.Normal)
        //centerBtn.setBackgroundImage(UIImage.init(named: "blueNavHighlighted.png") , forState: UIControlState.Highlighted)
        centerBtn.addTarget(self, action:#selector(centerBtnAction), for:UIControlEvents.touchUpInside)
        centerBtn.titleLabel?.numberOfLines = 1
        centerBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 40)
        centerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        centerBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        centerBtn.titleLabel?.textAlignment = NSTextAlignment.center
        centerBtn.setTitleColor(UIColor.white, for: UIControlState())
        //centerBtn.setTitleColor(UIColor(red:195/255, green:125/255, blue:200/255, alpha:1), forState: UIControlState.Highlighted)
        centerBtn.setTitle("+", for: UIControlState())
        tabBar.addSubview(centerBtn)
        centerBtn.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        
    }
    
    func centerBtnAction() {
        
        if ((UIApplication.shared.delegate as! AppDelegate).addMomentView != nil) {
            (UIApplication.shared.delegate as! AppDelegate).removeAddMomentView()
        }
        
        UIView.animate(withDuration: 0.38, delay:0.0, options: .curveEaseOut, animations: {
            
            (UIApplication.shared.delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransform.identity.scaledBy(x: 0.92, y: 0.92)
            
            }, completion: { finished in
                if (finished) {
                    
                    //let newnav = UINavigationController(rootViewController: CreateViewController()) //PickerViewController() //CameraViewController()  //
                    //newnav.navigationController?.navigationBarHidden = true
                    
                    self.present(PickMediaViewController(), animated: true, completion: nil)
                    
                    
                }
        })
        
    }
    
    
    
}
