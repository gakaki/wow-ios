
extension SequenceType  where Generator.Element == [String: AnyObject] {
    public func groupBy(key: String) -> [String: AnyObject]{
        let  keys = self.flatMap{($0[key] as! String)}
        let tempSet = Set<String>(keys)
        let uniqueKeys = Array(tempSet)
        var result = [String: AnyObject]()
        for item in uniqueKeys{
            let predicate = NSPredicate(format: "SELF.\(key) =[cd] %@", item)
            let arrFilter = self.filter{predicate.evaluateWithObject($0)}
            result[item] = arrFilter
        }
        return result
    }
}

