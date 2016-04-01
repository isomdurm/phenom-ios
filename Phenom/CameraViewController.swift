//
//  CameraViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/29/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, FSCameraViewDelegate, FSAlbumViewDelegate, FusumaDelegate {

    var navBarView = UIView()
    
    let titleLbl = UILabel()
    
    var albumViewerContainer: UIView!
    var cameraViewerContainer: UIView!
    var statusViewerContainer: UIView!
    
    var albumView  = FSAlbumView.instance()
    var cameraView = FSCameraView.instance()
    
    var delegate: FusumaDelegate? = nil
    
    var albumBtn = UIButton()
    var cameraBtn = UIButton()
    var statusBtn = UIButton()
    
    var imgToPass = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        
        //let bottomHeight = self.view.frame.size.height-64-self.view.frame.size.width
        //albumViewerContainer = UIView(frame: CGRectMake(0, 64+self.view.frame.size.width, self.view.frame.size.width, bottomHeight))
        albumViewerContainer = UIView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50))
        albumViewerContainer.backgroundColor = UIColor.greenColor() // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(albumViewerContainer)
        
        cameraViewerContainer = UIView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50))
        cameraViewerContainer.backgroundColor = UIColor.greenColor() // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(cameraViewerContainer)
        
        statusViewerContainer = UIView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50))
        statusViewerContainer.backgroundColor = UIColor.yellowColor() // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(statusViewerContainer)
        
        albumView.delegate  = self
        cameraView.delegate = self
        
        albumViewerContainer.addSubview(albumView)
        cameraViewerContainer.addSubview(cameraView)
        
        //
        
        cameraViewerContainer.hidden = true
        statusViewerContainer.hidden = true
        
        
        //
        //
        //
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, 20, 70, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(CameraViewController.xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(xBtn)
        
        titleLbl.frame = CGRectMake(0, 20, self.navBarView.frame.size.width, 44)
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "CAMERA ROLL"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)

        let nextBtn = UIButton()
        nextBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        nextBtn.backgroundColor = UIColor.blueColor()
        nextBtn.addTarget(self, action:#selector(CameraViewController.nextBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        nextBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        nextBtn.titleLabel?.numberOfLines = 1
        nextBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        nextBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        nextBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        nextBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        nextBtn.setTitle("Next", forState: UIControlState.Normal)
        self.navBarView.addSubview(nextBtn)
        
        //
        
        albumBtn = UIButton(type: UIButtonType.Custom)
        albumBtn.frame = CGRectMake(self.view.frame.size.width/3*0, self.view.frame.size.height-50, self.view.frame.size.width/3, 50)
        albumBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //albumBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        albumBtn.backgroundColor = UIColor.blueColor()
        albumBtn.addTarget(self, action:#selector(CameraViewController.albumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(albumBtn)
        
        cameraBtn = UIButton(type: UIButtonType.Custom)
        cameraBtn.frame = CGRectMake(self.view.frame.size.width/3*1, self.view.frame.size.height-50, self.view.frame.size.width/3, 50)
        cameraBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //cameraBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        cameraBtn.backgroundColor = UIColor.redColor()
        cameraBtn.addTarget(self, action:#selector(CameraViewController.cameraBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(cameraBtn)
        
        statusBtn = UIButton(type: UIButtonType.Custom)
        statusBtn.frame = CGRectMake(self.view.frame.size.width/3*2, self.view.frame.size.height-50, self.view.frame.size.width/3, 50)
        statusBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //statusBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        statusBtn.backgroundColor = UIColor.orangeColor()
        statusBtn.addTarget(self, action:#selector(CameraViewController.statusBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(statusBtn)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        albumView.frame  = CGRect(origin: CGPointZero, size: albumViewerContainer.frame.size)
        albumView.layoutIfNeeded()
        cameraView.frame = CGRect(origin: CGPointZero, size: cameraViewerContainer.frame.size)
        cameraView.layoutIfNeeded()
        
        albumView.initialize()
        cameraView.initialize()
        
    }
    
    func albumBtnAction() {
        albumViewerContainer.hidden = false
        cameraViewerContainer.hidden = true
        statusViewerContainer.hidden = true
        titleLbl.text = "CAMERA ROLL"

    }
    
    func cameraBtnAction() {
        albumViewerContainer.hidden = true
        cameraViewerContainer.hidden = false
        statusViewerContainer.hidden = true
        titleLbl.text = "CAMERA"
    }
    
    func statusBtnAction() {
        albumViewerContainer.hidden = true
        cameraViewerContainer.hidden = true
        statusViewerContainer.hidden = false
        titleLbl.text = "STATUS"
    }
    
    func xBtnAction() {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
        cameraView.session?.stopRunning()
        
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func nextBtnAction() {
        
        if (self.albumViewerContainer.hidden) {
            
            let vc = ComposeViewController()
            vc.passedImage = self.imgToPass
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let view = albumView.imageCropView
            
            UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
            let context = UIGraphicsGetCurrentContext()
            CGContextTranslateCTM(context, -albumView.imageCropView.contentOffset.x, -albumView.imageCropView.contentOffset.y)
            view.layer.renderInContext(context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            delegate?.fusumaImageSelected(image)
            
            self.imgToPass = image
            
            let vc = ComposeViewController()
            vc.passedImage = self.imgToPass
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
    ///////////
    
    // MARK: FSCameraViewDelegate
    func cameraShotFinished(image: UIImage) {
        
        delegate?.fusumaImageSelected(image)
//        self.dismissViewControllerAnimated(true, completion: {
//            
//            self.delegate?.fusumaDismissedWithImage?(image)
//        })
        
        self.imgToPass = image
        
        // display "REDO" button in top right, to the left of the "nextBtn"
        
        
    }
    
    // MARK: FSAlbumViewDelegate
    func albumViewCameraRollUnauthorized() {
        
        delegate?.fusumaCameraRollUnauthorized()
    }
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(image: UIImage) {
        
        print("Image selected")
        //imageView.image = image
        
        self.imgToPass = image
        
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        print("Called when the close button is pressed")
    }
    

}
