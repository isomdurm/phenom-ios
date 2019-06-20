//
//  ChatCell.swift
//  Phenom
//
//  Created by Isom Durm on 4/13/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        userImgView.contentMode = UIViewContentMode.scaleAspectFill
        userImgView.isUserInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        userBtn.backgroundColor = UIColor.clear
        contentView.addSubview(userBtn)
        
        usernameBtn.backgroundColor = UIColor.clear
        usernameBtn.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        usernameBtn.titleLabel?.numberOfLines = 1
        usernameBtn.contentHorizontalAlignment = .left
        usernameBtn.contentVerticalAlignment = .center
        usernameBtn.titleLabel?.textAlignment = .left
        usernameBtn.setTitleColor(UIColor.white, for: UIControlState())
        usernameBtn.setTitleColor(UIColor.white, for: .highlighted)
        contentView.addSubview(usernameBtn)
        
        chatLbl.backgroundColor = UIColor.clear
        chatLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        chatLbl.textColor = UIColor.white
        chatLbl.textAlignment = NSTextAlignment.left
        chatLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        chatLbl.numberOfLines = 0
        chatLbl.sizeToFit()
        contentView.addSubview(chatLbl)
        self.chatLbl.hashtagColor = UIColor.white
        self.chatLbl.mentionColor = UINavigationBar.appearance().tintColor //UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
        self.chatLbl.URLColor = UIColor(red:0/255, green:138/255, blue:255/255, alpha:1) //blue
        
        dateLbl.backgroundColor = UIColor.clear
        dateLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        dateLbl.textColor = UIColor.gray
        dateLbl.textAlignment = NSTextAlignment.right
        dateLbl.numberOfLines = 1
        dateLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentView.addSubview(dateLbl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }


}
