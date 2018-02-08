//
//  StopWatchViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/29.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController {

    var countDownLabel: UILabel!
    var resetButton : UIButton!
    var startButton : UIButton!
    var pauseButton : UIButton!
    var timer : Timer?
    var stopWatchTime : Double = 0.0
    let timerInternal = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Stop Watch"
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI
    func updateUI() -> Void {
        
        self.view.backgroundColor = UIColor.init(red: 15/255.0, green: 4/255.0, blue: 39/255.0, alpha: 1.0)
        
        let viewWidth : CGFloat = self.view.bounds.size.width
        let viewHeight : CGFloat = self.view.bounds.size.height
        
        let countDownTop : CGFloat = 150.0
        let countDownHeight : CGFloat = 60.0
        let countDownWidth : CGFloat = 100.0
        let countDownX : CGFloat = (CGFloat)((viewWidth - 100) * 0.5)
        
        countDownLabel = UILabel.init(frame: CGRect(x: countDownX, y: countDownTop, width: countDownWidth, height: countDownHeight))
        countDownLabel.font = UIFont.systemFont(ofSize: 50)
        countDownLabel.textAlignment = NSTextAlignment.center
        countDownLabel.textColor = UIColor.white
        countDownLabel.text = "0.0"
        view.addSubview(countDownLabel)
        
        startButton = UIButton.init(frame: CGRect(x: 0.0, y: countDownTop * 2 + countDownHeight, width: viewWidth * 0.5, height: viewHeight - countDownTop * 2 - countDownHeight))
        startButton.setTitle("开始", for: UIControlState.normal)
        startButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        startButton.backgroundColor = UIColor.init(red: 0/255.0, green: 156/255.0, blue: 255/255.0, alpha: 1.0)
        startButton.addTarget(self, action: #selector(onBtnAction), for: UIControlEvents.touchUpInside)
        view.addSubview(startButton)
        
        pauseButton = UIButton.init(frame: CGRect(x: viewWidth * 0.5, y: countDownTop * 2 + countDownHeight, width: viewWidth * 0.5, height: viewHeight - countDownTop * 2 - countDownHeight))
        pauseButton.setTitle("暂停", for: UIControlState.normal)
        pauseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        pauseButton.backgroundColor = UIColor.init(red: 52/255.0, green: 152/255.0, blue: 41/255.0, alpha: 1.0)
        pauseButton.addTarget(self, action: #selector(onBtnAction), for: UIControlEvents.touchUpInside)
        view.addSubview(pauseButton)
        
        resetButton = UIButton.init(frame: CGRect(x: viewWidth - 100.0, y: 80.0, width: 100.0, height: 60.0))
        resetButton.setTitle("Reset", for: UIControlState.normal)
        resetButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        resetButton.addTarget(self, action: #selector(onBtnAction), for: UIControlEvents.touchUpInside)
        view.addSubview(resetButton)
    }
    
    @objc func onBtnAction(sender : UIButton) -> Void {
        
        if sender == startButton {
            
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: timerInternal, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            }
            
            self.timer?.fireDate = Date.distantPast
            
        } else if sender == pauseButton {
            
            self.timer?.fireDate = Date.distantFuture
            
        } else if sender == resetButton {
            
            self.timer?.fireDate = Date.distantFuture
            stopWatchTime = 0.0
            updateShowTime()
            
        }
    }
    
    @objc func countDown() -> Void {
        stopWatchTime += timerInternal
        updateShowTime()
    }
    
    func updateShowTime() -> Void {
        countDownLabel.text = String(format:"%0.1f", arguments:[stopWatchTime])
    }
    
    deinit {
        print("********")
    }
}
