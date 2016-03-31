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
    
    var theScrollView = UIScrollView()
    
    var userImgView = UIImageView()
    var nameLbl = UILabel()
    var usernameLbl = UILabel()
    var followBtn = UIButton(type: UIButtonType.Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.userImgView.backgroundColor = UIColor.lightGrayColor()
        self.userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.userImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.userImgView)
        self.userImgView.layer.masksToBounds = true
        
        self.nameLbl.backgroundColor = UIColor.yellowColor()
        self.nameLbl.font = UIFont.boldSystemFontOfSize(17)
        self.nameLbl.textColor = UIColor.lightGrayColor()
        self.nameLbl.textAlignment = NSTextAlignment.Left
        self.nameLbl.numberOfLines = 1
        self.nameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.contentView.addSubview(self.nameLbl)
        
        self.usernameLbl.backgroundColor = UIColor.greenColor()
        self.usernameLbl.font = UIFont.boldSystemFontOfSize(14)
        self.usernameLbl.textColor = UIColor.lightGrayColor()
        self.usernameLbl.textAlignment = NSTextAlignment.Left
        self.usernameLbl.numberOfLines = 1
        self.usernameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.contentView.addSubview(self.usernameLbl)
        
        self.followBtn.backgroundColor = UIColor.blueColor()
        //self.followBtn.addTarget(self, action:#selector(CameraViewController.self.followBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.followBtn)
        
        //
        //
        
        self.theScrollView.backgroundColor = UIColor.orangeColor() // UIColor(red:20/255, green:20/255, blue:25/255, alpha:1)
        //self.theScrollView.delegate = self
        self.theScrollView.pagingEnabled = false
        self.theScrollView.showsHorizontalScrollIndicator = true
        self.theScrollView.showsVerticalScrollIndicator = false
        self.theScrollView.scrollsToTop = false
        self.theScrollView.scrollEnabled = true
        self.theScrollView.bounces = true
        self.theScrollView.alwaysBounceVertical = false
        self.theScrollView.alwaysBounceHorizontal = true
        self.theScrollView.userInteractionEnabled = true
        self.contentView.addSubview(self.theScrollView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.userImgView.frame = CGRectMake(15, 15, 50, 50)
        self.nameLbl.frame = CGRectMake(15+50+10, 15, self.cellWidth-15-50-15-50-15, 25)
        self.usernameLbl.frame = CGRectMake(15+50+10, 15+25, self.cellWidth-15-50-15-50-15, 25)
        self.followBtn.frame = CGRectMake(self.cellWidth-15-40, 20, 40, 40)
        
        //self.followBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //self.followBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        
        self.theScrollView.frame = CGRectMake(0, 0, self.cellWidth, 150)
        self.theScrollView.contentSize = CGSize(width: self.cellWidth*3, height: 150)
        self.theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        
    }
    
    

}
