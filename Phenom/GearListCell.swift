//
//  GearListCell.swift
//  Phenom
//
//  Created by Isom Durm on 4/11/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        
        gearImgView.backgroundColor = UIColor.white // UIColor(red:33/255, green:33/255, blue:35/255, alpha:1)
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
        
        gearImgView.frame = CGRect(x: 15, y: 15, width: 100, height: 100)
        
        let padding = CGFloat(10)
        
        let height = (UIApplication.shared.delegate as! AppDelegate).heightForView(gearNameLbl.text!, font: gearNameLbl.font, width: cellWidth-15-100-15-15)+padding
        
        gearNameLbl.frame = CGRect(x: 15+100+15, y: 15, width: cellWidth-15-100-15-15, height: height)
        gearBrandLbl.frame = CGRect(x: 15+100+15, y: 15+height, width: cellWidth-15-100-15-15, height: 20)
        
        gearAddBtn.frame = CGRect(x: cellWidth-65-15, y: 130-38-15, width: 65, height: 38)
        
        
    }
    
    

}
