//
//  LightingTestController.swift
//  Color
//
//  Created by James Wang on 11/16/17.
//  Copyright © 2017 DanielW. All rights reserved.
//

/*import Foundation
import UIKit
import AVFoundation


class LightingTestController: UIViewController {
    
    @IBOutlet weak var lightView: LightingTestView!
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var videoCaptureOutput = AVCaptureVideoDataOutput()
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPreset640x480
        let devices = AVCaptureDevice.devices()
        
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                if (device as AnyObject).position == AVCaptureDevicePosition.back {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
    }
    
    func beginSession() {
        var screenHeight = self.view.frame.height
        var screenWidth = self.view.frame.width
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        
        videoCaptureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable:kCVPixelFormatType_32BGRA]
        
        videoCaptureOutput.alwaysDiscardsLateVideoFrames = true
        
        captureSession.addOutput(videoCaptureOutput)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = CGRect(0, 0, screenHeight, screenWidth)
        captureSession.startRunning()
        
        var startVideoBtn = UIButton(frame: CGRectMake(0, screenHeight/2, screenWidth, screenHeight/2))
        startVideoBtn.addTarget(self, action: "startVideo", for: UIControlEvents.touchUpInside)
        self.view.addSubview(startVideoBtn)
        
        var stopVideoBtn = UIButton(frame: CGRectMake(0, 0, screenWidth, screenHeight/2))
        stopVideoBtn.addTarget(self, action: "stopVideo", for: UIControlEvents.touchUpInside)
        self.view.addSubview(stopVideoBtn)
    }
}*/
