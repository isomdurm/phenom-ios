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
    
    var teamBannerView = UIView()
    var teamNameLbl = UILabel()
    var teamSportLbl = UILabel()
    var teamNumLbl = UILabel()
    var teamPositionLbl = UILabel()
    
    //
    
    var timelineImgView = UIImageView()
    var timelineMusicLbl = UILabel()
    var timelineModeLbl = UILabel()
    var timelineRankLbl = UILabel()
    
    var timelineTinyHeartBtn = UIButton()
    var timelineLikeLblBtn = UIButton()
    
    var timelineUserImgView = UIImageView()
    var timelineUserImgViewBtn = UIButton()
    var timelineNameLbl = UILabel()
    var timelineTimeLbl = UILabel()
    
    var timelineFollowBtn = UIButton()
    
    var timelineHeadlineLbl = UILabel()
    
    var timelineLikeBtn = UIButton()
    var timelineChatBtn = UIButton()
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
        
        teamBannerView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        contentView.addSubview(teamBannerView)
        
        teamNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 30)
        teamNameLbl.textColor = UIColor.whiteColor()
        teamNameLbl.textAlignment = .Center
        contentView.addSubview(teamNameLbl)
        teamNameLbl.textAlignment = .Center
        teamNameLbl.lineBreakMode = .ByWordWrapping
        teamNameLbl.numberOfLines = 0
        
        teamSportLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        teamSportLbl.textColor = UIColor.whiteColor()
        teamSportLbl.textAlignment = .Right
        contentView.addSubview(teamSportLbl)
        
        teamNumLbl.backgroundColor = UINavigationBar.appearance().tintColor //gold
        teamNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 20)
        teamNumLbl.textColor = UIColor.whiteColor()
        teamNumLbl.textAlignment = .Center
        contentView.addSubview(teamNumLbl)
        
        teamPositionLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        teamPositionLbl.textColor = UIColor.whiteColor()
        teamPositionLbl.textAlignment = .Left
        contentView.addSubview(teamPositionLbl)
        
        //
        
        timelineImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        timelineImgView.contentMode = UIViewContentMode.ScaleAspectFill
        timelineImgView.image = UIImage(named: "purple200.png")
        contentView.addSubview(timelineImgView)
        timelineImgView.layer.masksToBounds = true
        timelineImgView.userInteractionEnabled = true
        
        timelineMusicLbl.backgroundColor = UINavigationBar.appearance().tintColor
        timelineMusicLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        timelineMusicLbl.textColor = UIColor.whiteColor()
        timelineMusicLbl.textAlignment = .Center
        contentView.addSubview(timelineMusicLbl)
        
        timelineModeLbl.backgroundColor = UINavigationBar.appearance().tintColor
        timelineModeLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        timelineModeLbl.textColor = UIColor.whiteColor()
        timelineModeLbl.textAlignment = .Center
        contentView.addSubview(timelineModeLbl)
        
        timelineRankLbl.backgroundColor = UINavigationBar.appearance().tintColor
        timelineRankLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 18)
        timelineRankLbl.textColor = UIColor.whiteColor()
        timelineRankLbl.textAlignment = .Center
        contentView.addSubview(timelineRankLbl)
        
        timelineUserImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
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
        timelineTimeLbl.textColor = UIColor.grayColor()
        timelineTimeLbl.textAlignment = .Left
        contentView.addSubview(timelineTimeLbl)

        timelineFollowBtn.backgroundColor = UIColor.orangeColor()
        timelineFollowBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , forState: UIControlState.Normal)
        timelineFollowBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , forState: UIControlState.Selected)
        timelineFollowBtn.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(timelineFollowBtn)
        timelineFollowBtn.layer.cornerRadius = 2
        timelineFollowBtn.layer.masksToBounds = true
        
        timelineHeadlineLbl.backgroundColor = UIColor.clearColor()
        timelineHeadlineLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        timelineHeadlineLbl.textColor = UIColor.whiteColor()
        contentView.addSubview(timelineHeadlineLbl)
        timelineHeadlineLbl.textAlignment = .Left
        timelineHeadlineLbl.lineBreakMode = .ByWordWrapping
        timelineHeadlineLbl.numberOfLines = 0
        
        timelineLikeBtn.backgroundColor = UINavigationBar.appearance().tintColor
        timelineLikeBtn.setBackgroundImage(UIImage.init(named: "timeline-like-btn.png") , forState: UIControlState.Normal)
        timelineLikeBtn.setBackgroundImage(UIImage.init(named: "timeline-like-btn-selected.png") , forState: UIControlState.Selected)
        contentView.addSubview(timelineLikeBtn)
        timelineLikeBtn.layer.cornerRadius = 2
        timelineLikeBtn.layer.masksToBounds = true
        
        timelineChatBtn.backgroundColor = UINavigationBar.appearance().tintColor
        timelineChatBtn.setBackgroundImage(UIImage.init(named: "timeline-chat-btn.png") , forState: UIControlState.Normal)
        //timelineChatBtn.setBackgroundImage(UIImage.init(named: "timeline-chat-btn.png") , forState: UIControlState.Selected)
        contentView.addSubview(timelineChatBtn)
        timelineChatBtn.layer.cornerRadius = 2
        timelineChatBtn.layer.masksToBounds = true

        timelineGearBtn.backgroundColor = UINavigationBar.appearance().tintColor
        timelineGearBtn.setBackgroundImage(UIImage.init(named: "timeline-gear-btn.png") , forState: UIControlState.Normal)
        contentView.addSubview(timelineGearBtn)
        timelineGearBtn.layer.cornerRadius = 2
        timelineGearBtn.layer.masksToBounds = true
        
        timelineMoreBtn.backgroundColor = UIColor.init(white: 0.25, alpha: 1.0)
        contentView.addSubview(timelineMoreBtn)
        timelineMoreBtn.layer.cornerRadius = 2
        timelineMoreBtn.layer.masksToBounds = true

        timelineSingleTapRecognizer.numberOfTapsRequired = 1
        timelineImgView.addGestureRecognizer(timelineSingleTapRecognizer)
        
        timelineDoubleTapRecognizer.numberOfTapsRequired = 2
        timelineImgView.addGestureRecognizer(timelineDoubleTapRecognizer)
        
        timelineSingleTapRecognizer.requireGestureRecognizerToFail(timelineDoubleTapRecognizer) 
        
        //
        
        gearImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
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
        gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear.png") , forState: UIControlState.Normal)
        //gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear-selected.png") , forState: UIControlState.Selected)
        gearAddBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , forState: UIControlState.Selected)
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
