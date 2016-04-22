//
//  AddMomentView.swift
//  Phenom
//
//  Created by Clay Zug on 4/21/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class AddMomentView: UIView {

    var bg: UIImageView?
    var btn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        backgroundColor = UIColor.clearColor()
        
        bg = UIImageView()
        bg!.backgroundColor = UIColor.clearColor()
        bg!.image = UIImage(named: "add-moment-view-blue.png")
        self.addSubview(bg!)
        
        btn = UIButton.init(type: .Custom)
        btn!.backgroundColor = UIColor.clearColor()
        //btn!.addTarget(self, action:#selector(btn!Action), forControlEvents:.TouchUpInside)
        btn!.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        btn!.titleLabel?.numberOfLines = 1
        btn!.contentHorizontalAlignment = .Center
        btn!.contentVerticalAlignment = .Center
        btn!.titleLabel?.textAlignment = .Center
        btn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn!.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        btn!.setTitle("ADD A MOMENT!", forState: .Normal)
        self.addSubview(btn!)
        btn!.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        bg!.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        btn!.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        
    }

}
