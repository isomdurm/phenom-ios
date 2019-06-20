//
//  PeopleListViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/7/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class PeopleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var passedTitle = ""
    var passedUserId = ""
    
    var peopleData = Data()
    
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
        titleLbl.text = passedTitle
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(PeopleCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))
        
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
        
        //
        
        queryForPeople()

        //
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    func queryForPeople() {
        
        // user/following
                
        var url = ""
        let date = Date().timeIntervalSince1970 * 1000
        
        if (passedTitle == "FANS") {
            
            url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(passedUserId)/followers?since=\(date)&limit=20"
            
        } else if (passedTitle == "FOLLOWING") {
            
            url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/\(passedUserId)/following?since=\(date)&limit=20"
            
        } else {
            print("something is wrong")
            return
        }
        
        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        
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
                    
                    
                    self.peopleData = response.data!
                    
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
        let json = JSON(data: peopleData)
        return json["results"].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 15+44+15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:PeopleCell = PeopleCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        
        if let person = results[indexPath.row]["username"].string {
            cell.usernameLbl.text = person
        }
        
        if let name = results[indexPath.row]["firstName"].string {
            cell.nameLbl.text = ("\(name) \(results[indexPath.row]["lastName"])")
        }
        
        if let id = results[indexPath.row]["imageUrl"].string {
            let fileUrl = URL(string: id)
            
            cell.userImgView.frame = CGRect(x: 15, y: 15, width: 44, height: 44)
            cell.userImgView.setNeedsLayout()
            cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                                                     success: { image in
                                                        
                                                        //print("image here: \(image)")
                                                        cell.userImgView.image = image
                                                        
                },
                                                     failure: { error in
                                                        
                                                        if ((error) != nil) {
                                                            print("error here: \(error)")
                                                            
                                                            // collapse, this cell - it was prob deleted - error 402
                                                            
                                                        }
            })
        }
        
        if let id = results[indexPath.row]["id"].string {
            
            let defaults = UserDefaults.standard
            let currentUserId = defaults.object(forKey: "userId") as! String
            if (id == currentUserId) {
                
                cell.followBtn.isSelected = true
                cell.followBtn.isHidden = true
                
            } else {
                
                if let id = results[indexPath.row]["userFollows"].bool {
                    if (id) {
                        cell.followBtn.isSelected = true
                        cell.followBtn.isHidden = true
                    } else {
                        cell.followBtn.isSelected = false
                        cell.followBtn.isHidden = false
                    }
                } else {
                    cell.followBtn.isSelected = true
                    cell.followBtn.isHidden = true
                }
                
            }
            
        }
        
        
        cell.followBtn.tag = indexPath.row
        cell.followBtn.addTarget(self, action:#selector(followBtnAction), for: .touchUpInside)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = .none
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        
        if let _ = results[indexPath.row]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserJson = results[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    func followBtnAction(_ sender : UIButton) {
        
        // follow only
        
        sender.isHidden = true
        
        // get frame of follow btn
        
        let ip = IndexPath(item: sender.tag, section: 0)
        let cell = self.theTableView.cellForRow(at: ip) as! PeopleCell
        
        //let mediaHeight = cell.frame.size.width+110
        
        let followImgView = UIImageView(frame: CGRect(x: self.view.frame.size.width-65-15, y: 18, width: 65, height: 38))
        followImgView.backgroundColor = UIColor.clear
        followImgView.image = UIImage(named: "addedBtnImg.png")
        cell.addSubview(followImgView)
        
        followImgView.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.18, animations: {
            followImgView.transform = CGAffineTransform.identity.scaledBy(x: 1.04, y: 1.04)
            }, completion: { finished in
                if (finished){
                    UIView.animate(withDuration: 0.16, animations: {
                        followImgView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                        }, completion: { finished in
                            if (finished) {
                                
                                let delay = 0.3 * Double(NSEC_PER_SEC)
                                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: time) {
                                    
                                    UIView.animate(withDuration: 0.18, animations: {
                                        followImgView.alpha = 0.0
                                        }, completion: { finished in
                                            if (finished) {
                                                followImgView.removeFromSuperview()
                                                
                                                //
                                                self.followAction(sender)
                                                //
                                                
                                            }
                                    })
                                }
                            }
                    })
                }
        })
    }
    
    func followAction(_ sender : UIButton) {
        
        let json = JSON(data: peopleData)
        let results = json["results"]
        let uid = results[sender.tag]["id"].string
        
        // follow
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.sharedApplication().delegate as! AppDelegate).phenomApiUrl)/user/\(uid!)/follow"
        
        let headers = [
            "Authorization": "Bearer \(bearerToken)",
            "Content-Type": "application/json",   //"application/x-www-form-urlencoded"
            "apiVersion" : "\((UIApplication.shared.delegate as! AppDelegate).apiVersion)"
        ]
        
        Alamofire.request(.POST, url, headers: headers)
            .responseJSON { response in
                
                if let j = response.result.value {
                    
                    if let errorCode = j["errorCode"] {
                        let ec = errorCode as! NSNumber
                        if ec != 200 {
                            print("err: \(ec)")
                            return
                        }
                    }
                    
                    
                    let array = NSUserDefaults.standardUserDefaults().arrayForKey("followingUserIds")
                    let ma = NSMutableArray(array: array!)
                    if (ma.containsObject(uid!)) {
                        // in followingUserIds, do nothing
                    } else {
                        let followingCount = NSUserDefaults.standardUserDefaults().objectForKey("followingCount") as! Int
                        let newcount = followingCount+1
                        
                        ma.addObject(uid!)
                        let newarray = ma as NSArray
                        NSUserDefaults.standardUserDefaults().setObject(newarray, forKey: "followingUserIds")
                        NSUserDefaults.standardUserDefaults().setObject(newcount, forKey: "followingCount")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        print("followed")
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
        
    }
    

}
