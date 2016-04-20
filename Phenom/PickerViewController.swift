//
//  PickerViewController.swift
//  Phenom
//
//  Created by Clay Zug on 4/18/16.
//  Copyright © 2016 Clay Zug. All rights reserved.
//

import UIKit
import DKImagePickerController
import ImagePicker

class PickerViewController: DKImagePickerController {

    //var pickerController = DKImagePickerController()
    //var asset: DKAsset?
    
//    var imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        navigationController?.navigationBarHidden = true
//        edgesForExtendedLayout = UIRectEdge.None
//        
//        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
//        view.backgroundColor = UIColor(red:23/255, green:23/255, blue:25/255, alpha:1)

        
//        Configuration.doneButtonTitle = "Finish"
//        Configuration.noImagesTitle = "Sorry! There are no images here!"
//        Configuration.cancelButtonTitle = "Cancelll"
//        
//        self.imageLimit = 1
//        
//        pickerController.assetType = .AllPhotos // assetType
//        pickerController.allowsLandscape = false // allowsLandscape
//        pickerController.allowMultipleTypes = false // allowMultipleType
//        //pickerController.sourceType = .Photo // sourceType // by hiding this - it shows the camera button as the first item
//        pickerController.singleSelect = true //singleSelect
//        // pickerController.showsEmptyAlbums = false
//        // pickerController.defaultAssetGroup = PHAssetCollectionSubtype.SmartAlbumFavorites
//        pickerController.showsCancelButton = true
//        // Clear all the selected assets if you used the picker controller as a single instance.
//        pickerController.defaultSelectedAssets = nil
//        //pickerController.defaultSelectedAssets = self.assets

        self.showsCancelButton = true
        self.maxSelectableCount = 1
        self.singleSelect = true
        
        self.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            print("didSelectAssets")
            //self.asset = assets[0]
            //print("self.asset: \(self.asset)")
            
            
            let asset = assets[0]
            
            
//            asset.fetchImageWithSize(CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width+110) , completeBlock: { (image, info) in
//                
//                dispatch_async(dispatch_get_main_queue(), { () in
//                    
//                    let vc = ComposeViewController()
//                    vc.passedImage = image!
//                    //self.navigationController?.pushViewController(vc, animated: true)
//                    self.pushViewController(vc, animated: true)
//                    
//                })
//                
//            })
//            
//            
            asset.fetchOriginalImage(true, completeBlock: { (image, info) in
                
                dispatch_async(dispatch_get_main_queue(), { () in
                    
                    let vc = ComposeViewController()
                    vc.passedImage = image!
                    //self.navigationController?.pushViewController(vc, animated: true)
                    self.pushViewController(vc, animated: true)
                    
                })
            })
            
//            asset.fetchAVAssetWithCompleteBlock { (avAsset) in
//                dispatch_async(dispatch_get_main_queue(), { () in
//                    
//                    
//                    //self.playVideo(avAsset!.URL)
//                })
//            }
            
            
//            let vc = ComposeViewController()
//            //vc.passedImage =
//            //self.navigationController?.pushViewController(vc, animated: true)
//            self.pushViewController(vc, animated: true)
        }
        
//        self.presentViewController(pickerController, animated: false) {}
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dismissPickerViewControllerAction(_:)), name:"DismissPickerViewControllerNotification" ,object: nil)
        
        
//        imagePickerController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
//        //imagePickerController.delegate = self
//        //self.presentViewController(imagePickerController, animated: false, completion: nil)
//        
//        imagePickerController.imageLimit = 1
//        Configuration.doneButtonTitle = "Finish"
//        Configuration.noImagesTitle = "Sorry! There are no images here!"
//        
//        self.view.addSubview(imagePickerController.view)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).tabbarvc?.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)
        
    }
    
//    func wrapperDidPress(images: [UIImage]) {
//        print("wrapperDidPress")
//        
//        
//    }
//    
//    func doneButtonDidPress(images: [UIImage]) {
//        print("doneButtonDidPress hit")
//        
//        
//    }
//    
//    func cancelButtonDidPress() {
//        
//        dismissViewControllerAnimated(true, completion: nil)
//        delegate?.cancelButtonDidPress()
//        
//    }
//    
//    
//    var imageAssets: [UIImage] {
//        
//        
//        //return ImagePicker.resolveAssets(imagePicker.stack.assets)
//        return ImagePicker.resolveAssets(self.stack.assets)
//        
//    }
    
    
    
    
    
    
    

}
