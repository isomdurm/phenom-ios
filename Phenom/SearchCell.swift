//
//  SearchCell.swift
//  Phenom
//
//  Created by Isom Durm on 3/31/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    var cellWidth = CGFloat()
    
    var peopleImgView = UIImageView()
    var peopleNameLbl = UILabel()
    var peopleUsernameLbl = UILabel()
    var peopleFollowBtn = UIButton(type: UIButtonType.custom)
    
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
        peopleImgView.contentMode = UIViewContentMode.scaleAspectFill
        peopleImgView.isUserInteractionEnabled = true
        contentView.addSubview(peopleImgView)
        peopleImgView.layer.masksToBounds = true
        
        peopleNameLbl.backgroundColor = UIColor.clear
        peopleNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        peopleNameLbl.textColor = UIColor.white
        peopleNameLbl.textAlignment = NSTextAlignment.left
        peopleNameLbl.numberOfLines = 1
        peopleNameLbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(peopleNameLbl)
        
        peopleUsernameLbl.backgroundColor = UIColor.clear
        peopleUsernameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        peopleUsernameLbl.textColor = UIColor.gray
        peopleUsernameLbl.textAlignment = NSTextAlignment.left
        peopleUsernameLbl.numberOfLines = 1
        peopleUsernameLbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        contentView.addSubview(peopleUsernameLbl)
        
        peopleFollowBtn.backgroundColor = UIColor.orange
        peopleFollowBtn.setBackgroundImage(UIImage.init(named: "notAddedBtnImg.png") , for: UIControlState())
        peopleFollowBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , for: UIControlState.selected)
        contentView.addSubview(peopleFollowBtn)
        
        // gear
        
        gearImgView.backgroundColor = UIColor.white //UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
        gearImgView.contentMode = UIViewContentMode.scaleAspectFill
        gearImgView.isUserInteractionEnabled = true
        contentView.addSubview(gearImgView)
        gearImgView.layer.masksToBounds = true
        
        gearNameLbl.backgroundColor = UIColor.clear
        gearNameLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        gearNameLbl.textColor = UIColor.white
        gearNameLbl.textAlignment = NSTextAlignment.left
        gearNameLbl.numberOfLines = 0
        gearNameLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentView.addSubview(gearNameLbl)
        
        gearBrandLbl.backgroundColor = UIColor.clear
        gearBrandLbl.font = UIFont.init(name: "MaisonNeue-Medium", size: 14)
        gearBrandLbl.textColor = UIColor.gray
        gearBrandLbl.textAlignment = NSTextAlignment.left
        gearBrandLbl.numberOfLines = 1
        gearBrandLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentView.addSubview(gearBrandLbl)
        
        gearAddBtn.backgroundColor = UIColor.orange
        gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear.png") , for: UIControlState())
        //gearAddBtn.setBackgroundImage(UIImage.init(named: "add-gear-selected.png") , forState: UIControlState.Selected)
        gearAddBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , for: UIControlState.selected)
        contentView.addSubview(gearAddBtn)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // people
        
        
        
        // gear
        
        
        
    }
    
   
    
}
