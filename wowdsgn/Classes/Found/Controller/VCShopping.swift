


import UIKit
import SnapKit
import VTMagic

class VCShopping: WowBaseVCCartSearch {
    
    var v : VCVTMagic!

    var vc_found:CollapsibleTableViewController?
    var vc_brand:WOWBrandListController?
    var vc_designer:VCDesignerList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    override func setUI() {
        super.setUI()
        
        self.title = "分类"

        
        v                               = VCVTMagic()
        v.magicView.dataSource          = self
        v.magicView.delegate            = self
        
        v.magicView.layoutStyle         = .center
        v.magicView.switchStyle         = .default
        
        v.magicView.sliderWidth         = 50.w
        v.magicView.itemWidth           = MGScreenWidth / 3
        v.magicView.sliderColor         = WowColor.black
        v.magicView.sliderHeight        = 3.w

        self.addChildViewController(v)
        self.view.addSubview(v.magicView)
        
        v.magicView.snp.makeConstraints {[weak self] (make) -> Void in
            if let strongSelf = self {
                make.size.equalTo(strongSelf.view)

            }
        }

        
        vc_found    = CollapsibleTableViewController.init(style: .grouped)
//        let vc_table =
        vc_brand    = UIStoryboard.initialViewController("Brand", identifier:String(describing: WOWBrandListController.self)) as? WOWBrandListController
        vc_designer = UIStoryboard.initialViewController("Designer", identifier:String(describing: VCDesignerList.self)) as? VCDesignerList
        
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
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["分类","品牌","设计师"]
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton{
        
        let button = magicView .dequeueReusableItem(withIdentifier: self.identifier_magic_view_bar_item)
        
        if ( button == nil) {
            let width           = self.view.frame.width / 3
            let b               = UIButton(type: .custom)
            b.frame             = CGRect(x: 0, y: 0, width: width, height: 50)
            b.titleLabel!.font  =  UIFont.systemFont(ofSize: 14)
            b.setTitleColor(WowColor.grayLight, for: UIControlState())
            b.setTitleColor(WowColor.black, for: .selected)
            b.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            return b
        }
        
        return button!
    }
    
    func buttonAction(){
        print("button")
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController{
        
        let vc = magicView.dequeueReusablePage(withIdentifier: self.identifier_magic_view_page)
        
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
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt){
        print("viewDidAppear:", pageIndex);
        
        if let b = magicView.menuItem(at: pageIndex) {
            print("  button asc is ", b)
            
            switch pageIndex {
                case  0: break
                case  1:
                    MobClick.e(.Brands_List)
                    break
                case  2:
                    MobClick.e(.Designers_List)
                    break
                default:
                    MobClick.e(.Shopping)
                    break
            }

        }
    }
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt){
        print("didSelectItemAtIndex:", itemIndex);
        
    }
    
}
