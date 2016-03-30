//
//  ProgressView.swift
//  Breakfast
//
//  Created by Clay Zug on 11/9/15.
//  Copyright © 2015 Clay Zug. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var bg: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor.clearColor()
        
        self.bg = UIView()
        self.bg!.backgroundColor = UIColor.clearColor() //UIColor.init(white: 0.0, alpha: 0.35)
        self.addSubview(self.bg!)
        
        self.activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray) //WhiteLarge
        self.addSubview(self.activityIndicator!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        self.bg!.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.activityIndicator!.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
    }

}
