
import UIKit
import SnapKit
import VTMagic

class VCShopping: WowBaseVCCartSearch {
    
    var v : VCVTMagic!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        super.setUI()
        
        self.title = "购物"
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
     
        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle       = .Center
        v.magicView.switchStyle       = .Default
        
  
        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self.view)
//            make.top.equalTo(self.snp_topLayoutGuideTop)
        }

        v.magicView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension VCShopping:VTMagicViewDataSource{
    
    var identifier_magic_view_bar_item : String {
        get {
            return "identifier_magic_view_bar_item"
        }
    }
    var identifier_magic_view_page : String {
        get {
            return "identifier_magic_view_page"
        }
    }
    
    //获取所有菜单名，数组中存放字符串类型对象
    func menuTitlesForMagicView(magicView: VTMagicView) -> [String] {
        return ["分类","品牌","设计师"]
    }
    func magicView(magicView: VTMagicView, menuItemAtIndex itemIndex: UInt) -> UIButton{
        
        let button = magicView .dequeueReusableItemWithIdentifier(self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            
            let b = TooglePriceBtn(title:"价格\(itemIndex)",frame: CGRectMake(0, 0, self.view.frame.width / 3, 50)) { (asc) in
                print("you clicket status is "  , asc)
            }
            
            if ( itemIndex <= 1) {
                b.image_is_show = false
            }else{
                b.image_is_show = true
            }
            return b
            
        }
        
        return button!
    }
    
    func magicView(magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePageWithIdentifier(self.identifier_magic_view_page)
        
        if ((vc == nil)) {
            
            //            let vc_me  = VCMe.init()
            //            vc_me.label.text = "label text \(pageIndex)"
            //            return vc_me
            
            let vc_me = VCCategoryProducts()
            return vc_me
        }
        
        return vc!;
    }
    func touchClick(btn:UIButton){
        print(btn.state)
    }
}
//extension ViewController:VTMagicReuseProtocol{
//    func vtm_prepareForReuse(){
//        pring("clear old data if needed: ", self)
////        self.copy()
////        [self.collectionView setContentOffset:CGPointZero];
//    }
//
//}
//
extension VCShopping:VTMagicViewDelegate{
    func magicView(magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("viewDidAppear:", pageIndex);
        
        if let b = magicView.menuItemAtIndex(pageIndex) as! TooglePriceBtn? {
            print("  button asc is ", b.asc)
        }
    }
    func magicView(magicView: VTMagicView, didSelectItemAtIndex itemIndex: UInt){
        print("didSelectItemAtIndex:", itemIndex);
        
    }
    
}