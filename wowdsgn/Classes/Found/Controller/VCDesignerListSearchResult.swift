
import UIKit

protocol VCDesignerListSearchResultDelegate:class{
    func searchResultSelect(_ model:WOWDesignerModel)
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
        self.edgesForExtendedLayout = UIRectEdge()
        tableView.register(UINib.nibName("WOWBaseStyleCell"), forCellReuseIdentifier:"WOWBaseStyleCell")
        tableView.keyboardDismissMode = .onDrag
    }
}


extension VCDesignerListSearchResult{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWBaseStyleCell", for: indexPath) as! WOWBaseStyleCell
        let model = resultArr[(indexPath as NSIndexPath).row]
        cell.leftImageView.set_webimage_url(model.designerPhoto )
        
        cell.centerTitleLabel!.text = model.designerName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = resultArr[(indexPath as NSIndexPath).row]
        if let del = delegate {
            del.searchResultSelect(model)
        }
    }
}
