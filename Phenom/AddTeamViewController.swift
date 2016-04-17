//
//  AddTeamViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/3/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit

class AddTeamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var navBarView = UIView()
    var teamNameField: UITextField = UITextField()
    var sportField: UITextField = UITextField()
    let sportData = ["Baseball", "Basketball", "Football", "Soccer", "Lacrosse", "Ice Hockey", "Softball", "Tennis", "Track & Field", "Volleyball", "Wrestling", "Swimming", "Cross Country", "Field Hockey", "Golf", "Rugby", "Cross Fit", "Skiing", "Snowboading", "Skateboarding", "Figure Skating", "Gymnastics"]
    
    var numberField: UITextField = UITextField()
    var firstNameField: UITextField = UITextField()
    var lastNameField: UITextField = UITextField()
    var positionField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge.None
        
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.Custom)
        xBtn.frame = CGRectMake(15, 20, 44, 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blueColor()
        xBtn.addTarget(self, action:#selector(xBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRectMake(0, 20, navBarView.frame.size.width, 44))
        titleLbl.textAlignment = NSTextAlignment.Center
        titleLbl.text = "ADD YOUR TEAM"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.whiteColor()
        navBarView.addSubview(titleLbl)
        
        let saveBtn = UIButton(type: .Custom)
        saveBtn.frame = CGRectMake(view.frame.size.width-44-15, 20, 44, 44)
        saveBtn.setImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        //saveBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        saveBtn.backgroundColor = UIColor.blueColor()
        saveBtn.addTarget(self, action:#selector(saveBtnAction), forControlEvents:UIControlEvents.TouchUpInside)
        navBarView.addSubview(saveBtn)
        
        teamNameField.frame = CGRectMake(20, 64, view.frame.size.width-40, 64)
        teamNameField.backgroundColor = UIColor.clearColor()
        teamNameField.delegate = self
        teamNameField.textColor = UIColor.whiteColor()
        teamNameField.attributedPlaceholder = NSAttributedString(string:"team name",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        teamNameField.keyboardType = .Default
        teamNameField.returnKeyType = .Next
        teamNameField.enablesReturnKeyAutomatically = true
        teamNameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        teamNameField.placeholder = "team name"
        teamNameField.autocapitalizationType = .Words
        teamNameField.tag = 0
        view.addSubview(teamNameField)
        teamNameField.text = ""
        
        sportField.frame = CGRectMake(20, 64+64, view.frame.size.width-40, 64)
        sportField.backgroundColor = UIColor.clearColor()
        sportField.delegate = self
        sportField.textColor = UIColor.whiteColor()
        sportField.attributedPlaceholder = NSAttributedString(string:"sport",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        sportField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        sportField.placeholder = "sport"
        sportField.addTarget(self, action: #selector(sportFieldEditing), forControlEvents: .EditingDidBegin)
        sportField.tag = 1
        view.addSubview(sportField)
        sportField.text = ""
        
        numberField.frame = CGRectMake(20, 64+64+64, view.frame.size.width-40, 64)
        numberField.backgroundColor = UIColor.clearColor()
        numberField.delegate = self
        numberField.textColor = UIColor.whiteColor()
        numberField.attributedPlaceholder = NSAttributedString(string:"your number",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        numberField.keyboardType = .NumberPad
        numberField.returnKeyType = .Next
        numberField.enablesReturnKeyAutomatically = true
        numberField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        numberField.placeholder = "your number"
        numberField.tag = 2
        view.addSubview(numberField)
        numberField.text = ""
        
        positionField.frame = CGRectMake(20, 64+64+64+64, view.frame.size.width-40, 64)
        positionField.backgroundColor = UIColor.clearColor()
        positionField.delegate = self
        positionField.textColor = UIColor.whiteColor()
        positionField.attributedPlaceholder = NSAttributedString(string:"your position",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        positionField.keyboardType = .Default
        positionField.returnKeyType = .Done
        positionField.enablesReturnKeyAutomatically = true
        positionField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        positionField.placeholder = "your position"
        positionField.autocapitalizationType = .Sentences
        positionField.tag = 3
        view.addSubview(positionField)
        positionField.text = ""
        
        
        
        let lineview = UIView()
        lineview.frame = CGRectMake(0, 64+63.5, view.frame.size.width, 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRectMake(0, 64+64+63.5, view.frame.size.width, 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2)
        
        let lineview3 = UIView()
        lineview3.frame = CGRectMake(0, 64+64+64+63.5, view.frame.size.width, 0.5)
        lineview3.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview3)
        
        let lineview4 = UIView()
        lineview4.frame = CGRectMake(0, 64+64+64+64+63.5, view.frame.size.width, 0.5)
        lineview4.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview4)
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        teamNameField.becomeFirstResponder()
        
    }
    
    
    func xBtnAction() {
        
        view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    // sportPicker
    
    func sportFieldEditing(sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        sender.inputView = pickerView
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sportData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sportData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportField.text = sportData[row]
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == teamNameField) {
            sportField.becomeFirstResponder()
        } else if (textField == sportField) {
            numberField.becomeFirstResponder()
        } else if (textField == numberField) {
            positionField.becomeFirstResponder()
        } else if (textField == positionField) {
            
        } else {
            
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == teamNameField) {
            
            let currentString: NSString = textField.text!
            if (currentString == "") {
                let space = " "
                if (string == space) {
                    return false
                }
            }
        } else {
            
            let space = " "
            if (string == space) {
                return false
            }
        }
        
        
        if (textField == teamNameField) {
            let maxLength = 100
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        } else {
            let maxLength = 50
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
            return newString.length <= maxLength
        }
        
    }
    
    
    
    func saveBtnAction() {
        
        
    }
}
