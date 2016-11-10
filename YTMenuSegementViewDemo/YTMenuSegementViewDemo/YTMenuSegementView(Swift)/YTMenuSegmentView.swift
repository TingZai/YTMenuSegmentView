//
//  YTMenuSegmentView.swift
//  MovieFansDemo1
//
//  Created by 余婷 on 16/10/10.
//  Copyright © 2016年 余婷. All rights reserved.
//

import UIKit

let Screen_H = UIScreen.mainScreen().bounds.height
let Screen_W = UIScreen.mainScreen().bounds.width

///MARK: - 菜单分段选择器协议
protocol YTMenuSegmentViewDelegate{

    func YTMenuSegment(segment:YTMenuSegmentView,seleteItemIndex:[Int])
}

//1.声明所有的子视图
//2.在构造方法中添加子视图
//3.在layoutSubviews中计算frame

class YTMenuSegmentView: UIView {
    
    let sc = UIScreen.mainScreen().bounds.width
    //MARK: - 外部属性
    ///代理属性
    var delegate:YTMenuSegmentViewDelegate? = nil
    ///分段选择器的高度
    var segementHeaderHeight:CGFloat = 50
    ///内容视图的高度
    var contentHeight:CGFloat = 150
    
    ///每个分组被选中的下标对应的数组
    lazy var indexArray:[Int] = {
    
        return [Int]()
    }()
    
    ///分段内容
    var items:[(String,[String])]? = nil{
    
        //MARK: - 创建按钮
        //当给items属性赋值的时候，去创建对应的按钮
        didSet{
        
            for (i,item) in items!.enumerate(){
                //1.设置分组选中的下标
                self.indexArray.append(0)
                
                //2.创建按钮
                let button = YTMenuSegmentButton()
                button.title = item.0
                button.subTitle = "全部"
                self.topView.addSubview(button)
                //设置边框
                button.layer.borderColor = UIColor.RGBColor(227, G: 227, B: 227, A: 0.6).CGColor
                button.layer.borderWidth = 1
                //添加点击事件
                button.addTarget(self, action: "buttonAction:")
                //设置tag值
                button.tag = i+100
                
            }
        }
    }
    
    ///选中下标
    var seletedIndex = -1{
    
        didSet{
    
            self.setNeedsLayout()
        }
    }   //-1代表一个都没有选中
    
    
    //MARK: - 第一步，声明子视图
    //1.上面的部分
    let topView  = UIView()
    
    //2.下面的部分
    var bottomCollectionView:UICollectionView? = nil
    var bottomView = UIView()
    
    //3.中间的线
    
    
    //MAKR: - 第二部，添加子视图
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //2.下面的部分
        //a.
        self.addSubview(self.bottomView)
        bottomView.clipsToBounds = true
        //b.
        let layout = UICollectionViewFlowLayout()
        bottomCollectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: layout)
        self.bottomView.addSubview(bottomCollectionView!)
        self.bottomCollectionView?.backgroundColor = UIColor.whiteColor()
        //设置代理
        bottomCollectionView?.delegate = self
        bottomCollectionView?.dataSource = self
        //注册cell
        bottomCollectionView?.registerNib(UINib.init(nibName: "YTMenuSegementCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        bottomCollectionView?.autoresizesSubviews = false
        self.bottomCollectionView?.scrollEnabled = false
        bottomCollectionView?.clipsToBounds = true
        
        
        
        //3.设置背景颜色
        self.backgroundColor = UIColor.RGBColor(0, G: 0, B: 0, A: 0.4)
        self.autoresizesSubviews = false
        
        
        //1.上面的部分
        self.addSubview(topView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK: - collectionView 协议方法
extension YTMenuSegmentView:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.seletedIndex == -1 {
            return 0
        }
        
        //拿到对应的数据源
        let item = items![self.seletedIndex]
        return item.1.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! YTMenuSegementCell
        //2.刷新数据
        let text = self.items![self.seletedIndex].1[indexPath.row]
        cell.textLabel.text = text
        if indexPath.row == self.indexArray[seletedIndex] {
            
            cell.selectedView.hidden = false
        }else{
        
            cell.selectedView.hidden = true
        }
    
        //3.返回cell
        return cell
    }
    
    //设置间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    
        return UIEdgeInsetsMake(20, 20, 20, 20)
    }
    
    //设置cell的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let W = (collectionView.frame.size.width - 20*5)/4
        let H:CGFloat = 30
        return CGSizeMake(W, H)
    }
    
    //cell被点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! YTMenuSegementCell
        cell.selectedView.hidden = false
        
        let preCell = collectionView.cellForItemAtIndexPath(NSIndexPath.init(forRow: self.indexArray[seletedIndex], inSection: 0)) as! YTMenuSegementCell
        preCell.selectedView.hidden = true
        
        //更新分组中的选中下标值
        self.indexArray[seletedIndex] = indexPath.row
        //更新对象的分组按钮的显示
        let button = self.topView.viewWithTag(seletedIndex+100) as! YTMenuSegmentButton
        button.subTitle = self.items![seletedIndex].1[indexPath.row]
        
        //通知外部刷新数据
        self.delegate?.YTMenuSegment(self, seleteItemIndex:indexArray)
        
        //收起collectionView
        button.seleted = false
        self.seletedIndex = -1
        
    }
    
    
}

//MARK: - 按钮点击
extension YTMenuSegmentView{

    func buttonAction(button:YTMenuSegmentButton){
        //1.按钮被选中
        if button.seleted {
            
            //a.取消原来选中的按钮
            if self.seletedIndex != -1 {
                //拿到之前选中的按钮
                let tButton = self.topView.viewWithTag(self.seletedIndex+100) as! YTMenuSegmentButton
                //变成非选中状态
                tButton.seleted = false
            }
            //b.更新index值
            self.seletedIndex = button.tag - 100
            
        }else{
            //2.按钮取消选中
            self.seletedIndex = -1
        }
    }
}

//MARK: - 计算子视图的frame
extension YTMenuSegmentView{

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //1.上面部分
        let topX:CGFloat = 0
        let topY:CGFloat = 0
        let topW = self.frame.size.width
        let topH = self.segementHeaderHeight
        self.topView.frame = CGRectMake(topX, topY, topW, topH)
        
        //1.1设置按钮的frame
        let buttonW = topW / CGFloat(self.items!.count)
        let buttonH = topH
        let buttonY:CGFloat = 0
        //拿到所有的按钮
        for (i,item) in self.topView.subviews.enumerate() {
            
            let buttonX = CGFloat(i) * buttonW
            item.frame = CGRectMake(buttonX, buttonY, buttonW+1, buttonH)
        }
        
        
        //2.下面部分
        let bmX:CGFloat = 0
        let bmY = topH
        let bmW = topW
        
        self.bottomCollectionView!.frame = CGRectMake(0, 0, bmW, self.contentHeight)
        
        if self.seletedIndex == -1 {
        
            
            UIView.animateWithDuration(0.5, animations: {
                    self.bottomView.frame = CGRectMake(bmX, bmY, bmW,0)
                    self.backgroundColor = UIColor.clearColor()
                
                }, completion: { (ret) in
                    
                    self.frame.size.height = self.segementHeaderHeight
            })
            
        
            
            
        }else{
            self.frame.size.height = Screen_H
            self.bottomCollectionView?.reloadData()
            UIView.animateWithDuration(0.5, animations: { 
                self.backgroundColor = UIColor.RGBColor(0, G: 0, B: 0, A: 0.4)
                self.bottomView.frame = CGRectMake(bmX, bmY, bmW, self.contentHeight)
                
                }, completion: { (ret) in
                
            })
            
            
            
        }
        
    }
}

//MARK: - UITouch
extension YTMenuSegmentView{

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //拿到当前选中的按钮
        if self.seletedIndex != -1 {
            let button = self.topView.viewWithTag(self.seletedIndex+100) as! YTMenuSegmentButton
            button.seleted = false
        }
        self.seletedIndex = -1
    }
}


//MARK: - UIColor扩展
extension UIColor{

    ///通过0-255的RGB值去创建一个颜色对象
    static func RGBColor(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat) -> UIColor{
        
        return UIColor.init(red: R/255, green: G/255, blue: B/255, alpha: A)
    }
}
