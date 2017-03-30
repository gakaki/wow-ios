//
//  MainCell.swift
//  XXPagingScrollView
//
//  Created by 陈旭 on 2016/10/18.
//  Copyright © 2016年 LJC. All rights reserved.
//

import UIKit
protocol cell_801_delegate:class {
    // 跳转专题详情代理
    func goToProcutDetailVCWith_801(_ productId: Int?)
}
class Cell_801_Product: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 801 // 今日单品倒计时
    }
     var heightAll:CGFloat = 210
    //当前展示的图片索引
    var currentIndex : Int = 0
    // 统一标题
    var currentSingTodayName : String? {
        didSet{
            leftView?.lb_SingTodayName.text     = currentSingTodayName
            middleView?.lb_SingTodayName.text   = currentSingTodayName
            rightView?.lb_SingTodayName.text    = currentSingTodayName
        }
    }
    
    //用于轮播的左中右三个View（不管几张都是这三个UIView交替使用）
    var leftView , middleView , rightView : WOW_SingProductView?
    
    let cardSize:CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 210)
    
    let scrollerViewWidth:CGFloat   = MGScreenWidth
    let scrollerViewHeight:CGFloat  = 210
    
    //自动滚动计时器
    var autoScrollTimer:Timer?
    
    var cardCount:Int = 0
    weak var delegate : cell_801_delegate?
    var isConfigCellUI :Bool = false
    var dataSourceArray:[WOWProductModel]?{
        didSet{
            if dataSourceArray?.count > 1 {// 如果大于1个，则显示pageController
                configureView()
//                self.currentIndex = 0
                configureAutoScrollTimer()
                pagingScrollView.pageControl.isHidden       = false
                pagingScrollView.scrollView.isScrollEnabled = true
                pagingScrollView.pageControl.numberOfPages  = (self.dataSourceArray?.count) ?? 1
             
            }else{// 当数据源为一个时，禁止scrollview滑动，pagecontroller隐藏，计时器销毁
                self.currentIndex = 0
                dellocTimer()
                pagingScrollView.pageControl.isHidden       = true
                pagingScrollView.scrollView.isScrollEnabled = false
             
            }

            cardCount = dataSourceArray?.count ?? 0
            resetViewSource()
        }
    }
    
    @IBOutlet weak var pagingScrollView: PagingScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置三个 View 左中右
        configureView()
        
        configureAutoScrollTimer()
        
    }
    
    //设置自动滚动计时器
    func configureAutoScrollTimer() {
        if autoScrollTimer == nil {
        //设置一个定时器，每三秒钟滚动一次
        autoScrollTimer = Timer.scheduledTimer(timeInterval: 5, target: self,
                                               selector: #selector(letItScroll),
                                               userInfo: nil, repeats: true)
        RunLoop.current.add(autoScrollTimer!, forMode: RunLoopMode.commonModes)
        }
    }
    //销毁计时器
    func dellocTimer(){
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    //计时器时间一到，滚动一个View
    func letItScroll(){
        let offset = CGPoint(x: 2*scrollerViewWidth, y: 0)
        pagingScrollView.scrollView.setContentOffset(offset, animated: true)
    }

    func countDownView() -> WOWCountDownView {
        let v = Bundle.main.loadNibNamed("WOWCountDownView", owner: self, options: nil)?.last as! WOWCountDownView
        
        return v
    }
    func singProductView() -> WOW_SingProductView {
        let v = Bundle.main.loadNibNamed("WOW_SingProductView", owner: self, options: nil)?.last as! WOW_SingProductView

        return v
    }
    //设置三个 View 左中右
    func configureView(){
        pagingScrollView.scrollView.removeSubviews()
        
        self.leftView       = singProductView()
//        self.leftView?.lb_SingTodayName.text = self.currentSingTodayName
        let cvLeft          = countDownView()
        cvLeft.frame        = (self.leftView?.view_CountDown?.bounds)!
        cvLeft.timeStamp    = 0
        self.leftView?.view_CountDown?.addSubview(cvLeft)
        
        self.middleView     = singProductView()
//        self.middleView?.lb_SingTodayName.text = self.currentSingTodayName
        let cvMiddle        = countDownView()
        cvMiddle.frame      = (self.middleView?.view_CountDown?.bounds)!
        cvMiddle.timeStamp  = 0
        self.middleView?.view_CountDown?.addSubview(cvMiddle)
        
        
        self.rightView      = singProductView()
//        self.rightView?.lb_SingTodayName.text = self.currentSingTodayName
        let cvRight         = countDownView()
        cvRight.frame       = (self.rightView?.view_CountDown?.bounds)!
        cvRight.timeStamp   = 0
        self.rightView?.view_CountDown?.addSubview(cvRight)

        self.gotoVCDetail()
       
        
        pagingScrollView.scrollView.showsHorizontalScrollIndicator = false
        
        pagingScrollView.scrollView.addSubview(self.leftView!)
        pagingScrollView.scrollView.addSubview(self.middleView!)
        pagingScrollView.scrollView.addSubview(self.rightView!)
        
        leftView?.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self{
                make.top.bottom.equalTo(strongSelf.pagingScrollView)
                make.width.equalTo(MGScreenWidth)
                make.centerX.equalTo(MGScreenWidth/2).priority(750)
            }
            
            })

        middleView?.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self{
                make.top.bottom.equalTo(strongSelf.pagingScrollView)
                make.width.equalTo(MGScreenWidth)
                make.centerX.equalTo(CGFloat(1)*strongSelf.cardSize.width + MGScreenWidth/2).priority(750)
            }
            
            })

        rightView?.snp.makeConstraints({[weak self] (make) in
            if let strongSelf = self{
                make.top.bottom.equalTo(strongSelf.pagingScrollView)
                make.width.equalTo(MGScreenWidth)
                make.centerX.equalTo(CGFloat(2)*strongSelf.cardSize.width + MGScreenWidth/2).priority(750)
            }
            
            })

        pagingScrollView.scrollView.delegate    = self
        pagingScrollView.scrollView.contentSize = CGSize(width: self.scrollerViewWidth * 3, height: self.scrollerViewHeight)
        
        pagingScrollView.cardCount      =     CGFloat(3)
        pagingScrollView.pagingWidth    =     self.scrollerViewWidth
        pagingScrollView.pagingHeight   =     self.scrollerViewHeight
        
        //滚动视图内容区域向左偏移一个view的宽度
        pagingScrollView.scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth, y: 0)

    }
    // 处理各个视图 点击 跳转逻辑
    func gotoVCDetail()  {
        // 代理跳转
        self.leftView?.productIdBlock = { [weak self](productId) in
            if let strongSelf = self {
                if let dev = strongSelf.delegate{
                    dev.goToProcutDetailVCWith_801(productId)
                }
            }
            
        }
        
        self.middleView?.productIdBlock = { [weak self](productId) in
            if let strongSelf = self {
                if let dev = strongSelf.delegate{
                    dev.goToProcutDetailVCWith_801(productId)
                }
            }
            
        }
        
        self.rightView?.productIdBlock = { [weak self](productId) in
            if let strongSelf = self {
                if let dev = strongSelf.delegate{
                    dev.goToProcutDetailVCWith_801(productId)
                }
            }
            
        }

    }
    // 重新配置各个页面的信息
    func configureModel(model: WOWProductModel?,v: WOW_SingProductView?){
        for countView in  (v?.view_CountDown?.subviews)! {
           let view = (countView as! WOWCountDownView)
            if model?.timeoutSeconds > 0 {
                view.timeStamp = model?.timeoutSeconds ?? 0
            }else{
                view.timeStamp = model?.timeoutSeconds ?? 0
            }
        }
        v?.model = model
        v?.imgVieww.set_webimage_url(model?.productImg)


        if let price = model?.sellPrice {
            let result = WOWCalPrice.calTotalPrice([price],counts:[1])
            v?.priceLabel.text     = result//千万不用格式化了
            v?.originalpriceLabel.setStrokeWithText("")
            if let originalPrice = model?.originalprice {
                if originalPrice > price{
                    //显示下划线
                    let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                    
                    v?.originalpriceLabel.setStrokeWithText(result)
                }
            }
        }

    }

    
    //每当滚动后重新设置各个 View 的数据
    func resetViewSource() {
        //当前显示的是第一个View
        if self.currentIndex == 0 {
            //            configUI(index: self.currentIndex)
            configureModel(model: dataSourceArray?.last,v: self.leftView)
            
            configureModel(model: dataSourceArray?.first,v: self.middleView)
            
            let rightImageIndex = (self.dataSourceArray?.count) > 1 ? 1 : 0 //保护
            configureModel(model: dataSourceArray?[rightImageIndex],v: self.rightView)
            
            
        }
            //当前显示的是最后一个View
        else if self.currentIndex == ((self.dataSourceArray?.count) ?? 1) - 1 {
            
            configureModel(model: dataSourceArray?[self.currentIndex-1],v: self.leftView)
            
            configureModel(model: dataSourceArray?.last,v: self.middleView)
            
            configureModel(model: dataSourceArray?.first,v: self.rightView)

            
        }//其他情况
        else{
            
            configureModel(model: dataSourceArray?[self.currentIndex-1],v: self.leftView)
            if self.currentIndex < dataSourceArray?.count{
                
            configureModel(model: dataSourceArray?[self.currentIndex],v: self.middleView)
            
            }
            if self.currentIndex < ((dataSourceArray?.count) ?? 1) - 1{

            configureModel(model: dataSourceArray?[self.currentIndex+1],v: self.rightView)
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension Cell_801_Product:UIScrollViewDelegate{
    //scrollView滚动完毕后触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSourceArray?.count != 0){
            
            //如果向左滑动（显示下一张）
            if(offset >= self.scrollerViewWidth*2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSourceArray?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = ((self.dataSourceArray?.count) ?? 1) - 1
                }
            }
            
            //重新设置各个view的数据源
            
            resetViewSource()
            
            //设置页控制器当前页码
            
            pagingScrollView.pageControl.currentPage = self.currentIndex
        }
        

    }
    //手动拖拽滚动开始
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //使自动滚动计时器失效（防止用户手动移动图片的时候这边也在自动滚动）
        dellocTimer()
        
    }
    
    //手动拖拽滚动结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        //重新启动自动滚动计时器
        configureAutoScrollTimer()
        
    }
    
}
