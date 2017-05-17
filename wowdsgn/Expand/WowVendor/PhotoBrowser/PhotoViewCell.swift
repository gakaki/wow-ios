//
//  PhotoViewCell.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/15.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit
import Kingfisher

open class PhotoModel {
    open var description: String?
    // 网络图片的URL
    open var imageUrlString: String?
    // 本地图片 或者已经下载好的图片
    open var localImage: UIImage?
    // 用来设置默认图片 和执行动画 如果没有提供,将没有加载时的默认图片, 并且没有动画
    open var sourceImageView: UIImageView?
    // 本地图片
    public init(localImage: UIImage?, sourceImageView: UIImageView?) {
        self.localImage = localImage
        self.sourceImageView = sourceImageView
//        self.description = description
    }
    // 网络图片
    public init(imageUrlString: String?, sourceImageView: UIImageView?) {
        self.imageUrlString = imageUrlString
        self.sourceImageView = sourceImageView
//        self.description = description
    }
}

class PhotoViewCell: UICollectionViewCell {
    /// 单击响应
    var singleTapAction: ((_ gesture: UITapGestureRecognizer) -> Void)?
    /// 图片模型设置
    var photoModel: PhotoModel! = nil {
        didSet {
            setupImage()
        }
    }
    // 是否横屏
    fileprivate var isLandscap: Bool {
        let screenSize = UIScreen.main.bounds.size
        return screenSize.width >= screenSize.height
    }
    
    fileprivate var downloadTask: RetrieveImageTask?
    /// 懒加载 对外可读
    fileprivate(set) lazy var imageView: UIImageView = {[unowned self] in
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor.black
        return imageView
    }()
    /// 懒加载
    fileprivate(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: self.contentView.zj_width - PhotoBrowser.contentMargin, height: self.contentView.zj_height))
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.clipsToBounds = true
        //        pagingEnabled = false
        // 预设定
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        return scrollView
    }()
    /// 进度显示
    fileprivate lazy var hud: SimpleHUD? = {[unowned self] in
        
        let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (self.zj_height - 80)*0.5, width: self.zj_width, height: 80.0))
        return hud
    }()

    /// 设置图片
    var image: UIImage? = nil {
        didSet {
            setupImageViewFrame()
        }
    }
    //MARK:- life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        downloadTask?.cancel()
        downloadTask = nil
        DLog("\(self.debugDescription) --- 销毁")
    }
    //MARK:- private 初始设置
    fileprivate func commonInit() {
        setupScrollView()
        addGestures()
    }
    
    fileprivate func addGestures() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        
        // 允许优先执行doubleTap, 在doubleTap执行失败的时候执行singleTap
        // 如果没有设置这个, 那么将只会执行singleTap 不会执行doubleTap
        singleTap.require(toFail: doubleTap)
        
        addGestureRecognizer(singleTap)
        addGestureRecognizer(doubleTap)
    }
    
    fileprivate func setupScrollView() {
        scrollView.addSubview(imageView)
        contentView.addSubview(scrollView)
    }
    
    //MARK:- 点击处理
    
    // 单击手势, 给外界处理
    func handleSingleTap(_ ges: UITapGestureRecognizer) {
        // 首先缩放到最小倍数, 以便于执行退出动画时frame可以同步改变
        if scrollView.zoomScale != scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
        }
        singleTapAction?(ges)
    }
    
    // 双击放大至最大 或者 缩小至最小
    func handleDoubleTap(_ ges: UITapGestureRecognizer) {
        //        DLog("double---------")
        if imageView.image == nil { return }
        
        if scrollView.zoomScale <= scrollView.minimumZoomScale { // 放大
            
            let location = ges.location(in: scrollView)
            // 放大scrollView.maximumZoomScale倍, 将它的宽高缩小
            let width = scrollView.zj_width/scrollView.maximumZoomScale
            let height = scrollView.zj_height/scrollView.maximumZoomScale
            
            let rect = CGRect(x: location.x * (1 - 1/scrollView.maximumZoomScale), y: location.y * (1 - 1/scrollView.maximumZoomScale), width: width, height: height)
            scrollView.zoom(to: rect, animated: true)
            
        } else {// 缩小
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            
        }
        
    }
    
    // 处理屏幕旋转
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: self.contentView.zj_width - PhotoBrowser.contentMargin, height: self.contentView.zj_height)
        setupImageViewFrame()
    }
    
    ///  重置UI状态
    func resetUI() {
        scrollView.zoomScale = scrollView.minimumZoomScale
        imageView.image = nil
        singleTapAction = nil
        hud?.hideHUD()
    }
}

// MARK: - private helper --- 加载图片设置
extension PhotoViewCell {
    fileprivate func setupImage() {
        
        hud?.hideHUD()
        guard let photo = photoModel else {
            assert(false, "设置的图片模型不正确")
            return
        }
        
        // 如果是加载本地的图片, 直接设置图片即可, 注意这里是photoBrowser需要提升的地方
        // 因为对于本地图片的加载没有做处理, 所以当直接使用 UIImage(named"")的形式加载图片的时候, 会消耗大量的内存
        // 不过鉴于参考了其他的图片浏览器框架, 大家对本地图片都没有处理, 因为这个确实用的很少, 毕竟都是用来加载网络图片的情况比较多
        // 如果发现确实需要处理后面会努力处理这个问题
        if photo.localImage != nil {
            image = photo.localImage
            return
        }
        
        // 加载网路图片
        guard let urlString = photo.imageUrlString, let url = URL(string: urlString.webp_url()) else {
//            assert(false, "设置的url不合法")
            DLog("设置的url不合法")
            return
        }
        // 添加提示框
        if let HUD = hud {
            addSubview(HUD)
        }
        // 添加进度显示
        hud?.addLoadingView()
        // 设置默认图片
        if let sourceImageView = photo.sourceImageView {
            image = sourceImageView.image
        }
        
        image =  UIImage(named: "placeholder_product")
        imageView.yy_setImage(with: url, placeholder: image, options: []) {[weak self] (img, url, imageFromType, imageStage, error) in
            if let strongSelf = self  {
                
                strongSelf.image = img
                strongSelf.hud?.hideLoadingView()
                
                if let _ = img {//加载成功
                    strongSelf.hud?.hideHUD()
                    return
                }
            }

        }

        
    }
    
    fileprivate func setupImageViewFrame() {
        // 考虑长图, 考虑旋转屏幕
        if let imageV = image {
            
            // 设置为最小倍数
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
            imageView.image = image

            // 按照图片比例设置imageView的frame
            let width = imageV.size.width < scrollView.zj_width ? scrollView.zj_width : scrollView.zj_width
            let height = imageV.size.height * (width / imageV.size.width)
            
            // 长图
            if height > scrollView.zj_height {
                imageView.frame = CGRect(x: (scrollView.zj_width - width) / 2, y: 0.0, width: width, height: height)
                scrollView.contentSize = imageView.bounds.size
                scrollView.contentOffset = CGPoint.zero
//                scrollView.zoomToRect(CGRect(x: scrollView.zj_centerX, y: scrollView.zj_centerY, width: scrollView.zj_width/2, height: scrollView.zj_height/2), animated: false)
            } else {
                // 居中显示
                imageView.frame = CGRect(x: (scrollView.zj_width - width) / 2, y: (scrollView.zj_height - height) / 2, width: width, height: height)
                
            }
            // 使得最大缩放时(双击或者放大)图片高度 = 屏幕高度 + 1.0倍图片高度
            scrollView.maximumZoomScale = scrollView.zj_height / height + 1.0
        }
    }
}

// MARK: - UIScrollViewDelegate
extension PhotoViewCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 居中显示图片
        setImageViewToTheCenter()
    }
    
    
    // 居中显示图片
    func setImageViewToTheCenter() {
        let offsetX = (scrollView.zj_width > scrollView.contentSize.width) ? (scrollView.zj_width - scrollView.contentSize.width)*0.5 : 0.0
        let offsetY = (scrollView.zj_height > scrollView.contentSize.height) ? (scrollView.zj_height - scrollView.contentSize.height)*0.5 : 0.0
        
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
        
    }
    
}
