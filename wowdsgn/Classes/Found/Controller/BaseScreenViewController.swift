//
//  BaseScreenViewController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/1/6.
//  Copyright © 2017年 g. All rights reserved.
//
import IQKeyboardManagerSwift
import UIKit
// 页面如果有筛选，则只需，继承这个类就可以。
class BaseScreenViewController: WOWBaseViewController {
    
    var screenView          : WOWScreenView!
    var screenBtnimg        = UIImageView()
    /* 请求params */
    var params              = [String: Any]()
    /* main数据条件 */
    var query_showCount     = 10
    //    var query_sortBy        = 1
    var query_categoryId    = 16
    var currentTypeIndex:ShowTypeIndex  = .New
    var currentSortType:SortType        = .Asc
    
    var query_sortBy        = 1{
        didSet{
            if query_sortBy == 1 {
                currentTypeIndex = .New
            }
            if query_sortBy == 2 {
                currentTypeIndex = .Sales
            }
            if query_sortBy == 3 {
                currentTypeIndex = .Price
            }
            
        }
    }
    var query_asc          = 1{
        didSet{
            if query_asc == 1 {
                currentSortType = .Asc
            }
            if query_asc == 0 {
                currentSortType = .Desc
            }
        }
    }

    
    
    
    /* 筛选条件 */
    var screenColorArr     : [String]?
    var screenStyleArr     : [String]?
    var screenPriceArr     = Dictionary<String, Int>()
    var screenScreenArr    = [String]()
    var screenMinPrice      : Int?
    var screenMaxPrice      : Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    deinit {
        print("销毁")
    }
    override func setUI() {
        super.setUI()
         configScreeningView()
    }
    //MARK:筛选界面
    func configScreeningView()  {
        screenView = WOWScreenView(frame:CGRect(x: ScreenViewConfig.frameX,y: 0,width: MGScreenWidth - ScreenViewConfig.frameX,height: MGScreenHeight))
        
              
        
        screenBtnimg.image = UIImage.init(named: "screen")
        screenBtnimg.addTapGesture(action: {[weak self] (tap) in
            if let strongSelf = self{
                
                strongSelf.screenView.showInView(view: UIApplication.shared.keyWindow!)
            }
        })
    
        self.view.addSubview(screenBtnimg)
        screenBtnimg.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.right.bottom.equalTo(-30)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
