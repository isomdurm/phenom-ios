//
//  MainCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/30/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import QuartzCore

class MainCell: UITableViewCell { 
    
    var cellWidth = CGFloat()
    
    //
    
    var teamNameLbl = UILabel()
    var teamSportLbl = UILabel()
    var teamNumLbl = UILabel()
    var teamPositionLbl = UILabel()
    
    //
    
    var timelineImgView = UIImageView()
    var timelineMusicLbl = UILabel()
    var timelineModeLbl = UILabel()
    
    var timelineTinyHeartBtn = UIButton()
    var timelineLikeLblBtn = UIButton()
    
    var timelineUserImgView = UIImageView()
    var timelineUserImgViewBtn = UIButton()
    var timelineNameLbl = UILabel()
    var timelineTimeLbl = UILabel()
    
    var timelineFollowBtn = UIButton()
    
    var timelineHeadlineLbl = UILabel()
    
    var timelineLikeBtn = UIButton()
    var timelineCommentBtn = UIButton()
    var timelineGearBtn = UIButton()
    var timelineMoreBtn = UIButton()
    
    var timelineSingleTapRecognizer = UITapGestureRecognizer()
    var timelineDoubleTapRecognizer = UITapGestureRecognizer()
    
    //
    
    var gearImgView = UIImageView()
    var gearBrandLbl = UILabel()
    var gearNameLbl = UILabel()
    var gearAddBtn = UIButton()
    var gearSingleTapRecognizer = UITapGestureRecognizer()
    var gearDoubleTapRecognizer = UITapGestureRecognizer()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        teamNameLbl.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/3*2)
        teamNameLbl.font = UIFont.boldSystemFontOfSize(25)
        teamNameLbl.textColor = UIColor.whiteColor()
        teamNameLbl.textAlignment = .Center
        contentView.addSubview(teamNameLbl)
        
        teamSportLbl.frame = CGRect(x: -25, y: frame.size.height/3*2, width: frame.size.width, height: 50)
        teamSportLbl.font = UIFont.boldSystemFontOfSize(15)
        teamSportLbl.textColor = UIColor.whiteColor()
        teamSportLbl.textAlignment = .Right
        contentView.addSubview(teamSportLbl)
        
        teamNumLbl.frame = CGRect(x: frame.size.width/2-25, y: frame.size.height/3*2, width: 50, height: 50)
        teamNumLbl.backgroundColor = UIColor.orangeColor()
        teamNumLbl.font = UIFont.boldSystemFontOfSize(15)
        teamNumLbl.textColor = UIColor.whiteColor()
        teamNumLbl.textAlignment = .Center
        contentView.addSubview(teamNumLbl)
        
        teamPositionLbl.frame = CGRect(x: frame.size.width/2+25, y: frame.size.height/3*2, width: frame.size.width/2, height: 50)
        teamPositionLbl.font = UIFont.boldSystemFontOfSize(15)
        teamPositionLbl.textColor = UIColor.whiteColor()
        teamPositionLbl.textAlignment = .Left
        contentView.addSubview(teamPositionLbl)
        
        //
        
        timelineImgView.backgroundColor = UIColor.clearColor() // UIColor.lightGrayColor()
        timelineImgView.contentMode = UIViewContentMode.ScaleAspectFill
        timelineImgView.image = UIImage(named: "purple200.png")
        contentView.addSubview(timelineImgView)
        timelineImgView.layer.masksToBounds = true
        timelineImgView.userInteractionEnabled = true
        
        timelineMusicLbl.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        timelineMusicLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        timelineMusicLbl.textColor = UIColor.whiteColor()
        timelineMusicLbl.textAlignment = .Center
        contentView.addSubview(timelineMusicLbl)
        
        timelineModeLbl.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        timelineModeLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        timelineModeLbl.textColor = UIColor.whiteColor()
        timelineModeLbl.textAlignment = .Center
        contentView.addSubview(timelineModeLbl)
        
        timelineUserImgView.backgroundColor = UIColor.orangeColor()
        timelineUserImgView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(timelineUserImgView)
        timelineUserImgView.layer.masksToBounds = true
        
        timelineUserImgViewBtn.backgroundColor = UIColor.clearColor()
        contentView.addSubview(timelineUserImgViewBtn)
        
        timelineNameLbl.backgroundColor = UIColor.clearColor()
        timelineNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        timelineNameLbl.textColor = UIColor.whiteColor()
        timelineNameLbl.textAlignment = .Left
        contentView.addSubview(timelineNameLbl)
        
        timelineTimeLbl.backgroundColor = UIColor.clearColor()
        timelineTimeLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        timelineTimeLbl.textColor = UIColor.whiteColor()
        timelineTimeLbl.textAlignment = .Left
        contentView.addSubview(timelineTimeLbl)

        timelineFollowBtn.backgroundColor = UIColor.orangeColor()
        timelineFollowBtn.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(timelineFollowBtn)
        
        timelineHeadlineLbl.backgroundColor = UIColor.clearColor()
        timelineHeadlineLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        timelineHeadlineLbl.textColor = UIColor.whiteColor()
        contentView.addSubview(timelineHeadlineLbl)
        timelineHeadlineLbl.textAlignment = .Left
        timelineHeadlineLbl.lineBreakMode = .ByWordWrapping
        timelineHeadlineLbl.numberOfLines = 0
        
        timelineLikeBtn.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        contentView.addSubview(timelineLikeBtn)
        
        timelineCommentBtn.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        contentView.addSubview(timelineCommentBtn)

        timelineGearBtn.backgroundColor = UIColor(red:157/255, green:135/255, blue:64/255, alpha:1)
        contentView.addSubview(timelineGearBtn)
        
        timelineMoreBtn.backgroundColor = UIColor.init(white: 0.25, alpha: 1.0)
        contentView.addSubview(timelineMoreBtn)

        timelineSingleTapRecognizer.numberOfTapsRequired = 1
        timelineImgView.addGestureRecognizer(timelineSingleTapRecognizer)
        
        timelineDoubleTapRecognizer.numberOfTapsRequired = 2
        timelineImgView.addGestureRecognizer(timelineDoubleTapRecognizer)
        
        timelineSingleTapRecognizer.requireGestureRecognizerToFail(timelineDoubleTapRecognizer) 
        
        //
        
        gearImgView.backgroundColor = UIColor.clearColor()
        gearImgView.contentMode = UIViewContentMode.ScaleAspectFill
        gearImgView.image = UIImage(named: "purple200.png")
        contentView.addSubview(gearImgView)
        gearImgView.layer.masksToBounds = true
        gearImgView.userInteractionEnabled = true
        
        gearBrandLbl.backgroundColor = UIColor.clearColor()
        gearBrandLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 16)
        gearBrandLbl.textColor = UIColor.grayColor()
        gearBrandLbl.textAlignment = .Left
        contentView.addSubview(gearBrandLbl)
        
        gearNameLbl.backgroundColor = UIColor.clearColor()
        gearNameLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        gearNameLbl.textColor = UIColor.whiteColor()
        gearNameLbl.textAlignment = .Left
        contentView.addSubview(gearNameLbl)
        gearNameLbl.textAlignment = .Left
        gearNameLbl.lineBreakMode = .ByWordWrapping
        gearNameLbl.numberOfLines = 0
        
        gearAddBtn.backgroundColor = UIColor.orangeColor()
        contentView.addSubview(gearAddBtn)
        
        gearSingleTapRecognizer.numberOfTapsRequired = 1
        gearImgView.addGestureRecognizer(gearSingleTapRecognizer)

        gearDoubleTapRecognizer.numberOfTapsRequired = 2
        gearImgView.addGestureRecognizer(gearDoubleTapRecognizer)
        
        gearSingleTapRecognizer.requireGestureRecognizerToFail(gearDoubleTapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

    
    
}
