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
    var userBtn: UIButton?
    var userLbl: UILabel?
    var timeImgView: UIImageView?
    var timeLbl: UILabel?
    
    var bg: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame 
        backgroundColor = UIColor.blackColor()
        
        bg = UIView()
        bg!.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        addSubview(bg!)
        
        userImgView = UIImageView()
        userImgView!.backgroundColor = UIColor.lightGrayColor()
        addSubview(userImgView!)
        
        userBtn = UIButton(type: UIButtonType.Custom)
        userBtn!.backgroundColor = UIColor.clearColor()
        addSubview(userBtn!)

        
        userLbl = UILabel()
        userLbl!.backgroundColor = UIColor.clearColor()
        userLbl!.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        userLbl!.textColor = UIColor.whiteColor()
        userLbl!.textAlignment = NSTextAlignment.Left
        userLbl!.numberOfLines = 1
        userLbl!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addSubview(userLbl!)
        
        timeImgView = UIImageView()
        timeImgView!.backgroundColor = UIColor.lightGrayColor()
        addSubview(timeImgView!)
        
        timeLbl = UILabel()
        timeLbl!.backgroundColor = UIColor.clearColor()
        timeLbl!.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        timeLbl!.textColor = UIColor.lightGrayColor()
        timeLbl!.textAlignment = NSTextAlignment.Left
        timeLbl!.numberOfLines = 1
        timeLbl!.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        addSubview(timeLbl!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        bg!.frame = CGRectMake(0, 0, frame.size.width, 64)
        
        userImgView!.frame = CGRectMake(15, 10, 44, 44)
        userBtn!.frame = CGRectMake(15, 10, frame.size.width/2, 44)
        userLbl!.frame = CGRectMake(15+44+10, 10, frame.size.width-20-44-20-20, 22)
        timeImgView!.frame = CGRectMake(15+44+10, 10+22+4, 14, 14)
        timeLbl!.frame = CGRectMake(15+44+10+14+8, 10+22, frame.size.width-20-44-20-20, 22)
        
        
    }

}
