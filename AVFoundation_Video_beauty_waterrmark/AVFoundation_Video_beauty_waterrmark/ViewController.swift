//
//  ViewController.swift
//  AVFoundation_Video_beauty_waterrmark
//
//  Created by 刘健 on 2017/2/9.
//  Copyright © 2017年 刘健. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , AVCaptureVideoDataOutputSampleBufferDelegate{

    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestAccessForVideo()
    }
    
    func initialSession() {
        session = AVCaptureSession.init()
        let video = getVideoDevice(type: .back)
        do {
            let videoInput = try AVCaptureDeviceInput.init(device: video)
            if (session?.canAddInput(videoInput))! {
                session?.addInput(videoInput)
            }
            
            let videoQueue = DispatchQueue.init(label: "VideoQueue")
            let videoOutput = AVCaptureVideoDataOutput.init()
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            videoOutput.videoSettings = [String(kCVPixelBufferPixelFormatTypeKey):kCVPixelFormatType_32BGRA]
            
            if (session?.canAddOutput(videoOutput))! {
                session?.addOutput(videoOutput)
            }
            
            previewLayer =  AVCaptureVideoPreviewLayer.init(session: session)
            previewLayer?.frame = UIScreen.main.bounds
            self.view.layer.insertSublayer(previewLayer!, at: 0)
            session?.startRunning()
            
            
        } catch {
            
        }
    }
    
    func getVideoDevice(type: AVCaptureDevicePosition) -> (AVCaptureDevice?){
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)

        for device in devices! {
            let dev = device as? AVCaptureDevice
            if dev?.position == AVCaptureDevicePosition.back {
                 return dev
            }
        }
        return nil
    }
    
    
    func requestAccessForVideo() {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch status {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.initialSession()
                    }
                }
            })
            break
        case .authorized:
            DispatchQueue.main.async {
                self.initialSession()
            }
            break
        case .denied:
            break
        case .restricted:
            break
        default: break
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        print("收到视频数据")
    }

}

