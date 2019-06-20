//
//  GearDetailViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke
import QuartzCore
import SafariServices

class GearDetailViewController: UIViewController, UIScrollViewDelegate, SFSafariViewControllerDelegate, UIGestureRecognizerDelegate {

    
    var passedGearData = JSON(data: Data())
    
    var id = NSNumber()
    var sku = ""
    var sourceId = NSNumber()
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
    
    var lockerBtn = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        // apply data
        
        id = passedGearData["id"].number!
        sku = passedGearData["sku"].string!
        sourceId = passedGearData["sourceId"].number!
        sourceProductId = passedGearData["sourceProductId"].string!
        
        name = passedGearData["name"].string!
        brand = passedGearData["brand"].string!
        
        productDescription = passedGearData["description"].string!
        productUrl = passedGearData["productUrl"].string!
        imageUrl = passedGearData["imageUrl"].string!
        
        if let _ = passedGearData["lockerCount"].number {
            lockerCount = passedGearData["lockerCount"].number!
        } else {
            lockerCount = 0
        }
        
        if let _ = passedGearData["trainingMomentCount"].number {
            trainingMomentCount = passedGearData["trainingMomentCount"].number!
        } else {
            trainingMomentCount = 0
        }
        
        if let _ = passedGearData["gamingMomentCount"].number {
            gamingMomentCount = passedGearData["gamingMomentCount"].number!
        } else {
            gamingMomentCount = 0
        }
        
        if let _ = passedGearData["stylingMomentCount"].number {
            stylingMomentCount = passedGearData["stylingMomentCount"].number!
        } else {
            stylingMomentCount = 0
        } 
        
        existsInLocker = passedGearData["existsInLocker"].bool!
        
        
        if let _ = passedGearData["brandLogoImageUrl"].string {
            brandLogoImageUrl = passedGearData["brandLogoImageUrl"].string!
        }
        
        //
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), for: UIControlState())
        backBtn.backgroundColor = UIColor.clear
        backBtn.addTarget(self, action:#selector(backAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(backBtn)
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        titleLbl.text = brand.uppercased()
        navBarView.addSubview(titleLbl)
        
        
        theScrollView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        theScrollView.backgroundColor = UIColor.clear
        theScrollView.delegate = self
        theScrollView.isPagingEnabled = false
        theScrollView.showsHorizontalScrollIndicator = false
        theScrollView.showsVerticalScrollIndicator = true
        theScrollView.scrollsToTop = true
        theScrollView.isScrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = true
        theScrollView.isUserInteractionEnabled = true
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
        
        let productNameHeight = (UIApplication.shared.delegate as! AppDelegate).heightForView(name, font: UIFont.init(name: "MaisonNeue-Bold", size: 18)!, width: textWidth)
        let productDescriptionHeight = (UIApplication.shared.delegate as! AppDelegate).heightForView(productDescription, font: UIFont.init(name: "MaisonNeue-Medium", size: 14)!, width: textWidth)
        
        let totalHeight = squareHeight+buyHeight+brandHeight+statsHeight+padding+productNameHeight+padding+productDescriptionHeight+padding+padding
        
        // measure height of padding+title+padding+description+padding
        
        // measure necessary height
        theScrollView.contentSize = CGSize(width: theScrollView.frame.size.width, height: totalHeight)
        
        
        let gearScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: theScrollView.frame.size.width, height: theScrollView.frame.size.width))
        gearScrollView.backgroundColor = UIColor.clear //UIColor.yellowColor()
        theScrollView.addSubview(gearScrollView)
        
        let imgView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: theScrollView.frame.size.width, height: theScrollView.frame.size.width))
        imgView1.contentMode = UIViewContentMode.scaleAspectFill
        imgView1.backgroundColor = UIColor.white
        theScrollView.addSubview(imgView1)
        imgView1.layer.masksToBounds = true
        
        if (imageUrl != "") {
            
            let fileUrl = URL(string: imageUrl)
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
        
        
        let buyBtn = UIButton.init(type: .custom)
        buyBtn.frame = CGRect(x: 10, y: gearScrollView.frame.size.height+10, width: theScrollView.frame.size.width-20, height: 50)
        //buyBtn.setImage(UIImage(named: "goldNav.png"), forState: UIControlState.Normal)
        
        buyBtn.backgroundColor = UIColor.clear
        buyBtn.addTarget(self, action:#selector(buyBtnAction), for:UIControlEvents.touchUpInside)
        buyBtn.titleLabel?.numberOfLines = 1
        buyBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        buyBtn.contentHorizontalAlignment = .center
        buyBtn.contentVerticalAlignment = .center
        buyBtn.titleLabel?.textAlignment = .center
        theScrollView.addSubview(buyBtn)
        
        if (productUrl == "") {
            buyBtn.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
            buyBtn.setTitleColor(UIColor.gray, for: UIControlState())
            buyBtn.setTitleColor(UIColor.gray, for: .selected)
            //buyBtn.setBackgroundImage(UIImage(named: "blackNav.png"), forState: .Normal)
            buyBtn.setTitle("NOT AVAILABLE", for: UIControlState())
        } else {
            buyBtn.setTitleColor(UIColor.white, for: UIControlState())
            buyBtn.setTitleColor(UIColor.white, for: .selected)
            buyBtn.setBackgroundImage(UIImage(named: "goldNav.png"), for: UIControlState())
            buyBtn.setTitle("BUY NOW", for: UIControlState())
        }
        
        let brandImgView = UIImageView(frame: CGRect(x: 10, y: gearScrollView.frame.size.height+70+10, width: gearScrollView.frame.size.width/2-20, height: 70-20))
        brandImgView.contentMode = UIViewContentMode.scaleAspectFit
        brandImgView.backgroundColor = UIColor.clear
        brandImgView.layer.masksToBounds = true
        
        
        // IF brandLogoImageUrl than get it
        if (brandLogoImageUrl != "") {
            
            let fileUrl = URL(string: brandLogoImageUrl)
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
        
        lockerBtn.frame = CGRect(x: gearScrollView.frame.size.width-10-50, y: gearScrollView.frame.size.height+70+10, width: 50, height: 50)
        lockerBtn.backgroundColor = UIColor.darkGray
        lockerBtn.setImage(UIImage(named: "add-gear.png"), for: UIControlState())
        lockerBtn.addTarget(self, action:#selector(lockerBtnAction), for: .touchUpInside)
        theScrollView.addSubview(lockerBtn)
        if (existsInLocker) {
            lockerBtn.isSelected = true
        } else {
            lockerBtn.isSelected = false
        }
        
        //
        
        let lockerNumLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2+10, y: gearScrollView.frame.size.height+70+10, width: (gearScrollView.frame.size.width/2)/2, height: 32))
        lockerNumLbl.text = String(lockerCount)
        lockerNumLbl.textColor = UIColor.white
        lockerNumLbl.textAlignment = .left
        lockerNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(lockerNumLbl)
        
        let lockerLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2+10, y: gearScrollView.frame.size.height+70+10+32, width: (gearScrollView.frame.size.width/2)/2, height: 20))
        lockerLbl.text = "LOCKERS"
        lockerLbl.textColor = UIColor.white
        lockerLbl.textAlignment = .left
        lockerLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(lockerLbl)
        
        let trainingNumLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2-40-80, y: gearScrollView.frame.size.height+70+70+10, width: 80, height: 32))
        trainingNumLbl.text = String(trainingMomentCount)
        trainingNumLbl.textColor = UIColor.white
        trainingNumLbl.textAlignment = .center
        trainingNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(trainingNumLbl)
        
        let trainingLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2-40-80, y: gearScrollView.frame.size.height+70+70+10+32, width: 80, height: 20))
        trainingLbl.text = "TRAINING"
        trainingLbl.textColor = UIColor.white
        trainingLbl.textAlignment = .center
        trainingLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(trainingLbl)
        
        let gamingNumLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2-40, y: gearScrollView.frame.size.height+70+70+10, width: 80, height: 32))
        gamingNumLbl.text = String(gamingMomentCount)
        gamingNumLbl.textColor = UIColor.white
        gamingNumLbl.textAlignment = .center
        gamingNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(gamingNumLbl)
        
        let gamingLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2-40, y: gearScrollView.frame.size.height+70+70+10+32, width: 80, height: 20))
        gamingLbl.text = "GAMING"
        gamingLbl.textColor = UIColor.white
        gamingLbl.textAlignment = .center
        gamingLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(gamingLbl)
        
        let stylingNumLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2+40, y: gearScrollView.frame.size.height+70+70+10, width: 80, height: 32))
        stylingNumLbl.text = String(stylingMomentCount)
        stylingNumLbl.textColor = UIColor.white
        stylingNumLbl.textAlignment = .center
        stylingNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
        theScrollView.addSubview(stylingNumLbl)
        
        let stylingLbl = UILabel(frame: CGRect(x: gearScrollView.frame.size.width/2+40, y: gearScrollView.frame.size.height+70+70+10+32, width: 80, height: 20))
        stylingLbl.text = "STYLING"
        stylingLbl.textColor = UIColor.white
        stylingLbl.textAlignment = .center
        stylingLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        theScrollView.addSubview(stylingLbl)
        
        
        let productNameLbl = UILabel(frame: CGRect(x: 15, y: gearScrollView.frame.size.height+70+70+70+padding, width: textWidth, height: productNameHeight))
        productNameLbl.text = name
        productNameLbl.textColor = UIColor.white
        productNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 18)
        productNameLbl.lineBreakMode = .byWordWrapping
        productNameLbl.numberOfLines = 100
        productNameLbl.textAlignment = .center
        theScrollView.addSubview(productNameLbl)
        
        let descriptionLbl = UILabel(frame: CGRect(x: 15, y: gearScrollView.frame.size.height+70+70+70+padding+productNameHeight+padding, width: textWidth, height: productDescriptionHeight))
        descriptionLbl.text = productDescription
        descriptionLbl.textColor = UIColor.white
        descriptionLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        descriptionLbl.lineBreakMode = .byWordWrapping
        descriptionLbl.numberOfLines = 100
        descriptionLbl.textAlignment = .center
        theScrollView.addSubview(descriptionLbl)
        
        //
        
        let lineview1 = UIView()
        lineview1.frame = CGRect(x: 0, y: gearScrollView.frame.size.height+69.5, width: gearScrollView.frame.size.width, height: 0.5)
        lineview1.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview1)
        
        let lineview1a = UIView()
        lineview1a.frame = CGRect(x: gearScrollView.frame.size.width/2-0.25, y: gearScrollView.frame.size.height+70, width: 0.5, height: 70)
        lineview1a.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview1a)
        
        let lineview2 = UIView()
        lineview2.frame = CGRect(x: 0, y: gearScrollView.frame.size.height+70+69.5, width: gearScrollView.frame.size.width, height: 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview2)
        
        let lineview3 = UIView()
        lineview3.frame = CGRect(x: 0, y: gearScrollView.frame.size.height+70+70+69.5, width: gearScrollView.frame.size.width, height: 0.5)
        lineview3.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theScrollView.addSubview(lineview3)
        
        
        
        
        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
        
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }

    func backAction() {
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func buyBtnAction() {
        
        if (productUrl != "") {
            
            let svc = SFSafariViewController(url: URL(string: productUrl)!, entersReaderIfAvailable: false)
            //self.navigationController?.pushViewController(svc, animated: false)
            self.present(svc, animated: false, completion: nil)
            
            UIApplication.shared.statusBarStyle = .default
            
        }
    }
    
    func lockerBtnAction() {
        
        if  (lockerBtn.isSelected) {
            print("un-select lockerBtn")
            lockerBtn.isSelected = false
        } else {
            print("select lockerBtn")
            lockerBtn.isSelected = true
            
            // add to locker
            
            
            
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        controller.dismiss(animated: true, completion: nil)
        
        
    }
    
    


}
