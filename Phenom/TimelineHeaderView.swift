//
//  TimelineHeaderView.swift
//  Phenom
//
//  Created by Clay Zug on 3/30/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class TimelineHeaderView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var userImgView: UIImageView?
    var userLbl: UILabel?
    var timeImgView: UIImageView?
    var timeLbl: UILabel?
    
    var bg: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor.blackColor()
        
        self.bg = UIView()
        self.bg!.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        self.addSubview(self.bg!)
        
        self.userImgView = UIImageView()
        self.userImgView!.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(self.userImgView!)
        
        self.userLbl = UILabel()
        self.userLbl!.backgroundColor = UIColor.clearColor()
        self.userLbl!.font = UIFont.boldSystemFontOfSize(18)
        self.userLbl!.textColor = UIColor.whiteColor()
        self.userLbl!.textAlignment = NSTextAlignment.Left
        self.userLbl!.numberOfLines = 1
        self.userLbl!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.addSubview(self.userLbl!)
        
        self.timeImgView = UIImageView()
        self.timeImgView!.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(self.timeImgView!)
        
        self.timeLbl = UILabel()
        self.timeLbl!.backgroundColor = UIColor.clearColor()
        self.timeLbl!.font = UIFont.boldSystemFontOfSize(12)
        self.timeLbl!.textColor = UIColor.lightGrayColor()
        self.timeLbl!.textAlignment = NSTextAlignment.Left
        self.timeLbl!.numberOfLines = 1
        self.timeLbl!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.addSubview(self.timeLbl!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        self.bg!.frame = CGRectMake(0, 0, self.frame.size.width, 64)
        
        self.userImgView!.frame = CGRectMake(15, 10, 44, 44)
        self.userLbl!.frame = CGRectMake(15+44+10, 10, self.frame.size.width-20-44-20-20, 22)
        self.timeImgView!.frame = CGRectMake(15+44+10, 10+22+4, 14, 14)
        self.timeLbl!.frame = CGRectMake(15+44+10+14+8, 10+22, self.frame.size.width-20-44-20-20, 22)
        
        
    }

}
