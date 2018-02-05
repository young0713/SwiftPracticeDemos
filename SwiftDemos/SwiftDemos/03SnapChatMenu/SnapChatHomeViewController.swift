//
//  SnapChatHomeViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/31.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit

class SnapChatHomeViewController: UIViewController {

    var contentImgView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.contentImgView = UIImageView.init(frame: self.view.bounds)
        self.contentImgView.image = UIImage.init(named: "left")
        self.view.addSubview(self.contentImgView)
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
