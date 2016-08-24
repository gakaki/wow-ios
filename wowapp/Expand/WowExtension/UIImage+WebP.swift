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
        var url = self.webp_url(url)
        url = "\(url)/&rand=\(String.random())"
        let cache = YYWebImageManager.sharedManager().cache
        cache?.memoryCache.removeObjectForKey(url)
        cache?.diskCache.removeObjectForKey(url)
        
        self.set_webimage_url_base(url,place_holder_name: pic_name , need_random_url: true )
    }
    func set_webimage_url_base( url:String? , place_holder_name pic_name:String , need_random_url random:Bool = false ) -> Void {
        do{
    
            try! self.yy_setImageWithURL( NSURL(string:url ?? ""), placeholder: UIImage(named: pic_name) , options:  [YYWebImageOptions.ProgressiveBlur , YYWebImageOptions.SetImageWithFadeAnimation], completion: { ( image, url, from:YYWebImageFromType, stage:YYWebImageStage, e:NSError?) in

                let url_str = url.URLString
                if ( from == YYWebImageFromType.Remote ||  from == YYWebImageFromType.None ){
                    DLog("image url is \(url_str),from remote or none,\(stage)")
                }
  
            })
           
        }catch let e {
            DLog(e)
        }
       
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
extension UIImage {
    
    func fixOrientation() -> UIImage {
        if (self.imageOrientation == .Up) {
            return self
        }
        
        var transform = CGAffineTransformIdentity
        
        switch (self.imageOrientation) {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            
        default:
            break
        }
        
        switch (self.imageOrientation) {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        default:
            break
        }
        
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                        CGImageGetBitsPerComponent(self.CGImage), 0,
                                        CGImageGetColorSpace(self.CGImage),
                                        CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
        
        switch (self.imageOrientation) {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx)
        return UIImage(CGImage: cgimg!)
    }
}
//
//class Constant {
//    struct Time {
//        let now = { round(NSDate().timeIntervalSince1970) } // seconds
//    }
//}

