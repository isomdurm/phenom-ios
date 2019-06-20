//
//  MainCell.swift
//  Phenom
//
//  Created by Isom Durm on 3/30/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        teamNameLbl.textColor = UIColor.white
        teamNameLbl.textAlignment = .center
        contentView.addSubview(teamNameLbl)
        teamNameLbl.textAlignment = .center
        teamNameLbl.lineBreakMode = .byWordWrapping
        teamNameLbl.numberOfLines = 0
        
        teamSportLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        teamSportLbl.textColor = UIColor.white
        teamSportLbl.textAlignment = .right
        contentView.addSubview(teamSportLbl)
        
        teamNumLbl.backgroundColor = UINavigationBar.appearance().tintColor //gold
        teamNumLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 20)
        teamNumLbl.textColor = UIColor.white
        teamNumLbl.textAlignment = .center
        contentView.addSubview(teamNumLbl)
        
        teamPositionLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        teamPositionLbl.textColor = UIColor.white
        teamPositionLbl.textAlignment = .left
        contentView.addSubview(teamPositionLbl)
        
        //
        
        timelineImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        timelineImgView.contentMode = UIViewContentMode.scaleAspectFill
        timelineImgView.image = UIImage(named: "purple200.png")
        contentView.addSubview(timelineImgView)
        timelineImgView.layer.masksToBounds = true
        timelineImgView.isUserInteractionEnabled = true
        
        timelineMusicLbl.backgroundColor = UINavigationBar.appearance().tintColor
        timelineMusicLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        timelineMusicLbl.textColor = UIColor.white
        timelineMusicLbl.textAlignment = .center
        contentView.addSubview(timelineMusicLbl)
        
        timelineModeLbl.backgroundColor = UINavigationBar.appearance().tintColor
        timelineModeLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        timelineModeLbl.textColor = UIColor.white
        timelineModeLbl.textAlignment = .center
        contentView.addSubview(timelineModeLbl)
        
        timelineRankLbl.backgroundColor = UINavigationBar.appearance().tintColor
        timelineRankLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 18)
        timelineRankLbl.textColor = UIColor.white
        timelineRankLbl.textAlignment = .center
        contentView.addSubview(timelineRankLbl)
        
        timelineUserImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        timelineUserImgView.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(timelineUserImgView)
        timelineUserImgView.layer.masksToBounds = true

        timelineUserImgViewBtn.backgroundColor = UIColor.clear
        contentView.addSubview(timelineUserImgViewBtn)
        
        timelineNameLbl.backgroundColor = UIColor.clear
        timelineNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 15)
        timelineNameLbl.textColor = UIColor.white
        timelineNameLbl.textAlignment = .left
        contentView.addSubview(timelineNameLbl)
        
        timelineTimeLbl.backgroundColor = UIColor.clear
        timelineTimeLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        timelineTimeLbl.textColor = UIColor.gray
        timelineTimeLbl.textAlignment = .left
        contentView.addSubview(timelineTimeLbl)

        timelineFollowBtn.backgroundColor = UIColor.orange
        timelineFollowBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , for: UIControlState())
        timelineFollowBtn.setBackgroundImage(UIImage.init(named: "timeline-follow-btn.png") , for: UIControlState.selected)
        timelineFollowBtn.contentMode = UIViewContentMode.scaleAspectFill
        contentView.addSubview(timelineFollowBtn)
        timelineFollowBtn.layer.cornerRadius = 2
        timelineFollowBtn.layer.masksToBounds = true
        
        timelineHeadlineLbl.backgroundColor = UIColor.clear
        timelineHeadlineLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 15)
        timelineHeadlineLbl.textColor = UIColor.white
        contentView.addSubview(timelineHeadlineLbl)
        timelineHeadlineLbl.textAlignment = .left
        timelineHeadlineLbl.lineBreakMode = .byWordWrapping
        timelineHeadlineLbl.numberOfLines = 0
        
        timelineLikeBtn.backgroundColor = UINavigationBar.appearance().tintColor
        timelineLikeBtn.setBackgroundImage(UIImage.init(named: "timeline-like-btn.png") , for: UIControlState())
        timelineLikeBtn.setBackgroundImage(UIImage.init(named: "timeline-like-btn-selected.png") , for: UIControlState.selected)
        contentView.addSubview(timelineLikeBtn)
        timelineLikeBtn.layer.cornerRadius = 2
        timelineLikeBtn.layer.masksToBounds = true
        
        timelineChatBtn.backgroundColor = UINavigationBar.appearance().tintColor
        timelineChatBtn.setBackgroundImage(UIImage.init(named: "timeline-chat-btn.png") , for: UIControlState())
        //timelineChatBtn.setBackgroundImage(UIImage.init(named: "timeline-chat-btn.png") , forState: UIControlState.Selected)
        contentView.addSubview(timelineChatBtn)
        timelineChatBtn.layer.cornerRadius = 2
        timelineChatBtn.layer.masksToBounds = true

        timelineGearBtn.backgroundColor = UINavigationBar.appearance().tintColor
        timelineGearBtn.setBackgroundImage(UIImage.init(named: "timeline-gear-btn.png") , for: UIControlState())
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
        
        timelineSingleTapRecognizer.require(toFail: timelineDoubleTapRecognizer) 
        
        //
        
        gearImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        gearImgView.contentMode = UIViewContentMode.scaleAspectFill
        gearImgView.image = UIImage(named: "purple200.png")
        contentView.addSubview(gearImgView)
        gearImgView.layer.masksToBounds = true
        gearImgView.isUserInteractionEnabled = true
        
        gearBrandLbl.backgroundColor = UIColor.clear
        gearBrandLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 16)
        gearBrandLbl.textColor = UIColor.gray
        gearBrandLbl.textAlignment = .left
        contentView.addSubview(gearBrandLbl)
        
        gearNameLbl.backgroundColor = UIColor.clear
        gearNameLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 16)
        gearNameLbl.textColor = UIColor.white
        gearNameLbl.textAlignment = .left
        contentView.addSubview(gearNameLbl)
        gearNameLbl.textAlignment = .left
        gearNameLbl.lineBreakMode = .byWordWrapping
        gearNameLbl.numberOfLines = 0
        
        gearAddBtn.backgroundColor = UIColor.orange
        gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear.png") , for: UIControlState())
        //gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear-selected.png") , forState: UIControlState.Selected)
        gearAddBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , for: UIControlState.selected)
        contentView.addSubview(gearAddBtn)
        
        gearSingleTapRecognizer.numberOfTapsRequired = 1
        gearImgView.addGestureRecognizer(gearSingleTapRecognizer)

        gearDoubleTapRecognizer.numberOfTapsRequired = 2
        gearImgView.addGestureRecognizer(gearDoubleTapRecognizer)
        
        gearSingleTapRecognizer.require(toFail: gearDoubleTapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
    }

    
    
}
