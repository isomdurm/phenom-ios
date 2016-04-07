//
//  ExploreGearViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class ExploreGearViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var collectionsData = NSData()
    var gearData = NSData()
    
    var navBarView = UIView()
    
    var theCollectionView: UICollectionView!
    
    var isSearching: Bool = false
    
    var sportObj = "ALL"
    var categoryObj = "ALL"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
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
        titleLbl.text = "EXPLORE GEAR"
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.whiteColor()
        self.navBarView.addSubview(titleLbl)
        
        let searchBtn = UIButton(type: .Custom)
        searchBtn.frame = CGRectMake(self.view.frame.size.width-70-20, 20, 70, 44)
        searchBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //searchBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.blueColor()
        searchBtn.addTarget(self, action:#selector(self.searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.navBarView.addSubview(searchBtn)
        
        let cellWidth = self.view.frame.size.width/2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth+20)
        
        self.theCollectionView = UICollectionView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-49), collectionViewLayout: layout)
        self.theCollectionView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.theCollectionView.dataSource = self
        self.theCollectionView.delegate = self
        self.theCollectionView!.registerClass(GearCell.self, forCellWithReuseIdentifier: "Cell")
        self.theCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        self.view.addSubview(self.theCollectionView)
        self.theCollectionView.bounces = true
        self.theCollectionView.scrollEnabled = true
        self.theCollectionView.alwaysBounceVertical = true

        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(self.backAction))
        swipeBack.direction = .Right
        self.view.addGestureRecognizer(swipeBack)
        self.theCollectionView.addGestureRecognizer(swipeBack)
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadExploreGear(_:)), name:"ReloadExploreGearNotification" ,object: nil)
        
        //
        
        self.queryForGear()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore = false
            //self.queryForFeatured()
        }
        
        self.isSearching = false
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBtnAction() {
        
        // pre-select "gear"
        
        let vc = SearchViewController()
        vc.selectedTab = "gear"
        self.navigationController?.pushViewController(vc, animated: false)
        
        self.isSearching = true
        
    }
    
    func reloadExploreGear(notification: NSNotification){
        
        let dict = notification.userInfo! as NSDictionary
        
        let type = dict.objectForKey("type") as! String
        let obj = dict.objectForKey("obj") as! String

        // update obj
        // update filter btn
        // scroll to top
        // reload collectionView
        
        if (type == "SPORT") {
            
            self.sportObj = obj
            
            if (obj == "ALL") {
                // set btn as "SPORT"
            } else {
             
                
            }
        } else {
            
            self.categoryObj = obj
            
            if (obj == "ALL") {
                // set btn as "CATEGORY"
                
            } else {

                
            }
        }
        
        //
        
        self.theCollectionView.setContentOffset(CGPoint.zero, animated: false)
        
        //
        
        self.queryForGear()
        
        //
        
    }
    
    func queryForGear() {
        
        // blank collectionView
        
        self.gearData = NSData()
        self.theCollectionView.reloadData()
       
        // query with new params
        
        
        
        
        // reload collectionView
        
        self.theCollectionView.reloadData()
        
    }
    
    
    func navBtnAction() {
        //        print("navBtnAction hit")
        
        self.navigationController?.pushViewController(SearchViewController(), animated: false)
        
        self.isSearching = true
        
    }
    
    
    // CollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11 // self.objArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GearCell
        
        cell.backgroundColor = UIColor.greenColor()
        
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        self.navigationController?.pushViewController(GearDetailViewController(), animated: true)
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        // Create header
        if (kind == UICollectionElementKindSectionHeader) {
            // Create Header
            let headerView : UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath)
            
            let headerHeight = self.theCollectionView.frame.size.width/2+70
            headerView.frame = CGRectMake(0, 0, self.theCollectionView.frame.size.width, headerHeight)
            
            //self.theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.theTableView.frame.size.width, headerHeight))
            headerView.backgroundColor = UIColor.whiteColor()
            
            let heroView = UIView(frame: CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.width/2))
            heroView.backgroundColor = UIColor.lightGrayColor()
            headerView.addSubview(heroView)
            
            let sportBtn = UIButton.init(type: UIButtonType.Custom)
            sportBtn.frame = CGRectMake(10, headerView.frame.size.width/2+10, headerView.frame.size.width/2-15, 50)
            sportBtn.backgroundColor = UIColor.greenColor()
            sportBtn.addTarget(self, action:#selector(self.sportBtnAction), forControlEvents:.TouchUpInside)
            sportBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            sportBtn.titleLabel?.numberOfLines = 1
            sportBtn.contentHorizontalAlignment = .Center
            sportBtn.contentVerticalAlignment = .Center
            sportBtn.titleLabel?.textAlignment = .Center
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            sportBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            headerView.addSubview(sportBtn)
            
            let categoryBtn = UIButton.init(type: UIButtonType.Custom)
            categoryBtn.frame = CGRectMake(headerView.frame.size.width/2+5, headerView.frame.size.width/2+10, headerView.frame.size.width/2-15, 50)
            categoryBtn.backgroundColor = UIColor.greenColor()
            categoryBtn.addTarget(self, action:#selector(self.categoryBtnAction), forControlEvents:.TouchUpInside)
            categoryBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            categoryBtn.titleLabel?.numberOfLines = 1
            categoryBtn.contentHorizontalAlignment = .Center
            categoryBtn.contentVerticalAlignment = .Center
            categoryBtn.titleLabel?.textAlignment = .Center
            categoryBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            categoryBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            headerView.addSubview(categoryBtn)
            
            
            if (self.sportObj == "ALL") {
                sportBtn.setTitle("SPORT", forState: .Normal)
            } else {
                sportBtn.setTitle(self.sportObj, forState: .Normal)
            }
            
            if (self.categoryObj == "ALL") {
                categoryBtn.setTitle("CATEGORY", forState: .Normal)
            } else {
                categoryBtn.setTitle(self.categoryObj, forState: .Normal)
            }
            
            
            reusableView = headerView
        }
        return reusableView!
    }

    
    
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
        
        let headerHeight = self.theCollectionView.frame.size.width/2+70
        return CGSizeMake(self.view.frame.width, headerHeight)  // Header size
    }
    
    //    func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    //        return false
    //    }

    
    
    // 
    
    
    func sportBtnAction() {
        
        // present drop down just below this button
        
        let vc = FilterViewController()
        vc.passedType = "SPORT"
        vc.selectedObj = self.sportObj
        let newnav = UINavigationController(rootViewController: vc)
        self.navigationController?.presentViewController(newnav, animated: true, completion: nil)
        
    }

    func categoryBtnAction() {
        
        let vc = FilterViewController()
        vc.passedType = "CATEGORY"
        vc.selectedObj = self.categoryObj
        let newnav = UINavigationController(rootViewController: vc)
        self.navigationController?.presentViewController(newnav, animated: true, completion: nil)
        
    }
}
