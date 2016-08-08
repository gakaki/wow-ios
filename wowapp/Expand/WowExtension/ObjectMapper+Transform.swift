
import ObjectMapper

public class StringDecimalNumberTransform: TransformType {
    public typealias Object = String
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> String? {
        if let string = value as? String {
            return string
        }
        if let double = value as? Double {
            return "\(NSDecimalNumber(double: double))"
        }
        return nil
    }
    
    public func transformToJSON(value: String?) -> String? {
        guard let v = value else { return nil }
        return v
    }
}