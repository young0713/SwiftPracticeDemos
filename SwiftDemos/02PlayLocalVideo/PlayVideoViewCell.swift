//
//  PlayVideoViewCell.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/30.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit
import AVFoundation

typealias PlayBtnBlock = () -> Void

class PlayVideoViewCell: UITableViewCell {

    var playBtn : UIButton!
    var videoScreenshotView : UIImageView!
    var videoNameLabel : UILabel!
    var playBtnBlock : PlayBtnBlock?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.red
        updateUI()
    }
    
    func updateUI() -> Void {
        
        videoScreenshotView = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: PlayVideoViewCell.cellWidth(), height: PlayVideoViewCell.cellHeight()))
        videoScreenshotView.backgroundColor = UIColor.black
        addSubview(videoScreenshotView)
       
        let playBtnW : CGFloat = 80.0
        let playBtnH : CGFloat = 40.0
        let playBtnX = (PlayVideoViewCell.cellWidth() - playBtnW) * 0.5
        let playBtnY = (PlayVideoViewCell.cellHeight() - playBtnH) * 0.5
        playBtn = UIButton.init(frame: CGRect(x: playBtnX, y: playBtnY, width: playBtnW, height: playBtnH))
        playBtn.setTitle("播放", for: UIControlState.normal)
        playBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        playBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        playBtn.addTarget(self, action: #selector(onPlayBtnAction), for: UIControlEvents.touchUpInside)
        addSubview(playBtn)
        
        let videoNameW : CGFloat = PlayVideoViewCell.cellWidth() - 40.0
        let videoNameH : CGFloat = 30.0
        let videoNameX : CGFloat = 20.0
        let videoNameY = PlayVideoViewCell.cellHeight() - 40.0
        videoNameLabel = UILabel.init(frame: CGRect(x: videoNameX, y: videoNameY, width: videoNameW, height: videoNameH))
        videoNameLabel.textAlignment = NSTextAlignment.center
        videoNameLabel.font = UIFont.systemFont(ofSize: 12)
        videoNameLabel.text = "视频名称"
        videoNameLabel.textColor = UIColor.white
        addSubview(videoNameLabel)
    }
    
    @objc func onPlayBtnAction() -> Void {
        if playBtnBlock != nil {
            playBtnBlock!()
        }
    }
    
    func updateVideoResource(name : NSString?) -> Void {
        videoNameLabel.text = NSString.init(string: name!) as String;
        loadVideoImage(videoName: name)
    }
    
    func loadVideoImage(videoName:NSString?) -> Void {
    
        let path = Bundle.main.path(forResource: videoName! as String, ofType: nil)
        let videoURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVAsset.init(url: videoURL as URL)
        let generator = AVAssetImageGenerator.init(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time : CMTime = CMTimeMakeWithSeconds(0.0, 600)
        var actualTime : CMTime = CMTimeMake(0, 0)
        
        do {
            let cgImage : CGImage! = try generator.copyCGImage(at: time, actualTime: &actualTime)
            self.videoScreenshotView.image = UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print(error)
        }
    }
    
    static func cellHeight() -> CGFloat {
        return UIScreen.main.bounds.size.width * 9 / 16
    }
    
    static func cellWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}
