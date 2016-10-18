//
//  WOWCommentController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/24.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum CommentType {
    case sence
    case product
}

class WOWCommentController: WOWBaseViewController {
    var mainID:Int!
    let cellID = String(describing: WOWCommentCell.self)
    var commentType:CommentType = CommentType.sence
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    var dataArr = [WOWCommentListModel]()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setUI() {
        super.setUI()
        WOWBorderColor(self.inputTextView)
        WOWBorderRadius(self.inputTextView)
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200
        tableView.clearRestCell()
        tableView.register(UINib.nibName(String(describing: WOWCommentCell.self)), forCellReuseIdentifier:cellID)
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        navigationItem.title = "评论"
    }
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBAction func sendButtonClick(_ sender: UIButton) {
        send()
    }
    
    
    fileprivate func send(){
        guard WOWUserManager.loginStatus else{
            goLogin()
            return
        }
        let comments = inputTextView.text
        guard !(comments?.isEmpty)! else{
            WOWHud.showMsg("请输入评论")
            return
        }
        var type = "scene"
        switch commentType {
        case .product:
            type = "product"
        case .sence:
            type = "scene"
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.api_SubmitComment(uid:WOWUserManager.userID,comment:comments!,thingid:self.mainID,type:type), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.endEditing()
                let model = WOWCommentListModel()
                model.comment = comments
                model.user_nick = WOWUserManager.userName
                model.user_headimage = WOWUserManager.userHeadImageUrl
                model.created_at = "刚刚"
                strongSelf.dataArr.insert(model, at: 0)
                strongSelf.tableView.reloadData()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endEditing()
            }
        }
    }
    
    fileprivate func endEditing(){
        self.inputTextView.resignFirstResponder()
        self.inputTextView.text = ""
        self.inputConstraint.constant = 30
        self.view.layoutIfNeeded()
    }
    
    
    fileprivate func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        present(vc, animated: true, completion: nil)
    }
    
    
    fileprivate func addObserver(){
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func keyBoardWillShow(_ note:Notification){
        let userInfo  = (note as NSNotification).userInfo as [AnyHashable: Any]!
        let  keyBoardBounds = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            self.bottomViewConstraint.constant = deltaY
            self.view.layoutIfNeeded()
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    func keyBoardWillHide(_ note:Notification){
        let userInfo  = (note as NSNotification).userInfo as [AnyHashable: Any]!
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.bottomViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        let type = (commentType == .product) ? "product":"scene"
        WOWNetManager.sharedManager.requestWithTarget(.api_CommentList(pageindex:"\(self.pageIndex)",thingid:self.mainID,type:type), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
            let totalPage = JSON(result)["totalPages"].intValue
                let arr = Mapper<WOWCommentListModel>().mapArray(JSONObject:result["comment"] as! [String:AnyObject])
                strongSelf.endRefresh()
                if let array = arr{
                    if strongSelf.pageIndex == 0{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    if strongSelf.pageIndex == totalPage - 1 || totalPage == 0{
                        strongSelf.tableView.mj_footer = nil
                    }else{
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                }
                strongSelf.tableView.reloadData()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
}

extension WOWCommentController:UITextViewDelegate{
    
    var COMMENTS_LIMIT:Int{
        get {
            return 250
        }
    }
//    
//    //中文和其他字符的判断方式不一样
    func textViewDidChange(_ textView: UITextView) {
        guard inputConstraint.constant < 100 else{
            return
        }
        let fixedWidth = inputTextView.frame.size.width
        inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        inputConstraint.constant = newSize.height
        self.view.layoutIfNeeded()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            send()
            return false
        }
        let ret = textView.text.characters.count + text.characters.count - range.length <= COMMENTS_LIMIT
        if ret == false{
            WOWHud.showMsg("您输入的字符超过限制")
            return false
        }
        return true
    }
}


extension WOWCommentController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWCommentCell
        cell.showData(dataArr[(indexPath as NSIndexPath).row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputTextView.resignFirstResponder()
    }
    
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "暂无评论"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(170, g: 170, b: 170),NSFontAttributeName:UIFont.mediumScaleFontSize(17)])
        return attri
    }
    
//    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
//        return 40
//    }
    
}
