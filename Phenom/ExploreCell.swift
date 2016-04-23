//
//  ExploreCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/30/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ExploreCell: UITableViewCell {

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
        
        nameLbl.backgroundColor = UIColor.yellowColor()
        nameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        nameLbl.textColor = UIColor.lightGrayColor()
        nameLbl.textAlignment = NSTextAlignment.Left
        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(nameLbl)
        
        usernameLbl.backgroundColor = UIColor.clearColor()
        usernameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        usernameLbl.textColor = UIColor.redColor()
        usernameLbl.textAlignment = NSTextAlignment.Left
        usernameLbl.numberOfLines = 1
        usernameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(usernameLbl)
        
        followBtn.backgroundColor = UIColor.blueColor()
        //followBtn.addTarget(self, action:#selector(followBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        contentView.addSubview(followBtn)
        

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        userImgView.frame = CGRectMake(15, 15, 50, 50)
        nameLbl.frame = CGRectMake(15+50+10, 15, cellWidth-15-50-15-50-15, 25)
        usernameLbl.frame = CGRectMake(15+50+10, 15+25, cellWidth-15-50-15-50-15, 25)
        followBtn.frame = CGRectMake(cellWidth-15-40, 20, 40, 40)
        
        
    }
    
    

}
