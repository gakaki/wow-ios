
extension Sequence  where Iterator.Element == [String: AnyObject] {
    public func groupBy(_ key: String) -> [String: AnyObject]{
        let  keys = self.flatMap{($0[key] as! String)}
        let tempSet = Set<String>(keys)
        let uniqueKeys = Array(tempSet)
        var result = [String: AnyObject]()
        for item in uniqueKeys{
            let predicate = NSPredicate(format: "SELF.\(key) =[cd] %@", item)
            let arrFilter = self.filter{predicate.evaluate(with: $0)}
            result[item] = arrFilter as AnyObject?
        }
        return result
    }
}

