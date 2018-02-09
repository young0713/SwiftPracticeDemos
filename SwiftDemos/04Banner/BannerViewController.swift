//
//  BannerViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/2/8.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit

class SSImageView: UIImageView {
    
    private var resUrl : String?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame:CGRect!, url:String?) {
        super.init(frame: frame)
        
        resUrl = url
        downloadRes()
    }
    
    private func downloadRes() {
        // currently not think about cache, just down and show
        
        if (resUrl != nil) {
            
            let downloadQueue = DispatchQueue(label: resUrl!)
            weak var weakSelf = self
            downloadQueue.async(execute: {
                
                let url = NSURL.init(string: self.resUrl!)
                
                do {
                    let image = try UIImage.init(data: Data.init(contentsOf: url! as URL))
                    
                    if (image != nil) {
                        DispatchQueue.main.async(execute: {
                            weakSelf?.image = image
                        })
                    }
                } catch {
                    
                }
            })
        }
    }
}

class BannerInfo: NSObject {
    var resUrl : String?
    var title : String?
    
    init(title:String?, resUrl:String?) {
        super.init()
        
        self.title = title
        self.resUrl = resUrl
    }
}

class BannerItemView: UIView {
    private var bannerInfo :BannerInfo?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, bannerInfo:BannerInfo?) {
        super.init(frame: frame)
        
        self.bannerInfo = bannerInfo
        initSubViews()
    }
    
    private func initSubViews() {
        let imageView = SSImageView.init(frame: self.bounds, url: self.bannerInfo?.resUrl)
        self.addSubview(imageView)
    }
}

class BannerView: UIScrollView {
    private var bannerListInfo : Array<BannerInfo> = []
    
    func updateBannerInfo(bannerList : Array<BannerInfo>) -> Void {
        
        removeAllSubViews()
        
        self.bannerListInfo = bannerList
        var index : CGFloat = 0.0
        let width = self.frame.size.width
        let height = self.frame.size.height
        for bannerInfo in bannerList {
            let itemFrame = CGRect(x: width * index, y: 0, width: width, height: height)
            let bannerItemView = BannerItemView.init(frame: itemFrame, bannerInfo: bannerInfo)
            self.addSubview(bannerItemView)
            index += 1.0
        }
        
        self.contentSize = CGSize(width: width * index, height: height)
        self.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    private func removeAllSubViews() {
        
    }
}

class BannerViewController: UIViewController {

    private var bannerView : BannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Banner"
        view.backgroundColor = UIColor.white
        
        bannerView = BannerView()
        view.addSubview(bannerView)
        
        let bannerWidth = view.bounds.size.width
        let bannerHeight = bannerWidth * 9 / 16
        bannerView.frame = CGRect(x: 0, y: 100, width: bannerWidth, height: bannerHeight)
        
        bannerView.updateBannerInfo(bannerList: createDatasource())
    }
    
    private func createDatasource() -> Array<BannerInfo>! {
        
        let banner0 = BannerInfo.init(title: "高山", resUrl: "http://f.hiphotos.baidu.com/image/pic/item/503d269759ee3d6db032f61b48166d224e4ade6e.jpg")
        let banner1 = BannerInfo.init(title: "美女", resUrl: "http://e.hiphotos.baidu.com/image/pic/item/d31b0ef41bd5ad6e81443fda8dcb39dbb6fd3c44.jpg")
        let banner2 = BannerInfo.init(title: "樱花", resUrl: "http://a.hiphotos.baidu.com/image/h%3D300/sign=5c0f1ed450b5c9ea7df305e3e538b622/cf1b9d16fdfaaf519b4aa960875494eef11f7a47.jpg")
        
        return [banner0, banner1, banner2]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
