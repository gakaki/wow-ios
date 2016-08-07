import YYWebImage

//YYImage WebP Support
extension UIImageView {
    
    class func imageWithUrlWebP(url:String) -> UIImageView {
        let image_view = UIImageView()
        image_view.set_webimage_url(url)
        return image_view
    }
    
    func set_webimage_url( url:String ) -> Void {
        let url = self.webp_url(url)
        self.yy_setImageWithURL(NSURL(string:url ?? "") , placeholder: UIImage(named: "placeholder_product"))
    }
    
    func webp_url(url:String) -> String {
        var res = url ?? ""
        if ( res.length <= 0 ){
            return ""
        }
       res     = "\(url)?imageMogr2/format/webp"
       return res
    }
    
}