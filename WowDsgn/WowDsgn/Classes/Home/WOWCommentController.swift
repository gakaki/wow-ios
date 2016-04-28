//
//  WOWCommentController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/24.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

enum CommentType {
    case Sence
    case Product
}

class WOWCommentController: WOWBaseViewController {
    var mainID:String!
    let cellID = String(WOWCommentCell)
    var commentType:CommentType = CommentType.Sence
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func setUI() {
        super.setUI()
        WOWBorderColor(self.inputTextView)
        WOWBorderRadius(self.inputTextView)
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200
        tableView.clearRestCell()
        tableView.registerNib(UINib.nibName(String(WOWCommentCell)), forCellReuseIdentifier:cellID)
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        navigationItem.title = "评论"
    }
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBAction func sendButtonClick(sender: UIButton) {
        send()
    }
    
    
    private func send(){
        guard WOWUserManager.loginStatus else{
            goLogin()
            return
        }
        let comments = inputTextView.text
        guard !comments.isEmpty else{
            WOWHud.showMsg("请输入评论")
            return
        }
        
        WOWNetManager.sharedManager.requestWithTarget(.Api_SubmitComment(uid:WOWUserManager.userID,comment:comments,product_id:self.mainID), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.endEditing()
                let model = WOWCommentListModel()
                model.comment = comments
                model.user_nick = WOWUserManager.userName
                model.user_headimage = WOWUserManager.userHeadImageUrl
                model.created_at = "刚刚"
                strongSelf.dataArr.insert(model, atIndex: 0)
                strongSelf.tableView.reloadData()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endEditing()
            }
        }
    }
    
    private func endEditing(){
        self.inputTextView.resignFirstResponder()
        self.inputTextView.text = ""
        self.inputConstraint.constant = 30
        self.view.layoutIfNeeded()
    }
    
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyBoardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyBoardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }

    
    func keyBoardWillShow(note:NSNotification){
        let userInfo  = note.userInfo as [NSObject:AnyObject]!
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            self.bottomViewConstraint.constant = deltaY
            self.view.layoutIfNeeded()
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    func keyBoardWillHide(note:NSNotification){
        let userInfo  = note.userInfo as [NSObject:AnyObject]!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.bottomViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
            UIView.animateWithDuration(duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.Api_CommentList(pageindex:"\(self.pageIndex)",product_id:self.mainID), successClosure: {[weak self](result) in
            if let strongSelf = self{
               let arr = Mapper<WOWCommentListModel>().mapArray(result)
                if let array = arr{
                    strongSelf.dataArr.appendContentsOf(array)
                }
                strongSelf.tableView.reloadData()
            }
        }) {(errorMsg) in
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
    func textViewDidChange(textView: UITextView) {
        /*
        if COMMENTS_LIMIT > 0 {
            // markedTextRange指的是当前高亮选中的，除了长按选中，用户中文输入拼音过程往往也是高亮选中状态
            if let selectedRange = textView.markedTextRange {
                
            } else {
                let text = textView.text
                if text.characters.count > COMMENTS_LIMIT {
                    let range = Range(start: text.startIndex, end: adv)
                    let subText = text.substringWithRange(range)
                    textView.text = subText
                }
            }
        }
        */
        /*
        let lang = textView.textInputMode?.primaryLanguage
        if lang == "zh-Hans"{
            let range = textView.markedTextRange
            if let selectedRange = range {
                let position = textView.positionFromPosition(selectedRange.start, offset: 0)
                if position == nil{
                    if textView.text.characters.count > COMMENTS_LIMIT {
                        textView.text = (textView.text as NSString).substringToIndex(COMMENTS_LIMIT)
                    }
                }else{}
            }
        }else{
            if textView.text.characters.count > COMMENTS_LIMIT {
                textView.text = (textView.text as NSString).substringToIndex(COMMENTS_LIMIT)
            }
        }
         */
    
        guard inputConstraint.constant < 100 else{
            return
        }
        let fixedWidth = inputTextView.frame.size.width
        inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = inputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        inputConstraint.constant = newSize.height
        self.view.layoutIfNeeded()
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWCommentCell
        cell.showData(dataArr[indexPath.row])
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.inputTextView.resignFirstResponder()
    }
    
}