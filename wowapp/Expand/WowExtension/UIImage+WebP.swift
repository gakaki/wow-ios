import YYWebImage

//YYImage WebP Support
extension UIImageView {
    
    class func imageWithUrlWebP(url:String) -> UIImageView {
        let image_view = UIImageView()
        image_view.set_webimage_url(url)
        return image_view
    }
    
    func set_webimage_url_user( url:String ) -> Void {
        let pic_name    = "placeholder_userhead"
        self.set_webimage_url_base(url,place_holder_name: pic_name)
    }
    func set_webimage_url_base( url:String , place_holder_name pic_name:String ) -> Void {
        let url = self.webp_url(url)
        self.yy_setImageWithURL(NSURL(string:url ?? "") , placeholder: UIImage(named: pic_name) , options: YYWebImageOptions.ProgressiveBlur, completion: nil)
    }
    
    func set_webimage_url( url:String? ) -> Void {
        let url = self.webp_url(url)
//        self.yy_setImageWithURL(NSURL(string:url ?? "") , )
        let pic_name    = "placeholder_product"
        self.set_webimage_url_base(url,place_holder_name: pic_name)
    }
    
    func webp_url(url:String?) -> String {
        var res = url ?? ""
        if ( res.length <= 0 ){
            return ""
        }else{
            res     = "\(url!)?imageMogr2/format/webp"
        }
//        DLog(res)
       return res
    }
    
}