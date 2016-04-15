//
//  ChatCell.swift
//  Phenom
//
//  Created by Clay Zug on 4/13/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    var cellWidth = CGFloat()
    
    var userImgView = UIImageView()
    var userBtn = UIButton()
    var usernameBtn = UIButton()
    var chatLbl = ActiveLabel()
    var dateLbl = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        userImgView.userInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        userBtn.backgroundColor = UIColor.clearColor()
        contentView.addSubview(userBtn)
        
        usernameBtn.backgroundColor = UIColor.clearColor()
        usernameBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        usernameBtn.titleLabel?.numberOfLines = 1
        usernameBtn.contentHorizontalAlignment = .Left
        usernameBtn.contentVerticalAlignment = .Center
        usernameBtn.titleLabel?.textAlignment = .Left
        usernameBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        usernameBtn.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        contentView.addSubview(usernameBtn)
        
        chatLbl.backgroundColor = UIColor.clearColor()
        chatLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        chatLbl.textColor = UIColor.whiteColor()
        chatLbl.textAlignment = NSTextAlignment.Left
        chatLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        chatLbl.numberOfLines = 0
        chatLbl.sizeToFit()
        contentView.addSubview(chatLbl)
        self.chatLbl.hashtagColor = UIColor.whiteColor()
        self.chatLbl.mentionColor = UINavigationBar.appearance().tintColor //UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
        self.chatLbl.URLColor = UIColor(red:0/255, green:138/255, blue:255/255, alpha:1) //blue
        
        dateLbl.backgroundColor = UIColor.clearColor()
        dateLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        dateLbl.textColor = UIColor.grayColor()
        dateLbl.textAlignment = NSTextAlignment.Right
        dateLbl.numberOfLines = 1
        dateLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentView.addSubview(dateLbl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }


}
