//
//  ProgressView.swift
//  Phenom
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
        backgroundColor = UIColor.clearColor()
        
        bg = UIView()
        bg!.backgroundColor = UIColor.clearColor() //UIColor.init(white: 0.0, alpha: 0.35)
        self.addSubview(bg!)
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray) //WhiteLarge
        self.addSubview(activityIndicator!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        bg!.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        activityIndicator!.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
    }

}
