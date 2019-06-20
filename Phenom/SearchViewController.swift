//
//  SearchViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/25/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore
import SwiftyJSON
import Haneke

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var people = Data()
    var gear = Data()
    
    var bg: UIView = UIView()
    var cancelBtn = UIButton()
    var icon = UIImageView()
    var theTextField = UITextField()
    var theTableView = UITableView()
    var duration: NSNumber!
    var curve: NSNumber!
    
    var peopleArray = NSMutableArray()
    var savedSearchNames = NSMutableArray()
    
    var gearArray = NSMutableArray()
    var savedSearchGear = NSMutableArray()
    
    var selectedTab = NSString()
    var tabBtn1 = UIButton(type: UIButtonType.custom)
    var tabBtn2 = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        let searchView:UIView = UIView()
        searchView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        searchView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        cancelBtn.frame = CGRect(x: searchView.frame.size.width-70, y: 20, width: 70, height: 44)
        cancelBtn.backgroundColor = UIColor.clear
        cancelBtn.addTarget(self, action:#selector(cancelBtnAction), for:UIControlEvents.touchUpInside)
        cancelBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        cancelBtn.titleLabel?.numberOfLines = 1
        cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        cancelBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        cancelBtn.titleLabel?.textAlignment = NSTextAlignment.center
        cancelBtn.setTitleColor(UIColor.white, for: UIControlState())
        cancelBtn.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        cancelBtn.setTitle("Cancel", for: UIControlState())
        searchView.addSubview(cancelBtn)
        cancelBtn.isEnabled = false
        cancelBtn.alpha = 0.0
        
        bg.frame = CGRect(x: 14, y: 20+7, width: view.frame.size.width-28, height: 30)
        bg.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        searchView.addSubview(bg)
        bg.layer.cornerRadius = 7
        bg.layer.masksToBounds = true
        
        let btn = UIButton(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: bg.frame.size.width, height: bg.frame.size.height)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action:#selector(btnAction), for:UIControlEvents.touchUpInside)
        bg.addSubview(btn)
        
        let width = (UIApplication.shared.delegate as! AppDelegate).widthForView("Search", font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, height: 30)
        
        //icon.frame = CGRectMake(14+10, 20+7+10, 12, 12)
        icon.frame = CGRect(x: (view.frame.size.width/2)-(width/2)-7, y: 20+7+10, width: 12, height: 12)
        icon.backgroundColor = UIColor.clear
        icon.image = UIImage(named:"miniSearchImg.png")
        searchView.addSubview(icon)
        
        //theTextField.frame = CGRectMake(44, 28, view.frame.size.width-44-14, 30)
        theTextField.frame = CGRect(x: icon.frame.origin.x+icon.frame.size.width+6, y: 28, width: width, height: 30)
        theTextField.backgroundColor = UIColor.clear
        theTextField.delegate = self
        theTextField.textColor = UIColor.white // UIColor(red:42/255, green:42/255, blue:42/255, alpha:1)
        theTextField.keyboardType = UIKeyboardType.default
        theTextField.returnKeyType = UIReturnKeyType.done
        theTextField.enablesReturnKeyAutomatically = true
        theTextField.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        theTextField.placeholder = "Search"
        theTextField.autocapitalizationType = UITextAutocapitalizationType.none
        theTextField.autocorrectionType = UITextAutocorrectionType.no
        searchView.addSubview(theTextField)
        //theTextField.addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        theTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        let line:UIView = UIView()
        line.frame = CGRect(x: 0, y: searchView.frame.size.height-0.5, width: searchView.frame.size.width, height: 0.5)
        line.backgroundColor = UIColor.init(white: 0.30, alpha: 1.0)
        //searchView.addSubview(line)
        
        view.addSubview(searchView)
        
        //
        
        let tabView:UIView = UIView()
        tabView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: 44)
        tabView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
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
        
        view.addSubview(tabView)
        
        if (selectedTab == "gear") {
            tabBtn2.isSelected = true
        } else {
            tabBtn1.isSelected = true
        }
        
        //
        
        theTableView.frame = CGRect(x: 0, y: 64+44, width: view.frame.size.width, height: view.frame.size.height-64-44-49)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.register(SearchCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        //
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow(_:)),name: NSNotification.Name.UIKeyboardWillShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardDidShow(_:)),name: NSNotification.Name.UIKeyboardDidShow,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(_:)),name: NSNotification.Name.UIKeyboardWillHide,object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self,selector: "textDidChange:", name: UITextFieldTextDidChangeNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorAlert(_:)), name:"ShowErrorAlertNotification" ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reachedLimitErrorAlert(_:)), name:"ReachedLimitErrorAlertNotification" ,object: nil)
        
        theTextField.becomeFirstResponder()
        
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnAction() {
        theTextField.becomeFirstResponder()
    }
    
    func tabBtn1Action() {
        tabBtn1.isSelected = true
        tabBtn2.isSelected = false
        
        // load people array
        theTableView.reloadData()
    }
    
    func tabBtn2Action() {
        tabBtn1.isSelected = false
        tabBtn2.isSelected = true
        
        // load gear array
        theTableView.reloadData()
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
        
        theTextField.text = ""
        peopleArray.removeAllObjects()
        gearArray.removeAllObjects()
        theTextField.resignFirstResponder()
        
        navigationController?.popViewController(animated: false)
    }
    
    func keyboardWillShow(_ notification: Notification){
        
        let userInfo = notification.userInfo!
        duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        curve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animate(withDuration: duration.doubleValue, delay:0, options: .curveEaseOut, animations: {
            
            var bgFrame = self.bg.frame
            var iconFrame = self.icon.frame
            var tfFrame = self.theTextField.frame
            
            bgFrame.size.width = self.view.frame.size.width-14-70
            
            iconFrame.origin.x = 24
            tfFrame.origin.x = 44
            tfFrame.size.width = self.view.frame.size.width-44-70
            
            self.bg.frame = bgFrame
            self.icon.frame = iconFrame
            self.theTextField.frame = tfFrame
            
            self.cancelBtn.alpha = 1.0
            
            }, completion: { finished in
                self.cancelBtn.isEnabled = true
        })
        
    }
    func keyboardDidShow(_ notification: Notification){
    }
    func keyboardWillHide(_ notification: Notification){
        
    }
    //    func textDidChange(notification: NSNotification){
    //
    //    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if (tabBtn1.isSelected) {
            peopleArray.removeAllObjects()
            
            let nothing = ""
            if (theTextField.text == nothing) {
                
                let defaults = UserDefaults.standard
                let array = defaults.array(forKey: "savedSearchNames")
                let ma = NSMutableArray(array: array!)
                
                let arr = ma.sorted { $0.localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending}
                
                for name in arr {
                    
                    let n = name as! String
                    
                    if (n.lowercased()).hasPrefix(theTextField.text!.lowercased()) {
                        peopleArray.add(n)
                    }
                }
                
                theTableView.reloadData()
                
            } else {
                
                //peopleArray.addObject(n)
                
                
                peopleArray.add("\(theTextField.text!)")
                
                theTableView.reloadData()
            }
            
        } else if (tabBtn2.isSelected) {
            
            gearArray.removeAllObjects()
            
            let nothing = ""
            if (theTextField.text == nothing) {
                
                let defaults = UserDefaults.standard
                let array = defaults.array(forKey: "savedSearchGear")
                let ma = NSMutableArray(array: array!)
                
                let arr = ma.sorted { $0.localizedCaseInsensitiveCompare($1 as! String) == ComparisonResult.orderedAscending}
                
                for name in arr {
                    
                    let n = name as! String
                    
                    if (n.lowercased()).hasPrefix(theTextField.text!.lowercased()) {
                        gearArray.add(n)
                    }
                }
                
                theTableView.reloadData()
                
            } else {
                
                gearArray.add("\(theTextField.text!)")
                
                theTableView.reloadData()
            }
            
        } else {
            // error
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == theTextField) {
            let space = " "
            if (string == space) {
                return false
            }
            let maxLength = 30
            let currentString: NSString = theTextField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.length <= maxLength
        } else {
            let maxLength = 400
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.length <= maxLength
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == theTextField) {
            textField.resignFirstResponder()
            return false
        } else {
            return true
        }
    }
    
    
    func queryForPeopleWithString(_ str : String) {
        
        //https://api1.phenomapp.com:8081/user/search?pageNumber=INT&query=STRING
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/user/search?pageNumber=1&query=\(self.theTextField.text)"
        
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
                    
                    
                    self.people = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
    }
    
    func queryForGearWithString(_ str : String) {
        
        // https://api1.phenomapp.com:8081/product?query=STRING

        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/product?query=\(self.theTextField.text)"
        
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
                    
                    
                    self.gear = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                    })
                    
                }
        }
        
    }
    
    func queryForMusicWithString(_ str : String) {
        
        // search for music
        // https://api1.phenomapp.com:8081/moment/searchForSongs?searchString=STRING
        
        
        // featured music call
        // https://play.spotify.com/user/phenomapp/playlist/1QHuNn2F6ai4uIlkLweFfg
        
        // play music call
        // av session with music url in moment  -  "publicUrl"
        
        
        
        
    }
    
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (tabBtn1.isSelected) {
           return peopleArray.count
        } else if (tabBtn2.isSelected) {
            return gearArray.count
        } else {
            // error
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        
        let cell:SearchCell = SearchCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = view.frame.size.width
        //cell.cellString = (theTextField.text)!
        
        cell.textLabel?.frame = CGRect(x: 20, y: 0, width: view.frame.size.width-20-20-80, height: 64)
        cell.textLabel?.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        cell.textLabel?.textColor = UIColor.white
        
//        cell.addBtn.hidden = true
//        
//        let name = peopleArray.objectAtIndex(indexPath.row) as! String
//        cell.textLabel?.text = name
//        
        cell.textLabel?.text = "testing"
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (theTextField.isEditing) {
            theTextField.resignFirstResponder()
        }
    }


}
