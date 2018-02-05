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
    
    private let timerInternal : CGFloat = 0.05
    private let videoMaxLength : CGFloat = 10.0
    private let progressWidth : CGFloat = 5.0
    private let buttonWH : CGFloat = 100.0
    
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
    
    private lazy var recordBtn : UIButton = UIButton.init()
    
    private lazy var progressLayer : CAShapeLayer = {
        
        let progressLayer = CAShapeLayer.init()
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = progressWidth
        progressLayer.lineCap = kCALineCapRound
        let bezierPath = UIBezierPath.init(roundedRect:CGRect(x: progressWidth * 0.5, y: progressWidth * 0.5, width: buttonWH - progressWidth, height: buttonWH - progressWidth) , cornerRadius: buttonWH * 0.5 - progressWidth)
        progressLayer.path = bezierPath.cgPath
        
        return progressLayer;
    }()
    
    private var timer : Timer?
    
    private var currentRecordTime : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        startScan()
        addRecordBtn()
    }
    
    private func addRecordBtn() {
        recordBtn.setTitle("长按录制视频", for: UIControlState.normal)
        recordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        recordBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        
        recordBtn.frame = CGRect(x: (self.view.bounds.size.width - buttonWH) * 0.5, y: self.view.bounds.size.height - 150.0, width: buttonWH, height: buttonWH)
        recordBtn.backgroundColor = UIColor.init(red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 0.9)
        recordBtn.layer.cornerRadius = buttonWH * 0.5
        recordBtn.layer.masksToBounds = true
        recordBtn.addTarget(self, action: #selector(onStartRecordVideo), for: UIControlEvents.touchDown)
        recordBtn.addTarget(self, action: #selector(onStopRecordVideo), for: UIControlEvents.touchUpInside)
        recordBtn.addTarget(self, action: #selector(onStopRecordVideo), for: UIControlEvents.touchUpOutside)
        self.view.addSubview(recordBtn)
        
        recordBtn.layer.addSublayer(progressLayer)
        updateProgress(progress: 0)
    }
    
    private func updateProgress(progress : CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = progress
        CATransaction.commit()
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
    
    @objc func onStartRecordVideo() -> Void{
        // start record
        recordBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInternal), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
        
        self.timer?.fireDate = Date.distantPast
    }
    
    @objc func onStopRecordVideo() -> Void{
        // stop record
        recordBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        
        self.timer?.fireDate = Date.distantFuture
        currentRecordTime = 0.0
        updateProgress(progress: 0.0)
    }
    
    @objc func countDown() -> Void{
        
        currentRecordTime += timerInternal
        updateProgress(progress: currentRecordTime / videoMaxLength)
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
