//
//  GearListViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/5/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore
import SwiftyJSON
import Haneke

class GearListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    var passedProducts = []
    
    var gearData = NSData()
    
    var theCollectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    
    var objArray = NSMutableArray()
    
    var navBarView = UIView()
    
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
        titleLbl.text = "GEAR"
        titleLbl.font = UIFont.boldSystemFontOfSize(17)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        //
        //
        //
        
        let cellWidth = self.view.frame.size.width/2
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        self.theCollectionView = UICollectionView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49), collectionViewLayout: layout)
        self.theCollectionView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.theCollectionView.dataSource = self
        self.theCollectionView.delegate = self
        //self.theCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.theCollectionView!.registerClass(GearCell.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.theCollectionView)
        self.theCollectionView.bounces = true
        self.theCollectionView.scrollEnabled = true
        self.theCollectionView.alwaysBounceVertical = true
        
        //
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.backAction))
        swipeRight.direction = .Right
        self.view.addGestureRecognizer(swipeRight)
        
        //
        
        self.queryForGear()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func queryForGear() {
        
        // https://api1.phenomapp.com:8081/moment?momentId=STRING
        
        // gear list inside moment json
        
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let bearerToken = defaults.objectForKey("bearerToken") as! NSString
//        
//        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
//        
//        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//        
//        guard let URL = NSURL(string: "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)") else {return}
//        let request = NSMutableURLRequest(URL: URL)
//        request.HTTPMethod = "GET"
//        
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("\((UIApplication.sharedApplication().delegate as! AppDelegate).apiVersion)", forHTTPHeaderField: "apiVersion")
//        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            
//            let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                if (error == nil) {
//                    
//                    let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
//                    
//                    if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
//                        
//                        let json = JSON(data: dataFromString)
//                        if json["errorCode"].number != 200  {
//                            print("json: \(json)")
//                            print("error: \(json["errorCode"].number)")
//                            
//                            return
//                        }
//                        
//                        self.gearData = dataFromString
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            
//                            self.theCollectionView.reloadData()
//                            
//                        })
//                        
//                    } else {
//                        print("URL Session Task Failed: %@", error!.localizedDescription);
//                    }
//                }
//                
//            })
//            task.resume()
//        })
        
    }
    
    
    // CollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11 // self.objArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GearCell
        
        cell.backgroundColor = UIColor.greenColor()
        
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
//        let gearArray = JSON(data: self.gearData)
//        let results = gearArray["results"]
//        
//        
//        
//        let vc = GearDetailViewController()
//        
//        let id = results[sender.tag]["id"].number
//        let sku = results[sender.tag]["sku"].string
//        let sourceId = results[sender.tag]["sourceId"].number
//        let sourceProductId = results[sender.tag]["sourceProductId"].string
//        
//        let name = results[sender.tag]["name"].string
//        let brand = results[sender.tag]["brand"].string
//        
//        let productDescription = results[sender.tag]["description"].string
//        let productUrl = results[sender.tag]["productUrl"].string
//        let imageUrl = results[sender.tag]["imageUrl"].string
//        
//        let lockerCount = results[sender.tag]["lockerCount"].number
//        let trainingMomentCount = results[sender.tag]["trainingMomentCount"].number
//        let gamingMomentCount = results[sender.tag]["gamingMomentCount"].number
//        let stylingMomentCount = results[sender.tag]["stylingMomentCount"].number
//        
//        let existsInLocker = results[sender.tag]["existsInLocker"].bool
//        
//        
//        vc.id = "\(id!)"
//        vc.sku = sku!
//        vc.sourceId = "\(sourceId!)"
//        vc.sourceProductId = sourceProductId!
//        vc.name = name!
//        vc.brand = brand!
//        
//        if let brandLogoImageUrl = results[sender.tag]["brandLogoImageUrl"].string {
//            vc.brandLogoImageUrl = brandLogoImageUrl
//        }
//        
//        vc.productDescription = productDescription!
//        vc.productUrl = productUrl!
//        vc.imageUrl = imageUrl!
//        vc.lockerCount = lockerCount!
//        vc.trainingMomentCount = trainingMomentCount!
//        vc.gamingMomentCount = gamingMomentCount!
//        vc.stylingMomentCount = stylingMomentCount!
//        vc.existsInLocker = existsInLocker!
//        
//        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    //    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    //        var reusableView : UICollectionReusableView? = nil
    //
    //        // Create header
    //        if (kind == UICollectionElementKindSectionHeader) {
    //            // Create Header
    //            var headerView : PackCollectionSectionView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kCellheaderReuse, forIndexPath: indexPath) as PackCollectionSectionView
    //
    //            reusableView = headerView
    //        }
    //        return reusableView!
    //    }
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = self.view.frame.size.width/2
        
        return CGSize(width: cellWidth, height: cellWidth) // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0) // margin between cells
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(self.view.frame.width, 0)  // Header size
    }
    
    //    func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    //        return false
    //    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    

}
