//
//  CaptureViewController.swift
//  morement
//
//  Created by Cuong Pham on 7/4/15.
//  Copyright © 2015 morement.vn. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    
    @IBAction func closeButtonTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func choosePhotoFromLib(){
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    func uploadImage(title: String, caption: String, user: String, path: [String], latlng: [String]){   
    }

    @IBAction func capturePhoto(){
        showCamare()
    }
    
    func showCamare(){
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        }else{
            noCamera()
        }
    }
    
    func noCamera(){
        let AlertVC: UIAlertController = UIAlertController(title: "No Camera", message: "Sorry, This device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        AlertVC.addAction(okAction)
        presentViewController(AlertVC, animated: true, completion: nil)

    }
    
    // If we find a device we'll store it here for later use

    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
     
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imagePicker.contentMode = .ScaleAspectFit //3
        imagePicker.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// :param: string       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
