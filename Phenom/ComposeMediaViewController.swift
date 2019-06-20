//
//  ComposeMediaViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/20/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire

class ComposeMediaViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    var navBarView = UIView()
    
    var theScrollView = UIScrollView()
    
    var passedImage = UIImage()
    var passedHeadline = ""
    
    var tabBtn1 = UIButton(type: UIButtonType.custom)
    var tabBtn2 = UIButton(type: UIButtonType.custom)
    var tabBtn3 = UIButton(type: UIButtonType.custom)
    
    var theTextView = KMPlaceholderTextView()
    var textFieldAtTop: Bool = false
    
    var statusOnly: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBarHidden = true
        //edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        //        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        //        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        //        view.addSubview(navBarView)
        //
        //        let backBtn = UIButton(type: UIButtonType.Custom)
        //        backBtn.frame = CGRectMake(15, 20, 44, 44)
        //        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //        backBtn.backgroundColor = UIColor.redColor()
        //        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        //        navBarView.addSubview(backBtn)
        //
        //        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        //        titleLbl.textAlignment = NSTextAlignment.Center
        //        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        //        titleLbl.textColor = UIColor.whiteColor()
        //        titleLbl.text = "I AM"
        //        navBarView.addSubview(titleLbl)
        //
        //        let shareBtn = UIButton()
        //        shareBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
        //        shareBtn.backgroundColor = UIColor.blueColor()
        //        shareBtn.addTarget(self, action:#selector(shareBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        //        shareBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
        //        shareBtn.titleLabel?.numberOfLines = 1
        //        shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        //        shareBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        //        shareBtn.titleLabel?.textAlignment = NSTextAlignment.Center
        //        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        //        shareBtn.setTitle("SHARE", forState: UIControlState.Normal)
        //        navBarView.addSubview(shareBtn)
        
        //
        
        let mediaHeight = view.frame.size.width+110
        
        let theImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: mediaHeight))
        theImageView.image  = passedImage
        theImageView.contentMode = UIViewContentMode.scaleAspectFit
        theImageView.isUserInteractionEnabled = true
        view.addSubview(theImageView)
        theImageView.layer.masksToBounds = true
        
        //
        
        theScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        theScrollView.backgroundColor = UIColor.clear
        theScrollView.delegate = self
        theScrollView.isPagingEnabled = true
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = true
        theScrollView.scrollsToTop = true
        theScrollView.isScrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = true
        theScrollView.isUserInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        theScrollView.contentInset = UIEdgeInsets(top: mediaHeight, left: 0, bottom: 0, right: 0)
        
        // measure necessary height
        theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width, height: theScrollView.frame.size.height)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let tabWidth = view.frame.width/3
        tabBtn1.frame = CGRect(x: 0, y: 0, width: tabWidth, height: 44)
        tabBtn1.backgroundColor = UIColor.clear
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn1.setTitleColor(UIColor.white, for: UIControlState())
        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn1.setTitle("TRAINING", for: UIControlState())
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), for:UIControlEvents.touchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn1.isSelected = true
        
        tabBtn2.frame = CGRect(x: tabWidth*1, y: 0, width: tabWidth, height: 44)
        tabBtn2.backgroundColor = UIColor.clear
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn2.setTitleColor(UIColor.white, for: UIControlState())
        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn2.setTitle("GAMING", for: UIControlState())
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), for:UIControlEvents.touchUpInside)
        tabView.addSubview(tabBtn2)
        
        tabBtn3.frame = CGRect(x: tabWidth*2, y: 0, width: tabWidth, height: 44)
        tabBtn3.backgroundColor = UIColor.clear
        tabBtn3.titleLabel?.numberOfLines = 1
        tabBtn3.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn3.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn3.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn3.setTitleColor(UIColor.white, for: UIControlState())
        tabBtn3.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn3.setTitle("STYLING", for: UIControlState())
        tabBtn3.addTarget(self, action:#selector(tabBtn3Action), for:UIControlEvents.touchUpInside)
        tabView.addSubview(tabBtn3)
        
        let line2:UIView = UIView()
        line2.frame = CGRect(x: 0, y: tabView.frame.size.height-0.5, width: tabView.frame.size.width, height: 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        theScrollView.addSubview(tabView)
        
        //
        
        // add caption
        
        theTextView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: 150)
        theTextView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTextView.delegate = self
        theTextView.textColor = UIColor.white
        theTextView.keyboardType = UIKeyboardType.twitter
        theTextView.returnKeyType = UIReturnKeyType.default
        theTextView.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        theTextView.enablesReturnKeyAutomatically = true
        theTextView.textAlignment = NSTextAlignment.left
        //theTextView.autocapitalizationType = UITextAutocapitalizationType.None
        //theTextView.autocorrectionType = UITextAutocorrectionType.No
        theTextView.isScrollEnabled = true
        theTextView.scrollsToTop = false
        theScrollView.addSubview(theTextView)
        
        if (passedHeadline == "") {
            theTextView.text = ""
        } else {
            theTextView.text = passedHeadline
        }
        //theTextView.text = ""
        theTextView.placeholder = "Add a caption..."
        
        theTextView.placeholderColor = UIColor.init(white: 1.0, alpha: 0.8)
        
        theTextView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        
        // add gear - show 3 and a + button
        
        let gearView = UIView()
        gearView.frame = CGRect(x: 0, y: 44+100, width: view.frame.size.width, height: 100)
        gearView.backgroundColor = UIColor.blue
        theScrollView.addSubview(gearView)
        
        
        // add music - show 3 and a + button
        
        let musicView = UIView()
        musicView.frame = CGRect(x: 0, y: 44+100+100, width: view.frame.size.width, height: 100)
        musicView.backgroundColor = UIColor.green
        theScrollView.addSubview(musicView)
        
        //
        // to hide clear background
        let fakeView = UIView()
        fakeView.frame = CGRect(x: 0, y: 44+100+100+100, width: view.frame.size.width, height: 100*10)
        fakeView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theScrollView.addSubview(fakeView)
        
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow ,object: nil)
        
        //
        
        if (statusOnly) {
            
            theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            theScrollView.isScrollEnabled = false
            theScrollView.bounces = false
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
    }
    
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func tabBtn1Action() {
        tabBtn1.isSelected = true
        tabBtn2.isSelected = false
        tabBtn3.isSelected = false
        
    }
    
    func tabBtn2Action() {
        tabBtn1.isSelected = false
        tabBtn2.isSelected = true
        tabBtn3.isSelected = false
        
    }
    
    func tabBtn3Action() {
        tabBtn1.isSelected = false
        tabBtn2.isSelected = false
        tabBtn3.isSelected = true
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (textFieldAtTop && theTextView.isFirstResponder) {
            view.endEditing(true)
        }
        
        if (theScrollView.contentOffset.y != 0) {
            textFieldAtTop = false
        }
        
        
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        //print("scrollViewWillBeginDecelerating at x: \(scrollView.contentOffset.x)")
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //print("scrollViewDidEndDecelerating at x: \(scrollView.contentOffset.x)")
        
        if (theScrollView.contentOffset.y == 0) {
            print("scrollViewDidEndDecelerating hit")
            textFieldAtTop = true
        }
        
    }
    
    
    func keyboardWillShow(_ notification: Notification) {
        
        print("keyboardWillShow hit")
        theScrollView.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
        
    }
    
    func keyboardDidShow(_ notification: Notification) {
        
        print("keyboardDidShow hit")
        textFieldAtTop = true
        
    }
    
    // UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (theTextView.text == "") {
            if (text == " ") {
                return false;
            }
        }
        if (text == "\n")
        {
            //return false;
        }
        
        //
        
        let maxLength = 200
        let currentString: NSString = textView.text!
        let newString: NSString = currentString.replacingCharacters(in: range, with: text)
        
        return newString.length <= maxLength
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        //        // adjust height
        //
        //        let maxFloat = CGFloat(MAXFLOAT)
        //        let newSize = textView.sizeThatFits(CGSizeMake(view.frame.size.width-40, maxFloat))
        //
        //        var newFrame = textView.frame
        //        newFrame.size = CGSizeMake(view.frame.size.width-40, newSize.height)
        //
        //        textView.frame = newFrame
        
    }
    
    
    func shareBtnAction() {
        //        print("shareBtnAction hit")
        
        view.endEditing(true)
        
        //
        
        print("passedImage: \(passedImage)")
        print("passedImage.size: \(passedImage.size)")
        
        //
        
        var mode = NSString()
        
        if (tabBtn1.isSelected) {
            mode = (tabBtn1.titleLabel?.text)!
        } else if (tabBtn2.isSelected) {
            mode = (tabBtn2.titleLabel?.text)!
        } else if (tabBtn3.isSelected) {
            mode = (tabBtn3.titleLabel?.text)!
        } else {
            // error
            return
        }
        
        print("mode: \(mode)")
        
        //
        
        print("theTextField: \(theTextView.text)")
        
        //
        
        
    }
    
    
    func savePhoto(_ image:UIImage) {
        
        // maxHeight
        // maxWidth
        
        let resizedimage = (UIApplication.shared.delegate as! AppDelegate).resizeImage(image, newWidth: 600)
        //let resizedimagesmall = self.resizeImage(image, newWidth: 300)
        
        self.uploadImage(resizedimage)
        
    }
    
    func uploadImage(_ image : UIImage) {
        
        let fullUrl = ""
        
        let imagePathUrl = URL()
        let videoPathUrl = URL()
        
        // http://httpbin.org/post
        
        Alamofire.upload(
            .POST,
            fullUrl,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: imagePathUrl, name: "photo")
                multipartFormData.appendBodyPart(fileURL: videoPathUrl, name: "video")
                multipartFormData.appendBodyPart(data: "Constants.AuthKey".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"authKey")
                multipartFormData.appendBodyPart(data: "\(16)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"idUserChallenge")
                multipartFormData.appendBodyPart(data: "comment".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"comment")
                multipartFormData.appendBodyPart(data:"\(0.00)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"latitude")
                multipartFormData.appendBodyPart(data:"\(0.00)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"longitude")
                multipartFormData.appendBodyPart(data:"India".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"location")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
//                    upload.responseJSON { request, response, JSON, error in
//                        
//                        
//                    }
                    print("success: upload: \(upload)")
                    
                case .Failure(let encodingError):
                    
                    print("error: encodingError: \(encodingError)")
                    
                }
            }
        )
        
        
//        
//        Alamofire.request(.GET, url, headers: headers)
//            .responseJSON { response in
//                //print(response.request)  // original URL request
//                //print(response.response) // URL response
//                //print(response.data)     // server data
//                //print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    //print("JSON: \(JSON)")
//                    
//                    if let errorCode = JSON["errorCode"] {
//                        let ec = errorCode as! NSNumber
//                        if ec != 200 {
//                            print("err: \(ec)")
//                            return
//                        }
//                    }
//                    
//                  
//                    
//                }
//        }
//        
//        
//        
//        
//        
//        
//        
//        
//        func sendFile(
//            urlPath:String,
//            fileName:String,
//            data:NSData,
//            completionHandler: (NSURLResponse?, NSData?, NSError?) -> Void){
//            
//            let url: NSURL = NSURL(string: urlPath)!
//            let request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
//            
//            request1.HTTPMethod = "PUT"
//            
//            let boundary = generateBoundaryString()
//            
//            let fullData = photoDataToFormData(data,boundary:boundary,fileName:fileName)
//            
//            request1.setValue("multipart/form-data; boundary=" + boundary,
//                              forHTTPHeaderField: "Content-Type")
//            
//            // REQUIRED!
//            request1.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
//            
//            request1.HTTPBody = fullData
//            request1.HTTPShouldHandleCookies = false
//            let defaults = NSUserDefaults.standardUserDefaults()
//            let bearerToken = defaults.stringForKey("bearerToken")! as String
//            request1.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
//            request1.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//            
//            //            let queue:NSOperationQueue = NSOperationQueue()
//            //            NSURLConnection.sendAsynchronousRequest(
//            //                request1,
//            //                queue: queue,
//            //                completionHandler: completionHandler)
//            
//            let session = NSURLSession.sharedSession()
//            //let task = session.dataTaskWithRequest(request, completionHandler:completionHandler)
//            //task.resume()
//            let task = session.dataTaskWithRequest(request1, completionHandler: {(data, response, error) in
//                
//                // notice that I can omit the types of data, response and error
//                // your code
//                
//                if (error != nil) {
//                    print("hmmm error w img upload: \(error?.code)")
//                    
//                    
//                } else {
//                    
//                    // success
//                    print("success w response: \(response?.description)")
//                    //
//                    // reload timline and profile
//                    
//                }
//                
//                
//            });
//            
//            // do whatever you need with the task e.g. run
//            task.resume()
//            
//            
//        }
//        
//        
//        //let url = "https://api1.phenomapp.com:8081/user"
//        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user"
//        //        let img = UIImage(contentsOfFile: fullPath)
//        let data: NSData = UIImageJPEGRepresentation(image, 0.7)!
//        
//        sendFile(url,
//                 fileName:"image.jpeg",
//                 data:data,
//                 completionHandler: {
//                    (result:NSURLResponse?, isNoInternetConnection:NSData?, err: NSError?) -> Void in
//                    
//                    // ...
//                    NSLog("Complete: \(result)")
//            }
//        )
//        
//        // this is a very verbose version of that function
//        // you can shorten it, but i left it as-is for clarity
//        // and as an example
//        func photoDataToFormData(data:NSData,boundary:String,fileName:String) -> NSData {
//            let fullData = NSMutableData()
//            
//            // 1 - Boundary should start with --
//            let lineOne = "--" + boundary + "\r\n"
//            fullData.appendData(lineOne.dataUsingEncoding(
//                NSUTF8StringEncoding,
//                allowLossyConversion: false)!)
//            
//            // 2
//            let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
//            NSLog(lineTwo)
//            fullData.appendData(lineTwo.dataUsingEncoding(
//                NSUTF8StringEncoding,
//                allowLossyConversion: false)!)
//            
//            // 3
//            let lineThree = "Content-Type: image/jpg\r\n\r\n"
//            fullData.appendData(lineThree.dataUsingEncoding(
//                NSUTF8StringEncoding,
//                allowLossyConversion: false)!)
//            
//            // 4
//            fullData.appendData(data)
//            
//            // 5
//            let lineFive = "\r\n"
//            fullData.appendData(lineFive.dataUsingEncoding(
//                NSUTF8StringEncoding,
//                allowLossyConversion: false)!)
//            
//            // 6 - The end. Notice -- at the start and at the end
//            let lineSix = "--" + boundary + "--\r\n"
//            fullData.appendData(lineSix.dataUsingEncoding(
//                NSUTF8StringEncoding,
//                allowLossyConversion: false)!)
//            
//            return fullData
//        }
        
    }
    
    func generateBoundaryString() -> String {
        
        return "Boundary-\(UUID().uuidString)"
    }
   

}
