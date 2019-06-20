//
//  TimelineHeaderView.swift
//  Phenom
//
//  Created by Isom Durm on 3/30/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        backgroundColor = UIColor.black
        
        bg = UIView()
        bg!.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        addSubview(bg!)
        
        userImgView = UIImageView()
        userImgView!.backgroundColor = UIColor.lightGray
        addSubview(userImgView!)
        
        userBtn = UIButton(type: UIButtonType.custom)
        userBtn!.backgroundColor = UIColor.clear
        addSubview(userBtn!)

        
        userLbl = UILabel()
        userLbl!.backgroundColor = UIColor.clear
        userLbl!.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        userLbl!.textColor = UIColor.white
        userLbl!.textAlignment = NSTextAlignment.left
        userLbl!.numberOfLines = 1
        userLbl!.lineBreakMode = NSLineBreakMode.byTruncatingTail
        addSubview(userLbl!)
        
        timeImgView = UIImageView()
        timeImgView!.backgroundColor = UIColor.lightGray
        addSubview(timeImgView!)
        
        timeLbl = UILabel()
        timeLbl!.backgroundColor = UIColor.clear
        timeLbl!.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        timeLbl!.textColor = UIColor.lightGray
        timeLbl!.textAlignment = NSTextAlignment.left
        timeLbl!.numberOfLines = 1
        timeLbl!.lineBreakMode = NSLineBreakMode.byTruncatingTail
        addSubview(timeLbl!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        bg!.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 64)
        
        userImgView!.frame = CGRect(x: 15, y: 10, width: 44, height: 44)
        userBtn!.frame = CGRect(x: 15, y: 10, width: frame.size.width/2, height: 44)
        userLbl!.frame = CGRect(x: 15+44+10, y: 10, width: frame.size.width-20-44-20-20, height: 22)
        timeImgView!.frame = CGRect(x: 15+44+10, y: 10+22+4, width: 14, height: 14)
        timeLbl!.frame = CGRect(x: 15+44+10+14+8, y: 10+22, width: frame.size.width-20-44-20-20, height: 22)
        
        
    }

}
