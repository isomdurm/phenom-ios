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
        titleLbl.text = "EXPLORE GEAR"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let searchBtn = UIButton(type: .Custom)
        searchBtn.frame = CGRectMake(view.frame.size.width-70-20, 20, 70, 44)
        searchBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //searchBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.blueColor()
        searchBtn.addTarget(self, action:#selector(searchBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(searchBtn)
        
        let cellWidth = view.frame.size.width/2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth+20)
        
        theCollectionView = UICollectionView(frame: CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49), collectionViewLayout: layout)
        theCollectionView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        theCollectionView!.registerClass(GearCell.self, forCellWithReuseIdentifier: "Cell")
        theCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        view.addSubview(theCollectionView)
        theCollectionView.bounces = true
        theCollectionView.scrollEnabled = true
        theCollectionView.alwaysBounceVertical = true

        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .Right
        view.addGestureRecognizer(swipeBack)
        theCollectionView.addGestureRecognizer(swipeBack)
        
        //
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadExploreGear(_:)), name:"ReloadExploreGearNotification" ,object: nil)
        
        //
        
        queryForGear()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore) {
            (UIApplication.sharedApplication().delegate as! AppDelegate).reloadExplore = false
            //queryForFeatured()
        }
        
        isSearching = false
    }
    
    func backAction() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBtnAction() {
        
        // pre-select "gear"
        
        let vc = SearchViewController()
        vc.selectedTab = "gear"
        navigationController?.pushViewController(vc, animated: false)
        
        isSearching = true
        
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
            
            sportObj = obj
            
            if (obj == "ALL") {
                // set btn as "SPORT"
            } else {
             
                
            }
        } else {
            
            categoryObj = obj
            
            if (obj == "ALL") {
                // set btn as "CATEGORY"
                
            } else {

                
            }
        }
        
        //
        
        theCollectionView.setContentOffset(CGPoint.zero, animated: false)
        
        //
        
        queryForGear()
        
        //
        
    }
    
    func queryForGear() {
        
        // blank collectionView
        
        gearData = NSData()
        theCollectionView.reloadData()
       
        // query with new params
        
        
        
        
        // reload collectionView
        
        theCollectionView.reloadData()
        
    }
    
    
    func navBtnAction() {
        //        print("navBtnAction hit")
        
        navigationController?.pushViewController(SearchViewController(), animated: false)
        
        isSearching = true
        
    }
    
    
    // CollectionViewDelegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11 // objArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GearCell
        
        cell.backgroundColor = UIColor.greenColor()
        
        
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        navigationController?.pushViewController(GearDetailViewController(), animated: true)
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        // Create header
        if (kind == UICollectionElementKindSectionHeader) {
            // Create Header
            let headerView : UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", forIndexPath: indexPath)
            
            let headerHeight = theCollectionView.frame.size.width/2+70
            headerView.frame = CGRectMake(0, 0, theCollectionView.frame.size.width, headerHeight)
            
            //theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, headerHeight))
            headerView.backgroundColor = UIColor.whiteColor()
            
            let heroView = UIView(frame: CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.width/2))
            heroView.backgroundColor = UIColor.lightGrayColor()
            headerView.addSubview(heroView)
            
            let sportBtn = UIButton.init(type: UIButtonType.Custom)
            sportBtn.frame = CGRectMake(10, headerView.frame.size.width/2+10, headerView.frame.size.width/2-15, 50)
            sportBtn.backgroundColor = UIColor.greenColor()
            sportBtn.addTarget(self, action:#selector(sportBtnAction), forControlEvents:.TouchUpInside)
            sportBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
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
            categoryBtn.addTarget(self, action:#selector(categoryBtnAction), forControlEvents:.TouchUpInside)
            categoryBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
            categoryBtn.titleLabel?.numberOfLines = 1
            categoryBtn.contentHorizontalAlignment = .Center
            categoryBtn.contentVerticalAlignment = .Center
            categoryBtn.titleLabel?.textAlignment = .Center
            categoryBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            categoryBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
            headerView.addSubview(categoryBtn)
            
            
            if (sportObj == "ALL") {
                sportBtn.setTitle("SPORT", forState: .Normal)
            } else {
                sportBtn.setTitle(sportObj, forState: .Normal)
            }
            
            if (categoryObj == "ALL") {
                categoryBtn.setTitle("CATEGORY", forState: .Normal)
            } else {
                categoryBtn.setTitle(categoryObj, forState: .Normal)
            }
            
            
            reusableView = headerView
        }
        return reusableView!
    }

    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = view.frame.size.width/2
        
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
        
        let headerHeight = theCollectionView.frame.size.width/2+70
        return CGSizeMake(view.frame.width, headerHeight)  // Header size
    }
    
    //    func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    //        return false
    //    }

    
    
    // 
    
    
    func sportBtnAction() {
        
        // present drop down just below this button
        
        let vc = FilterViewController()
        vc.passedType = "SPORT"
        vc.selectedObj = sportObj
        let newnav = UINavigationController(rootViewController: vc)
        navigationController?.presentViewController(newnav, animated: true, completion: nil)
        
    }

    func categoryBtnAction() {
        
        let vc = FilterViewController()
        vc.passedType = "CATEGORY"
        vc.selectedObj = categoryObj
        let newnav = UINavigationController(rootViewController: vc)
        navigationController?.presentViewController(newnav, animated: true, completion: nil)
        
    }
}
