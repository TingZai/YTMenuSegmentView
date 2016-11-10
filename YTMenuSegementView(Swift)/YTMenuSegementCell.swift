//
//  YTMenuSegementCell.swift
//  MovieFansDemo1
//
//  Created by 余婷 on 16/10/10.
//  Copyright © 2016年 余婷. All rights reserved.
//

import UIKit

class YTMenuSegementCell: UICollectionViewCell {
    
    //MARK: - 子视图
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(self.frame.size.height)
        //切圆角
        self.selectedView.frame = self.bounds
        self.selectedView.layer.cornerRadius = self.selectedView.frame.size.height/2
    }
    

}
