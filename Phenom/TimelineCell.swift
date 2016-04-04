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
    var typeLbl = UILabel()
    
    var heartImgView = UIImageView()
    var commentImgView = UIImageView()
    var gearImgView = UIImageView()
    var gearLbl = UILabel()
    
    var heartImgViewSmall = UIImageView()
    var likesLbl = UILabel()
    
    var headerLbl = UILabel()

    var commentLbl = UILabel()
    
    var lineView1 = UIView()
    var lineView2 = UIView()
    var lineView3 = UIView()
    
    var doubleTapRecognizer = UITapGestureRecognizer()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.momentImgView.backgroundColor = UIColor.lightGrayColor()
        self.momentImgView.contentMode = UIViewContentMode.ScaleAspectFit //ScaleAspectFill
        self.momentImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.momentImgView)
        self.momentImgView.layer.masksToBounds = true
        
        self.musicLbl.backgroundColor = UIColor.clearColor()
        self.musicLbl.font = UIFont.systemFontOfSize(12)
        self.musicLbl.textColor = UIColor.whiteColor()
        self.musicLbl.textAlignment = NSTextAlignment.Left
        self.musicLbl.numberOfLines = 1
        self.musicLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.contentView.addSubview(self.musicLbl)
        
        self.typeLbl.backgroundColor = UIColor.clearColor()
        self.typeLbl.font = UIFont.systemFontOfSize(12)
        self.typeLbl.textColor = UIColor.whiteColor()
        self.typeLbl.textAlignment = NSTextAlignment.Center
        self.typeLbl.numberOfLines = 1
        self.typeLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(self.typeLbl)
        
        //
        
        self.heartImgView.backgroundColor = UIColor.redColor()
        self.heartImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.heartImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.heartImgView)
        self.heartImgView.layer.masksToBounds = true
        
        self.commentImgView.backgroundColor = UIColor.lightGrayColor()
        self.commentImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.commentImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.commentImgView)
        self.commentImgView.layer.masksToBounds = true
        
        self.gearImgView.backgroundColor = UIColor.lightGrayColor()
        self.gearImgView.contentMode = UIViewContentMode.ScaleAspectFill
        self.gearImgView.userInteractionEnabled = true
        self.contentView.addSubview(self.gearImgView)
        self.gearImgView.layer.masksToBounds = true

        self.gearLbl.backgroundColor = UIColor.whiteColor()
        self.gearLbl.font = UIFont.systemFontOfSize(12)
        self.gearLbl.textColor = UIColor.lightGrayColor()
        self.gearLbl.textAlignment = NSTextAlignment.Left
        self.gearLbl.numberOfLines = 1
        self.gearLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.contentView.addSubview(self.gearLbl)
        
        //
        
        self.heartImgViewSmall.backgroundColor = UIColor.lightGrayColor()
        self.heartImgViewSmall.contentMode = UIViewContentMode.ScaleAspectFill
        self.heartImgViewSmall.userInteractionEnabled = true
        self.contentView.addSubview(self.heartImgViewSmall)
        self.heartImgViewSmall.layer.masksToBounds = true
        
        self.likesLbl.backgroundColor = UIColor.clearColor()
        self.likesLbl.font = UIFont.systemFontOfSize(12)
        self.likesLbl.textColor = UIColor.whiteColor()
        self.likesLbl.textAlignment = NSTextAlignment.Left
        self.likesLbl.numberOfLines = 1
        self.likesLbl.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.contentView.addSubview(self.likesLbl)
        
        self.headerLbl.backgroundColor = UIColor.clearColor()
        self.headerLbl.font = UIFont.systemFontOfSize(17)
        self.headerLbl.textColor = UIColor.lightGrayColor()
        self.headerLbl.textAlignment = NSTextAlignment.Left
        self.headerLbl.numberOfLines = 0
        self.headerLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(self.headerLbl)
        
        //
        
        self.commentLbl.backgroundColor = UIColor.clearColor()
        self.commentLbl.font = UIFont.systemFontOfSize(12)
        self.commentLbl.textColor = UIColor.whiteColor()
        self.commentLbl.textAlignment = NSTextAlignment.Left
        self.commentLbl.numberOfLines = 1
        self.commentLbl.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(self.commentLbl)
        
        //
        
        self.lineView1.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        self.contentView.addSubview(self.lineView1)
        
        self.lineView2.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        self.contentView.addSubview(self.lineView2)
        
        self.lineView3.backgroundColor = UIColor.init(white: 0.3, alpha: 1.0)
        self.contentView.addSubview(self.lineView3)
        
        //
        
        self.doubleTapRecognizer.numberOfTapsRequired = 2
        self.momentImgView.addGestureRecognizer(self.doubleTapRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.momentImgView.frame = CGRectMake(0, 0, self.cellWidth, self.cellWidth)
        self.musicLbl.frame = CGRectMake(15, self.cellWidth-10-20-10-20, 200, 20)
        self.typeLbl.frame = CGRectMake(15, self.cellWidth-10-20, 200, 20)
        
        //
        
        self.heartImgView.frame = CGRectMake(15, self.cellWidth+3, 44, 44)
        self.commentImgView.frame = CGRectMake(15+44+15, self.cellWidth+3, 44, 44)
        self.gearImgView.frame = CGRectMake(self.cellWidth/2+15, self.cellWidth+3, 44, 44)
        self.gearLbl.frame = CGRectMake(self.cellWidth/2+15+44+5, self.cellWidth+3, 44, 44)
        
        //
        
        self.heartImgViewSmall.frame = CGRectMake(15, self.cellWidth+50+3, 22, 22)
        self.likesLbl.frame = CGRectMake(15+22+5, self.cellWidth+50+3, 200, 22)
        
        //
        
        self.headerLbl.frame = CGRectMake(15, self.cellWidth+50+3+22+3, self.cellWidth-15-15, 50)
        
        //
        
        self.commentLbl.frame = CGRectMake(15, self.cellWidth+50+80+3, self.cellWidth-20-20, 28)
        
        //
        
        self.lineView1.frame = CGRectMake((self.cellWidth/2)-0.20, self.cellWidth, 0.5, 50)
        
        self.lineView2.frame = CGRectMake(0, self.cellWidth+50, self.cellWidth, 0.5)
        
        self.lineView3.frame = CGRectMake(0, self.cellWidth+50+80, self.cellWidth, 0.5)
        
        
//        let font = UIFont.boldSystemFontOfSize(17)
//        let height = (UIApplication.sharedApplication().delegate as! AppDelegate).heightForView(self.headerLbl.text!, font: font, width: self.cellWidth-15-15)
//        
//        self.headerLbl.frame = CGRectMake(15, 200+15, self.cellWidth-15-15, height)
//        self.headerLbl.frame = CGRectMake(15, 200+15+height, self.cellWidth-15-15, 20)
//        
//        self.lineView.frame = CGRectMake(0, 129.5, self.cellWidth, 0.5)
        
        //
        
    }
    
    
}
