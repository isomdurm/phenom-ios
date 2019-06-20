//
//  PeopleCell.swift
//  Phenom
//
//  Created by Isom Durm on 4/11/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class PeopleCell: UITableViewCell {

    var cellWidth = CGFloat()
    
    var userImgView = UIImageView()
    var nameLbl = UILabel()
    var usernameLbl = UILabel()
    var followBtn = UIButton(type: UIButtonType.custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        userImgView.contentMode = UIViewContentMode.scaleAspectFill
        userImgView.isUserInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        nameLbl.backgroundColor = UIColor.clear
        nameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        nameLbl.textColor = UIColor.white
        nameLbl.textAlignment = NSTextAlignment.left
        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(nameLbl)
        
        usernameLbl.backgroundColor = UIColor.clear
        usernameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        usernameLbl.textColor = UIColor.gray
        usernameLbl.textAlignment = NSTextAlignment.left
        usernameLbl.numberOfLines = 1
        usernameLbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(usernameLbl)
        
        followBtn.backgroundColor = UIColor.orange
        followBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , for: UIControlState())
        followBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , for: UIControlState.selected)
        contentView.addSubview(followBtn)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userImgView.frame = CGRect(x: 15, y: 15, width: 44, height: 44)
        nameLbl.frame = CGRect(x: 15+50+10, y: 15, width: cellWidth-15-50-15-50-15, height: 20)
        usernameLbl.frame = CGRect(x: 15+50+10, y: 15+20, width: cellWidth-15-50-15-50-15, height: 20)
        
        //followBtn.frame = CGRectMake(cellWidth-15-40, 20, 40, 40)
        // 15+44+15
        followBtn.frame = CGRect(x: cellWidth-65-15, y: 18, width: 65, height: 38)
        
        
        
    }

}
