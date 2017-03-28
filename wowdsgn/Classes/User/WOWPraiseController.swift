//
//  WOWPraiseController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWPraiseController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellOneID = String(describing: WOWPraiseOneCell.self)
    let cellTwoID = String(describing: WOWPraiseTwoCell.self)
    let cellThreeID = String(describing: WOWPraiseThreeCell.self)

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
    }
    override func setUI() {
        super.setUI()
        configTable()
    }
    
    fileprivate func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellOneID), forCellReuseIdentifier:cellOneID)
        tableView.register(UINib.nibName(cellTwoID), forCellReuseIdentifier:cellTwoID)
        tableView.register(UINib.nibName(cellThreeID), forCellReuseIdentifier:cellThreeID)

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension WOWPraiseController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOneID, for: indexPath) as! WOWPraiseOneCell
            
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTwoID, for: indexPath) as! WOWPraiseTwoCell
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellThreeID, for: indexPath) as! WOWPraiseThreeCell
            
            return cell
        }

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            UIApplication.currentViewController()?.bingWorksDetail()
    }
    
}
