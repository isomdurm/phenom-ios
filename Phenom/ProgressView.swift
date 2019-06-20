//
//  ProgressView.swift
//  Phenom
//
//  Created by Isom Durm on 11/9/15.
//  Copyright © 2015 Phenom. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var bg: UIView?
    var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        backgroundColor = UIColor.clear
        
        bg = UIView()
        bg!.backgroundColor = UIColor.clear //UIColor.init(white: 0.0, alpha: 0.35)
        self.addSubview(bg!)
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray) //WhiteLarge
        self.addSubview(activityIndicator!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    override func layoutSubviews() {
        
        bg!.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        activityIndicator!.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
    }

}
