//
//  AddMomentView.swift
//  Phenom
//
//  Created by Isom Durm on 4/21/16.
//  Copyright © 2016 Phenom. All rights reserved.
//

import UIKit

class AddMomentView: UIView {

    var bg: UIImageView?
    var btn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        backgroundColor = UIColor.clear
        
        bg = UIImageView()
        bg!.backgroundColor = UIColor.clear
        bg!.image = UIImage(named: "add-moment-view-blue.png")
        self.addSubview(bg!)
        
        btn = UIButton.init(type: .custom)
        btn!.backgroundColor = UIColor.clear
        //btn!.addTarget(self, action:#selector(btn!Action), forControlEvents:.TouchUpInside)
        btn!.titleLabel?.font = UIFont.init(name: "MaisonNeue-Bold", size: 14)
        btn!.titleLabel?.numberOfLines = 1
        btn!.contentHorizontalAlignment = .center
        btn!.contentVerticalAlignment = .center
        btn!.titleLabel?.textAlignment = .center
        btn!.setTitleColor(UIColor.white, for: UIControlState())
        btn!.setTitleColor(UIColor.white, for: .highlighted)
        btn!.setTitle("ADD A MOMENT!", for: UIControlState())
        self.addSubview(btn!)
        btn!.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        bg!.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        btn!.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
    }

}
