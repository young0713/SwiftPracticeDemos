//
//  DemoListViewController.swift
//  SwiftDemos
//
//  Created by wanzhaoyang on 2018/1/29.
//  Copyright © 2018年 ksyun. All rights reserved.
//

import UIKit

enum ShowType {
    case Push, Present
}

class DemoInfoModel: NSObject {
    var title : String!
    var className : String!
    var showType : ShowType!
    
    init(title:String, className:String, showType:ShowType) {
        self.title = title
        self.className = className
        self.showType = showType
    }
}

class DemoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var listTableView : UITableView!
    
    var dataSourceArray : Array<DemoInfoModel>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Demo"

        createDatasource()
        
        listTableView = UITableView.init(frame: view.bounds, style: UITableViewStyle.plain)
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        view.addSubview(listTableView)
    }
    
    private func createDatasource() {
        
        let demo1Info = DemoInfoModel(title: "01、Stop Watch", className: "StopWatchViewController", showType: ShowType.Push)
        dataSourceArray.append(demo1Info)
        
        let demo2Info = DemoInfoModel(title: "02、Play Local Video", className: "PlayLocalVideoViewController", showType: ShowType.Push)
        dataSourceArray.append(demo2Info)
        
        let demo3Info = DemoInfoModel(title: "03、Snap Chat Menu", className: "SnapChatMenuViewController", showType: ShowType.Present)
        dataSourceArray.append(demo3Info)
        
        let demo4Info = DemoInfoModel(title: "04、Banner", className: "BannerViewController", showType: ShowType.Push)
        dataSourceArray.append(demo4Info)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate && UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataSourceArray.count;
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
        
        if dataSourceArray.count > indexPath.row {
            let infoModel = dataSourceArray[indexPath.row]
            cell?.textLabel?.text = infoModel.title
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if dataSourceArray.count < indexPath.row {
            return;
        }
        
        let infoModel = dataSourceArray[indexPath.row]
        let className = infoModel.className
        if let aClass = NSClassFromString("SwiftDemos." + className!) {
            if let vcClass = aClass as? UIViewController.Type {
                let vc = vcClass.init()
                
                if infoModel.showType == ShowType.Push {
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    navigationController?.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}
