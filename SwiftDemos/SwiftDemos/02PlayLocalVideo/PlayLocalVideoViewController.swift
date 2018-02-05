//
//  PlayLocalVideoViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/30.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit
import AVKit

class PlayLocalVideoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var videoListView : UITableView!
    var videoPathList : NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Video List"
        view.backgroundColor = UIColor.black
        
        videoListView = UITableView.init(frame: self.view.bounds, style: UITableViewStyle.plain)
        videoListView.separatorStyle = UITableViewCellSeparatorStyle.none
        videoListView.delegate = self
        videoListView.dataSource = self
        view.addSubview(videoListView)
        
        videoPathList = NSMutableArray.init()
        loadVideos()
    }
    
    func loadVideos() -> Void {
        let paths = Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: "")
        
        objc_sync_enter(videoPathList)
        videoPathList.addObjects(from: paths)
        objc_sync_exit(videoPathList)
        
        videoListView.reloadData()
    }
    
    // MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoPathList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PlayVideoCell"
        
        var videoCell : PlayVideoViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PlayVideoViewCell
        if videoCell == nil {
            videoCell = PlayVideoViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            videoCell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        
        if videoPathList.count > indexPath.row {
            let videoPath : NSString = videoPathList.object(at: indexPath.row) as! NSString
            let pathURL = NSURL.init(string: videoPath as String)
            let videoName : NSString? = pathURL?.lastPathComponent as NSString?
            
            videoCell?.updateVideoResource(name:videoName)
            
            weak var weakSelf = self
            videoCell?.playBtnBlock = {() in
                let playerVc = AVPlayerViewController.init()
                let videoUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: videoName! as String, ofType: nil)!)
                playerVc.player = AVPlayer.init(url: videoUrl)
                playerVc.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
                playerVc.player?.play()
                
                weakSelf?.present(playerVc, animated: true, completion: nil)
            }
        }
        
        return videoCell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlayVideoViewCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    deinit {
        print("********")
    }
}
