//
//  DemoListViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/29.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit

class DemoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Demo"
        
        listTableView = UITableView.init(frame: view.bounds, style: UITableViewStyle.plain)
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.addSubview(listTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier = "listCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            let bottomLine = UIView.init()
            bottomLine.backgroundColor = UIColor.lightGray
            bottomLine.frame = CGRect(x: 0, y: 44, width: view.bounds.size.width, height: 1)
            cell?.addSubview(bottomLine)
        }
        
        cell?.textLabel?.text = itemShowTitleWithIndex(index: indexPath.row)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showVcWithIndex(index: indexPath.row)
    }
    
    func itemShowTitleWithIndex(index : NSInteger) -> String? {
        
        var title : String?
        
        switch index {
        case 0:
            title = "01、Stop Watch"
            break
        case 1:
            title = "02、Play Local Video"
            break
        case 2:
            title = "03、Snap Chat Menu"
            break
        default:
            break
        }
        
        return title
    }
    
    func showVcWithIndex(index : NSInteger) -> Void {
        
        var showVc : UIViewController!
        
        switch index {
        case 0:
            showVc = StopWatchViewController()
            navigationController?.pushViewController(showVc, animated: true)
            break
        case 1:
            showVc = PlayLocalVideoViewController()
            navigationController?.pushViewController(showVc, animated: true)
            break
        case 2:
            showVc = SnapChatMenuViewController()
            navigationController?.present(showVc, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}
