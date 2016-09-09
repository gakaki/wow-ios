
import UIKit

protocol VCDesignerListSearchResultDelegate:class{
    func searchResultSelect(model:WOWDesignerModel)
}

class VCDesignerListSearchResult: WOWBaseTableViewController {
    
    var resultArr = [WOWDesignerModel]()
    var delegate  : VCDesignerListSearchResultDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.edgesForExtendedLayout = .None
        tableView.registerNib(UINib.nibName("WOWBaseStyleCell"), forCellReuseIdentifier:"WOWBaseStyleCell")
        tableView.keyboardDismissMode = .OnDrag
    }
}


extension VCDesignerListSearchResult{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("WOWBaseStyleCell", forIndexPath: indexPath) as! WOWBaseStyleCell
        let model = resultArr[indexPath.row]
        //        cell.leftImageView.kf_setImageWithURL(NSURL(string:model.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.leftImageView.set_webimage_url(model.designerPhoto )
        
        cell.centerTitleLabel!.text = model.designerName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = resultArr[indexPath.row]
        if let del = delegate {
            del.searchResultSelect(model)
        }
    }
}