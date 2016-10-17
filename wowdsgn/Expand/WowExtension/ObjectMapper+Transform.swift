
import ObjectMapper

open class StringDecimalNumberTransform: TransformType {
    public func transformFromJSON(_ value: Any?) -> String? {
        if let string = value as? String {
            return string
        }
        if (value as? Double) != nil {
//            return "\(NSDecimalNumber(double:double))"
            return "22"
        }
        return nil
    }

    public typealias Object = String
    public typealias JSON = String
    
    public init() {}

    open func transformToJSON(_ value: String?) -> String? {
        guard let v = value else { return nil }
        return v
    }
}
