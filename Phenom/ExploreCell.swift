//
//  ExploreCell.swift
//  Phenom
//
//  Created by Isom Durm on 3/30/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class ExploreCell: UITableViewCell {

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
        
        nameLbl.backgroundColor = UIColor.yellow
        nameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        nameLbl.textColor = UIColor.lightGray
        nameLbl.textAlignment = NSTextAlignment.left
        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(nameLbl)
        
        usernameLbl.backgroundColor = UIColor.clear
        usernameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        usernameLbl.textColor = UIColor.red
        usernameLbl.textAlignment = NSTextAlignment.left
        usernameLbl.numberOfLines = 1
        usernameLbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(usernameLbl)
        
        followBtn.backgroundColor = UIColor.blue
        //followBtn.addTarget(self, action:#selector(followBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        contentView.addSubview(followBtn)
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userImgView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        nameLbl.frame = CGRect(x: 15+50+10, y: 15, width: cellWidth-15-50-15-50-15, height: 25)
        usernameLbl.frame = CGRect(x: 15+50+10, y: 15+25, width: cellWidth-15-50-15-50-15, height: 25)
        followBtn.frame = CGRect(x: cellWidth-15-40, y: 20, width: 40, height: 40)
        
        
    }
    
    

}
