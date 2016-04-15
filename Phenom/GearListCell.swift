//
//  GearListCell.swift
//  Phenom
//
//  Created by Clay Zug on 4/11/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class GearListCell: UITableViewCell {

    var cellWidth = CGFloat()
    var gearImgView = UIImageView()
    var gearNameLbl = UILabel()
    var gearBrandLbl = UILabel()
    var gearAddBtn = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        gearImgView.backgroundColor = UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
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
        
        gearImgView.frame = CGRectMake(15, 15, 100, 100)
        
        let padding = CGFloat(10)
        
        let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(gearNameLbl.text!, font: gearNameLbl.font, width: cellWidth-15-100-15-15)+padding
        
        gearNameLbl.frame = CGRectMake(15+100+15, 15, cellWidth-15-100-15-15, height)
        gearBrandLbl.frame = CGRectMake(15+100+15, 15+height, cellWidth-15-100-15-15, 20)
        
        gearAddBtn.frame = CGRect(x: cellWidth-65-15, y: 130-38-15, width: 65, height: 38)
        
        
    }
    
    

}
