
import UIKit
import SnapKit
import VTMagic

class VCShopping: WowBaseVCCartSearch {
    
    var v : VCVTMagic!
    
    var vc_found:UIViewController?
    var vc_brand:WOWBrandListController?
    var vc_designer:VCDesignerList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUI() {
        super.setUI()
        
        self.title = "购物"

        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .Center
        v.magicView.switchStyle         = .Default
        
        v.magicView.sliderWidth         = 50.w
        v.magicView.itemWidth           = MGScreenWidth / 3
        v.magicView.sliderColor         = WowColor.blackColor()
        v.magicView.sliderHeight        = 3.w

        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self.view)
        }

        
        vc_found    = UIStoryboard.initialViewController("Found", identifier:String(VCFound)) as! VCFound
        vc_brand    = UIStoryboard.initialViewController("Brand", identifier:String(WOWBrandListController)) as! WOWBrandListController
        vc_designer = UIStoryboard.initialViewController("Designer", identifier:String(VCDesignerList)) as! VCDesignerList
        
        addChildViewController(vc_found!)
        addChildViewController(vc_brand!)
        addChildViewController(vc_designer!)
        
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
            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .Custom)
            b.frame             = CGRectMake(0, 0, width, 50)
            b.titleLabel!.font  =  UIFont.systemFontOfSize(14)
            b.setTitleColor(WowColor.grayLightColor(), forState: .Normal)
            b.setTitleColor(WowColor.blackColor(), forState: .Selected)
            b.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
            
            return b
        }
        
        return button!
    }
    
    func buttonAction(){
        print("button")
    }
    
    func magicView(magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePageWithIdentifier(self.identifier_magic_view_page)
        
        if (vc == nil) {

            if (pageIndex == 0){
                return vc_found!
            }else if (pageIndex == 1){
                return vc_brand!
            }else{
                return vc_designer!
            }
        }
        
        return vc!
    }
}

extension VCShopping:VTMagicViewDelegate{
    func magicView(magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("viewDidAppear:", pageIndex);
        
        if let b = magicView.menuItemAtIndex(pageIndex) {
            print("  button asc is ", b)
        }
    }
    func magicView(magicView: VTMagicView, didSelectItemAtIndex itemIndex: UInt){
        print("didSelectItemAtIndex:", itemIndex);
        
    }
    
}