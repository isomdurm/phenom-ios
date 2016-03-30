//
//  NewViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    var navBarView = UIView()
    
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
        xBtn.addTarget(self, action:#selector(NewViewController.xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 0, self.navBarView.frame.size.width, 64))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "NEW"
        titleLbl.font = UIFont.boldSystemFontOfSize(20)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func xBtnAction() {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
}
