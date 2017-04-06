import YYWebImage


extension String {
    
    static func random(_ length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.characters.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        
        return randomString
    }
}
enum YYImageWidth {
    case SMALL
    case MEDIUM
    case BIG
}

//YYImage WebP Support
extension UIImageView {
    
    class func imageWithUrlWebP(_ url:String) -> UIImageView {
        let image_view = UIImageView()
        image_view.set_webimage_url(url)
        return image_view
    }
    
    func set_webimage_url_user( _ url:String? ) -> Void {
        let pic_name    = "placeholder_userhead"
        var url = self.webp_url(url)
        url = "\(url)/&rand=\(String.random())"
        let cache = YYWebImageManager.shared().cache
        cache?.memoryCache.removeObject(forKey: url)
        cache?.diskCache.removeObject(forKey: url)
        
        self.set_webimage_url_base(url,place_holder_name: pic_name , need_random_url: true )
    }
    func set_webimage_url_base( _ url:String? , place_holder_name pic_name:String , need_random_url random:Bool = false ) -> Void {
        do{
            let url_obj            = URL(string:url ?? "")
            let image_place_holder = UIImage(named: pic_name)
            
            try! self.yy_setImage(
                with: url_obj,
                placeholder: image_place_holder,
                options: [YYWebImageOptions.progressiveBlur , YYWebImageOptions.setImageWithFadeAnimation],
                completion: { (img, url, from_type, image_stage,err ) in
                    
                    _ = url.absoluteString
                    if ( from_type == YYWebImageFromType.remote ||  from_type == YYWebImageFromType.none ){
//                        DLog("image url is \(url_str),from remote or none,\(image_stage)")
                    }

            })
            
        }catch let _ {
//            DLog(e)
        }
     }
    
    func set_webimage_url( _ url:String? ) -> Void {
        if url != nil {
            let url         = self.webp_url(url)
            let pic_name    = "placeholder_product"
            self.set_webimage_url_base(url,place_holder_name: pic_name)
        
        }
    }
    //带缓存的展位图为 uesrHead 的方法
    func set_webUserPhotoimage_url( _ url:String? ) -> Void {
        if url != nil {
            let url         = self.webp_url(url)
            let pic_name    = "placeholder_userhead"
            self.set_webimage_url_base(url,place_holder_name: pic_name)
            
        }
    }
    func webp_url(_ url:String?) -> String {
        var res = url ?? ""
        if ( res.length <= 0 ){
            return ""
        }else{
//            res     = "\(url!)?imageMogr2/format/webp" 
            res     = "\(url!)?imageView2/1/format/webp/q/90"
//            switch UIDevice.deviceType {
//            case .dt_iPhone4S,.dt_iPhone5:
//                res     = "\(url!)?imageView2/0/w/700/format/webp/q/90"
//            case .dt_iPhone6:
//                res     = "\(url!)?imageView2/0/w/700/format/webp/q/90"
//            case .dt_iPhone6_Plus:
//                res     = "\(url!)?imageView2/0/format/webp/q/90"
//            default:
//                res     = "\(url!)?imageView2/0/w/700/format/webp/q/90"
//
//            }
        }
       return res
    }
    
}
extension UIImage {
    
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .up) {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch (self.imageOrientation) {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            
        default:
            break
        }
        
        switch (self.imageOrientation) {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                        bitsPerComponent: (self.cgImage?.bitsPerComponent)!, bytesPerRow: 0,
                                        space: (self.cgImage?.colorSpace!)!,
                                        bitmapInfo: (self.cgImage?.bitmapInfo.rawValue)!)
        ctx?.concatenate(transform)
        
        switch (self.imageOrientation) {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx?.makeImage()
        return UIImage(cgImage: cgimg!)
    }
}
//
//class Constant {
//    struct Time {
//        let now = { round(NSDate().timeIntervalSince1970) } // seconds
//    }
//}

