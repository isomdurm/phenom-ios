//
//  SettingsViewController.swift
//  Phenom
//
//  Created by Isom Durm on 3/25/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit
import Social
import MessageUI

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var theTableView: UITableView = UITableView()
    var viewersArray = NSMutableArray()
    
    var navBarView = UIView()
    
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
        titleLbl.text = "SETTINGS"
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
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aLbl = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 35))
        aLbl.textAlignment = NSTextAlignment.left
        
        switch (section) {
        case 0: aLbl.text = "ACCOUNT"
        case 1: aLbl.text = "MANAGE"
        case 2: aLbl.text = "INVITE FRIENDS"
        case 3: aLbl.text = "SUPPORT"
        case 4: aLbl.text = ""
        default: aLbl.text = ""}
        
        aLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        aLbl.textColor = UINavigationBar.appearance().tintColor //gold
        
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        aView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        aView.addSubview(aLbl)
        
        return aView;
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 8
        case 1: return 2
        case 2: return 4
        case 3: return 2
        case 4: return 1
        default: return 0}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        
        cell.textLabel?.font =  UIFont.init(name: "MaisonNeue-Medium", size: 15)
        cell.textLabel?.textColor = UIColor.init(white: 1.0, alpha: 1.0)
        cell.detailTextLabel?.font =  UIFont.init(name: "MaisonNeue-Medium", size: 14)
        cell.detailTextLabel?.frame = CGRect(x: self.view.frame.size.width/2, y: 0, width: self.view.frame.size.width/2-50, height: 50)
        
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")! as String
        let firstName = defaults.object(forKey: "firstName") as! String
        let lastName = defaults.object(forKey: "lastName") as! String
        let sports = defaults.object(forKey: "sports") as! NSArray
        let hometown = defaults.object(forKey: "hometown") as! String
        let bio = defaults.object(forKey: "description") as! String
        let email = defaults.object(forKey: "email") as! String
        let birthday = defaults.object(forKey: "birthday") as! Date
        
        if (indexPath.section==0 && indexPath.row==0) {
            
            cell.textLabel!.text = "Name"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = "\(firstName) \(lastName)"
            
        } else if (indexPath.section==0 && indexPath.row==1) {
            
            cell.textLabel!.text = "Username"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = "\(username)"
            
        } else if (indexPath.section==0 && indexPath.row==2) {
            
            cell.textLabel!.text = "Birthday"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = "\(birthday)"
            
        } else if (indexPath.section==0 && indexPath.row==3) {
            
            cell.textLabel!.text = "Hometown"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = "\(hometown)"
            
        } else if (indexPath.section==0 && indexPath.row==4) {
            
            cell.textLabel!.text = "Sports"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            let sportsStr = sports.componentsJoined(by: ", ")
            cell.detailTextLabel?.text = "\(sportsStr)"
            
        } else if (indexPath.section==0 && indexPath.row==5) {
            
            cell.textLabel!.text = "Bio"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = bio
            
        } else if (indexPath.section==0 && indexPath.row==6) {
            
            cell.textLabel!.text = "Email"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = email
            
        } else if (indexPath.section==0 && indexPath.row==7) {
            
            cell.textLabel!.text = "Password"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = ""
            
        } else if (indexPath.section==1 && indexPath.row==0) {
            
            cell.textLabel!.text = "Clear Search History"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.detailTextLabel?.text = ""
            
        } else if (indexPath.section==1 && indexPath.row==1) {
            
            cell.textLabel!.text = "Notifications"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==0) {
            
            cell.textLabel!.text = "Invite via Twitter"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==1) {
            
            cell.textLabel!.text = "Invite via Facebook"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==2) {
            
            cell.textLabel!.text = "Invite via Messages"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==2 && indexPath.row==3) {
            
            cell.textLabel!.text = "Invite via Email"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==3 && indexPath.row==0) {
            
            cell.textLabel!.text = "Love Phenom?"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==3 && indexPath.row==1) {
            
            cell.textLabel!.text = "Send Feedback"
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
        } else if (indexPath.section==4 && indexPath.row==0) {
            
            cell.textLabel!.text = "Log Out"
            cell.accessoryType = UITableViewCellAccessoryType.none
            
        } else {
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1) 
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor(red:43/255, green:43/255, blue:45/255, alpha:1)
        cell.selectedBackgroundView = bgView
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
        if (indexPath.section==0 && indexPath.row==0) {
            
            // full name
            let vc = EditProfileViewController()
            vc.passedEditType = "name"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==1) {
            
            // username
            let vc = EditProfileViewController()
            vc.passedEditType = "username"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==2) {
            
            // birthday
            let vc = EditProfileViewController()
            vc.passedEditType = "birthday"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==3) {
            
            // hometown
            let vc = EditProfileViewController()
            vc.passedEditType = "hometown"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==4) {
            
            // sports
            let vc = EditProfileViewController()
            vc.passedEditType = "sports"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==5) {
            
            // bio
            let vc = EditProfileViewController()
            vc.passedEditType = "bio"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==6) {
            
            // email
            let vc = EditProfileViewController()
            vc.passedEditType = "email"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==0 && indexPath.row==7) {
            
            // password
            let vc = EditProfileViewController()
            vc.passedEditType = "password"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section==1 && indexPath.row==0) {
            
            // clear search history
            self.areyousureyouwanttoclearhistory()
            
        } else if (indexPath.section==1 && indexPath.row==1) {
            
            // notifications
            
        } else if (indexPath.section==2 && indexPath.row==0) {
            
            inviteViaTwitter()
            
        } else if (indexPath.section==2 && indexPath.row==1) {
            
            inviteViaFacebook()
            
        } else if (indexPath.section==2 && indexPath.row==2) {
            
            inviteViaMessages()
            
        } else if (indexPath.section==2 && indexPath.row==3) {
            
            inviteViaEmail()
            
        } else if (indexPath.section==3 && indexPath.row==0) {
            
            //love phenom
            ratePhenom()
            
        } else if (indexPath.section==3 && indexPath.row==1) {
            
            //feedback
            feedbackEmail()
            
        } else if (indexPath.section==4 && indexPath.row==0) {
            
            areyousureyouwanttologout()
            
        } else {
            
        }

        
    }
    
    func areyousureyouwanttoclearhistory() {
        let alertController = UIAlertController(title:"Are you sure?", message:nil, preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let clearAction = UIAlertAction(title: "Yes, I'm sure", style: .default) { (action) in
            
            let defaults = UserDefaults.standard
            
            let searchedPeopleWords = defaults.array(forKey: "searchedPeopleWords")
            let searchedPeopleWordsMA = NSMutableArray(array: searchedPeopleWords!)
            searchedPeopleWordsMA.removeAllObjects()
            let searchedPeopleWordsNEW = searchedPeopleWordsMA as NSArray
            defaults.set(searchedPeopleWordsNEW, forKey: "searchedPeopleWords")
            
            let searchedGearWords = defaults.array(forKey: "searchedGearWords")
            let searchedGearWordsMA = NSMutableArray(array: searchedGearWords!)
            searchedGearWordsMA.removeAllObjects()
            let searchedGearWordsNEW = searchedGearWordsMA as NSArray
            defaults.set(searchedGearWordsNEW, forKey: "searchedGearWords")
            
            defaults.synchronize()
           
        }
        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    
    func inviteViaTwitter() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")! as String
        
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \(username))")
        vc.setInitialText(textToShare)
        vc.add(URL(string: "http://phenom.co/download"))
        present(vc, animated: true, completion: nil)
    }
    
    func inviteViaFacebook() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")! as String
        
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \(username))")
        vc.setInitialText(textToShare)
        vc.add(URL(string: "http://phenom.co/download"))
        present(vc, animated: true, completion: nil)
    }
    
    func inviteViaMessages() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")! as String
        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \(username) / http://phenom.co/download)")
        messageComposeVC.body = textToShare
        
        present(messageComposeVC, animated: true, completion: nil)
        
    }
    
    func inviteViaEmail() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")! as String
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("Invite to Phenom")
        let textToShare = String("Add me on Phenom! 🆕🔥 (username: \(username))\n\nhttp://phenom.co/download")
        mailComposerVC.setMessageBody(textToShare, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func ratePhenom() {
        
        let alertController = UIAlertController(title:"Love Phenom?", message:"⭐⭐⭐⭐⭐", preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let rateAction = UIAlertAction(title: "Give 5 Stars!", style: .default) { (action) in
            
            UIApplication.shared.openURL(URL(string: "itms://itunes.apple.com/us/app/phenom/id687226814?ls=1&mt=8")!)
        }
        alertController.addAction(rateAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func feedbackEmail() {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")! as String
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["support@phenomapp.com"])
        mailComposerVC.setSubject("iOS Feedback from \(username)")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
        }
    }
    
    func areyousureyouwanttologout() {
        let alertController = UIAlertController(title:"Are you sure?", message:nil, preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        let logoutAction = UIAlertAction(title: "Log Out", style: .default) { (action) in
            
            (UIApplication.shared.delegate as! AppDelegate).logoutAction()
        }
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
 

}
