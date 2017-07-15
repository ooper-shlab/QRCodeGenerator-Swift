//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by OOPer in cooperation with shlab.jp, on 2015/5/6.
//  Copyright (c) 2015-2016 OOPer. All rights reserved. See LICENSE.txt .
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

    override func viewWillAppear(_ animated: Bool) {
        let text = UserDefaults.standard.string(forKey: "text")
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
        UserDefaults.standard.setValue(text, forKey: "text")
        UserDefaults.standard.synchronize()
        //
        ALAssetsLibrary().writeImage(toSavedPhotosAlbum: image?.cgImage, orientation: ALAssetOrientation.up, completionBlock: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func QRCodeImage(_ message: String, size: CGSize) -> UIImage? {
        let data: Data = message.data(using: String.Encoding.utf8)!
        let params = [
            "inputMessage": data,
            "inputCorrectionLevel": "H"
        ] as [String : Any]
        let qrEncoder = CIFilter(name: "CIQRCodeGenerator", withInputParameters: params)
        let ciImage: CIImage = qrEncoder!.outputImage!
        var image = UIImage(ciImage: ciImage)
        //
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        context!.interpolationQuality = .none//
        image.draw(in: CGRect(origin: CGPoint(), size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image
    }
}

