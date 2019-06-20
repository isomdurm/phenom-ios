//
//  ExploreViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//


import UIKit
import Alamofire
import QuartzCore
import SwiftyJSON
import Haneke

class ExploreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var theTextField = UITextField()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var activityIndicator = UIActivityIndicatorView()
    
    var peopleData = Data()
    var gearData = Data()
    
    var tabBtn1 = UIButton(type: UIButtonType.custom)
    var tabBtn2 = UIButton(type: UIButtonType.custom)
    
    var isTyping: Bool = false
    var savedSearchArray = NSMutableArray()
    
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
        titleLbl.text = "EXPLORE"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        //
        
        let searchContainerView = UIView()
        searchContainerView.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 44)
        searchContainerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(searchContainerView)
        
        let bg = UIView()
        bg.frame = CGRect(x: 15, y: 5, width: view.frame.size.width-30, height: 34)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        searchContainerView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        theTextField.frame = CGRect(x: 15+14, y: 6, width: searchContainerView.frame.size.width-50, height: 34)
        theTextField.backgroundColor = UIColor.clear
        theTextField.delegate = self
        theTextField.textColor = UIColor.white // UIColor(red:42/255, green:42/255, blue:42/255, alpha:1)
        theTextField.keyboardType = UIKeyboardType.default
        theTextField.returnKeyType = UIReturnKeyType.search
        theTextField.enablesReturnKeyAutomatically = true
        theTextField.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        theTextField.placeholder = "Search people and gear!"
        theTextField.autocapitalizationType = UITextAutocapitalizationType.none
        theTextField.autocorrectionType = UITextAutocorrectionType.no
        theTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        searchContainerView.addSubview(theTextField)
        //theTextField.addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        theTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRect(x: 0, y: 64+44, width: view.frame.size.width, height: 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(tabView)
        
        tabBtn1.frame = CGRect(x: 0, y: 0, width: tabView.frame.size.width/2, height: 44)
        tabBtn1.backgroundColor = UIColor.clear
        tabBtn1.titleLabel?.numberOfLines = 1
        tabBtn1.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn1.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn1.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn1.setTitleColor(UIColor.white, for: UIControlState())
        tabBtn1.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn1.setTitle("PEOPLE", for: UIControlState())
        tabBtn1.addTarget(self, action:#selector(tabBtn1Action), for:UIControlEvents.touchUpInside)
        tabView.addSubview(tabBtn1)
        
        tabBtn2.frame = CGRect(x: tabView.frame.size.width/2*1, y: 0, width: tabView.frame.size.width/2, height: 44)
        tabBtn2.backgroundColor = UIColor.clear
        tabBtn2.titleLabel?.numberOfLines = 1
        tabBtn2.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        tabBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        tabBtn2.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        tabBtn2.titleLabel?.textAlignment = NSTextAlignment.center
        tabBtn2.setTitleColor(UIColor.white, for: UIControlState())
        tabBtn2.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState.selected)
        tabBtn2.setTitle("GEAR", for: UIControlState())
        tabBtn2.addTarget(self, action:#selector(tabBtn2Action), for:UIControlEvents.touchUpInside)
        tabView.addSubview(tabBtn2)
        
        let line2:UIView = UIView()
        line2.frame = CGRect(x: 0, y: tabView.frame.size.height-0.5, width: tabView.frame.size.width, height: 0.5)
        line2.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        tabView.addSubview(line2)
        
        //
        
        tabBtn1.isSelected = true
        
        //
        
        theTableView.frame = CGRect(x: 0, y: 64+44+44, width: view.frame.size.width, height: view.frame.size.height-64-49-44-44)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        //
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        //
        
        //queryForLikes()
        //
        
        //
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(_:)),name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardDidShow(_:)),name: NSNotification.Name.UIKeyboardDidShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(_:)),name: NSNotification.Name.UIKeyboardWillHide,object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self,selector: "textDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorAlert(_:)), name:"ShowErrorAlertNotification" ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reachedLimitErrorAlert(_:)), name:"ReachedLimitErrorAlertNotification" ,object: nil)
        
        //theTextField.becomeFirstResponder()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
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
    
    func tabBtn1Action() {
        tabBtn1.isSelected = true
        tabBtn2.isSelected = false
        
        if (self.isTyping) {
            
            self.checkForSavedSearchMatches()
            
        } else {
            
            // load people
            if (self.theTextField.text != "") {
                
                self.view.endEditing(true)
                
                self.queryForPeople(self.theTextField.text!)
            }
        }
        
    }
    
    func tabBtn2Action() {
        tabBtn1.isSelected = false
        tabBtn2.isSelected = true
        
        if (self.isTyping) {
            
            self.checkForSavedSearchMatches()
            
        } else {
            
            // load gear
            if (self.theTextField.text != "") {
                
                self.view.endEditing(true)
                
                self.queryForGear(self.theTextField.text!)
            }
        }
        
    }


    func showErrorAlert(_ notification: Notification){
        //theTextField.resignFirstResponder()
        
        let alertController = UIAlertController(title: "There is no one with that username.", message:"", preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
        }
    }
    
    func reachedLimitErrorAlert(_ notification: Notification){
        //theTextField.resignFirstResponder()
        
        let alertController = UIAlertController(title: "You have reached the following limit: 500.", message:"", preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true) {
        }
        
    }
    
    func cancelBtnAction() {
        
        
    }
    
    func keyboardWillShow(_ notification: Notification){
        
        // userInfo = notification.userInfo!
        //duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        //curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
       
        
    }
    func keyboardDidShow(_ notification: Notification){
    }
    func keyboardWillHide(_ notification: Notification){
        
    }
    //    func textDidChange(notification: NSNotification){
    //
    //    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        print("textFieldDidChange hit: \(textField.text!)")
        
        if (!self.isTyping) {
            self.isTyping = true
        }
        
        self.checkForSavedSearchMatches()
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text!
        if (currentString == "") {
            let space = " "
            if (string == space) {
                return false
            }
        }
        
        let maxLength = 100
        //let currentString: NSString = theTextField.text!
        let newString: NSString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.length <= maxLength
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == theTextField) {
            
            self.isTyping = false
            self.view.endEditing(true)
            
            if (self.tabBtn1.isSelected) {
                self.queryForPeople(textField.text!)
            } else {
                self.queryForGear(textField.text!)
            }
            
            textField.resignFirstResponder()
            
            return true
        } else {
            return true
        }
        
    }
    
    func checkForSavedSearchMatches() {
        
        self.savedSearchArray.removeAllObjects()
        
        // find matches
        
        let defaults = UserDefaults.standard
        
        if (self.tabBtn1.isSelected) {
            
            // find matches in saved people array
            
            let array = defaults.array(forKey: "searchedPeopleWords")
            let ma = NSMutableArray(array: array!)
            
            for obj in ma {
                
                if (obj.hasPrefix(self.theTextField.text!)) {
                    
                    self.savedSearchArray.add(obj)
                }
            }
            
        } else if (self.tabBtn2.isSelected) {
            
            // find matches in saved gear array
            
            let array = defaults.array(forKey: "searchedGearWords")
            let ma = NSMutableArray(array: array!)
            
            for obj in ma {
                
                if (obj.hasPrefix(self.theTextField.text!)) {
                    
                    self.savedSearchArray.add(obj)
                }
            }
        } else {
            print("something is wrong")
        }
        
        
        // reload table to show search saved results
        
        self.theTableView.reloadData()
        
        //
        
    }
    
    func queryForPeople(_ str : String) {
        
        // https://api1.phenomapp.com:8081/user/search?query=STRING&pageNumber=INT
        
        self.peopleData = Data()
        self.theTableView.reloadData()
        

        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/search?query=\(str)&pageNumber=1"
        
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
                    
                    let json = JSON(data: self.peopleData)
                    
                    let results = json["results"]
                    
                    if (results.count > 0) {
                        
                        // save "searchedPeopleWords"
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let array = defaults.arrayForKey("searchedPeopleWords")
                        let ma = NSMutableArray(array: array!)
                        if (ma.containsObject(str)) {
                            // in searchedGearWords, do nothing
                        } else {
                            ma.addObject(str)
                            let newarray = ma as NSArray
                            defaults.setObject(newarray, forKey: "searchedPeopleWords")
                            defaults.synchronize()
                        }
                        //
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.reloadAction()
                            
                        })
                        
                    } else {
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showEmptyTable()
                            
                        })
                    }
                    
                }
        }
        
    }
    
    func queryForGear(_ str : String) {
        
        // https://api1.phenomapp.com:8081/product?query=STRING STRING STRING
        
        self.gearData = Data()
        self.theTableView.reloadData()
        
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/product?query=\(str)"
        
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
                    
                    self.gearData = response.data!
                    
                    let json = JSON(data: self.gearData)
                    
                    let results = json["results"]["products"]
                    
                    if (results.count > 0) {
                        
                        // save "searchedGearWords"
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let array = defaults.arrayForKey("searchedGearWords")
                        let ma = NSMutableArray(array: array!)
                        if (ma.containsObject(str)) {
                            // in searchedGearWords, do nothing
                        } else {
                            ma.addObject(str)
                            let newarray = ma as NSArray
                            defaults.setObject(newarray, forKey: "searchedGearWords")
                            defaults.synchronize()
                        }
                        //
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.reloadAction()
                            
                        })
                        
                    } else {
                        
                        // done, reload tableView
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.showEmptyTable()
                            
                        })
                    }
                    
                }
        }
        
    }
    
    func reloadAction() {
        
        self.theTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.theTableView.reloadData()
        
    }
    
    func showEmptyTable() {
        
        // show empty timeline btn
        self.theTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.theTableView.frame.size.width, height: self.theTableView.frame.size.height))
        self.theTableView.tableHeaderView!.isUserInteractionEnabled = true
        let emptyTableBtn = UIButton(type: UIButtonType.custom)
        //emptyTableBtn.frame = CGRectMake(self.theTableView.tableHeaderView!.frame.size.width/2-125, self.theTableView.tableHeaderView!.frame.size.height/2-50, 250, 100)
        emptyTableBtn.frame = CGRect(x: self.theTableView.tableHeaderView!.frame.size.width/2-100, y: 50, width: 200, height: 50)
        emptyTableBtn.backgroundColor = UIColor.clear
        emptyTableBtn.titleLabel?.numberOfLines = 2
        emptyTableBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        emptyTableBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        emptyTableBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        emptyTableBtn.titleLabel?.textAlignment = NSTextAlignment.center
        emptyTableBtn.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState())
        emptyTableBtn.setTitleColor(UIColor(red:197/255, green:175/255, blue:104/255, alpha:1), for: UIControlState.highlighted)
        emptyTableBtn.setTitle("No results :(", for: UIControlState())
        self.theTableView.tableHeaderView!.addSubview(emptyTableBtn)
        
        //
        
        self.theTableView.reloadData()
        
    }
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 35))
        aLbl.textAlignment = NSTextAlignment.left
        
        if (self.isTyping) {
            aLbl.text = "SAVED"
        } else {
            aLbl.text = "RESULTS"
        }
        
        aLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        aLbl.textColor = UINavigationBar.appearance().tintColor //gold
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        aView.addSubview(aLbl)
        
        return aView;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.isTyping) {
            return savedSearchArray.count
        } else {
            if (self.tabBtn1.isSelected) {
                let json = JSON(data: peopleData)
                return json["results"].count
            } else {
                let json = JSON(data: gearData)
                return json["results"]["products"].count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (self.isTyping) {
            return 60
        } else {
            if (self.tabBtn1.isSelected) {
                return 15+44+15
            } else {
                return 130
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SearchCell = SearchCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        
        if (self.isTyping) {
            
            cell.peopleImgView.isHidden = true
            cell.peopleNameLbl.isHidden = true
            cell.peopleUsernameLbl.isHidden = true
            cell.peopleFollowBtn.isHidden = true
            
            cell.gearImgView.isHidden = true
            cell.gearNameLbl.isHidden = true
            cell.gearBrandLbl.isHidden = true
            cell.gearAddBtn.isHidden = true
            
            let result = self.savedSearchArray.object(at: indexPath.row) as! String
            cell.textLabel?.text = result
            cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
            cell.textLabel?.textColor = UIColor.white
            
        } else {
            
            cell.textLabel?.text = ""
            
            if (tabBtn1.isSelected) {
                
                //let json = JSON(data: peopleData)
                //let results = json["results"]
                
                cell.peopleImgView.isHidden = false
                cell.peopleNameLbl.isHidden = false
                cell.peopleUsernameLbl.isHidden = false
                cell.peopleFollowBtn.isHidden = false
                
                cell.gearImgView.isHidden = true
                cell.gearNameLbl.isHidden = true
                cell.gearBrandLbl.isHidden = true
                cell.gearAddBtn.isHidden = true
                
                cell.peopleImgView.frame = CGRect(x: 15, y: 15, width: 44, height: 44)
                cell.peopleNameLbl.frame = CGRect(x: 15+50+10, y: 15, width: cell.cellWidth-15-50-15-50-15, height: 20)
                cell.peopleUsernameLbl.frame = CGRect(x: 15+50+10, y: 15+20, width: cell.cellWidth-15-50-15-50-15, height: 20)
                cell.peopleFollowBtn.frame = CGRect(x: cell.cellWidth-15-40, y: 20, width: 40, height: 40)
                
                let people = JSON(data: peopleData)
                let results = people["results"]
                
                if let person = results[indexPath.row]["username"].string {
                    cell.peopleUsernameLbl.text = person
                }
                
                if let name = results[indexPath.row]["firstName"].string {
                    cell.peopleNameLbl.text = ("\(name) \(results[indexPath.row]["lastName"])")
                }
                
                if let id = results[indexPath.row]["imageUrl"].string {
                    let fileUrl = URL(string: id)
                    
                    cell.peopleImgView.frame = CGRect(x: 15, y: 10, width: 44, height: 44)
                    cell.peopleImgView.setNeedsLayout()
                    cell.peopleImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                        success: { image in
                            
                            //print("image here: \(image)")
                            cell.peopleImgView.image = image
                            
                        },
                        failure: { error in
                            
                            if ((error) != nil) {
                                print("error here: \(error)")
                                
                                // collapse, this cell - it was prob deleted - error 402
                                
                            }
                    })
                }
                
                
            } else {
                
                //let json = JSON(data: gearData)
                //let results = json["results"]["products"]
                
                cell.peopleImgView.isHidden = true
                cell.peopleNameLbl.isHidden = true
                cell.peopleUsernameLbl.isHidden = true
                cell.peopleFollowBtn.isHidden = true
                
                cell.gearImgView.isHidden = false
                cell.gearNameLbl.isHidden = false
                cell.gearBrandLbl.isHidden = false
                cell.gearAddBtn.isHidden = false
                
                let json = JSON(data: self.gearData)
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
                    nameHeight = 0
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
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = .none
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        if (self.isTyping) {
            self.isTyping = false
            self.view.endEditing(true)
            
            let result = self.savedSearchArray.object(at: indexPath.row) as! String
            self.theTextField.text = result
            
            if (tabBtn1.isSelected) {
                self.queryForPeople(self.theTextField.text!)
            } else if (tabBtn2.isSelected) {
                self.queryForGear(self.theTextField.text!)
            } else {
                print("something is wrong")
            }
            
        } else {
            
            if (tabBtn1.isSelected) {
                
                // person
                let json = JSON(data: peopleData)
                let results = json["results"]
                if let _ = results[indexPath.row]["id"].string {
                    let vc = ProfileViewController()
                    vc.passedUserJson = results[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            } else if (tabBtn2.isSelected) {
                
                // gear
                let json = JSON(data: self.gearData)
                let results = json["results"]
                let productsDict = results["products"]
                
                let vc = GearDetailViewController()
                vc.passedGearData = productsDict[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)

                
            } else {
                print("something went wrong")
            }
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch (scrollView.panGestureRecognizer.state) {
            
        case UIGestureRecognizerState.began:
            break;
        case UIGestureRecognizerState.changed:
            
            self.view.endEditing(true)
            
            break;
        case UIGestureRecognizerState.possible:
            break;
        default:
            break;
        }
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
        
        let json = JSON(data: gearData)
        let results = json["results"]
        let productsDict = results["products"]
        
        let productJson = productsDict[sender.tag]
        
        
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
