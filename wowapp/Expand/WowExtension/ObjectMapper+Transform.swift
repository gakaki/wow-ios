
import ObjectMapper

open class StringDecimalNumberTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: AnyObject?) -> String? {
        if let string = value as? String {
            return string
        }
        if let double = value as? Double {
            return "\(NSDecimalNumber(double: double))"
        }
        return nil
    }
    
    open func transformToJSON(_ value: String?) -> String? {
        guard let v = value else { return nil }
        return v
    }
}
