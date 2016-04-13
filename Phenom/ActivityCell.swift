//
//  ActivityCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    var cellWidth = CGFloat()
    
    var userImgView = UIImageView()
    var userBtn = UIButton()
    var activityLbl = UILabel()
    var momentImgView = UIImageView()
    var momentBtn = UIButton()
    var followBtn = UIButton(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        userImgView.userInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        userBtn.backgroundColor = UIColor.clearColor()
        contentView.addSubview(userBtn)
        
        activityLbl.backgroundColor = UIColor.clearColor()
        activityLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 13)
        activityLbl.textColor = UIColor.lightGrayColor()
        activityLbl.textAlignment = NSTextAlignment.Left
        activityLbl.numberOfLines = 1
        activityLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(activityLbl)
        
        momentImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        momentImgView.contentMode = UIViewContentMode.ScaleAspectFill
        momentImgView.userInteractionEnabled = true
        contentView.addSubview(momentImgView)
        momentImgView.layer.masksToBounds = true
        
        momentBtn.backgroundColor = UIColor.clearColor()
        contentView.addSubview(momentBtn)
        
        followBtn.backgroundColor = UIColor.blueColor()
        followBtn.setBackgroundImage(UIImage.init(named: "notAddedBtnImg.png") , forState: UIControlState.Normal)
        followBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , forState: UIControlState.Selected)
        contentView.addSubview(followBtn)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userImgView.frame = CGRectMake(15, 10, 44, 44)
        userBtn.frame = CGRectMake(15, 10, 44, 44)
        
        momentImgView.frame = CGRectMake(cellWidth-15-44, 10, 44, 44)
        momentBtn.frame = CGRectMake(cellWidth-15-44, 10, 44, 44) 
        
        followBtn.frame = CGRectMake(cellWidth-15-44, 10, 44, 44)
        
        //followBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //followBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        
        
        
    }

}
