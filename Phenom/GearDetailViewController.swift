//
//  GearDetailViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore
import SafariServices

class GearDetailViewController: UIViewController, UIScrollViewDelegate, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate {

    var id = ""
    var sku = ""
    var sourceId = ""
    var sourceProductId = ""
    
    var name = ""
    var brand = ""
    var brandLogoImageUrl = ""
    var productDescription = ""
    var productUrl = ""
    var imageUrl = ""

    var lockerCount = NSNumber()
    var trainingMomentCount = NSNumber()
    var gamingMomentCount = NSNumber() 
    var stylingMomentCount = NSNumber()
    
    var existsInLocker: Bool = false
    
    //
    
    var navBarView = UIView()
    
    var theScrollView = UIScrollView()
    
    var lockerBtn = UIButton.init(type: .Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.text = brand.uppercaseString
        navBarView.addSubview(titleLbl)
        
        
        theScrollView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theScrollView.backgroundColor = UIColor.clearColor()
        theScrollView.delegate = self
        theScrollView.pagingEnabled = false
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = true
        theScrollView.scrollsToTop = true
        theScrollView.scrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = true
        theScrollView.userInteractionEnabled = true
        view.addSubview(theScrollView)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        let squareHeight = view.frame.size.width
        let buyHeight = CGFloat(70)
        let brandHeight = CGFloat(70)
        let statsHeight = CGFloat(70)
        
        let padding = CGFloat(20)
        let textWidth = view.frame.size.width-30
        
//        let productName = NSString(string: "Junior supreme 170 ice hockey elbow pads").uppercaseString
//        let productDescription = NSString(string: "this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. ").uppercaseString
        
        let productNameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(name, font: UIFont.init(name: "MaisonNeue-Bold", size: 18)!, width: textWidth)
        let productDescriptionHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(productDescription, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: textWidth)
        
        let totalHeight = squareHeight+buyHeight+brandHeight+statsHeight+padding+productNameHeight+padding+productDescriptionHeight+padding+padding
        
        // measure height of padding+title+padding+description+padding
        
        // measure necessary height
        theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width, height: totalHeight)
        
        
        let gearScrollView = UIScrollView(frame: CGRectMake(0, 0, theScrollView.frame.size.width, theScrollView.frame.size.width))
        gearScrollView.backgroundColor = UIColor.clearColor() //UIColor.yellowColor()
        theScrollView.addSubview(gearScrollView)
        
        let imgView1 = UIImageView(frame: CGRectMake(0, 0, theScrollView.frame.size.width, theScrollView.frame.size.width))
        imgView1.contentMode = UIViewContentMode.ScaleAspectFill
        theScrollView.addSubview(imgView1)
        imgView1.layer.masksToBounds = true
        
        if (imageUrl != "") {
            
            let fileUrl = NSURL(string: imageUrl)
            imgView1.setNeedsLayout()
            imgView1.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                                         success: { image in
                                            
                                            imgView1.image = image
                                            
                },
                                         failure: { error in
                                            
                                            if ((error) != nil) {
                                                print("error here: \(error)")
                                                
                                                // collapse, this cell - it was prob deleted - error 402
                                                
                                            }
            })
        } else {
            imgView1.image = UIImage(named: "placeholder.png")
        }
        
        
        
        let buyBtn = UIButton.init(type: .Custom)
        buyBtn.frame = CGRectMake(10, gearScrollView.frame.size.height+10, theScrollView.frame.size.width-20, 50)
        buyBtn.backgroundColor = UINavigationBar.appearance().tintColor
        buyBtn.setTitle("BUY NOW", forState: .Normal)
        buyBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 16)
        buyBtn.addTarget(self, action:#selector(buyBtnAction), forControlEvents: .TouchUpInside)
        theScrollView.addSubview(buyBtn)
        
        
        let brandImgView = UIImageView(frame: CGRectMake(10, gearScrollView.frame.size.height+70+10, gearScrollView.frame.size.width/2-20, 70-20))
        brandImgView.contentMode = UIViewContentMode.ScaleAspectFit
        brandImgView.backgroundColor = UIColor.clearColor()
        brandImgView.layer.masksToBounds = true
        
        // IF brandLogoImageUrl than get it
        if (brandLogoImageUrl != "") {
            
            let fileUrl = NSURL(string: brandLogoImageUrl)
            brandImgView.setNeedsLayout()
            brandImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                success: { image in
                    
                    brandImgView.image = image
                    
                },
                failure: { error in
                    
                    if ((error) != nil) {
                        print("error here: \(error)")
                        
                        // collapse, this cell - it was prob deleted - error 402
                        
                    }
            })
        } else {
            brandImgView.image = UIImage(named: "placeholder.png")
        }
        
        theScrollView.addSubview(brandImgView)
        
        //
        
        lockerBtn.frame = CGRectMake(gearScrollView.frame.size.width-10-50, gearScrollView.frame.size.height+70+10, 50, 50)
        lockerBtn.backgroundColor = UIColor.darkGrayColor()
        lockerBtn.addTarget(self, action:#selector(lockerBtnAction), forControlEvents: .TouchUpInside)
        theScrollView.addSubview(lockerBtn)
        if (existsInLocker) {
            lockerBtn.selected = true
        } else {
            lockerBtn.selected = false
        }
        
        //
        
        let lockerNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+10, gearScrollView.frame.size.height+70+10, (gearScrollView.frame.size.width/2)/2, 32))
        lockerNumLbl.text = String(lockerCount)
        lockerNumLbl.textColor = UIColor.whiteColor()
        lockerNumLbl.textAlignment = .Left
        lockerNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(lockerNumLbl)
        
        let lockerLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+10, gearScrollView.frame.size.height+70+10+32, (gearScrollView.frame.size.width/2)/2, 20))
        lockerLbl.text = "LOCKERS"
        lockerLbl.textColor = UIColor.whiteColor()
        lockerLbl.textAlignment = .Left
        lockerLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(lockerLbl)
        
        let trainingNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40-80, gearScrollView.frame.size.height+70+70+10, 80, 32))
        trainingNumLbl.text = String(trainingMomentCount)
        trainingNumLbl.textColor = UIColor.whiteColor()
        trainingNumLbl.textAlignment = .Center
        trainingNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(trainingNumLbl)
        
        let trainingLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40-80, gearScrollView.frame.size.height+70+70+10+32, 80, 20))
        trainingLbl.text = "TRAINING"
        trainingLbl.textColor = UIColor.whiteColor()
        trainingLbl.textAlignment = .Center
        trainingLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(trainingLbl)
        
        let gamingNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40, gearScrollView.frame.size.height+70+70+10, 80, 32))
        gamingNumLbl.text = String(gamingMomentCount)
        gamingNumLbl.textColor = UIColor.whiteColor()
        gamingNumLbl.textAlignment = .Center
        gamingNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(gamingNumLbl)
        
        let gamingLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40, gearScrollView.frame.size.height+70+70+10+32, 80, 20))
        gamingLbl.text = "GAMING"
        gamingLbl.textColor = UIColor.whiteColor()
        gamingLbl.textAlignment = .Center
        gamingLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(gamingLbl)
        
        let stylingNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+40, gearScrollView.frame.size.height+70+70+10, 80, 32))
        stylingNumLbl.text = String(stylingMomentCount)
        stylingNumLbl.textColor = UIColor.whiteColor()
        stylingNumLbl.textAlignment = .Center
        stylingNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(stylingNumLbl)
        
        let stylingLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+40, gearScrollView.frame.size.height+70+70+10+32, 80, 20))
        stylingLbl.text = "STYLING"
        stylingLbl.textColor = UIColor.whiteColor()
        stylingLbl.textAlignment = .Center
        stylingLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(stylingLbl)
        
        
        let productNameLbl = UILabel(frame: CGRectMake(15, gearScrollView.frame.size.height+70+70+70+padding, textWidth, productNameHeight))
        productNameLbl.text = name
        productNameLbl.textColor = UIColor.whiteColor()
        productNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 18)
        productNameLbl.lineBreakMode = .ByWordWrapping
        productNameLbl.numberOfLines = 100
        productNameLbl.textAlignment = .Center
        theScrollView.addSubview(productNameLbl)
        
        let descriptionLbl = UILabel(frame: CGRectMake(15, gearScrollView.frame.size.height+70+70+70+padding+productNameHeight+padding, textWidth, productDescriptionHeight))
        descriptionLbl.text = productDescription
        descriptionLbl.textColor = UIColor.whiteColor()
        descriptionLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        descriptionLbl.lineBreakMode = .ByWordWrapping
        descriptionLbl.numberOfLines = 100
        descriptionLbl.textAlignment = .Center
        theScrollView.addSubview(descriptionLbl)
        
        //
        
        let lineview1 = UIView()
        lineview1.frame = CGRectMake(0, gearScrollView.frame.size.height+69.5, gearScrollView.frame.size.width, 0.5)
        lineview1.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview1)
        
        let lineview1a = UIView()
        lineview1a.frame = CGRectMake(gearScrollView.frame.size.width/2-0.25, gearScrollView.frame.size.height+70, 0.5, 70)
        lineview1a.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview1a)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, gearScrollView.frame.size.height+70+69.5, gearScrollView.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview2)
        
        let lineview3 = UIView()
        lineview3.frame = CGRectMake(0, gearScrollView.frame.size.height+70+70+69.5, gearScrollView.frame.size.width, 0.5)
        lineview3.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview3)
        
        
        
        
        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .Right
        view.addGestureRecognizer(swipeBack)
        
        
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }

    func backAction() {
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func buyBtnAction() {
        
        if (productUrl != "") {
            
            let svc = SFSafariViewController(URL: NSURL(string: productUrl)!, entersReaderIfAvailable: false)
            //self.navigationController?.pushViewController(svc, animated: false)
            self.presentViewController(svc, animated: false, completion: nil)
            
            UIApplication.sharedApplication().statusBarStyle = .Default
            
        }
    }
    
    func lockerBtnAction() {
        
        if  (lockerBtn.selected) {
            print("un-select lockerBtn")
            lockerBtn.selected = false
        } else {
            print("select lockerBtn")
            lockerBtn.selected = true
            
            // add to locker
            
            
            
        }
    }
    
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    


}
