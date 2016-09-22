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
    
            try! self.yy_setImage( with: URL(string:url ?? ""), placeholder: UIImage(named: pic_name) , options:  [YYWebImageOptions.progressiveBlur , YYWebImageOptions.setImageWithFadeAnimation], completion: { ( image, url, from:YYWebImageFromType, stage:YYWebImageStage, e:NSError?) in

                let url_str = url.URLString
                if ( from == YYWebImageFromType.remote ||  from == YYWebImageFromType.none ){
                    DLog("image url is \(url_str),from remote or none,\(stage)")
                }
  
            })
           
        }catch let e {
            DLog(e)
        }
       
     }
    
    func set_webimage_url( _ url:String? ) -> Void {
        if let u = url {
            let url         = self.webp_url(url)
            let pic_name    = "placeholder_product"
            self.set_webimage_url_base(url,place_holder_name: pic_name)

        }
    }
    
    func webp_url(_ url:String?) -> String {
        var res = url ?? ""
        if ( res.length <= 0 ){
            return ""
        }else{
            res     = "\(url!)?imageMogr2/format/webp"
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

