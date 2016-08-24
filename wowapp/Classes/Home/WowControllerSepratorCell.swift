



protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(self)
    }
    
}



protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    
    static var NibName: String {
        return String(self)
    }
}


extension UITableView {
    
    func register<T: UITableViewCell where T: ReusableView, T: NibLoadableView>(_: T.Type) {
        let Nib = UINib(nibName: T.NibName, bundle: nil)
        registerNib(Nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    
    func register<T: UITableViewCell where T: ReusableView>(_: T.Type) {
        registerClass(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}


class WowControllerSepratorCell: UITableViewCell {
    
    static let height = 15.h
    
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.blackColor()
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGFloat(15.h))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}