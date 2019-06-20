//
//  TimelineCell.swift
//  Phenom
//
//  Created by Isom Durm on 3/24/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    
    var cellWidth = CGFloat()

    var momentImgView = UIImageView()
    var musicLbl = UILabel()
    var modeLbl = UILabel()
    
    var heartImgView = UIImageView()
    var commentBtn = UIButton()
    
    var gearImgView = UIImageView()
    var gearLbl = UILabel()
    var gearBtn = UIButton()
    
    var heartImgViewSmall = UIImageView()
    var likesLbl = UILabel()
    var likesBtn = UIButton()
    
    var headerLbl = UILabel()
    var headerBtn = UIButton()

    var commentLbl = UILabel()
    
    var lineView1 = UIView()
    var lineView2 = UIView()
    var footerView = UIView()
    
    var singleTapRecognizer = UITapGestureRecognizer()
    var doubleTapRecognizer = UITapGestureRecognizer()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        momentImgView.backgroundColor = UIColor.lightGray
        momentImgView.contentMode = .scaleAspectFill //.ScaleAspectFit //
        momentImgView.isUserInteractionEnabled = true
        contentView.addSubview(momentImgView)
        momentImgView.layer.masksToBounds = true
        
        musicLbl.backgroundColor = UIColor.blue
        musicLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        musicLbl.textColor = UIColor.white
        musicLbl.textAlignment = .center
        musicLbl.numberOfLines = 1
        musicLbl.lineBreakMode = .byTruncatingTail
        contentView.addSubview(musicLbl)
        
        modeLbl.backgroundColor = UIColor.gray
        modeLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        modeLbl.textColor = UIColor.white
        modeLbl.textAlignment = .center
        modeLbl.numberOfLines = 1
        modeLbl.lineBreakMode = .byTruncatingTail
        contentView.addSubview(modeLbl)
        
        //
        
        heartImgView.backgroundColor = UIColor.red
        heartImgView.contentMode = .scaleAspectFill
        heartImgView.isUserInteractionEnabled = true
        contentView.addSubview(heartImgView)
        heartImgView.layer.masksToBounds = true
        
        commentBtn = UIButton(type: .custom)
        commentBtn.backgroundColor = .white
        contentView.addSubview(commentBtn)
        
        //
        
        gearImgView.backgroundColor = UIColor.lightGray
        gearImgView.contentMode = .scaleAspectFill
        gearImgView.isUserInteractionEnabled = true
        contentView.addSubview(gearImgView)
        gearImgView.layer.masksToBounds = true

        gearLbl.backgroundColor = UIColor.white
        gearLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        gearLbl.textColor = UIColor.lightGray
        gearLbl.textAlignment = .left
        gearLbl.numberOfLines = 1
        gearLbl.lineBreakMode = .byTruncatingTail
        contentView.addSubview(gearLbl)
        
        gearBtn = UIButton(type: .custom)
        gearBtn.backgroundColor = UIColor.clear
        contentView.addSubview(gearBtn)
        
        //
        
        heartImgViewSmall.backgroundColor = UIColor.lightGray
        heartImgViewSmall.contentMode = .scaleAspectFill
        heartImgViewSmall.isUserInteractionEnabled = true
        contentView.addSubview(heartImgViewSmall)
        heartImgViewSmall.layer.masksToBounds = true
        
        likesLbl.backgroundColor = UIColor.clear
        likesLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
        likesLbl.textColor = UIColor.white
        likesLbl.textAlignment = .left
        likesLbl.numberOfLines = 1
        likesLbl.lineBreakMode = .byTruncatingTail
        contentView.addSubview(likesLbl)
        
        likesBtn = UIButton(type: .custom)
        likesBtn.backgroundColor = UIColor.clear
        contentView.addSubview(likesBtn)
        
        //
        
        headerLbl.backgroundColor = UIColor.clear
        headerLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        headerLbl.textColor = UIColor.lightGray
        headerLbl.textAlignment = .left
        headerLbl.numberOfLines = 0
        headerLbl.lineBreakMode = .byWordWrapping
        contentView.addSubview(headerLbl)
        
        headerBtn = UIButton(type: .custom)
        headerBtn.backgroundColor = .clear
        contentView.addSubview(headerBtn)
        
        //
        
//        commentLbl.backgroundColor = UIColor.clearColor()
//        commentLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 12)
//        commentLbl.textColor = UIColor.whiteColor()
//        commentLbl.textAlignment = NSTextAlignment.Left
//        commentLbl.numberOfLines = 1
//        commentLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
//        contentView.addSubview(commentLbl)
        
        //
        
        lineView1.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        contentView.addSubview(lineView1)
        
        lineView2.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        contentView.addSubview(lineView2)
        
        footerView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        contentView.addSubview(footerView)
        
        //
        
        singleTapRecognizer.numberOfTapsRequired = 1
        momentImgView.addGestureRecognizer(singleTapRecognizer)
        
        doubleTapRecognizer.numberOfTapsRequired = 2
        momentImgView.addGestureRecognizer(doubleTapRecognizer)
        
        singleTapRecognizer.require(toFail: doubleTapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        heartImgView.frame = CGRect(x: 15, y: cellWidth+3, width: 44, height: 44)
        commentBtn.frame = CGRect(x: 15+44+15, y: cellWidth+3, width: 44, height: 44)
        
        
        gearImgView.frame = CGRect(x: cellWidth/2+15, y: cellWidth+3, width: 44, height: 44)
        gearLbl.frame = CGRect(x: cellWidth/2+15+44+5, y: cellWidth+3, width: 44, height: 44)
        gearBtn.frame = CGRect(x: cellWidth/2+15, y: cellWidth+3, width: 88+5, height: 44)
        
        //
        
        heartImgViewSmall.frame = CGRect(x: 15, y: cellWidth+50+3, width: 22, height: 22)
        likesLbl.frame = CGRect(x: 15+22+5, y: cellWidth+50+3, width: 200, height: 22)
        likesBtn.frame = CGRect(x: 15, y: cellWidth+50+3, width: 100, height: 22)
        
        //
        
        headerLbl.frame = CGRect(x: 15, y: cellWidth+50+3+22+3, width: cellWidth-15-15, height: 50)
        headerBtn.frame = CGRect(x: 15, y: cellWidth+50+3+22+3, width: cellWidth-15-15, height: 50)
        
        //
        
        //commentLbl.frame = CGRectMake(15, cellWidth+50+80+3, cellWidth-20-20, 28)
        
        //
        
        lineView1.frame = CGRect(x: (cellWidth/2)-0.20, y: cellWidth, width: 0.5, height: 50)
        
        lineView2.frame = CGRect(x: 0, y: cellWidth+50, width: cellWidth, height: 0.5)
        
        footerView.frame = CGRect(x: 0, y: cellWidth+50+80, width: cellWidth, height: 35)
        
        
//        let font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
//        let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(headerLbl.text!, font: font, width: cellWidth-15-15)
//        
//        headerLbl.frame = CGRectMake(15, 200+15, cellWidth-15-15, height)
//        headerLbl.frame = CGRectMake(15, 200+15+height, cellWidth-15-15, 20)
//        
//        lineView.frame = CGRectMake(0, 129.5, cellWidth, 0.5)
        
        //
        
    }
    
    
}
