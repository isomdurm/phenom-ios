//
//  InviteFriendsViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class InviteFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        
        // NO BACK BUTTON
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "INVITE FRIENDS"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let doneBtn = UIButton(type: UIButtonType.custom)
        doneBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        doneBtn.setImage(UIImage(named: "doneBtn.png"), for: UIControlState())
        //doneBtn.setBackgroundImage(UIImage(named: "backBtn.png"), forState: UIControlState.Normal)
        doneBtn.backgroundColor = UIColor.red
        doneBtn.addTarget(self, action:#selector(doneBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(doneBtn)
        
        theTableView.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height-64)
        theTableView.backgroundColor = UIColor.red
        theTableView.separatorColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.showsVerticalScrollIndicator = true
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(theTableView)
        theTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
        // auto-follow phenom
        //
        // ask for access to contacts
        //
        // show friends already on the service AND auto-follow them based on email in contacts
        //
        // show 10 suggested users under
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
        
    }
    
    // TableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
        
        
        
    }
    
    
    func doneBtnAction() {
        
        self.view.endEditing(true)
        self.navigationController?.dismiss(animated: false, completion: nil)
        (UIApplication.shared.delegate as! AppDelegate).presentTabBarViewController()
        
    }
    
    

}
