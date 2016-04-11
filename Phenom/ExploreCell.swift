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
        
        userImgView.backgroundColor = UIColor.lightGrayColor()
        userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        userImgView.userInteractionEnabled = true
        contentView.addSubview(userImgView)
        userImgView.layer.masksToBounds = true
        
        nameLbl.backgroundColor = UIColor.yellowColor()
        nameLbl.font = UIFont.boldSystemFontOfSize(17)
        nameLbl.textColor = UIColor.lightGrayColor()
        nameLbl.textAlignment = NSTextAlignment.Left
        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(nameLbl)
        
        usernameLbl.backgroundColor = UIColor.clearColor()
        usernameLbl.font = UIFont.boldSystemFontOfSize(14)
        usernameLbl.textColor = UIColor.redColor()
        usernameLbl.textAlignment = NSTextAlignment.Left
        usernameLbl.numberOfLines = 1
        usernameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(usernameLbl)
        
        followBtn.backgroundColor = UIColor.blueColor()
        //followBtn.addTarget(self, action:#selector(followBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        contentView.addSubview(followBtn)
        
        //
        //
        
//        theScrollView.backgroundColor = UIColor.orangeColor() // UIColor(red:20/255, green:20/255, blue:25/255, alpha:1)
        //theScrollView.delegate = self
        theScrollView.backgroundColor = UIColor.orangeColor()
        theScrollView.pagingEnabled = false
        theScrollView.showsHorizontalScrollIndicator = true
        theScrollView.showsVerticalScrollIndicator = false
        theScrollView.scrollsToTop = false
        theScrollView.scrollEnabled = true
        theScrollView.bounces = true
        theScrollView.alwaysBounceVertical = false
        theScrollView.alwaysBounceHorizontal = true
        theScrollView.userInteractionEnabled = true
        contentView.addSubview(theScrollView)
        theScrollView.hidden = true
        
        
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
        
        //followBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //followBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        
        theScrollView.frame = CGRectMake(0, 0, cellWidth, 150)
        theScrollView.contentSize = CGSize(width: cellWidth*3, height: 150)
        theScrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        
    }
    
    

}
