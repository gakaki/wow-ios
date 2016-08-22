import YYWebImage


extension String {
    
    static func random(length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}


//YYImage WebP Support
extension UIImageView {
    
    class func imageWithUrlWebP(url:String) -> UIImageView {
        let image_view = UIImageView()
        image_view.set_webimage_url(url)
        return image_view
    }
    
    func set_webimage_url_user( url:String? ) -> Void {
        let pic_name    = "placeholder_userhead"
        
        self.set_webimage_url_base(url,place_holder_name: pic_name , need_random_url: true )
    }
    func set_webimage_url_base( url:String? , place_holder_name pic_name:String , need_random_url random:Bool = false ) -> Void {
        var url = self.webp_url(url)
        if ( random == true ) {
            url = "\(url)/&rand=\(String.random())"
        }
        
        let cache = YYWebImageManager.sharedManager().cache
        cache?.memoryCache.removeObjectForKey(url)
        cache?.diskCache.removeObjectForKey(url)
        
        self.yy_setImageWithURL(NSURL(string:url ?? "") , placeholder: UIImage(named: pic_name) , options: YYWebImageOptions.ProgressiveBlur, completion: nil)
    }
    
    func set_webimage_url( url:String? ) -> Void {
        let url         = self.webp_url(url)
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
       return res
    }
    
}

//
//class Constant {
//    struct Time {
//        let now = { round(NSDate().timeIntervalSince1970) } // seconds
//    }
//}

