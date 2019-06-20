//
//  ExploreGearViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class ExploreGearViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {

    var collectionsData = Data()
    var gearData = Data()
    
    var navBarView = UIView()
    
    var theCollectionView: UICollectionView!
    
    var isSearching: Bool = false
    
    var sportObj = "ALL"
    var categoryObj = "ALL"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
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
        titleLbl.text = "EXPLORE GEAR"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let searchBtn = UIButton(type: .custom)
        searchBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        searchBtn.setImage(UIImage(named: "tabbar-explore-icon.png"), for: UIControlState())
        //searchBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        searchBtn.backgroundColor = UIColor.clear
        searchBtn.addTarget(self, action:#selector(searchBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(searchBtn)
        
        let cellWidth = view.frame.size.width/2
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth+20)
        
        theCollectionView = UICollectionView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49), collectionViewLayout: layout)
        theCollectionView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theCollectionView.dataSource = self
        theCollectionView.delegate = self
        theCollectionView!.register(GearCell.self, forCellWithReuseIdentifier: "Cell")
        theCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        view.addSubview(theCollectionView)
        theCollectionView.bounces = true
        theCollectionView.isScrollEnabled = true
        theCollectionView.alwaysBounceVertical = true

        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
        
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExploreGear(_:)), name:"ReloadExploreGearNotification" ,object: nil)
        
        //
        
        queryForGear()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((UIApplication.shared.delegate as! AppDelegate).reloadExplore) {
            (UIApplication.shared.delegate as! AppDelegate).reloadExplore = false
            //queryForFeatured()
        }
        
        isSearching = false
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
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
    
    func searchBtnAction() {
        
        // pre-select "gear"
        
        let vc = SearchViewController()
        vc.selectedTab = "gear"
        navigationController?.pushViewController(vc, animated: false)
        
        isSearching = true
        
    }
    
    func reloadExploreGear(_ notification: Notification){
        
        let dict = notification.userInfo! as NSDictionary
        
        let type = dict.object(forKey: "type") as! String
        let obj = dict.object(forKey: "obj") as! String

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
        
        gearData = Data()
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11 // objArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GearCell
        
        
        cell.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        //navigationController?.pushViewController(GearDetailViewController(), animated: true)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        // Create header
        if (kind == UICollectionElementKindSectionHeader) {
            // Create Header
            let headerView : UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)
            
            let heroHeight = theCollectionView.frame.size.width/2
            
            let headerHeight = theCollectionView.frame.size.width/2+70
            headerView.frame = CGRect(x: 0, y: 0, width: theCollectionView.frame.size.width, height: headerHeight)
            
            //theTableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, theTableView.frame.size.width, headerHeight))
            headerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
            
//            let heroView = UIView(frame: CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.width/2))
//            heroView.backgroundColor = UIColor.lightGrayColor()
//            headerView.addSubview(heroView)
            
            let heroBtn = UIButton.init(type: UIButtonType.custom)
            heroBtn.frame = CGRect(x: 0, y: 0, width: theCollectionView.frame.size.width, height: heroHeight)
            heroBtn.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
            heroBtn.addTarget(self, action:#selector(heroBtnAction), for:.touchUpInside)
            heroBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 25)
            heroBtn.titleLabel?.numberOfLines = 1
            heroBtn.contentHorizontalAlignment = .center
            heroBtn.contentVerticalAlignment = .center
            heroBtn.titleLabel?.textAlignment = .center
            heroBtn.setTitleColor(UIColor.white, for: UIControlState())
            heroBtn.setTitleColor(UIColor.white, for: .highlighted)
            heroBtn.setTitle("POPULAR GEAR", for: UIControlState())
            headerView.addSubview(heroBtn)
            
            let sportBtn = UIButton.init(type: UIButtonType.custom)
            sportBtn.frame = CGRect(x: 10, y: headerView.frame.size.width/2+10, width: headerView.frame.size.width/2-15, height: 50)
            sportBtn.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
            sportBtn.addTarget(self, action:#selector(sportBtnAction), for:.touchUpInside)
            sportBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
            sportBtn.titleLabel?.numberOfLines = 1
            sportBtn.contentHorizontalAlignment = .center
            sportBtn.contentVerticalAlignment = .center
            sportBtn.titleLabel?.textAlignment = .center
            sportBtn.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState())
            sportBtn.setTitleColor(UINavigationBar.appearance().tintColor, for: .highlighted)
            headerView.addSubview(sportBtn)
            sportBtn.layer.cornerRadius = 4
            sportBtn.layer.masksToBounds = true
            
            let categoryBtn = UIButton.init(type: UIButtonType.custom)
            categoryBtn.frame = CGRect(x: headerView.frame.size.width/2+5, y: headerView.frame.size.width/2+10, width: headerView.frame.size.width/2-15, height: 50)
            categoryBtn.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
            categoryBtn.addTarget(self, action:#selector(categoryBtnAction), for:.touchUpInside)
            categoryBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
            categoryBtn.titleLabel?.numberOfLines = 1
            categoryBtn.contentHorizontalAlignment = .center
            categoryBtn.contentVerticalAlignment = .center
            categoryBtn.titleLabel?.textAlignment = .center
            categoryBtn.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState())
            categoryBtn.setTitleColor(UINavigationBar.appearance().tintColor, for: .highlighted)
            headerView.addSubview(categoryBtn)
            categoryBtn.layer.cornerRadius = 4
            categoryBtn.layer.masksToBounds = true
            
            
            if (sportObj == "ALL") {
                sportBtn.setTitle("SPORT", for: UIControlState())
            } else {
                sportBtn.setTitle(sportObj, for: UIControlState())
            }
            
            if (categoryObj == "ALL") {
                categoryBtn.setTitle("CATEGORY", for: UIControlState())
            } else {
                categoryBtn.setTitle(categoryObj, for: UIControlState())
            }
            
            
            reusableView = headerView
        }
        return reusableView!
    }

    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.size.width/2
        
        return CGSize(width: cellWidth, height: cellWidth) // The size of one cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0) // margin between cells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let headerHeight = theCollectionView.frame.size.width/2+70
        return CGSize(width: view.frame.width, height: headerHeight)  // Header size
    }
    
    //    func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    //        return false
    //    }

    
    func heroBtnAction() {
        
        print("heroBtnAction hit")
        
    }
    
    func sportBtnAction() {
        
        // present drop down just below this button
        
        let vc = FilterViewController()
        vc.passedType = "SPORT"
        vc.selectedObj = sportObj
        let newnav = UINavigationController(rootViewController: vc)
        navigationController?.present(newnav, animated: true, completion: nil)
        
    }

    func categoryBtnAction() {
        
        let vc = FilterViewController()
        vc.passedType = "CATEGORY"
        vc.selectedObj = categoryObj
        let newnav = UINavigationController(rootViewController: vc)
        navigationController?.present(newnav, animated: true, completion: nil)
        
    }
}
