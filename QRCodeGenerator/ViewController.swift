//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by OOPer in cooperation with shlab.jp, on 2015/5/6.
//  Copyright (c) 2015-2017 OOPer. All rights reserved. See LICENSE.txt .
//

import UIKit
import Photos

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField.delegate = self
        requestPhotoLibraryAuthentication()
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
        PHPhotoLibrary.shared().performChanges({
            _ = PHAssetChangeRequest.creationRequestForAsset(from: image!)
        }, completionHandler: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func QRCodeImage(_ message: String, size: CGSize) -> UIImage? {
        let data: Data = message.data(using: .utf8)!
        let params = [
            "inputMessage": data,
            "inputCorrectionLevel": "H"
        ] as [String : Any]
        let qrEncoder = CIFilter(name: "CIQRCodeGenerator", parameters: params)
        let ciImage: CIImage = qrEncoder!.outputImage!
        var image = UIImage(ciImage: ciImage)
        //
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none//
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image
    }

    //### request for PhotoLibrary authentication (simplified)
    private func requestPhotoLibraryAuthentication() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization {status in
                //### For practical usage, show alert, update UI, guide to settings...
            }
        default:
            break
        }
    }
}

