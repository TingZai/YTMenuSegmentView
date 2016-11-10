//
//  YTMenuSegmentButton.swift
//  MovieFansDemo1
//
//  Created by 余婷 on 16/10/10.
//  Copyright © 2016年 余婷. All rights reserved.
//

import UIKit

class YTMenuSegmentButton: UIView {
    
    //MARK: - 外部属性
    ///文字1
    var title = ""{
    
        didSet{
        
            self.textLabel.text = title
        }
    }
    ///文字2
    var subTitle = ""{
    
        didSet{
        
            self.subTextLabel.text = subTitle
        }
    }
    ///文字字体
    var fontSize:CGFloat = 14
    
    ///文字选中的颜色
    var selectedColor = UIColor.RGBColor(63, G: 225, B: 181, A: 1)
    
    
    ///按钮的选中状态
    var seleted = false{
    
        didSet{
            //改变文字颜色和图片的旋转角度
            if seleted {
                self.textLabel.textColor = selectedColor
                UIView.animateWithDuration(0.3, animations: { 
                    self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
            }else{
            
                self.textLabel.textColor = UIColor.blackColor()
                UIView.animateWithDuration(0.3, animations: {
                    self.imageView.transform = CGAffineTransformMakeRotation(0)
                })
            }
        }
    }
    
    
    //MARK: - 内部属性
    private var target:AnyObject? = nil
    private var action:Selector? = nil
    
    //MARK: - 声明子视图
    let textLabel = UILabel()
    let subTextLabel = UILabel()
    let imageView = UIImageView()
    //MARK: - 添加子视图
    override init(frame: CGRect) {
        super.init(frame: frame)
        //1.
        self.addSubview(textLabel)
        textLabel.font = UIFont.systemFontOfSize(self.fontSize)
        //2.
        self.addSubview(subTextLabel)
        subTextLabel.font = UIFont.systemFontOfSize(self.fontSize)
        subTextLabel.textAlignment = .Center
        subTextLabel.textColor = self.selectedColor
        //3.
        self.addSubview(imageView)
        imageView.image = UIImage.init(named: "rotation")
        
        //设置背景颜色
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK: - 点击事件
extension YTMenuSegmentButton{

    ///添加点击事件
    func addTarget(target:AnyObject,action:Selector) {
        
        self.target = target
        self.action = action
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //改变当前按钮的状态
        self.seleted = !self.seleted
        
        //将按钮点击事件传输
        if target != nil{
        
            self.target!.performSelector(self.action!, withObject: self)
        }
        
    }
}

//MARK: - 计算frame
extension YTMenuSegmentButton{

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let H = self.frame.size.height
        let W = self.frame.size.width
        
        //1.
        let textSize = ToolManager.calculateStringSize(self.title, maxW: 5000, maxH: 50, fontSize: self.fontSize)
        let textW = textSize.width
        let textH = H/2
        self.textLabel.frame = CGRectMake(0, 0, textW, textH)
        self.textLabel.center = CGPointMake(W/2, H/4)
        //2.
        self.subTextLabel.frame = CGRectMake(0, textH, W, H/2)
        //3.
        let imH:CGFloat = 6
        let imW:CGFloat = 10
        let imX = self.textLabel.frame.origin.x + textW + 2
        let imY = H/4 - imH/2
        self.imageView.frame = CGRectMake(imX, imY, imW, imH)
    }
}
