//
//  CreateViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/14/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore

class CreateViewController: UIViewController {

    
    var cameraView = UIView()
    let cameraManager = CameraManager()
    var captureBtn =  UIButton(type: UIButtonType.Custom)
    
    var imgToPass = UIImage()
    
    var albumBtn = UIButton(type: UIButtonType.Custom)
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        
        //cameraView = UIView(frame: CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49))
        cameraView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-100)
        cameraView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(cameraView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(20, self.view.frame.size.height-40-20, 40, 40)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(xBtn)
        
        captureBtn.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height-80-10, 80, 80)
        captureBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //captureBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        captureBtn.backgroundColor = UIColor.purpleColor()
        captureBtn.addTarget(self, action:#selector(captureBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        //self.view.insertSubview(captureBtn, aboveSubview: self.cameraView)
        self.view.addSubview(captureBtn)
        captureBtn.layer.cornerRadius = captureBtn.frame.size.width/2
        captureBtn.layer.masksToBounds = true

        let albumBtn = UIButton()
        albumBtn.frame = CGRectMake(view.frame.size.width-40-20, self.view.frame.size.height-40-20, 40, 40)
        albumBtn.backgroundColor = UIColor.blueColor()
        albumBtn.addTarget(self, action:#selector(albumBtnAction), forControlEvents:.TouchUpInside)
        albumBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        albumBtn.titleLabel?.numberOfLines = 1
        albumBtn.contentHorizontalAlignment = .Center
        albumBtn.contentVerticalAlignment = .Center
        albumBtn.titleLabel?.textAlignment = .Center
        albumBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        albumBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        albumBtn.setTitle("Next", forState: .Normal)
        self.view.addSubview(albumBtn)
        
        //
        
        self.addCameraToView()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = true
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().statusBarHidden = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // camera functions
    
    func askForCameraPermissions(sender: UIButton) {
        
        cameraManager.askUserForCameraPermissions({ permissionGranted in
            //self.askForPermissionsButton.hidden = true
            //self.askForPermissionsLabel.hidden = true
            //self.askForPermissionsButton.alpha = 0
            //self.askForPermissionsLabel.alpha = 0
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }
   
    private func addCameraToView() {
        
        if (!cameraManager.cameraIsReady) {
            
            cameraManager.addPreviewLayerToView(self.cameraView, newCameraOutputMode: CameraOutputMode.StillImage)
            cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
                
                let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in  }))
                self?.presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        
        
    }

    //func recordButtonTapped(sender: UIButton) {
    func captureBtnAction(sender: UIButton) {
        
        // start
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: (view.frame.size.height-100)/2)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ///
        
        switch (cameraManager.cameraOutputMode) {
        case .StillImage:
            cameraManager.capturePictureWithCompletition({ (image, error) -> Void in
                
                let scaledimage = self.getScaledImage(image!)
                //let imagedata = UIImageJPEGRepresentation(scaledimage, 0.8)
                
                let vc = ComposeViewController()
                vc.passedImage = scaledimage
                self.navigationController?.pushViewController(vc, animated: true)
                
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
            })
        case .VideoWithMic, .VideoOnly:
            sender.selected = !sender.selected
            sender.setTitle(" ", forState: UIControlState.Selected)
            sender.backgroundColor = sender.selected ? UIColor.redColor() : UIColor.greenColor()
            if sender.selected {
                cameraManager.startRecordingVideo()
            } else {
                cameraManager.stopRecordingVideo({ (videoURL, error) -> Void in
                    if let errorOccured = error {
                        self.cameraManager.showErrorBlock(erTitle: "Error occurred", erMessage: errorOccured.localizedDescription)
                    }
                })
            }
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    
    func getScaledImage(image:UIImage)->UIImage {
        
        var scaledImage = UIImage()
        
        if (image.size.width > image.size.height) {
            // need to rotate 90 degrees to the right
            print("image.imageOrientation: \(image.imageOrientation)")
            let imageRef = image.CGImage!
            let rotatedImage = UIImage.init(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Right)
            print("rotatedImage.size: \(rotatedImage.size)")
            if (rotatedImage.size.width > 500) {
                // scale down to 500
                let percent = CGFloat(500/rotatedImage.size.width)
                let size = CGSizeApplyAffineTransform(rotatedImage.size, CGAffineTransformMakeScale(percent, percent))
                let hasAlpha = false
                let scale: CGFloat = 0.0
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                rotatedImage.drawInRect(CGRect(origin: CGPointZero, size: size))
                scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            } else {
                scaledImage = rotatedImage
            }
        } else {
            print("image.imageOrientation: \(image.imageOrientation)")
            if (image.size.width > 500) {
                // scale down to 500
                let percent = CGFloat(500/image.size.width)
                
                let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(percent, percent))
                let hasAlpha = false
                let scale: CGFloat = 0.0
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                image.drawInRect(CGRect(origin: CGPointZero, size: size))
                scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            } else {
                scaledImage = image
            }
        }
        print("scaledImage.size: \(scaledImage.size)")
        return scaledImage
    }
    
    
    // button actions
    
    func xBtnAction() {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
        cameraManager.captureSession?.stopRunning()
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func albumBtnAction() {
        
        // puch to albumVC
        
        self.navigationController?.pushViewController(ComposeViewController(), animated: true)
        
    }
    
}
