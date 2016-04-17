//
//  TimelineCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/24/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
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
        
        momentImgView.backgroundColor = UIColor.lightGrayColor()
        momentImgView.contentMode = .ScaleAspectFill //.ScaleAspectFit //
        momentImgView.userInteractionEnabled = true
        contentView.addSubview(momentImgView)
        momentImgView.layer.masksToBounds = true
        
        musicLbl.backgroundColor = UIColor.blueColor()
        musicLbl.font = UIFont.systemFontOfSize(12)
        musicLbl.textColor = UIColor.whiteColor()
        musicLbl.textAlignment = .Center
        musicLbl.numberOfLines = 1
        musicLbl.lineBreakMode = .ByTruncatingTail
        contentView.addSubview(musicLbl)
        
        modeLbl.backgroundColor = UIColor.grayColor()
        modeLbl.font = UIFont.systemFontOfSize(12)
        modeLbl.textColor = UIColor.whiteColor()
        modeLbl.textAlignment = .Center
        modeLbl.numberOfLines = 1
        modeLbl.lineBreakMode = .ByTruncatingTail
        contentView.addSubview(modeLbl)
        
        //
        
        heartImgView.backgroundColor = UIColor.redColor()
        heartImgView.contentMode = .ScaleAspectFill
        heartImgView.userInteractionEnabled = true
        contentView.addSubview(heartImgView)
        heartImgView.layer.masksToBounds = true
        
        commentBtn = UIButton(type: .Custom)
        commentBtn.backgroundColor = .whiteColor()
        contentView.addSubview(commentBtn)
        
        //
        
        gearImgView.backgroundColor = UIColor.lightGrayColor()
        gearImgView.contentMode = .ScaleAspectFill
        gearImgView.userInteractionEnabled = true
        contentView.addSubview(gearImgView)
        gearImgView.layer.masksToBounds = true

        gearLbl.backgroundColor = UIColor.whiteColor()
        gearLbl.font = UIFont.systemFontOfSize(12)
        gearLbl.textColor = UIColor.lightGrayColor()
        gearLbl.textAlignment = .Left
        gearLbl.numberOfLines = 1
        gearLbl.lineBreakMode = .ByTruncatingTail
        contentView.addSubview(gearLbl)
        
        gearBtn = UIButton(type: .Custom)
        gearBtn.backgroundColor = UIColor.clearColor()
        contentView.addSubview(gearBtn)
        
        //
        
        heartImgViewSmall.backgroundColor = UIColor.lightGrayColor()
        heartImgViewSmall.contentMode = .ScaleAspectFill
        heartImgViewSmall.userInteractionEnabled = true
        contentView.addSubview(heartImgViewSmall)
        heartImgViewSmall.layer.masksToBounds = true
        
        likesLbl.backgroundColor = UIColor.clearColor()
        likesLbl.font = UIFont.systemFontOfSize(12)
        likesLbl.textColor = UIColor.whiteColor()
        likesLbl.textAlignment = .Left
        likesLbl.numberOfLines = 1
        likesLbl.lineBreakMode = .ByTruncatingTail
        contentView.addSubview(likesLbl)
        
        likesBtn = UIButton(type: .Custom)
        likesBtn.backgroundColor = UIColor.clearColor()
        contentView.addSubview(likesBtn)
        
        //
        
        headerLbl.backgroundColor = UIColor.clearColor()
        headerLbl.font = UIFont.systemFontOfSize(17)
        headerLbl.textColor = UIColor.lightGrayColor()
        headerLbl.textAlignment = .Left
        headerLbl.numberOfLines = 0
        headerLbl.lineBreakMode = .ByWordWrapping
        contentView.addSubview(headerLbl)
        
        headerBtn = UIButton(type: .Custom)
        headerBtn.backgroundColor = .clearColor()
        contentView.addSubview(headerBtn)
        
        //
        
//        commentLbl.backgroundColor = UIColor.clearColor()
//        commentLbl.font = UIFont.systemFontOfSize(12)
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
        
        singleTapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        heartImgView.frame = CGRectMake(15, cellWidth+3, 44, 44)
        commentBtn.frame = CGRectMake(15+44+15, cellWidth+3, 44, 44)
        
        
        gearImgView.frame = CGRectMake(cellWidth/2+15, cellWidth+3, 44, 44)
        gearLbl.frame = CGRectMake(cellWidth/2+15+44+5, cellWidth+3, 44, 44)
        gearBtn.frame = CGRectMake(cellWidth/2+15, cellWidth+3, 88+5, 44)
        
        //
        
        heartImgViewSmall.frame = CGRectMake(15, cellWidth+50+3, 22, 22)
        likesLbl.frame = CGRectMake(15+22+5, cellWidth+50+3, 200, 22)
        likesBtn.frame = CGRectMake(15, cellWidth+50+3, 100, 22)
        
        //
        
        headerLbl.frame = CGRectMake(15, cellWidth+50+3+22+3, cellWidth-15-15, 50)
        headerBtn.frame = CGRectMake(15, cellWidth+50+3+22+3, cellWidth-15-15, 50)
        
        //
        
        //commentLbl.frame = CGRectMake(15, cellWidth+50+80+3, cellWidth-20-20, 28)
        
        //
        
        lineView1.frame = CGRectMake((cellWidth/2)-0.20, cellWidth, 0.5, 50)
        
        lineView2.frame = CGRectMake(0, cellWidth+50, cellWidth, 0.5)
        
        footerView.frame = CGRectMake(0, cellWidth+50+80, cellWidth, 35)
        
        
//        let font = UIFont.boldSystemFontOfSize(17)
//        let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(headerLbl.text!, font: font, width: cellWidth-15-15)
//        
//        headerLbl.frame = CGRectMake(15, 200+15, cellWidth-15-15, height)
//        headerLbl.frame = CGRectMake(15, 200+15+height, cellWidth-15-15, 20)
//        
//        lineView.frame = CGRectMake(0, 129.5, cellWidth, 0.5)
        
        //
        
    }
    
    
}
