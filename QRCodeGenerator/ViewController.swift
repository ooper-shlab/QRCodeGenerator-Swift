//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by OOPer in cooperation with shlab.jp, on 2015/5/6.
//  Copyright (c) 2015 OOPer. All rights reserved. See LICENSE.txt .
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        let text = NSUserDefaults.standardUserDefaults().stringForKey("text")
            ?? "http://oopers.com"
        textField.text = text
        let size = imageView.frame.size
        let image = QRCodeImage(text, size: size)
        imageView.image = image
    }
    
    @IBAction func updateAndSave(_: AnyObject) {
        let text = textField.text ?? ""
        let size = imageView.frame.size
        let image = QRCodeImage(text, size: size)
        imageView.image = image
        //
        NSUserDefaults.standardUserDefaults().setValue(text, forKey: "text")
        NSUserDefaults.standardUserDefaults().synchronize()
        //
        ALAssetsLibrary().writeImageToSavedPhotosAlbum(image?.CGImage, orientation: ALAssetOrientation.Up, completionBlock: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func QRCodeImage(message: String, size: CGSize) -> UIImage? {
        let data: NSData = message.dataUsingEncoding(NSUTF8StringEncoding)!
        let params = [
            "inputMessage": data,
            "inputCorrectionLevel": "H"
        ]
        let qrEncoder = CIFilter(name: "CIQRCodeGenerator", withInputParameters: params)
        let ciImage: CIImage = qrEncoder!.outputImage!
        var image = UIImage(CIImage: ciImage)
        //
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.None)//
        image.drawInRect(CGRect(origin: CGPoint(), size: size))
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }
}

