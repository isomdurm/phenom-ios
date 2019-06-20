//
//  ExplorePeopleViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class ExplorePeopleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var exploreGear = Data()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
    var isSearching: Bool = false
    
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
        titleLbl.text = "EXPLORE PEOPLE"
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
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        //theTableView.contentOffset = CGPoint(x: 0, y: 44)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(ExploreCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        //
        
        theTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        //
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
        
        //
        
        //queryForPeople()
        
        
        
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
        
        // pre-select "people"
        let vc = SearchViewController()
        
        navigationController?.pushViewController(vc, animated: false)
        
        isSearching = true
    }
    
    func queryForPeople() {
        
        
        
    }
    
    
    func navBtnAction() {
        //        print("navBtnAction hit")
        
        navigationController?.pushViewController(SearchViewController(), animated: false)
        
        isSearching = true
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        //navigationController?.pushViewController(ProfileViewController(), animated: true)
        
    }
    


}
