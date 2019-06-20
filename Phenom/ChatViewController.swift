//
//  ChatViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/28/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import SafariServices

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, SFSafariViewControllerDelegate {
    
    var commentsData = Data()
    
    var passedMomentJson = JSON(data: Data())
    
    var passedMomentId = ""
    var passedMomentUsername = ""
    var passedMomentUserImageUrl = ""
    var passedMomentHeadline = ""
    var passedMomentCreatedAt = ""
    var passedMomentReferences = NSArray()
    
    var navBarView = UIView()
    
    var theTableView: UITableView = UITableView()
    var refreshControl:UIRefreshControl!
    
    
    var chatView = UIView()
    var savedKeyboardHeight = CGFloat()
    var theTextView = KMPlaceholderTextView()
    var sendBtn = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        // parse passed moment
        
        passedMomentId = passedMomentJson["id"].string!
        passedMomentHeadline = passedMomentJson["headline"].string!
        passedMomentUsername = passedMomentJson["user"]["username"].string!
        passedMomentUserImageUrl = passedMomentJson["user"]["imageUrlTiny"].string!
        let obj = passedMomentJson["references"].arrayObject!
        passedMomentReferences = obj as NSArray
        print("passedMomentReferences: \(passedMomentReferences)")
        
        //
        
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
        titleLbl.text = "CHAT"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64-50)
        theTableView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: theTableView.frame.size.width, height: 0))

        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: UIControlEvents.valueChanged)
        theTableView.addSubview(refreshControl)
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action: #selector(backAction))
        swipeBack.direction = .right
        view.addGestureRecognizer(swipeBack)
        
        //
        
        self.chatView.frame = CGRect(x: 0, y: self.view.frame.size.height-51, width: self.view.frame.size.width, height: 51) //55
        self.chatView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.view.addSubview(self.chatView)
        
        self.savedKeyboardHeight = 224
        
        self.theTextView.frame = CGRect(x: 20, y: 10, width: self.chatView.frame.width-20-10-50-10, height: 35)
        self.theTextView.backgroundColor = UIColor.clear
        self.theTextView.delegate = self;
        self.theTextView.keyboardType = UIKeyboardType.twitter;
        self.theTextView.returnKeyType = UIReturnKeyType.default;
        self.theTextView.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        self.theTextView.enablesReturnKeyAutomatically = true;
        self.theTextView.textAlignment = NSTextAlignment.left
        self.theTextView.isScrollEnabled = false;
        self.theTextView.scrollsToTop = false;
        self.chatView.addSubview(self.theTextView)
        self.theTextView.text = ""
        self.theTextView.textColor = UIColor.white
        self.theTextView.placeholderColor = UIColor.init(white: 0.6, alpha: 1.0)
        self.theTextView.placeholder = "Add a comment..."
        
        self.sendBtn = UIButton(type: UIButtonType.custom)
        self.sendBtn.frame = CGRect(x: self.chatView.frame.width-50-10, y: 2, width: 50, height: 47)
        self.sendBtn.backgroundColor = UIColor.clear
        self.sendBtn.titleLabel?.numberOfLines = 1
        self.sendBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        self.sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        self.sendBtn.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        self.sendBtn.titleLabel?.textAlignment = NSTextAlignment.center
        self.sendBtn.setTitleColor(UINavigationBar.appearance().tintColor, for: UIControlState())
        self.sendBtn.setTitleColor(UIColor(red:207/255, green:185/255, blue:114/255, alpha:1), for: UIControlState.highlighted)
        self.sendBtn.setTitleColor(UIColor.init(white: 0.6, alpha: 1.0), for: UIControlState.disabled)
        self.sendBtn.setTitle("Send", for: UIControlState())
        self.sendBtn.addTarget(self, action:#selector(sendBtnAction), for:UIControlEvents.touchUpInside)
        self.chatView.addSubview(self.sendBtn)
        self.sendBtn.isEnabled = false
        
        let lineview = UIView()
        lineview.frame = CGRect(x: 0, y: 0, width: self.chatView.frame.size.width, height: 0.5)
        lineview.backgroundColor = UIColor.init(white: 0.6, alpha: 1.0) //UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        self.chatView.addSubview(lineview)
        
        //
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow ,object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide ,object: nil)
        
        //
        
        queryForChat()
        
        //
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationController?.interactivePopGestureRecognizer!.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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

    
    func keyboardWillShow(_ notification: Notification) {
        
        //
        
        let info = notification.userInfo!
        let keyboardframe: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue as NSNumber
        //let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        self.savedKeyboardHeight = keyboardframe.size.height
        
        UIView.animate(withDuration: duration.doubleValue, delay:0, options: .curveEaseOut, animations: {
            
            var chatViewFrame = self.chatView.frame
            chatViewFrame.origin.y = self.view.frame.size.height-self.savedKeyboardHeight-self.chatView.frame.size.height
            self.chatView.frame = chatViewFrame
            
            var tableViewFrame = self.theTableView.frame
            tableViewFrame.size.height = self.view.frame.size.height-self.savedKeyboardHeight-self.chatView.frame.size.height
            self.theTableView.frame = tableViewFrame
            
            }, completion: { finished in
                
        })
        
        let json = JSON(data: commentsData)
        let results = json["results"]["comments"]
        if (results.count>0) {
            let lastrow = self.theTableView.numberOfRows(inSection: 1)
            let ip = IndexPath(row: lastrow-1, section: 1)
            self.theTableView.scrollToRow(at: ip, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        //
        
        let info = notification.userInfo!
        let keyboardframe: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue as NSNumber
        //let curve = (info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).doubleValue
        //keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        self.savedKeyboardHeight = keyboardframe.size.height
        
        UIView.animate(withDuration: duration.doubleValue, delay:0, options: .curveEaseOut, animations: {
            
            var chatViewFrame = self.chatView.frame
            chatViewFrame.origin.y = self.view.frame.size.height-self.chatView.frame.size.height
            self.chatView.frame = chatViewFrame
            
            var tableViewFrame = self.theTableView.frame
            tableViewFrame.size.height = self.view.frame.size.height-self.chatView.frame.size.height
            self.theTableView.frame = tableViewFrame
            
            }, completion: { finished in
                
        })
        
    }
    
    // UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (self.theTextView.text == "") {
            if (text == " ") {
                return false;
            }
        }
        if (text == "\n")
        {
            return false
        }
        
        let maxLength = 400
        let currentString: NSString = textView.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        
        if (newString.length > 0) {
            self.sendBtn.isEnabled = true
        } else {
            self.sendBtn.isEnabled = false
        }
        
        return newString.length <= maxLength
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        // adjust height
        
        let maxFloat = CGFloat(MAXFLOAT)
        let newSize = textView.sizeThatFits(CGSize(width: self.chatView.frame.width-20-10-50-10, height: maxFloat))
        
        
        UIView.animate(withDuration: 0.05, delay:0, options: .curveEaseOut, animations: {
            
            var newFrame = textView.frame
            newFrame.size = CGSize(width: self.chatView.frame.width-20-10-50-10, height: newSize.height)
            textView.frame = newFrame
            
            let newheight = 10+newSize.height+10
            
            var chatViewFrame = self.chatView.frame
            chatViewFrame.size.height = newheight
            chatViewFrame.origin.y = self.view.frame.size.height-self.savedKeyboardHeight-newheight
            self.chatView.frame = chatViewFrame
            
            var tableViewFrame = self.theTableView.frame
            tableViewFrame.size.height = self.view.frame.size.height-self.savedKeyboardHeight-newheight
            self.theTableView.frame = tableViewFrame
            
            }, completion: { finished in
                
        })
        
        let json = JSON(data: commentsData)
        let results = json["results"]["comments"]
        if (results.count>0) {
            let lastrow = self.theTableView.numberOfRows(inSection: 1)
            let ip = IndexPath(row: lastrow-1, section: 1)
            self.theTableView.scrollToRow(at: ip, at: UITableViewScrollPosition.bottom, animated: true)
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
    
    
    //
    
    func refreshControlAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).lastvisiteddate = NSDate()
        
        //let newme = PFUser.currentUser()
        //newme!.setObject(NSDate(), forKey: "lastvisiteddate")
        //newme!.saveInBackground()
        
        queryForChat()
        
    }
    
    func queryForChat() {
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        let date = Date().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment/\(passedMomentId)/comments?since=\(date)&limit=30"
        
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
                    
                    self.commentsData = response.data!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTableView.reloadData()
                        self.refreshControl.endRefreshing()
                        
                    })
                }
        }
        
    }
    
    func emptyTimelineBtnAction() {
        
        //(UIApplication.sharedApplication().delegate as! AppDelegate).activityvc!.inviteFriends()
    }
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 1
        } else if (section == 1) {
            let json = JSON(data: commentsData)
            let results = json["results"]["comments"]
            return results.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            if (passedMomentHeadline == "") {
                return 0
            } else {
                let width = self.view.frame.size.width-15-44-15-15
                let height = (UIApplication.shared.delegate as! AppDelegate).heightForView(passedMomentHeadline, font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, width: width)
                return 15+20+15+height+5
            }
        } else if (indexPath.section == 1) {
            
            let json = JSON(data: commentsData)
            let results = json["results"]["comments"]
            if let id = results[indexPath.row]["commentText"].string {
                
                let width = self.view.frame.size.width-15-44-15-15
                let height = (UIApplication.shared.delegate as! AppDelegate).heightForView(id, font: UIFont.init(name: "MaisonNeue-Medium", size: 15)!, width: width)
                return 15+20+15+height+5
            } else {
                return 0
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ChatCell = ChatCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.cellWidth = self.view.frame.size.width
        
        cell.userImgView.frame = CGRect(x: 15, y: 15, width: 44, height: 44)
        cell.userBtn.frame = CGRect(x: 15, y: 15, width: 44, height: 44)
        
        if (indexPath.section == 0) {
            
            let fileUrl = URL(string: self.passedMomentUserImageUrl)
            cell.userImgView.setNeedsLayout()
            cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                failure: { error in
                    
                    if ((error) != nil) {
                        print("error here: \(error)")
                        // collapse, this cell - it was prob deleted - error 402
                    }
            },
                success: { image in
                    
                    cell.userImgView.image = image
                    
            })
            
            let nameWidth = (UIApplication.shared.delegate as! AppDelegate).widthForView(self.passedMomentUsername, font: cell.usernameBtn.titleLabel!.font, height: 20)
            cell.usernameBtn.frame = CGRect(x: 15+44+15, y: 15, width: nameWidth, height: 20)
            cell.usernameBtn.setTitle(self.passedMomentUsername, for: UIControlState())
            
            let dateWidth = (UIApplication.shared.delegate as! AppDelegate).widthForView(self.passedMomentCreatedAt, font: cell.dateLbl.font, height: 20)
            cell.dateLbl.frame = CGRect(x: cell.cellWidth-dateWidth-15, y: 15, width: dateWidth, height: 20)
            cell.dateLbl.text = self.passedMomentCreatedAt
            
            let chatWidth = cell.cellWidth-15-44-15-15
            let height = (UIApplication.shared.delegate as! AppDelegate).heightForView(self.passedMomentHeadline, font: cell.chatLbl.font, width: chatWidth)
            cell.chatLbl.frame = CGRect(x: 15+44+15, y: 15+20, width: chatWidth, height: height+10)
            cell.chatLbl.text = self.passedMomentHeadline
        
            
            cell.userBtn.isHidden = false
            cell.userBtn.tag = indexPath.row
            cell.userBtn.addTarget(self, action:#selector(userBtnAction1), for: .touchUpInside)
            
        } else if (indexPath.section == 1) {
            
            let json = JSON(data: commentsData)
            let results = json["results"]["comments"]
            
            // author
            // - username
            // IF tapped on avatar, pass all "auther" details: id, firstName, lastName, sport, followersCount... etc
            //
            // commentText
            // createdAt
            // flaggedAsInappropriate
            
            if let id = results[indexPath.row]["author"]["imageUrl"].string {
                let fileUrl = URL(string: id)
                
                cell.userImgView.setNeedsLayout()
                
                cell.userImgView.hnk_setImageFromURL(fileUrl!, placeholder: nil, //UIImage.init(named: "")
                    failure: { error in
                        
                        if ((error) != nil) {
                            print("error here: \(error)")
                        }
                },
                    success: { image in
                        
                        cell.userImgView.image = image
                })
            }            
            
            if let id = results[indexPath.row]["author"]["username"].string {
                
                let nameWidth = (UIApplication.shared.delegate as! AppDelegate).widthForView(id, font: cell.usernameBtn.titleLabel!.font, height: 20)
                cell.usernameBtn.frame = CGRect(x: 15+44+15, y: 15, width: nameWidth, height: 20)
                cell.usernameBtn.setTitle(id, for: .Normal)
                
            }
            
            if let id = results[indexPath.row]["createdAt"].string {
                
                let width = (UIApplication.shared.delegate as! AppDelegate).widthForView(id, font: cell.dateLbl.font, height: 20)
                cell.dateLbl.frame = CGRect(x: cell.cellWidth-width-15, y: 15, width: width, height: 20)
                cell.dateLbl.text = id
                
            }
            
            if let id = results[indexPath.row]["commentText"].string {
                
                let width = cell.cellWidth-15-44-15-15
                let height = (UIApplication.shared.delegate as! AppDelegate).heightForView(id, font: cell.chatLbl.font, width: width)
                cell.chatLbl.frame = CGRect(x: 15+44+15, y: 15+20, width: width, height: height+10)
                cell.chatLbl.text = id
                
            }
            
            cell.userBtn.isHidden = false
            cell.userBtn.tag = indexPath.row
            cell.userBtn.addTarget(self, action:#selector(userBtnAction2), for: .touchUpInside)
            
            
            cell.chatLbl.handleMentionTap { userHandle in
            
                print("\(userHandle) tapped")
                
                //self.handleMentionTap(indexPath, username: <#T##String#>)
                
//                if let id = results[indexPath.row]["author"]["id"].string {
//                    
//                }
            }
            
            cell.chatLbl.handleURLTap { userHandle in
                
                print("\(userHandle) tapped")
                
                if (userHandle != "") {
                    
                    let svc = SFSafariViewController(url: userHandle, entersReaderIfAvailable: false)
                    self.present(svc, animated: false, completion: nil)
                    
                    UIApplication.shared.statusBarStyle = .default
                }
            }
            
        } else {
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        if (indexPath.section == 0) {

            // get user, then go to user
            
        } else if (indexPath.section == 1) {

        } else {
            
        }
    }
    
    func userBtnAction1(_ sender: UIButton){
        
        let vc = ProfileViewController()
        vc.passedUserJson = passedMomentJson["user"]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func userBtnAction2(_ sender: UIButton){
       
        let json = JSON(data: commentsData)
        let results = json["results"]["comments"]
        
        if let _ = results[sender.tag]["author"]["id"].string {
            
            let vc = ProfileViewController()
            vc.passedUserJson = results[sender.tag]["author"] 
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }
    
    func handleMentionTap(_ ip : IndexPath, username : String) {
    
        
        
    }
    
    
    //
    //
    //
    
    
    func sendBtnAction() {
        
        print("sendBtnAction hit")
        
        if (self.theTextView.text == "") {
            return
        }
        
        // for at mentions - find @word and add as a parameter???
        
        // https://api1.phenomapp.com:8081/moment/:id/comment?commentText=Awesome @clayzug&references=clayzug
        
        let bearerToken = UserDefaults.standard.object(forKey: "bearerToken") as! String
        //let date = NSDate().timeIntervalSince1970 * 1000
        let url = "\((UIApplication.shared.delegate as! AppDelegate).phenomApiUrl)/moment/\(self.passedMomentId)/comment?commentText=\(self.theTextView.text)"
        
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
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.theTextView.text = ""
                        self.queryForChat()
                        
                    })
                    
                }
        }
        
    }

}
