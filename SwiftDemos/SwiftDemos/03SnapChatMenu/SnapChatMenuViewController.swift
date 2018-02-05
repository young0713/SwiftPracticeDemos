//
//  SnapChatMenuViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/31.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit

class SnapChatMenuViewController: UIViewController {

    var menuScrollView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
        title = "Snap Chat"
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        menuScrollView = UIScrollView.init(frame: view.bounds)
        menuScrollView.isPagingEnabled = true
        menuScrollView.bounces = false
        view.addSubview(menuScrollView)
        
        let homeVc = SnapChatHomeViewController()
        let cameraVc = SnapChatCameraViewController()
        let storyVc = SnapChatStoryViewController()
        
        addChildViewController(homeVc)
        addChildViewController(cameraVc)
        addChildViewController(storyVc)
        
        homeVc.view.frame = view.bounds
        let cameraViewOrigin = CGPoint(x: view.bounds.size.width, y: 0.0)
        cameraVc.view.frame = CGRect(origin: cameraViewOrigin, size: view.bounds.size)
        let storyViewOrigin = CGPoint(x: view.bounds.size.width * 2, y: 0.0)
        storyVc.view.frame = CGRect(origin: storyViewOrigin, size: view.bounds.size)
        
        menuScrollView.addSubview(homeVc.view)
        menuScrollView.addSubview(cameraVc.view)
        menuScrollView.addSubview(storyVc.view)
        
        menuScrollView.contentSize = CGSize(width: view.bounds.size.width * 3, height: view.bounds.size.height)
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
