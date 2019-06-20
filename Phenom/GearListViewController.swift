//
//  GearListViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/11/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class GearListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var singleMomentData = Data()
    var passedMomentId = String()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
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
        titleLbl.text = "GEAR LIST"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        //
        
        queryForMomentWithGear()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
    
    
    func queryForMomentWithGear() {

        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment?momentId=\(passedMomentId)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    self.singleMomentData = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                        
                    })
                    
                    
                }
        }
        
    }
    
    
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]
        return productsDict.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GearListCell = GearListCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]

        if let id = productsDict[indexPath.row]["imageUrl"].string {
            
            let fileUrl = URL(string: id)
            
            cell.gearImgView.frame = CGRect(x: 15, y: 15, width: 100, height: 100)
            cell.gearImgView.setNeedsLayout()
            
            //cell.momentImgView.hnk_setImageFromURL(fileUrl!)
            cell.gearImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                success: { image in
                    
                    //print("image here: \(image)")
                    cell.gearImgView.image = image
                    
                },
                failure: { error in
                    
                    if ((error) != nil) {
                        print("error here: \(error)")
                        
                        // collapse, this cell - it was prob deleted - error 402
                        
                    }
            })
            
        }
        
        var nameHeight = CGFloat()
        
        if let id = productsDict[indexPath.row]["brand"].string {
            cell.gearBrandLbl.text = id
        } else {
            cell.gearBrandLbl.text = ""
        }
        
        if let id = productsDict[indexPath.row]["name"].string {
            cell.gearNameLbl.text = id
            nameHeight = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(id, font: cell.gearNameLbl.font, width: self.view.frame.size.width-15-15-44-15)
        } else {
            cell.gearNameLbl.text = ""
        }
        
        cell.gearNameLbl.frame = CGRect(x: 15+100+15, y: 15, width: cell.cellWidth-15-100-15-15, height: nameHeight)
        cell.gearBrandLbl.frame = CGRect(x: 15+100+15, y: 15+nameHeight, width: cell.cellWidth-15-100-15-15, height: 20)
        
        if let id = productsDict[indexPath.row]["existsInLocker"].bool {
            if (id) {
                cell.gearAddBtn.isSelected = true
            } else {
                cell.gearAddBtn.isSelected = false
            }
        }
        
        cell.gearAddBtn.frame = CGRect(x: cell.cellWidth-65-15, y: 130-38-15, width: 65, height: 38)
        cell.gearAddBtn.tag = indexPath.row
        cell.gearAddBtn.addTarget(self, action:#selector(gearAddBtnAction), for: .touchUpInside)
        

        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]
        
        let vc = GearDetailViewController()
        vc.passedGearData = productsDict[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func gearAddBtnAction(_ sender : UIButton) {
        
        if (sender.isSelected) {
            
            sender.isSelected = false
            removeGearFromLocker(sender)
            
        } else {
            
            sender.isSelected = true
            addGearToLocker(sender)
            
        }
    }
    
    func addGearToLocker(_ sender : UIButton) {
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]
        
        let productJson = productsDict[sender.tag]
        print("productJson: \(productJson)")

        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/locker?product=\(productJson)"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.PUT, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    print("+1 added to locker")
                    
                    sender.selected = true
                    
                    let followingCount = NSUserDefaults.standardUserDefaults().objectForKey("lockerProductCount") as! Int
                    let newcount = followingCount+1
                    NSUserDefaults.standardUserDefaults().setObject(newcount, forKey: "lockerProductCount")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
    }
    
    func removeGearFromLocker(_ sender : UIButton) {
        
        
    }


}
