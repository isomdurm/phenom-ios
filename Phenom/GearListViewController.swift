//
//  GearListViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/11/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import SwiftyJSON
import Haneke

class GearListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var singleMomentData = NSData()
    var passedMomentId = String()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    
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
        backBtn.frame = CGRectMake(15, 20, 44, 44)
        backBtn.setImage(UIImage(named: "back-arrow.png"), forState: UIControlState.Normal)
        //backBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        backBtn.backgroundColor = UIColor.clearColor()
        backBtn.addTarget(self, action:#selector(backAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(backBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "GEAR LIST"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        
        theTableView.frame = CGRectMake(0, 64, view.frame.size.width, view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRectMake(0, 0, 0, 0))
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        //
        
        queryForMomentWithGear()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
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
    
    
    func queryForMomentWithGear() {
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/moment"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "momentId=\(passedMomentId)"
        let type = "GET"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sendRequest(url, parameters: params, type: type, completionHandler:  { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        return
                    }
                    
                    self.singleMomentData = dataFromString
                    
                    
                    let results = json["results"]
                    print("results: \(results)")
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                        
                    })
                    
                } else {
                    print("URL Session Task Failed: %@", error!.localizedDescription)
                    
                }
            } else {
                //
                print("errorrr in \(self)")
            }
        })
        
    }
    
    
    
    // TableViewDelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]
        return productsDict.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 130
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:GearListCell = GearListCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]

        if let id = productsDict[indexPath.row]["imageUrl"].string {
            
            let fileUrl = NSURL(string: id)
            
            cell.gearImgView.frame = CGRectMake(15, 15, 100, 100)
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
                cell.gearAddBtn.selected = true
            } else {
                cell.gearAddBtn.selected = false
            }
        }
        
        cell.gearAddBtn.frame = CGRect(x: cell.cellWidth-65-15, y: 130-38-15, width: 65, height: 38)
        cell.gearAddBtn.tag = indexPath.row
        cell.gearAddBtn.addTarget(self, action:#selector(gearAddBtnAction), forControlEvents: .TouchUpInside)
        

        
        return cell
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]
        
        let vc = GearDetailViewController()
        vc.passedGearData = productsDict[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func gearAddBtnAction(sender : UIButton) {
        
        if (sender.selected) {
            
            sender.selected = false
            removeGearFromLocker(sender)
            
        } else {
            
            sender.selected = true
            addGearToLocker(sender)
            
        }
    }
    
    func addGearToLocker(sender : UIButton) {
        
        let json = JSON(data: singleMomentData)
        let results = json["results"]
        let productsDict = results["products"]
        
        let productJson = productsDict[sender.tag]
        print("productJson: \(productJson)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/locker"
        //let date = NSDate().timeIntervalSince1970 * 1000
        let params = "product=\(productJson)"
        let type = "PUT"
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sendRequest(url, parameters: params, type: type, completionHandler:  { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                if let dataFromString = datastring!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    if json["errorCode"].number != 200  {
                        print("json: \(json)")
                        print("error: \(json["errorCode"].number)")
                        
                        sender.selected = false
                        
                        return
                    }
                    
                    print("+1 added to locker")
                    
                    sender.selected = true
                    
                    let followingCount = defaults.objectForKey("lockerProductCount") as! Int
                    let newcount = followingCount+1
                    defaults.setObject(newcount, forKey: "lockerProductCount")
                    defaults.synchronize()
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                    })
                    
                } else {
                    // print("URL Session Task Failed: %@", error!.localizedDescription);
                    
                }
                
            } else {
                //
            }
            
        })
        
    }
    
    func removeGearFromLocker(sender : UIButton) {
        
        
    }


}
