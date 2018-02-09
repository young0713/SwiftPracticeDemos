//
//  SnapChatCameraViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/31.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SnapChatCameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    private let timerInternal : CGFloat = 0.05
    private let videoMaxLength : CGFloat = 10.0
    private let progressWidth : CGFloat = 5.0
    private let buttonWH : CGFloat = 100.0
    
    private lazy var captureSession : AVCaptureSession = AVCaptureSession()
    
    private lazy var deviceInput : AVCaptureInput? = {
        
        let device : AVCaptureDevice? = AVCaptureDevice.default(for: AVMediaType.video)
        
        if device == nil {
            return nil
        }

        do {
            
            let input = try AVCaptureDeviceInput.init(device: device!)
            return input
        } catch {
            return nil
        }
    }()
    
    private lazy var deviceOutput : AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    
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
    
    private var videoPath : String?
    private var timer : Timer?
    
    private var currentRecordTime : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        startScan()
        initSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    private func initSubViews() {
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
        
        
        let cancelBtn = UIButton.init(type: UIButtonType.custom)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        cancelBtn.addTarget(self, action: #selector(onCancelBtnAction), for: UIControlEvents.touchUpInside)
        cancelBtn.frame = CGRect(x: 20, y: 20, width: 60, height: 40)
        view.addSubview(cancelBtn)
    }
    
    @objc private func onCancelBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateProgress(progress : CGFloat) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = progress
        CATransaction.commit()
    }
    
    private func startScan(){
        
        if deviceInput == nil {
            return
        }
        
        if !captureSession.canAddInput(deviceInput!) {
            return
        }
        
        if !captureSession.canAddOutput(deviceOutput) {
            return
        }
        
        captureSession.beginConfiguration()
        
        captureSession.addInput(deviceInput!)
        captureSession.addOutput(deviceOutput)
        view.layer.insertSublayer(previewLayer, at: 0)
        captureSession.commitConfiguration()
        
        captureSession.startRunning()
    }
    
    @objc func onStartRecordVideo() -> Void{
        // start record
        recordBtn.setTitleColor(UIColor.gray, for: UIControlState.normal)
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerInternal), target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        }
        
        self.timer?.fireDate = Date.distantPast
        
        playerStartRecord()
    }
    
    @objc func onStopRecordVideo() -> Void{
        // stop record
        recordBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        
        self.timer?.fireDate = Date.distantFuture
        currentRecordTime = 0.0
        updateProgress(progress: 0.0)
        
        playerStopRecord()
    }
    
    private func playerStartRecord() {
        
        let documentPath : String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let timeInterval = Date.init().timeIntervalSince1970
        videoPath = documentPath.appending(String(format:"/%.0f.mp4", timeInterval))
        
        if FileManager.default.fileExists(atPath: videoPath!) {
            do { try FileManager.default.removeItem(atPath: videoPath!)
            } catch { }
        }
        FileManager.default.createFile(atPath: videoPath!, contents: nil, attributes: nil)

        deviceOutput.startRecording(to: URL.init(fileURLWithPath: videoPath!), recordingDelegate: self)
    }
    
    private func playerStopRecord() {
        deviceOutput.stopRecording()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        let alertVc = UIAlertController.init(title: "提示", message: "视频录制成功，是否播放？", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (cancelAction : UIAlertAction) in
            
        }
        
        weak var weakSelf = self
        let certainAction = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { (certainAction : UIAlertAction) in
            weakSelf?.showRecordedVideo()
        }
        
        alertVc.addAction(cancelAction)
        alertVc.addAction(certainAction)
        
        self.present(alertVc, animated: true, completion: nil)
    }
    
    private func showRecordedVideo() {
        let playerVc = AVPlayerViewController.init()
        let videoUrl = NSURL.fileURL(withPath: self.videoPath!)
        playerVc.player = AVPlayer.init(url: videoUrl)
        playerVc.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
        playerVc.player?.play()
        
        self.present(playerVc, animated: true, completion: nil)
    }
    
    @objc func countDown() -> Void{
        
        currentRecordTime += timerInternal
        updateProgress(progress: currentRecordTime / videoMaxLength)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("SnapChatCameraViewController deinit")
    }
}
