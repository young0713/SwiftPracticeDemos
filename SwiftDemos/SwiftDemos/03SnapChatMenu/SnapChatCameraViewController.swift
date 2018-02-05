//
//  SnapChatCameraViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/31.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit
import AVFoundation

class SnapChatCameraViewController: UIViewController, AVCaptureAudioDataOutputSampleBufferDelegate {
    
    private lazy var captureSession : AVCaptureSession = AVCaptureSession()
    
    private lazy var deviceInput : AVCaptureInput? = {
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            
            let input = try AVCaptureDeviceInput.init(device: device!)
            return input
        } catch {
            return nil
        }
    }()
    
    private lazy var deviceOutput : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    private lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        
        let layer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        layer.frame = self.view.bounds
        
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        startScan()
    }
    
    private func startScan(){
        
        if !captureSession.canAddInput(deviceInput!) {
            return
        }
        
        if !captureSession.canAddOutput(deviceOutput) {
            return
        }
        
        captureSession.addInput(deviceInput!)
        captureSession.addOutput(deviceOutput)
        deviceOutput.metadataObjectTypes = deviceOutput.availableMetadataObjectTypes
        deviceOutput.setMetadataObjectsDelegate(self as? AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
        view.layer.insertSublayer(previewLayer, at: 0)
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SnapChatCameraViewController Will Appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
