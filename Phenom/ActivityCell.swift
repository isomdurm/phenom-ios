//
//  ActivityCell.swift
//  Phenom
//
//  Created by Isom Durm on 3/25/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    var cellWidth = CGFloat()
    
    var userImgView = UIImageView()
    var userBtn = UIButton()
    
    var activityLbl = UILabel()
    var momentImgView = UIImageView()
    var momentBtn = UIButton()
    var followBtn = UIButton(type: UIButtonType.custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        userImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        userImgView.contentMode = UIViewContentMode.scaleAspectFill
        userImgView.isUserInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        userBtn.backgroundColor = UIColor.clear
        contentView.addSubview(userBtn)
        
        activityLbl.backgroundColor = UIColor.clear
        activityLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        activityLbl.textColor = UIColor.lightGray
        activityLbl.textAlignment = NSTextAlignment.left
        contentView.addSubview(activityLbl)
        activityLbl.numberOfLines = 0
        activityLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        activityLbl.sizeToFit()
        
        momentImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        momentImgView.contentMode = UIViewContentMode.scaleAspectFill
        momentImgView.isUserInteractionEnabled = true
        contentView.addSubview(momentImgView)
        momentImgView.layer.masksToBounds = true
        
        momentBtn.backgroundColor = UIColor.clear
        contentView.addSubview(momentBtn)
        
        followBtn.backgroundColor = UIColor.blue
        followBtn.setBackgroundImage(UIImage.init(named: "notAddedBtnImg.png") , for: UIControlState())
        followBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , for: UIControlState.selected)
        contentView.addSubview(followBtn)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userImgView.frame = CGRect(x: 15, y: 10, width: 44, height: 44)
        userBtn.frame = CGRect(x: 15, y: 10, width: 44, height: 44)
        
        momentImgView.frame = CGRect(x: cellWidth-15-44, y: 10, width: 44, height: 44)
        momentBtn.frame = CGRect(x: cellWidth-15-44, y: 10, width: 44, height: 44) 
        
        followBtn.frame = CGRect(x: cellWidth-15-44, y: 10, width: 44, height: 44)
        
        
    }

}
