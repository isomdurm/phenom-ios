//
//  PickMediaViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/20/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import DKImagePickerController
import ImagePicker

class PickMediaViewController: DKImagePickerController {
    
    //var pickerController = DKImagePickerController()
    //var asset: DKAsset?
    
    //    var imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assetType = .AllAssets
        self.sourceType = .Photo // sourceType // by hiding this - it shows the camera button as the first item
        
        self.showsCancelButton = true
        self.maxSelectableCount = 1
        self.singleSelect = true
        
        self.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            //self.asset = assets[0]
            //print("self.asset: \(self.asset)")
            
            let asset = assets[0]
            
            asset.fetchOriginalImage(true, completeBlock: { (image, info) in
                
                dispatch_async(dispatch_get_main_queue(), { () in
                    
                    //let vc = ComposeMViewController()
                    let vc = EditMediaViewController()
                    //vc.passedImage = image!
                    //self.navigationController?.pushViewController(vc, animated: true)
                    self.pushViewController(vc, animated: true)
                    
                })
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        self.defaultSelectedAssets = nil
        //self.selectedAssets.removeAllObjects()
        //
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
    }
    
    

}
