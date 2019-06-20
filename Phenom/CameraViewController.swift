//
//  CameraViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/29/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        
        //let bottomHeight = view.frame.size.height-64-view.frame.size.width
        //albumViewerContainer = UIView(frame: CGRectMake(0, 64+view.frame.size.width, view.frame.size.width, bottomHeight))
        albumViewerContainer = UIView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-50))
        albumViewerContainer.backgroundColor = UIColor.green // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(albumViewerContainer)
        
        cameraViewerContainer = UIView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-50))
        cameraViewerContainer.backgroundColor = UIColor.green // UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(cameraViewerContainer)
        
        statusViewerContainer = UIView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-50))
        statusViewerContainer.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        view.addSubview(statusViewerContainer)
        
        
        statusTextView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
        statusTextView.backgroundColor = UIColor.clear
        statusTextView.delegate = self
        statusTextView.textColor = UIColor.init(white: 1.0, alpha: 1.0)
        statusTextView.keyboardType = UIKeyboardType.default
        statusTextView.returnKeyType = UIReturnKeyType.default
        statusTextView.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        statusTextView.enablesReturnKeyAutomatically = true
        statusTextView.textAlignment = NSTextAlignment.left
        statusTextView.autocapitalizationType = UITextAutocapitalizationType.none
        statusTextView.autocorrectionType = UITextAutocorrectionType.no
        statusTextView.isScrollEnabled = true
        statusTextView.scrollsToTop = false
        self.statusViewerContainer.addSubview(statusTextView)
        statusTextView.text = ""
        statusTextView.placeholder = "Add a caption..."
        statusTextView.placeholderColor = UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)
        statusTextView.textContainerInset = UIEdgeInsetsMake(19, 19, 19, 19)
        statusTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow ,object: nil)
        
        
        
        albumView.delegate  = self
        cameraView.delegate = self
        
        albumViewerContainer.addSubview(albumView)
        cameraViewerContainer.addSubview(cameraView)
        
        //
        
        cameraViewerContainer.isHidden = true
        statusViewerContainer.isHidden = true
        
        //
        //
        //
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.custom)
        xBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blue
        xBtn.addTarget(self, action:#selector(xBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(xBtn)
        
        titleLbl.frame = CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44)
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "CAMERA ROLL"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)

        let nextBtn = UIButton()
        nextBtn.frame = CGRect(x: view.frame.size.width-70-20, y: 20, width: 70, height: 44)
        nextBtn.backgroundColor = UIColor.blue
        nextBtn.addTarget(self, action:#selector(nextBtnAction), for:.touchUpInside)
        nextBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        nextBtn.titleLabel?.numberOfLines = 1
        nextBtn.contentHorizontalAlignment = .center
        nextBtn.contentVerticalAlignment = .center
        nextBtn.titleLabel?.textAlignment = .center
        nextBtn.setTitleColor(UIColor.white, for: UIControlState())
        nextBtn.setTitleColor(UIColor.white, for: .highlighted)
        nextBtn.setTitle("Next", for: UIControlState())
        navBarView.addSubview(nextBtn)
        
        //
        
        albumBtn = UIButton(type: UIButtonType.custom)
        albumBtn.frame = CGRect(x: view.frame.size.width/3*0, y: view.frame.size.height-50, width: view.frame.size.width/3, height: 50)
        albumBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //albumBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        albumBtn.backgroundColor = UIColor.blue
        albumBtn.addTarget(self, action:#selector(albumBtnAction), for:UIControlEvents.touchUpInside)
        view.addSubview(albumBtn)
        
        cameraBtn = UIButton(type: UIButtonType.custom)
        cameraBtn.frame = CGRect(x: view.frame.size.width/3*1, y: view.frame.size.height-50, width: view.frame.size.width/3, height: 50)
        cameraBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //cameraBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        cameraBtn.backgroundColor = UIColor.red
        cameraBtn.addTarget(self, action:#selector(cameraBtnAction), for:UIControlEvents.touchUpInside)
        view.addSubview(cameraBtn)
        
        statusBtn = UIButton(type: UIButtonType.custom)
        statusBtn.frame = CGRect(x: view.frame.size.width/3*2, y: view.frame.size.height-50, width: view.frame.size.width/3, height: 50)
        statusBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //statusBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: .Normal)
        statusBtn.backgroundColor = UIColor.orange
        statusBtn.addTarget(self, action:#selector(statusBtnAction), for:.touchUpInside)
        view.addSubview(statusBtn)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumView.frame  = CGRect(origin: CGPoint.zero, size: albumViewerContainer.frame.size)
        albumView.layoutIfNeeded()
        cameraView.frame = CGRect(origin: CGPoint.zero, size: cameraViewerContainer.frame.size)
        cameraView.layoutIfNeeded()
        
        albumView.initialize()
        cameraView.initialize()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let info = notification.userInfo!
        
        let keyboardframe: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (textView.text == "") {
            if (text == " ") {
                return false
            }
        }
        
        let maxLength = 200
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        return newString.length <= maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
    }
    
    
    
    func albumBtnAction() {
        albumViewerContainer.isHidden = false
        cameraViewerContainer.isHidden = true
        statusViewerContainer.isHidden = true
        titleLbl.text = "CAMERA ROLL"

        self.statusTextView.resignFirstResponder()
        
    }
    
    func cameraBtnAction() {
        albumViewerContainer.isHidden = true
        cameraViewerContainer.isHidden = false
        statusViewerContainer.isHidden = true
        titleLbl.text = "CAMERA"
        
        self.statusTextView.resignFirstResponder()
        
    }
    
    func statusBtnAction() {
        albumViewerContainer.isHidden = true
        cameraViewerContainer.isHidden = true
        statusViewerContainer.isHidden = false
        titleLbl.text = "STATUS"
        
        self.statusTextView.becomeFirstResponder()
        
    }
    
    func xBtnAction() {
        
        (UIApplication.shared.delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        
        cameraView.session?.stopRunning()
        
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    func nextBtnAction() {
        
        if (albumViewerContainer.isHidden == false) {
            
            let view = albumView.imageCropView
            
            UIGraphicsBeginImageContextWithOptions((view?.frame.size)!, true, 0)
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: -albumView.imageCropView.contentOffset.x, y: -albumView.imageCropView.contentOffset.y)
            view?.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            delegate?.fusumaImageSelected(image!)
            
            imgToPass = image!
            
            let vc = ComposeViewController()
            vc.passedImage = imgToPass
            navigationController?.pushViewController(vc, animated: true)
            
        } else if (cameraViewerContainer.isHidden == false) {
            
            let vc = ComposeViewController()
            vc.passedImage = imgToPass
            navigationController?.pushViewController(vc, animated: true)
            
        } else if (statusViewerContainer.isHidden == false) {
            
            let vc = ComposeViewController()
            vc.statusOnly = true
            vc.passedHeadline = self.statusTextView.text
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
        }
        
        
        
        
        if (albumViewerContainer.isHidden) {
            
            
            
        } else {
            
            
        }
        
        
        
    }
    
    ///////////
    
    // MARK: FSCameraViewDelegate
    func cameraShotFinished(_ image: UIImage) {
        
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
    func fusumaImageSelected(_ image: UIImage) {
        
//        print("Image selected")
        //imageView.image = image
        
        imgToPass = image
        
    }
    
    func fusumaDismissedWithImage(_ image: UIImage) {
//        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
//        print("Camera roll unauthorized")
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
//        print("Called when the close button is pressed")
    }
    

}
