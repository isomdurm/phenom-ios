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
    var activityLbl = UILabel()
    var momentImgView = UIImageView()
    var followBtn = UIButton(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.userImgView.backgroundColor = UIColor.lightGrayColor()
        self.userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.userImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.userImgView)
        self.userImgView.layer.masksToBounds = true
        
        self.activityLbl.backgroundColor = UIColor.yellowColor()
        self.activityLbl.font = UIFont.systemFontOfSize(12)
        self.activityLbl.textColor = UIColor.lightGrayColor()
        self.activityLbl.textAlignment = NSTextAlignment.Left
        self.activityLbl.numberOfLines = 1
        self.activityLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.contentView.addSubview(self.activityLbl)
        
        self.momentImgView.backgroundColor = UIColor.greenColor()
        self.momentImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.momentImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.momentImgView)
        self.momentImgView.layer.masksToBounds = true
        
        self.followBtn.backgroundColor = UIColor.blueColor()
        //self.followBtn.addTarget(self, action:#selector(CameraViewController.self.followBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.followBtn)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.userImgView.frame = CGRectMake(15, 10, 44, 44)
        self.activityLbl.frame = CGRectMake(15+44+10, 10, self.cellWidth-15-40-15-44-15-10, 44) // x = 15+44+10 is on purpose
        
        self.momentImgView.frame = CGRectMake(self.cellWidth-15-44, 10, 44, 44)
        self.followBtn.frame = CGRectMake(self.cellWidth-15-44, 10, 44, 44)
        
        //self.followBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //self.followBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        
        
        
    }

}
