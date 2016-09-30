
//
//  PhotoBrowser.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/4.
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

//

import UIKit
// MARK:- PhotoBrowserDelegate
public protocol PhotoBrowserDelegate: NSObjectProtocol {
    /// 更新当前的sourceImageView(update the currentSourceImageView)
    func sourceImageViewForCurrentIndex(_ index: Int) -> UIImageView?
    ///  正在显示第几页(the current displaying page)
    func photoBrowserDidDisplayPage(_ currentPage: Int, totalPages: Int)
    ///  将要展示图片, 进入浏览模式, 可以用来进行个性化的设置, 比如在这个时候, 隐藏状态栏 和原来的图片 (photoBrowser is preparing well and will begin display the first page )
    func photoBrowerWillDisplay(_ beginPage: Int)
    /// 结束展示图片, 将要退出浏览模式,销毁photoBrowser, 可以用来进行个性化的设置 比如显示状态栏, 显示原来的图片(photoBrowser will be dismissed)
    func photoBrowserWillEndDisplay(_ endPage: Int)
    ///  photoBrowser is now dismissed
    func photoBrowserDidEndDisplay(_ endPage: Int)
    
    func extraBtnOnClick(_ extraBtn: UIButton)
}

// 协议扩展, 实现oc协议的optional效果, 当然可以直接在协议前 加上@objc
// just to reach the effect provided by the objective-c's 'optional',but you can also use "@objc"
// MARK:-  extension PhotoBrowserDelegate
extension PhotoBrowserDelegate {
    // 更新当前的sourceImageView
    public func sourceImageViewForCurrentIndex(_ index: Int) -> UIImageView? {
        return nil
    }
    ///  正在显示第几页
    public func photoBrowserDidDisplayPage(_ currentPage: Int, totalPages: Int) { }
    //  将要展示图片, 进入浏览模式, 可以用来进行个性化的设置, 比如在这个时候, 隐藏状态栏 和原来的图片
    public func photoBrowerWillDisplay(_ beginPage: Int) { }
    // 结束展示图片, 将要退出浏览模式,销毁photoBrowser, 可以用来进行个性化的设置 比如显示状态栏, 显示原来的图片
    public func photoBrowserWillEndDisplay(_ endPage: Int) { }
    public func photoBrowserDidEndDisplay(_ endPage: Int) { }
    
    ///  点击附加的按钮的响应方法
    public func extraBtnOnClick(_ extraBtn: UIButton) { }
    
}



open class PhotoBrowser: UIViewController {
    
    // MARK:- public property
    
    /// 点击附加的按钮响应Closure
    open var extraBtnOnClickAction: ((_ extraBtn: UIButton) -> Void)?
    /// delegate
    open weak var delegate: PhotoBrowserDelegate?
    
    /// 每一页之间的间隔
    static let contentMargin: CGFloat = 20.0
    /// cell重用id
    static let cellID = "cellID"
    
    // MARK:- private property
    
    fileprivate var toolBarStyle: ToolBarStyle!
    // 用于在屏幕旋转的时候(不要改变图片索引和旋转后更新布局)
    fileprivate var isOritenting = false
    fileprivate var photoModels: [PhotoModel] = []
    
    /// 用来添加当前控制器为子控制器
    fileprivate weak var parentVc: UIViewController!
    
    /// 用来记录当前的图片索引 默认为0 这里设置为-1 是为了在进来的时候设置初始为0也能使oldValue != currentIndex
    fileprivate var currentIndex: Int = -1 {
        didSet {
            if oldValue == currentIndex { return }
            
            setupToolBarIndexText(currentIndex)
            // 正在显示的页
            delegate?.photoBrowserDidDisplayPage(currentIndex, totalPages: photoModels.count)
            
        }
    }
    
    fileprivate lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        // 每个cell的尺寸  -- 宽度设置为UICollectionView.bounds.size.width ---> 滚一页就是一个完整的cell
        flowLayout.itemSize = CGSize(width: self.view.zj_width + PhotoBrowser.contentMargin, height: self.view.zj_height)
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.sectionInset = UIEdgeInsets.zero
        return flowLayout
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {[unowned self] in
        
        // 分页每次滚动 UICollectionView.bounds.size.width
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.zj_width + PhotoBrowser.contentMargin, height: self.view.zj_height), collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoBrowser.cellID)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    fileprivate lazy var toolBar: PhotoToolBar = {
        
        let toolBar = PhotoToolBar(frame: CGRect(x: 0.0, y: self.view.zj_height - 44.0, width: self.view.zj_width, height: 44.0), toolBarStyle: ToolBarStyle())
        toolBar.backgroundColor = UIColor.clear
        return toolBar
    }()
    
    // MARK:- life cycle
    public init(photoModels: [PhotoModel], extraBtnOnClickAction: ((_ extraBtn: UIButton) -> Void)? = nil) {
        self.photoModels = photoModels
        self.extraBtnOnClickAction = extraBtnOnClickAction
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(collectionView)
        self.view.addSubview(toolBar)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self.debugDescription) --- 销毁")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        automaticallyAdjustsScrollViewInsets = false

    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 不能在viewDidLoad里面设置
        setupFrame()
        setupToolBarAction()
        animateZoomIn()
        currentIndex(currentIndex, animated: false)

    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("视图布局完成")
        
        if isOritenting {
            currentIndex(currentIndex, animated: false)
            isOritenting = false
        }
    }
    
    
    // MARK:- orientation
    // 开始旋转
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // 正在旋转屏幕
        isOritenting = true
        // to solve the error or complaint that 'the behavior of the UICollectionViewFlowLayout is not defined because:
        // the item height must be less that the height of the UICollectionView minus the section insets top and bottom values '
        // http://stackoverflow.com/questions/14469251/uicollectionviewflowlayout-size-warning-when-rotating-device-to-landscape
        
        // Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
        collectionView.collectionViewLayout.invalidateLayout()


    }
    
    open override var shouldAutorotate : Bool {
        return true
    }
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
}


// MARK: - public use func (使用方法)
extension PhotoBrowser {
    ///  显示图片浏览器
    ///
    ///  - parameter parentVc:  一般即可传入self
    ///  - parameter beginPage: 初始图片页
    public func show(inVc parentVc: UIViewController, beginPage: Int) {
        currentIndex = beginPage
        self.parentVc = parentVc
        self.view.frame = UIScreen.main.bounds
        self.parentVc.view.addSubview(self.view)
        self.parentVc.addChildViewController(self)
        self.didMove(toParentViewController: self.parentVc)
//        navigationController?.navigationBarHidden = true
//        tabBarController?.tabBar.hidden = true
        
    }
    
    ///  用于设置当前的页
    ///
    ///  - parameter currentIndex: 指定的页数
    ///  - parameter animated:     是否执行动画滚动到指定的页
    public func currentIndex(_ currentIndex: Int, animated: Bool) {
        assert(currentIndex >= 0 && currentIndex < photoModels.count, "设置的下标有误")
        if currentIndex < 0 || currentIndex >= photoModels.count { return }
        // 更新当前下标
        self.currentIndex = currentIndex
        // 滚动到特定的位置  !----> 这里一定要使用collectionView.bounds.size.width来设置偏移量
        collectionView.setContentOffset(CGPoint(x: CGFloat(currentIndex) * collectionView.zj_width, y: 0.0), animated: animated)
        
    }
}

// MARK: - private helper
extension PhotoBrowser {
    /// 当前的sourceImageView, 以便于设置默认图片和执行动画退出
    fileprivate func getCurrentSourceImageView(_ index: Int) -> UIImageView? {
        // 更新当前的sourceImageView, 以便于执行动画退出
        let currentModel = photoModels[index]
        if let sourceView = delegate?.sourceImageViewForCurrentIndex(index) { // 首先判断是否实现了代理方法返回sourceImageView, 如果有,就使用代理返回的
            return sourceView
        } else {// 代理没有返回 就判断是否一开始就设置了sourceImageView
            if let sourceView = currentModel.sourceImageView { //  初始设置了 就使用
                return sourceView
            } else {// 没有设置
                
                return nil
                
            }
        }
        
    }
    
    fileprivate func setupFrame() {
        // to solve the error or complaint that 'the behavior of the UICollectionViewFlowLayout is not defined because:
        // the item height must be less that the height of the UICollectionView minus the section insets top and bottom values '
        // http://stackoverflow.com/questions/14469251/uicollectionviewflowlayout-size-warning-when-rotating-device-to-landscape
        
        // Call -invalidateLayout to indicate that the collection view needs to requery the layout information.
        collectionView.collectionViewLayout.invalidateLayout()
        
        let collectionX = NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let collectionY = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let collectionW = NSLayoutConstraint(item: collectionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: PhotoBrowser.contentMargin)
        let collectionH = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([collectionX, collectionY, collectionW, collectionH])
        
        let toolBarX = NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let toolBarY = NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let toolBarW = NSLayoutConstraint(item: toolBar, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let toolBarH = NSLayoutConstraint(item: toolBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([toolBarX, toolBarY, toolBarW, toolBarH])
        
        
    }
}

// MARK: - toolBar
extension PhotoBrowser {
    
    fileprivate func setupToolBarIndexText(_ index: Int) {
        toolBar.indexText = "\(index + 1)/\(photoModels.count)"
        
    }
    
    fileprivate func setupToolBarAction() {
        
        toolBar.saveBtnOnClick = {[unowned self] (saveBtn: UIButton) in
            // 保存到相册
            let currentCell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! PhotoViewCell
            guard let currentImage  = currentCell.imageView.image  else { return }
           
            DispatchQueue.global().async {
                
                UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)

            }
            
        }
        toolBar.extraBtnOnClick = {[unowned self] (extraBtn: UIButton) in

            self.extraBtnOnClickAction?(extraBtn)
            self.delegate?.extraBtnOnClick(extraBtn)
        }
        
        
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (self.view.zj_height - 80)*0.5, width: self.view.zj_width, height: 80.0))

        self.view.addSubview(hud)
        if error == nil {
            // successful
            hud.showHUD("保存成功!", autoHide: true, afterTime: 1.0)
            
        } else {
            // failure
            hud.showHUD("保存失败!", autoHide: true, afterTime: 1.0)
            
        }
    }
}

// MARK: - animation
extension PhotoBrowser {
    
    fileprivate func animateZoomIn() {

        let currentModel = photoModels[currentIndex]
        let sourceView = getCurrentSourceImageView(currentIndex)
        
        if let sourceImageView = sourceView {
            //  当前的sourceView 将它的frame从它的坐标系转换为self的坐标系中来
            let window = UIApplication.shared.keyWindow!
            
            let beginFrame = window.convert(sourceImageView.frame, from: sourceImageView)
            
//            print("\(beginFrame) --- \(sourceImageView.frame)")
            
            let sourceViewSnap = snapView(sourceImageView)
            //
            sourceViewSnap.frame = beginFrame
            
            var endFrame: CGRect
            
            if let localImage = currentModel.localImage {
                
                // 按照图片比例设置imageView的frame
                let width = localImage.size.width < view.zj_width ? localImage.size.width : view.zj_width
                let height = localImage.size.height * (width / localImage.size.width)
                
                // 长图
                if height > view.zj_height {
                    endFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
                    
                } else {
                    // 居中显示
                    endFrame = CGRect(x:(view.zj_width - width) / 2, y: (view.zj_height - height) / 2, width: width, height: height)
                }
                
                
            } else {
                if let placeholderImage = sourceImageView.image {
                    // 按照图片比例设置imageView的frame
                    let width = placeholderImage.size.width < self.view.zj_width ? placeholderImage.size.width : self.view.zj_width
                    let height = placeholderImage.size.height * (width / placeholderImage.size.width)
                    // 长图
                    if height > view.zj_height {
                        endFrame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
                        
                    } else {
                        // 居中显示
                        endFrame = CGRect(x:(view.zj_width - width) / 2, y: (view.zj_height - height) / 2, width: width, height: height)
                        
                    }
                } else {
                    endFrame = CGRect.zero
                }
            }
            
            window.addSubview(sourceViewSnap)
            view.alpha = 1.0
            collectionView.isHidden = true
            toolBar.isHidden = true
            // 将要进入浏览模式
            delegate?.photoBrowerWillDisplay(currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                
                sourceViewSnap.frame = endFrame
            }, completion: {[unowned self] (_) in
                sourceViewSnap.removeFromSuperview()
                self.collectionView.isHidden = false
                self.toolBar.isHidden = false
                
            }) 

        } else {
            view.alpha = 0.0

            // 将要进入浏览模式
            delegate?.photoBrowerWillDisplay(currentIndex)
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.view.alpha = 1.0
            }, completion: { (_) in

                
            }) 
        }
    }
    
    fileprivate func animateZoomOut() {
//        navigationController?.navigationBarHidden = false
//        tabBarController?.tabBar.hidden = false

        let sourceView = getCurrentSourceImageView(currentIndex)
        
        if let sourceImageView = sourceView {
            // 当前的cell一定可以获取到
            let currentCell = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! PhotoViewCell
            let currentImageView: UIView
            // 如果超出imageView屏幕则截取整个屏幕
            if currentCell.imageView.bounds.size.height > view.zj_height {
                currentImageView = currentCell.contentView
            } else {
                currentImageView = currentCell.imageView
            }
            
            let currentImageSnap = snapView(currentImageView)
            
            let window = UIApplication.shared.keyWindow!
            window.addSubview(currentImageSnap)
            //        let beginFrame = window.convertRect(currentImageView.frame, toView: window)
            //        print(beginFrame)
            currentImageSnap.frame = currentImageView.frame
//            print(currentImageView.frame)
            let endFrame = sourceImageView.convert(sourceImageView.frame, to: window)
//            print(endFrame)
            // 将要退出
            delegate?.photoBrowserWillEndDisplay(currentIndex)
            
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                currentImageSnap.frame = endFrame
                self.view.alpha = 0.0
                
            }, completion: {[unowned self] (_) in
                // 退出浏览模式
                self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
                currentImageSnap.removeFromSuperview()
                
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }) 

        } else {
            delegate?.photoBrowserWillEndDisplay(currentIndex)
            
            UIView.animate(withDuration: 0.5, animations: {[unowned self] in
                self.view.alpha = 0.0
                
            }, completion: {[unowned self] (_) in
                // 退出浏览模式
                self.delegate?.photoBrowserDidEndDisplay(self.currentIndex)
                
                self.willMove(toParentViewController: nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            }) 
        }
    }
    
    fileprivate func snapView(_ view: UIView) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        return imageView
        
    }
    
    fileprivate func dismiss() {
        animateZoomOut()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PhotoBrowser: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public final func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public final func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    public final func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowser.cellID, for: indexPath) as! PhotoViewCell
        // 避免出现重用出错的问题(to avoid reusing mistakes)
        cell.resetUI()
        let currentModel = photoModels[(indexPath as NSIndexPath).row]
        // 可能在代理方法中重新设置了sourceImageView,所以需要更新当前的sourceImageView
        // maybe we update the sourceImageView through the delegare, so we need to reset the currentModel.sourceImageView
        currentModel.sourceImageView = getCurrentSourceImageView((indexPath as NSIndexPath).row)
        cell.photoModel = currentModel
        
        // 注意之前直接传了self的一个函数给singleTapAction 造成了循环引用
        cell.singleTapAction = {[unowned self](ges: UITapGestureRecognizer) in
            self.dismiss()
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let size = UIScreen.mainScreen().bounds.size
        return collectionView.bounds.size
    }
    
    public final func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isOritenting { return }
        // 向下取整
        currentIndex = Int(scrollView.contentOffset.x / scrollView.zj_width + 0.5)
//                print(currentIndex)
    }
    
}
