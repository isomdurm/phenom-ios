//
//  CreateViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/14/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    var navBarView = UIView()
    
    let titleLbl = UILabel()
    
    var albumBtn = UIButton()
    var cameraBtn = UIButton()
    var statusBtn = UIButton()
    
    var imgToPass = UIImage()
    
    var savedKeyboardHeight = CGFloat()
    var statusTextView = KMPlaceholderTextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(xBtn)
        
        titleLbl.frame = CGRectMake(0, 20, navBarView.frame.size.width, 44)
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "CAMERA ROLL"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let nextBtn = UIButton()
        nextBtn.frame = CGRectMake(view.frame.size.width-70-20, 20, 70, 44)
        nextBtn.backgroundColor = UIColor.blueColor()
        //nextBtn.addTarget(self, action:#selector(nextBtnAction), forControlEvents:.TouchUpInside)
        nextBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        nextBtn.titleLabel?.numberOfLines = 1
        nextBtn.contentHorizontalAlignment = .Center
        nextBtn.contentVerticalAlignment = .Center
        nextBtn.titleLabel?.textAlignment = .Center
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        nextBtn.setTitle("Next", forState: .Normal)
        navBarView.addSubview(nextBtn)
    
        //
        
        //let btnWidth = ((view.frame.size.width/2)/4)*3
        //let btnWidth = (view.frame.size.width/3)*2
        
        let topContainerHeight = self.view.frame.size.width+100
        let bottomContainerHeight = self.view.frame.size.height-64-topContainerHeight
        
        let topView = UIView(frame: CGRectMake(0, 64, view.frame.size.width, topContainerHeight))
        topView.backgroundColor = UIColor.darkGrayColor()
        view.addSubview(topView)
        
        
        
        
        let bottomContainerView = UIView(frame: CGRectMake(0, view.frame.size.height-bottomContainerHeight, view.frame.size.width, bottomContainerHeight))
        bottomContainerView.backgroundColor = UIColor.lightGrayColor() // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(bottomContainerView)
        
        albumBtn = UIButton(type: UIButtonType.Custom)
        albumBtn.frame = CGRectMake(bottomContainerView.frame.size.width/3*0, bottomContainerView.frame.size.height-50, bottomContainerView.frame.size.width/3, 50)
        albumBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //albumBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        albumBtn.backgroundColor = UIColor.blueColor()
        //albumBtn.addTarget(self, action:#selector(albumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        bottomContainerView.addSubview(albumBtn)
        
        cameraBtn = UIButton(type: UIButtonType.Custom)
        cameraBtn.frame = CGRectMake(bottomContainerView.frame.size.width/3*1, bottomContainerView.frame.size.height-50, bottomContainerView.frame.size.width/3, 50)
        cameraBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //cameraBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        cameraBtn.backgroundColor = UIColor.redColor()
        //cameraBtn.addTarget(self, action:#selector(cameraBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        bottomContainerView.addSubview(cameraBtn)
        
        statusBtn = UIButton(type: UIButtonType.Custom)
        statusBtn.frame = CGRectMake(bottomContainerView.frame.size.width/3*2, bottomContainerView.frame.size.height-50, bottomContainerView.frame.size.width/3, 50)
        statusBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //statusBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        statusBtn.backgroundColor = UIColor.orangeColor()
        //statusBtn.addTarget(self, action:#selector(statusBtnAction), forControlEvents:.TouchUpInside)
        bottomContainerView.addSubview(statusBtn)
        
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func xBtnAction() {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
        //cameraView.session?.stopRunning()
        
        view.endEditing(true)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
   
    

}
