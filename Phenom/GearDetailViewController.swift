//
//  GearDetailViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class GearDetailViewController: UIViewController, UIScrollViewDelegate {

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

        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:20/255, green:20/255, blue:22/255, alpha:1)
        
        self.navBarView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64)
        self.navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.navBarView)
        
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.frame = CGRectMake(20, 20, 70, 44)
        backBtn.setImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.redColor()
        backBtn.addTarget(self, action:#selector(self.backAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, self.navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        titleLbl.text = brand.uppercaseString
        self.navBarView.addSubview(titleLbl)
        
        
        self.theScrollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49)
        self.theScrollView.backgroundColor = UIColor.clearColor()
        self.theScrollView.delegate = self
        self.theScrollView.pagingEnabled = false
        self.theScrollView.showsHorizontalScrollIndicator = false
        self.theScrollView.showsVerticalScrollIndicator = true
        self.theScrollView.scrollsToTop = true
        self.theScrollView.scrollEnabled = true
        self.theScrollView.bounces = true
        self.theScrollView.alwaysBounceVertical = true
        self.theScrollView.userInteractionEnabled = true
        self.view.addSubview(self.theScrollView)
        self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.theScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        
        let squareHeight = self.view.frame.size.width
        let buyHeight = CGFloat(70)
        let brandHeight = CGFloat(70)
        let statsHeight = CGFloat(70)
        
        let padding = CGFloat(20)
        let textWidth = self.view.frame.size.width-30
        
//        let productName = NSString(string: "Junior supreme 170 ice hockey elbow pads").uppercaseString
//        let productDescription = NSString(string: "this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. this is a test of the american broadcasting system. ").uppercaseString
        
        let productNameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(name, font: UIFont.boldSystemFontOfSize(20), width: textWidth)
        let productDescriptionHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(productDescription, font: UIFont.boldSystemFontOfSize(14), width: textWidth)
        
        let totalHeight = squareHeight+buyHeight+brandHeight+statsHeight+padding+productNameHeight+padding+productDescriptionHeight+padding
        
        // measure height of padding+title+padding+description+padding
        
        // measure necessary height
        self.theScrollView.contentSize = CGSize(width: self.theScrollView.frame.size.width, height: totalHeight)
        
        
        let gearScrollView = UIScrollView(frame: CGRectMake(0, 0, self.theScrollView.frame.size.width, self.theScrollView.frame.size.width))
        gearScrollView.backgroundColor = UIColor.yellowColor()
        self.theScrollView.addSubview(gearScrollView)
        
        let buyBtn = UIButton.init(type: .Custom)
        buyBtn.frame = CGRectMake(10, gearScrollView.frame.size.height+10, self.theScrollView.frame.size.width-20, 50)
        buyBtn.backgroundColor = UIColor.blueColor()
        buyBtn.setTitle("buy now", forState: .Normal)
        buyBtn.addTarget(self, action:#selector(self.buyBtnAction), forControlEvents: .TouchUpInside)
        self.theScrollView.addSubview(buyBtn)
        
        
        let brandImgView = UIImageView(frame: CGRectMake(0, gearScrollView.frame.size.height+70, gearScrollView.frame.size.width/2, 70))
        brandImgView.backgroundColor = UIColor.redColor()
        
        // IF brandLogoImageUrl than get it
        
        self.theScrollView.addSubview(brandImgView)
        
        //
        
        self.lockerBtn.frame = CGRectMake(gearScrollView.frame.size.width-10-50, gearScrollView.frame.size.height+70+10, 50, 50)
        self.lockerBtn.backgroundColor = UIColor.darkGrayColor()
        self.lockerBtn.addTarget(self, action:#selector(self.lockerBtnAction), forControlEvents: .TouchUpInside)
        self.theScrollView.addSubview(self.lockerBtn)
        if (existsInLocker) {
            self.lockerBtn.selected = true
        } else {
            self.lockerBtn.selected = false
        }
        
        //
        
        let lockerNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+10, gearScrollView.frame.size.height+70+10, (gearScrollView.frame.size.width/2)/2, 40))
        lockerNumLbl.text = String(lockerCount)
        lockerNumLbl.textColor = UIColor.whiteColor()
        lockerNumLbl.textAlignment = .Left
        lockerNumLbl.font = UIFont.boldSystemFontOfSize(30)
        self.theScrollView.addSubview(lockerNumLbl)
        
        let lockerLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+10, gearScrollView.frame.size.height+70+10+40, (gearScrollView.frame.size.width/2)/2, 20))
        lockerLbl.text = "LOCKERS"
        lockerLbl.textColor = UIColor.whiteColor()
        lockerLbl.textAlignment = .Left
        lockerLbl.font = UIFont.boldSystemFontOfSize(12)
        self.theScrollView.addSubview(lockerLbl)
        
        let trainingNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40-80, gearScrollView.frame.size.height+70+70+10, 80, 40))
        trainingNumLbl.text = String(trainingMomentCount)
        trainingNumLbl.textColor = UIColor.whiteColor()
        trainingNumLbl.textAlignment = .Center
        trainingNumLbl.font = UIFont.boldSystemFontOfSize(30)
        self.theScrollView.addSubview(trainingNumLbl)
        
        let trainingLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40-80, gearScrollView.frame.size.height+70+70+10+40, 80, 20))
        trainingLbl.text = "TRAINING"
        trainingLbl.textColor = UIColor.whiteColor()
        trainingLbl.textAlignment = .Center
        trainingLbl.font = UIFont.boldSystemFontOfSize(12)
        self.theScrollView.addSubview(trainingLbl)
        
        let gamingNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40, gearScrollView.frame.size.height+70+70+10, 80, 40))
        gamingNumLbl.text = String(gamingMomentCount)
        gamingNumLbl.textColor = UIColor.whiteColor()
        gamingNumLbl.textAlignment = .Center
        gamingNumLbl.font = UIFont.boldSystemFontOfSize(30)
        self.theScrollView.addSubview(gamingNumLbl)
        
        let gamingLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2-40, gearScrollView.frame.size.height+70+70+10+40, 80, 20))
        gamingLbl.text = "GAMING"
        gamingLbl.textColor = UIColor.whiteColor()
        gamingLbl.textAlignment = .Center
        gamingLbl.font = UIFont.boldSystemFontOfSize(12)
        self.theScrollView.addSubview(gamingLbl)
        
        let stylingNumLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+40, gearScrollView.frame.size.height+70+70+10, 80, 40))
        stylingNumLbl.text = String(stylingMomentCount)
        stylingNumLbl.textColor = UIColor.whiteColor()
        stylingNumLbl.textAlignment = .Center
        stylingNumLbl.font = UIFont.boldSystemFontOfSize(30)
        self.theScrollView.addSubview(stylingNumLbl)
        
        let stylingLbl = UILabel(frame: CGRectMake(gearScrollView.frame.size.width/2+40, gearScrollView.frame.size.height+70+70+10+40, 80, 20))
        stylingLbl.text = "STYLING"
        stylingLbl.textColor = UIColor.whiteColor()
        stylingLbl.textAlignment = .Center
        stylingLbl.font = UIFont.boldSystemFontOfSize(12)
        self.theScrollView.addSubview(stylingLbl)
        
        
        let productNameLbl = UILabel(frame: CGRectMake(15, gearScrollView.frame.size.height+70+70+70+padding, textWidth, productNameHeight))
        productNameLbl.text = name
        productNameLbl.textColor = UIColor.whiteColor()
        productNameLbl.font = UIFont.boldSystemFontOfSize(20)
        productNameLbl.lineBreakMode = .ByWordWrapping
        productNameLbl.numberOfLines = 100
        productNameLbl.textAlignment = .Center
        self.theScrollView.addSubview(productNameLbl)
        
        let descriptionLbl = UILabel(frame: CGRectMake(15, gearScrollView.frame.size.height+70+70+70+padding+productNameHeight+padding, textWidth, productDescriptionHeight))
        descriptionLbl.text = productDescription
        descriptionLbl.textColor = UIColor.whiteColor()
        descriptionLbl.font = UIFont.boldSystemFontOfSize(14)
        descriptionLbl.lineBreakMode = .ByWordWrapping
        descriptionLbl.numberOfLines = 100
        descriptionLbl.textAlignment = .Center
        self.theScrollView.addSubview(descriptionLbl)
        
        //
        
        let lineview1 = UIView()
        lineview1.frame = CGRectMake(0, gearScrollView.frame.size.height+69.5, gearScrollView.frame.size.width, 0.5)
        lineview1.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.theScrollView.addSubview(lineview1)
        
        let lineview1a = UIView()
        lineview1a.frame = CGRectMake(gearScrollView.frame.size.width/2-0.25, gearScrollView.frame.size.height+70, 0.5, 70)
        lineview1a.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.theScrollView.addSubview(lineview1a)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, gearScrollView.frame.size.height+70+69.5, gearScrollView.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.theScrollView.addSubview(lineview2)
        
        let lineview3 = UIView()
        lineview3.frame = CGRectMake(0, gearScrollView.frame.size.height+70+70+69.5, gearScrollView.frame.size.width, 0.5)
        lineview3.backgroundColor = UIColor.init(white: 0.88, alpha: 1.0)
        self.theScrollView.addSubview(lineview3)
        
        
        
        
        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.backAction))
        swipeBack.direction = .Right
        self.view.addGestureRecognizer(swipeBack)
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func buyBtnAction() {
        
        
    }
    
    func lockerBtnAction() {
        
        if  (self.lockerBtn.selected) {
            print("un-select lockerBtn")
            self.lockerBtn.selected = false
        } else {
            print("select lockerBtn")
            self.lockerBtn.selected = true
        }
    }
    


}
