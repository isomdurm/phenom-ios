//
//  FilterViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/6/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var passedType = NSString()
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
    var theArray = NSArray()
    
    var filterBtn = UIButton.init(type: .custom)
    
    var selectedCells = NSMutableArray()
    var selectedCell = IndexPath()
    
    var selectedObj = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
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

        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "FILTER \(passedType)" 
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        if (passedType == "SPORT") {
            
            theArray = ["ALL", "BASEBALL", "BASKETBALL", "FOOTBALL", "SOCCER", "LACROSSE", "ICE HOCKEY", "SOFTBALL", "TENNIS", "TRACK & FIELD", "VOLLYBALL", "WRESTLING", "SWIMMING", "CROSS COUNTRY", "FIELD HOCKEY", "GOLF", "RUGBY", "CROSS FIT", "SKIING", "SNOWBOARDING", "SKATEBOARDING", "FIGURE SKATING", "GYMNASTICS"]
            
        } else {
            
            theArray = ["ALL", "CAT1", "CAT2", "CAT3", "CAT4", "CAT5", "CAT6"]
            
        }
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-60)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        let bottomContainerView = UIView(frame: CGRect(x: 0, y: view.frame.size.height-49, width: view.frame.size.width, height: 49))
        bottomContainerView.backgroundColor = UIColor.black
        view.addSubview(bottomContainerView)
        
        //filterBtn.frame = CGRectMake(10, 10, bottomContainerView.frame.size.width-20, bottomContainerView.frame.size.height-20)
        filterBtn.frame = CGRect(x: 0, y: view.frame.size.height-60, width: view.frame.size.width, height: 60)
        filterBtn.backgroundColor = UINavigationBar.appearance().tintColor
        filterBtn.addTarget(self, action:#selector(filterBtnAction), for:UIControlEvents.touchUpInside)
        filterBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        filterBtn.titleLabel?.numberOfLines = 1
        filterBtn.contentHorizontalAlignment = .center
        filterBtn.contentVerticalAlignment = .center
        filterBtn.titleLabel?.textAlignment = .center
        filterBtn.setTitleColor(UIColor.white, for: UIControlState())
        filterBtn.setTitleColor(UIColor.white, for: .highlighted)
        filterBtn.setTitle("APPLY FILTER", for: UIControlState())
        view.addSubview(filterBtn)
        
        //
        
//        if let i = theArray.indexOfObject("") {
//            print("Jason is at index \(i)")
//        } else {
//            print("not there")
//        }
    
        
        
        
        if (selectedObj != "") {
            // passed a selected cell, figure out the index and select that index
            
            let i = theArray.index(of: selectedObj)
            selectedCell = IndexPath(row: i, section: 0)
            
        } else {
            
            selectedCell = IndexPath(row: 0, section: 0)
        }
        
        //
        
        theTableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    func xBtnAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func filterBtnAction() {
        
        //print("cell: \(selectedCell) - obj: \(selectedObj)")
        
        // post nsnotification
        
        let dict = NSDictionary(dictionary:["type": passedType, "obj":selectedObj])
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReloadExploreGearNotification"), object: nil, userInfo: dict as! [AnyHashable: Any])
        
        xBtnAction()
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        
        let obj = theArray.object(at: indexPath.row) as! String
        cell.textLabel?.text = obj
        
        if (selectedCell == indexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let obj = theArray.object(at: indexPath.row) as! String
        
        selectedObj = obj
        selectedCell = indexPath
        
        theTableView.reloadData()
        
        
        
    }
    
    

}
