//
//  CreateViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/14/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import QuartzCore

class CreateViewController: UIViewController {

    
    var cameraView = UIView()
    let cameraManager = CameraManager()
    var captureBtn =  UIButton(type: UIButtonType.custom)
    
    var imgToPass = UIImage()
    
    var albumBtn = UIButton(type: UIButtonType.custom)
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        
        //cameraView = UIView(frame: CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49))
        cameraView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-100)
        cameraView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(cameraView)
        
        let xBtn = UIButton(type: UIButtonType.custom)
        xBtn.frame = CGRect(x: 20, y: self.view.frame.size.height-40-20, width: 40, height: 40)
        xBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blue
        xBtn.addTarget(self, action:#selector(xBtnAction), for:UIControlEvents.touchUpInside)
        self.view.addSubview(xBtn)
        
        captureBtn.frame = CGRect(x: self.view.frame.size.width/2-40, y: self.view.frame.size.height-80-10, width: 80, height: 80)
        captureBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //captureBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        captureBtn.backgroundColor = UIColor.purple
        captureBtn.addTarget(self, action:#selector(captureBtnAction), for:UIControlEvents.touchUpInside)
        //self.view.insertSubview(captureBtn, aboveSubview: self.cameraView)
        self.view.addSubview(captureBtn)
        captureBtn.layer.cornerRadius = captureBtn.frame.size.width/2
        captureBtn.layer.masksToBounds = true

        let albumBtn = UIButton()
        albumBtn.frame = CGRect(x: view.frame.size.width-40-20, y: self.view.frame.size.height-40-20, width: 40, height: 40)
        albumBtn.backgroundColor = UIColor.blue
        albumBtn.addTarget(self, action:#selector(albumBtnAction), for:.touchUpInside)
        albumBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        albumBtn.titleLabel?.numberOfLines = 1
        albumBtn.contentHorizontalAlignment = .center
        albumBtn.contentVerticalAlignment = .center
        albumBtn.titleLabel?.textAlignment = .center
        albumBtn.setTitleColor(UIColor.white, for: UIControlState())
        albumBtn.setTitleColor(UIColor.white, for: .highlighted)
        albumBtn.setTitle("Next", for: UIControlState())
        self.view.addSubview(albumBtn)
        
        //
        
        self.addCameraToView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // camera functions
    
    func askForCameraPermissions(_ sender: UIButton) {
        
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
   
    fileprivate func addCameraToView() {
        
        if (!cameraManager.cameraIsReady) {
            
            cameraManager.addPreviewLayerToView(self.cameraView, newCameraOutputMode: CameraOutputMode.stillImage)
            cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
                
                let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) -> Void in  }))
                self?.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        
    }

    //func recordButtonTapped(sender: UIButton) {
    func captureBtnAction(_ sender: UIButton) {
        
        // start
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.center = CGPoint(x: view.frame.size.width/2, y: (view.frame.size.height-100)/2)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ///
        
        switch (cameraManager.cameraOutputMode) {
        case .stillImage:
            cameraManager.capturePictureWithCompletition({ (image, error) -> Void in
                
                let scaledimage = self.getScaledImage(image!)
                //let imagedata = UIImageJPEGRepresentation(scaledimage, 0.8)
                
                let vc = ComposeViewController()
                vc.passedImage = scaledimage
                self.navigationController?.pushViewController(vc, animated: true)
                
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
            })
        case .videoWithMic, .videoOnly:
            sender.isSelected = !sender.isSelected
            sender.setTitle(" ", for: UIControlState.selected)
            sender.backgroundColor = sender.isSelected ? UIColor.red : UIColor.green
            if sender.isSelected {
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
    
    
    func getScaledImage(_ image:UIImage)->UIImage {
        
        var scaledImage = UIImage()
        
        if (image.size.width > image.size.height) {
            // need to rotate 90 degrees to the right
            print("image.imageOrientation: \(image.imageOrientation)")
            let imageRef = image.cgImage!
            let rotatedImage = UIImage.init(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.right)
            print("rotatedImage.size: \(rotatedImage.size)")
            if (rotatedImage.size.width > 500) {
                // scale down to 500
                let percent = CGFloat(500/rotatedImage.size.width)
                let size = rotatedImage.size.applying(CGAffineTransform(scaleX: percent, y: percent))
                let hasAlpha = false
                let scale: CGFloat = 0.0
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                rotatedImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
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
                
                let size = image.size.applying(CGAffineTransform(scaleX: percent, y: percent))
                let hasAlpha = false
                let scale: CGFloat = 0.0
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                image.draw(in: CGRect(origin: CGPoint.zero, size: size))
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
        
        (UIApplication.shared.delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        
        cameraManager.captureSession?.stopRunning()
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func albumBtnAction() {
        
        // puch to albumVC
        
        self.navigationController?.pushViewController(ComposeViewController(), animated: true)
        
    }
    
}
