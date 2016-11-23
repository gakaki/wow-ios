//
//  WOWCommentController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/24.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift


class WOWCommentController: WOWBaseViewController {
    let cellID = String(describing: WOWCommentCell.self)
    let pageSize        = 10
    var commentList = [WOWTopicCommentListModel]()
    var topic_id        = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    @IBOutlet weak var pressButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        request()
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit{
        removeObservers()
    }
    
    override func setUI() {
        super.setUI()
        inputTextView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50
        tableView.clearRestCell()
        tableView.register(UINib.nibName(String(describing: WOWCommentCell.self)), forCellReuseIdentifier:cellID)
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        configBuyBarItem()
        navigationItem.title = "评论"
    }
    
    @IBAction func sendButtonClick(_ sender: UIButton) {
        
        send()
    }
    
    
    fileprivate func send(){
        guard WOWUserManager.loginStatus else{
            toLoginVC(true)
            return
        }
        
        if inputTextView.text.isEmpty {
            WOWHud.showMsg("您的评论为空")
            return
        }
        if inputTextView.text.length < 3 {
            WOWHud.showMsg("请您输入更多内容")
            return
        }
        if inputTextView.text.length > 140 {
            WOWHud.showMsg("评论的最大字数为140字，请您删减")
            return
        }
        requestSendComment(inputTextView.text)
        
    }
    
    
    fileprivate func addObserver(){
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    

    
//MARK:Private Network
    override func request() {
        super.request()
        ///获取评论列表
        WOWNetManager.sharedManager.requestWithTarget(.api_TopicCommentList(pageSize: pageSize, currentPage: pageIndex, topicId: topic_id), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let r = JSON(result)
                let arr = Mapper<WOWTopicCommentListModel>().mapArray(JSONObject:r["comments"].arrayObject)
                if let array = arr{
                    if strongSelf.pageIndex == 1{
                        strongSelf.commentList = []
                    }
                    strongSelf.commentList.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer = nil
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.commentList = []
                    }
                    strongSelf.tableView.mj_footer = nil
                }

                strongSelf.tableView.reloadData()
                
                strongSelf.endRefresh()
            }
                
        
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
            }
                
            
        }
    }
    
    //发表评论
    func requestSendComment(_ content: String) {
        WOWNetManager.sharedManager.requestWithTarget(.api_SubmitTopicComment(topicId: topic_id, content: content), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                strongSelf.endEditing()
                strongSelf.request()
            }
            
        }){[weak self] (errorMsg) in
            
        }
    }
    
}

extension WOWCommentController:UITextViewDelegate{
    fileprivate func endEditing(){
        self.inputTextView.resignFirstResponder()
        self.inputTextView.text = ""
        self.inputConstraint.constant = 30
        self.view.layoutIfNeeded()
    }
   
    func keyBoardWillShow(_ note:Notification){
        let userInfo  = (note as NSNotification).userInfo as [AnyHashable: Any]!
        let  keyBoardBounds = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {[weak self]() in
            if let strongSelf = self {
                strongSelf.bottomViewConstraint.constant = deltaY
                strongSelf.view.layoutIfNeeded()
            }

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
        let animations:(() -> Void) = { [weak self]() in
            if let strongSelf = self {
                strongSelf.bottomViewConstraint.constant = 0
                strongSelf.view.layoutIfNeeded()
            }

        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }


    var COMMENTS_LIMIT:Int{
        get {
            return 140
        }
    }
    //delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        backgroundView.isHidden = false
        pressButton.isEnabled = true
        pressButton.setBackgroundColor(UIColor.init(hexString: "ffd444")!, forState: .normal)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        backgroundView.isHidden = true
        //如果有评论发布键可点击，没有评论发布键不可点击
        if textView.text.isEmpty {
            pressButton.isEnabled = false
            pressButton.setBackgroundColor(UIColor.init(hexString: "eaeaea")!, forState: .normal)
        }else {
            pressButton.isEnabled = true
            pressButton.setBackgroundColor(UIColor.init(hexString: "ffd444")!, forState: .normal)
        }
        
    }
    //    //中文和其他字符的判断方式不一样
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth = inputTextView.frame.size.width
        inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height > 120 {
            inputConstraint.constant = 120
        }else {
            inputConstraint.constant = newSize.height
            
        }
        self.view.layoutIfNeeded()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //            send()
            return false
        }
        //        let ret = textView.text.characters.count + text.characters.count - range.length <= COMMENTS_LIMIT
        //        if ret == false{
        //            WOWHud.showMsg("您输入的字符超过限制")
        //            return false
        //        }
        return true
    }

}


extension WOWCommentController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWCommentCell
        cell.modelData = commentList[(indexPath as NSIndexPath).row]
        cell.showData(commentList[(indexPath as NSIndexPath).row])
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
