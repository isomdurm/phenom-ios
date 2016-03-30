//
//  ExploreCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/25/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    var textLbl: UILabel!
    var bgImgView: UIImageView!
    var userImgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgHeight = frame.size.height*2/3
        
        bgImgView = UIImageView()
        bgImgView.frame = CGRect(x: (frame.size.width/2)-(imgHeight/2)-3, y: -3, width: imgHeight+6, height: imgHeight+6)
        bgImgView.backgroundColor = UINavigationBar.appearance().tintColor
        bgImgView.contentMode = UIViewContentMode.ScaleAspectFill
        bgImgView.image = UIImage(named: "purple200.png")
        contentView.addSubview(bgImgView)
        bgImgView.layer.cornerRadius = (imgHeight+6)/2
        bgImgView.layer.masksToBounds = true
        bgImgView.hidden = true
        
        userImgView = UIImageView()
        userImgView.frame = CGRect(x: (frame.size.width/2)-(imgHeight/2), y: 0, width: imgHeight, height: imgHeight)
        userImgView.backgroundColor = UIColor.init(white: 0.75, alpha: 1.0)
        userImgView.contentMode = UIViewContentMode.ScaleAspectFill
        contentView.addSubview(userImgView)
        userImgView.layer.cornerRadius = imgHeight/2
        userImgView.layer.masksToBounds = true
        userImgView.alpha = 0.0
        userImgView.image = UIImage(named: "placeholder.png")
        
        textLbl = UILabel(frame: CGRect(x: 0, y: userImgView.frame.size.height, width: frame.size.width, height: frame.size.height/3-10))
        textLbl.font = UIFont.systemFontOfSize(12)
        textLbl.textColor = UIColor.init(white: 0.1, alpha: 1.0)
        textLbl.textAlignment = .Center
        contentView.addSubview(textLbl)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
