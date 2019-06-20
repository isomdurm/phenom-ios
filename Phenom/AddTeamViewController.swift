//
//  AddTeamViewController.swift
//  Phenom
//
//  Created by Isom Durm on 4/3/16.
//  Copyright © 2016 Phenom. All rights reserved.
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
        
        navigationController?.isNavigationBarHidden = true
        edgesForExtendedLayout = UIRectEdge()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        
        navBarView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 64)
        navBarView.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)
        view.addSubview(navBarView)
        
        let xBtn = UIButton(type: UIButtonType.custom)
        xBtn.frame = CGRect(x: 15, y: 20, width: 44, height: 44)
        xBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //xBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        xBtn.backgroundColor = UIColor.blue
        xBtn.addTarget(self, action:#selector(xBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(xBtn)
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 20, width: navBarView.frame.size.width, height: 44))
        titleLbl.textAlignment = NSTextAlignment.center
        titleLbl.text = "ADD YOUR TEAM"
        titleLbl.font = UIFont.init(name: "MaisonNeue-Bold", size: 17)
        titleLbl.textColor = UIColor.white
        navBarView.addSubview(titleLbl)
        
        let saveBtn = UIButton(type: .custom)
        saveBtn.frame = CGRect(x: view.frame.size.width-44-15, y: 20, width: 44, height: 44)
        saveBtn.setImage(UIImage(named: "xbtn.png"), for: UIControlState())
        //saveBtn.setBackgroundImage(UIImage(named: "xbtn.png"), forState: UIControlState.Normal)
        saveBtn.backgroundColor = UIColor.blue
        saveBtn.addTarget(self, action:#selector(saveBtnAction), for:UIControlEvents.touchUpInside)
        navBarView.addSubview(saveBtn)
        
        teamNameField.frame = CGRect(x: 20, y: 64, width: view.frame.size.width-40, height: 64)
        teamNameField.backgroundColor = UIColor.clear
        teamNameField.delegate = self
        teamNameField.textColor = UIColor.white
        teamNameField.attributedPlaceholder = NSAttributedString(string:"team name",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        teamNameField.keyboardType = .default
        teamNameField.returnKeyType = .next
        teamNameField.enablesReturnKeyAutomatically = true
        teamNameField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        teamNameField.placeholder = "team name"
        teamNameField.autocapitalizationType = .words
        teamNameField.tag = 0
        view.addSubview(teamNameField)
        teamNameField.text = ""
        
        sportField.frame = CGRect(x: 20, y: 64+64, width: view.frame.size.width-40, height: 64)
        sportField.backgroundColor = UIColor.clear
        sportField.delegate = self
        sportField.textColor = UIColor.white
        sportField.attributedPlaceholder = NSAttributedString(string:"sport",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        sportField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        sportField.placeholder = "sport"
        sportField.addTarget(self, action: #selector(sportFieldEditing), for: .editingDidBegin)
        sportField.tag = 1
        view.addSubview(sportField)
        sportField.text = ""
        
        numberField.frame = CGRect(x: 20, y: 64+64+64, width: view.frame.size.width-40, height: 64)
        numberField.backgroundColor = UIColor.clear
        numberField.delegate = self
        numberField.textColor = UIColor.white
        numberField.attributedPlaceholder = NSAttributedString(string:"your number",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        numberField.keyboardType = .numberPad
        numberField.returnKeyType = .next
        numberField.enablesReturnKeyAutomatically = true
        numberField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        numberField.placeholder = "your number"
        numberField.tag = 2
        view.addSubview(numberField)
        numberField.text = ""
        
        positionField.frame = CGRect(x: 20, y: 64+64+64+64, width: view.frame.size.width-40, height: 64)
        positionField.backgroundColor = UIColor.clear
        positionField.delegate = self
        positionField.textColor = UIColor.white
        positionField.attributedPlaceholder = NSAttributedString(string:"your position",attributes:[NSForegroundColorAttributeName: UIColor(red:123/255, green:123/255, blue:125/255, alpha:1)])
        positionField.keyboardType = .default
        positionField.returnKeyType = .done
        positionField.enablesReturnKeyAutomatically = true
        positionField.font = UIFont.init(name: "MaisonNeue-Medium", size: 17)
        positionField.placeholder = "your position"
        positionField.autocapitalizationType = .sentences
        positionField.tag = 3
        view.addSubview(positionField)
        positionField.text = ""
        
        
        
        let lineview = UIView()
        lineview.frame = CGRect(x: 0, y: 64+63.5, width: view.frame.size.width, height: 0.5)
        lineview.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview)
        
        let lineview2 = UIView()
        lineview2.frame = CGRect(x: 0, y: 64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview2.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview2)
        
        let lineview3 = UIView()
        lineview3.frame = CGRect(x: 0, y: 64+64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview3.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview3)
        
        let lineview4 = UIView()
        lineview4.frame = CGRect(x: 0, y: 64+64+64+64+63.5, width: view.frame.size.width, height: 0.5)
        lineview4.backgroundColor = UIColor(red:48/255, green:48/255, blue:50/255, alpha:1)
        view.addSubview(lineview4)
    
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        teamNameField.becomeFirstResponder()
        
    }
    
    
    func xBtnAction() {
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }


    // sportPicker
    
    func sportFieldEditing(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        sender.inputView = pickerView
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sportData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sportData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportField.text = sportData[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
        } else {
            let maxLength = 50
            let currentString: NSString = textField.text!
            let newString: NSString = currentString.replacingCharacters(in: range, with: string)
            return newString.length <= maxLength
        }
        
    }
    
    
    
    func saveBtnAction() {
        
        
    }
}
