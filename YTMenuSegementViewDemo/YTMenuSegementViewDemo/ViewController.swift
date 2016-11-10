//
//  ViewController.swift
//  YTMenuSegementViewDemo
//
//  Created by 余婷 on 16/11/10.
//  Copyright © 2016年 余婷. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuView = YTMenuSegmentView.init(frame: CGRectMake(0, 20, self.view.bounds.width, 60))
        menuView.items = [("学校",["学校1","学校2","学校3","学校5","学校6","学校7"]),("城市",["城市1","城市2","城市3","城市4","城市5","城市6","城市7","城市8","城市9"]),("时间",["2010","2011","2012","2013","2014","2015","2016","2017","2018"])]
        self.view.addSubview(menuView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

