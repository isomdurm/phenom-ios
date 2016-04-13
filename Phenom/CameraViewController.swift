//
//  CameraViewController.swift
//  Phenom
//
//  Created by Clay Zug on 3/29/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, FSCameraViewDelegate, FSAlbumViewDelegate, FusumaDelegate, UITextViewDelegate {

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
    
    var savedKeyboardHeight = CGFloat()
    var statusTextView = KMPlaceholderTextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        
        //let bottomHeight = view.frame.size.height-64-view.frame.size.width
        //albumViewerContainer = UIView(frame: CGRectMake(0, 64+view.frame.size.width, view.frame.size.width, bottomHeight))
        albumViewerContainer = UIView(frame: CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-50))
        albumViewerContainer.backgroundColor = UIColor.greenColor() // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(albumViewerContainer)
        
        cameraViewerContainer = UIView(frame: CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-50))
        cameraViewerContainer.backgroundColor = UIColor.greenColor() // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(cameraViewerContainer)
        
        statusViewerContainer = UIView(frame: CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-50))
        statusViewerContainer.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        view.addSubview(statusViewerContainer)
        
        
        statusTextView.frame = CGRectMake(0, 0, self.view.frame.width, 100)
        statusTextView.backgroundColor = UIColor.clearColor()
        statusTextView.delegate = self
        statusTextView.textColor = UIColor.init(white: 1.0, alpha: 1.0)
        statusTextView.keyboardType = UIKeyboardType.Default
        statusTextView.returnKeyType = UIReturnKeyType.Default
        statusTextView.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        statusTextView.enablesReturnKeyAutomatically = true
        statusTextView.textAlignment = NSTextAlignment.Left
        statusTextView.autocapitalizationType = UITextAutocapitalizationType.None
        statusTextView.autocorrectionType = UITextAutocorrectionType.No
        statusTextView.scrollEnabled = true
        statusTextView.scrollsToTop = false
        self.statusViewerContainer.addSubview(statusTextView)
        statusTextView.text = ""
        statusTextView.placeholder = "Add a caption..."
        statusTextView.placeholderColor = UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)
        statusTextView.textContainerInset = UIEdgeInsetsMake(19, 19, 19, 19)
        statusTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CameraViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification ,object: nil)
        
        
        
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
        nextBtn.addTarget(self, action:#selector(nextBtnAction), forControlEvents:.TouchUpInside)
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
        
        albumBtn = UIButton(type: UIButtonType.Custom)
        albumBtn.frame = CGRectMake(view.frame.size.width/3*0, view.frame.size.height-50, view.frame.size.width/3, 50)
        albumBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //albumBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        albumBtn.backgroundColor = UIColor.blueColor()
        albumBtn.addTarget(self, action:#selector(albumBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        view.addSubview(albumBtn)
        
        cameraBtn = UIButton(type: UIButtonType.Custom)
        cameraBtn.frame = CGRectMake(view.frame.size.width/3*1, view.frame.size.height-50, view.frame.size.width/3, 50)
        cameraBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //cameraBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        cameraBtn.backgroundColor = UIColor.redColor()
        cameraBtn.addTarget(self, action:#selector(cameraBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        view.addSubview(cameraBtn)
        
        statusBtn = UIButton(type: UIButtonType.Custom)
        statusBtn.frame = CGRectMake(view.frame.size.width/3*2, view.frame.size.height-50, view.frame.size.width/3, 50)
        statusBtn.setImage(UIImage(named: "xbtn.png"), forState: .Normal)
        //statusBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        statusBtn.backgroundColor = UIColor.orangeColor()
        statusBtn.addTarget(self, action:#selector(statusBtnAction), forControlEvents:.TouchUpInside)
        view.addSubview(statusBtn)
        
        
        
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
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        
        let keyboardframe: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        self.savedKeyboardHeight = keyboardframe.size.height
        
        var textViewFrame = statusTextView.frame
        textViewFrame.size.height = self.view.frame.size.height-self.savedKeyboardHeight-64
        statusTextView.frame = textViewFrame
        
//        let newY = self.view.frame.size.height-self.savedKeyboardHeight-56
//        
//        var optionsbarFrame = self.optionsbar.frame
//        optionsbarFrame.origin.y = newY
//        self.optionsbar.frame = optionsbarFrame
    }
    
    // UITextViewDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text == "") {
            if (text == " ") {
                return false
            }
        }
        
        let maxLength = 200
        let currentString: NSString = textView.text!
        let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: text)
        
        return newString.length <= maxLength
    }
    
    func textViewDidChange(textView: UITextView) {
        
        
    }
    
    
    
    func albumBtnAction() {
        albumViewerContainer.hidden = false
        cameraViewerContainer.hidden = true
        statusViewerContainer.hidden = true
        titleLbl.text = "CAMERA ROLL"

        self.statusTextView.resignFirstResponder()
        
    }
    
    func cameraBtnAction() {
        albumViewerContainer.hidden = true
        cameraViewerContainer.hidden = false
        statusViewerContainer.hidden = true
        titleLbl.text = "CAMERA"
        
        self.statusTextView.resignFirstResponder()
        
    }
    
    func statusBtnAction() {
        albumViewerContainer.hidden = true
        cameraViewerContainer.hidden = true
        statusViewerContainer.hidden = false
        titleLbl.text = "STATUS"
        
        self.statusTextView.becomeFirstResponder()
        
    }
    
    func xBtnAction() {
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
        cameraView.session?.stopRunning()
        
        view.endEditing(true)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func nextBtnAction() {
        
        if (albumViewerContainer.hidden == false) {
            
            let view = albumView.imageCropView
            
            UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
            let context = UIGraphicsGetCurrentContext()
            CGContextTranslateCTM(context, -albumView.imageCropView.contentOffset.x, -albumView.imageCropView.contentOffset.y)
            view.layer.renderInContext(context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            delegate?.fusumaImageSelected(image)
            
            imgToPass = image
            
            let vc = ComposeViewController()
            vc.passedImage = imgToPass
            navigationController?.pushViewController(vc, animated: true)
            
        } else if (cameraViewerContainer.hidden == false) {
            
            let vc = ComposeViewController()
            vc.passedImage = imgToPass
            navigationController?.pushViewController(vc, animated: true)
            
        } else if (statusViewerContainer.hidden == false) {
            
            let vc = ComposeViewController()
            vc.statusOnly = true
            vc.passedHeadline = self.statusTextView.text
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
        }
        
        
        
        
        if (albumViewerContainer.hidden) {
            
            
            
        } else {
            
            
        }
        
        
        
    }
    
    ///////////
    
    // MARK: FSCameraViewDelegate
    func cameraShotFinished(image: UIImage) {
        
        delegate?.fusumaImageSelected(image)
//        dismissViewControllerAnimated(true, completion: {
//            
//            delegate?.fusumaDismissedWithImage?(image)
//        })
        
        imgToPass = image
        
        // display "REDO" button in top right, to the left of the "nextBtn"
        
        
    }
    
    // MARK: FSAlbumViewDelegate
    func albumViewCameraRollUnauthorized() {
        
        delegate?.fusumaCameraRollUnauthorized()
    }
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(image: UIImage) {
        
//        print("Image selected")
        //imageView.image = image
        
        imgToPass = image
        
    }
    
    func fusumaDismissedWithImage(image: UIImage) {
//        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
//        print("Camera roll unauthorized")
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (action) -> Void in
            
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
//        print("Called when the close button is pressed")
    }
    

}
