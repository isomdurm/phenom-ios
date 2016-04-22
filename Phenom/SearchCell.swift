//
//  SearchCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/31/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    var cellWidth = CGFloat()
    
    var peopleImgView = UIImageView()
    var peopleNameLbl = UILabel()
    var peopleUsernameLbl = UILabel()
    var peopleFollowBtn = UIButton(type: UIButtonType.Custom)
    
    var gearImgView = UIImageView()
    var gearNameLbl = UILabel()
    var gearBrandLbl = UILabel()
    var gearAddBtn = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // people
        
        peopleImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        peopleImgView.contentMode = UIViewContentMode.ScaleAspectFill
        peopleImgView.userInteractionEnabled = true
        contentView.addSubview(peopleImgView)
        peopleImgView.layer.masksToBounds = true
        
        peopleNameLbl.backgroundColor = UIColor.clearColor()
        peopleNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        peopleNameLbl.textColor = UIColor.whiteColor()
        peopleNameLbl.textAlignment = NSTextAlignment.Left
        peopleNameLbl.numberOfLines = 1
        peopleNameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(peopleNameLbl)
        
        peopleUsernameLbl.backgroundColor = UIColor.clearColor()
        peopleUsernameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        peopleUsernameLbl.textColor = UIColor.grayColor()
        peopleUsernameLbl.textAlignment = NSTextAlignment.Left
        peopleUsernameLbl.numberOfLines = 1
        peopleUsernameLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        contentView.addSubview(peopleUsernameLbl)
        
        peopleFollowBtn.backgroundColor = UIColor.orangeColor()
        peopleFollowBtn.setBackgroundImage(UIImage.init(named: "notAddedBtnImg.png") , forState: UIControlState.Normal)
        peopleFollowBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , forState: UIControlState.Selected)
        contentView.addSubview(peopleFollowBtn)
        
        // gear
        
        gearImgView.backgroundColor = UIColor.whiteColor() //UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        gearImgView.contentMode = UIViewContentMode.ScaleAspectFill
        gearImgView.userInteractionEnabled = true
        contentView.addSubview(gearImgView)
        gearImgView.layer.masksToBounds = true
        
        gearNameLbl.backgroundColor = UIColor.clearColor()
        gearNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        gearNameLbl.textColor = UIColor.whiteColor()
        gearNameLbl.textAlignment = NSTextAlignment.Left
        gearNameLbl.numberOfLines = 0
        gearNameLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentView.addSubview(gearNameLbl)
        
        gearBrandLbl.backgroundColor = UIColor.clearColor()
        gearBrandLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        gearBrandLbl.textColor = UIColor.grayColor()
        gearBrandLbl.textAlignment = NSTextAlignment.Left
        gearBrandLbl.numberOfLines = 1
        gearBrandLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        contentView.addSubview(gearBrandLbl)
        
        gearAddBtn.backgroundColor = UIColor.orangeColor()
        gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear.png") , forState: UIControlState.Normal)
        //gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear-selected.png") , forState: UIControlState.Selected)
        gearAddBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , forState: UIControlState.Selected)
        contentView.addSubview(gearAddBtn)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // people
        
        
        
        // gear
        
        
        
    }
    
   
    
}
