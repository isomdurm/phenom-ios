//
//  SearchCell.swift
//  Phenom
//
//  Created by Clay Zug on 3/31/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    var cellWidth = CGFloat()
    var cellString = String()
    var addBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addBtn = UIButton(type: UIButtonType.Custom)
        addBtn.backgroundColor = UIColor.clearColor()
        addBtn.setBackgroundImage(UIImage.init(named: "notAddedBtnImg.png") , forState: UIControlState.Normal)
        addBtn.setBackgroundImage(UIImage.init(named: "addedBtnImg.png") , forState: UIControlState.Selected)
        addBtn.addTarget(self, action:#selector(addBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        contentView.addSubview(addBtn)
        addBtn.selected = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        addBtn.frame = CGRectMake(cellWidth-46-16, 64/2-16, 46, 32)
        
    }
    
    func  addBtnAction() {
        
        if (addBtn.selected) {
            addBtn.selected = false
            
        } else {
            addBtn.selected = true
            
        }
        
        checkForUserWithName(cellString)
    }
    
    
    func checkForUserWithName(name:String) {
        
    }
}
