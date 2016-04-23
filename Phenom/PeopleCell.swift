//
//  PeopleCell.swift
//  Phenom
//
//  Created by Clay Zug on 4/11/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    var cellWidth = CGFloat()
    
    var userImgView = UIImageView()
    var nameLbl = UILabel()
    var usernameLbl = UILabel()
    var followBtn = UIButton(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        userImgView.userInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        nameLbl.backgroundColor = UIColor.clearColor()
        nameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        nameLbl.textColor = UIColor.whiteColor()
        nameLbl.textAlignment = NSTextAlignment.Left
        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(nameLbl)
        
        usernameLbl.backgroundColor = UIColor.clearColor()
        usernameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        usernameLbl.textColor = UIColor.grayColor()
        usernameLbl.textAlignment = NSTextAlignment.Left
        usernameLbl.numberOfLines = 1
        usernameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(usernameLbl)
        
        followBtn.backgroundColor = UIColor.orangeColor()
        followBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , forState: UIControlState.Normal)
        followBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , forState: UIControlState.Selected)
        contentView.addSubview(followBtn)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userImgView.frame = CGRectMake(15, 15, 44, 44)
        nameLbl.frame = CGRectMake(15+50+10, 15, cellWidth-15-50-15-50-15, 20)
        usernameLbl.frame = CGRectMake(15+50+10, 15+20, cellWidth-15-50-15-50-15, 20)
        
        //followBtn.frame = CGRectMake(cellWidth-15-40, 20, 40, 40)
        // 15+44+15
        followBtn.frame = CGRectMake(cellWidth-65-15, 18, 65, 38)
        
        
        
    }

}
