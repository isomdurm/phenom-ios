//
//  FSConstants.swift
//  Fusuma
//
//  Created by Yuta Akizuki on 2015/08/31.
//  Copyright © 2015年 ytakzk. All rights reserved.
//

import UIKit

// Extension
internal extension UIColor {
    
    class func hex (_ hexStr : NSString, alpha : CGFloat) -> UIColor {
        var hexStr = hexStr
        
        hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
//            print("invalid hex string", terminator: "")
            return UIColor.white
        }
    }
}

extension UIView {
    
    func addBottomBorder(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width:  frame.size.width, height: width)
        border.borderWidth = width
        layer.addSublayer(border)
    }

}
