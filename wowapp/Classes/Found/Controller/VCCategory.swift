
import UIKit

struct Pic {
    
    var id:String = ""
    var name:String = ""
    
}

let kAnimationDuration = 0.25
let kIndicatorViewH: CGFloat = 3.0      // 首页顶部标签指示条的高度
let kTitlesViewH: CGFloat = 35          // 顶部标题的高度
let kIndicatorViewwRatio:CGFloat = 1.9  // 首页顶部标签指示条的宽度倍

class VCCategory:WOWBaseViewController, UICollectionViewDelegate{
    
    var cid:String  = "10"
    
    @IBOutlet weak var btn_choose_view: UIView!
    @IBOutlet weak var cv: UICollectionView!
    
    override func setUI(){
      super.setUI()
        
    }
    
    override func request(){
        
    }
    /// 当前选中的按钮
    weak var selectedButton = UIButton()
    //底部红色指示器
    var indicatorView:UIView = {
        //底部红色指示器
        let v               = UIView()
        v.backgroundColor   = UIColor.blackColor()
        v.h                 = kIndicatorViewH
        let offset          = CGFloat(13)
        v.y                 = kTitlesViewH + offset + kIndicatorViewH
        v.tag               = -1
        
        v.layer.borderWidth   = 0.1
        v.layer.borderColor   = UIColor.blackColor().CGColor
        v.layer.cornerRadius  = 3
        
        return v
    }()
    // 标签
    weak var titlesView = UIView()
    
    let pics            = [
        Pic(id: "10", name: "客厅与卧室" ),
        Pic(id: "12", name: "厨房" ),
        Pic(id: "13", name: "浴室" ),
        Pic(id: "14", name: "户外" ),
        Pic(id: "15", name: "办公室" ),
        Pic(id: "16", name: "照明" ),
        Pic(id: "17", name: "家装配饰" )
    ]
    let cell_reuse_id        = "reuse_id"
    let cell_reuse_id_label  = "reuse_id_label"
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        request()
        
        
        //为了在autolayout的视图里获得真的宽度
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.edgesForExtendedLayout = .None
//        self.extendedLayoutIncludesOpaqueBars = false
        
        self.cv.delegate = self
        self.cv.dataSource = self
        //not add this
        //        self.cv.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuse_id")
        self.cv.backgroundView = UIImageView(image: UIImage(named: "bg"))
        //        self.cv.backgroundColor = UIColor(patternImage: UIImage(named: "10")!)
        self.cv.showsHorizontalScrollIndicator = false
        self.cv.decelerationRate = UIScrollViewDecelerationRateFast;
        
        layoutCells()
        
        self.cv.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Right)
        
        
        self.addChooseCard()
    }
    
    
    /// 标签上的按钮点击
    func titlesClick(button: UIButton) {
        // 修改按钮状态
        selectedButton!.enabled = true
        button.enabled = false
        selectedButton = button
        // 让标签执行动画
        UIView.animateWithDuration(kAnimationDuration) {
            self.indicatorView.w = self.selectedButton!.titleLabel!.w * kIndicatorViewwRatio
            self.indicatorView.centerX = self.selectedButton!.centerX
        }
    }
    
    func addChooseCard(){
        //内部子标签
        let btn_titles      = ["上新","销量","价格"]
        let count           = btn_titles.count
        let width           = btn_choose_view.w / CGFloat(count)
        let height          = btn_choose_view.h
        
        for index in 0..<count {
            let button      = UIButton()
            button.h        = height
            button.w        = width
            button.x        = CGFloat(index) * width
            button.tag      = index
            
            button.titleLabel!.font = UIFont.systemFontOfSize(14)
            button.setTitle(btn_titles[index], forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
            button.addTarget(self, action: #selector(titlesClick(_:)), forControlEvents: .TouchUpInside)
            btn_choose_view.addSubview(button)
            //默认点击了第一个按钮
            if index == 0 {
                button.enabled = false
                selectedButton = button
                //让按钮内部的Label根据文字来计算内容
                button.titleLabel?.sizeToFit()
                self.indicatorView.w         = button.titleLabel!.w * kIndicatorViewwRatio
                self.indicatorView.centerX       = button.centerX
                
            }
        }
        //底部红色指示器
        btn_choose_view.addSubview(indicatorView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension VCCategory : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func layoutCells() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 25)
        //        layout.itemSize                     = CGSize(width: 180, height: 180)
        
        //        layout.minimumInteritemSpacing      = 135.0
        layout.minimumLineSpacing           = 15.0
        //        layout.itemSize = CGSize(width: (UIScreen.mainScreen().bounds.size.width - 40)/3, height: ((UIScreen.mainScreen().bounds.size.width - 40)/3))
        cv!.collectionViewLayout = layout
    }
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    //    {
    //        return UIEdgeInsetsMake(10, 10, 10, 10);
    //    }
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        let cellSize:CGSize = CGSizeMake(100,100  )
        return cellSize
    }
    //1
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pics.count
    }
    
    
    //3
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let row  =  pics[indexPath.row]
        var cell =  UICollectionViewCell()
        
        if ( indexPath.row == 0) {
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cell_reuse_id, forIndexPath: indexPath)
            
            if let iv = cell.viewWithTag(2) as? UIImageView {
                let image   =  UIImage(named: row.id )
                iv.image    = image
            }
            if let lv = cell.viewWithTag(1) as? UILabel {
                lv.text =  row.name
            }
            
            
        }else{
            
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(cell_reuse_id_label, forIndexPath: indexPath)
            
            if let lv = cell.viewWithTag(1) as? UILabel {
                lv.text =  row.name
            }
        }
        self.updateCellStatus(cell, is_selected: false)
        
        if ( cell.selected == true){
            self.updateCellStatus(cell, is_selected: true)
        }
        return cell
    }
    
    
    // 改变cell的背景颜色
    func updateCellStatus(cell:UICollectionViewCell  , is_selected selected:Bool ){
        
        let alpha                = CGFloat( selected ?  0.4 : 0.2 )
        let borderWidth          = CGFloat( selected ?  1 :  0.8 )
        
        let color                = UIColor.whiteColor().colorWithAlphaComponent(alpha)
        cell.backgroundColor     = color
        cell.layer.borderWidth   = borderWidth
        cell.layer.borderColor   = color.CGColor
        cell.layer.cornerRadius  = 4
    }
    
    
    //取消选中操作
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            self.updateCellStatus(cell, is_selected: false)
        }
        
    }
    
    //选中时的操作
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if  let cell = collectionView.cellForItemAtIndexPath(indexPath) {
            self.cv.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            self.updateCellStatus(cell, is_selected: true)
            let row = indexPath.row
            cell.selected  = true;
            print(pics[row])
        }
        
    }
    
    
}