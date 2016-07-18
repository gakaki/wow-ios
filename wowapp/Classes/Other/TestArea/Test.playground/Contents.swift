//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


//if 条件语句高级用法咯
var age = 18
var sex = "girl"
if case 18...20 = age where sex == "girl"{
    print("交往吧")
}


for i in 1.stride(to: 9, by: 3){
    print(i)
}

//let tuple1 = (age:2,name:"xiaohei")
//let tuple2 = (2,"xiaohei")
//if tuple1 == tuple2{
//    print("两个元组相等")
//}
//let tupleFirst = tuple1.name

/**
 Swift泛型比较
 
 - parameter par1:
 - parameter par2:
 
 - returns:

func compare<T:Comparable>(a1 par1:T,par2:T) -> Bool {
    if par1 > par2{
        print("相等")
        return true
    }else{
        return false
    }
}

let a1 = 23
let b1 = 22
let bool1 = compare(a1:a1, par2: b1)
//let bool2 = compare(param1: 3.3, par2: 4.4)



struct Stack<Element>{
    var items = [Element]()
    mutating func push(item:Element){
        items.append(item)
    }
    mutating func pop()->Element{
        return items.removeLast()
    }
}

var s1 = Stack<String>()
s1.push("aa")
s1.push("ss")
s1.items.dropLast()
s1.items
s1.items.dropFirst()

extension Stack{
    var topItem:Element?{
        return self.items.first
    }
}

let views1:[UIView] = (1...2).map { _ in
    let v = UIView()
    return v
}

class Food {
    var name: String
    init(name: String){
        self.name = name
    }
    convenience init() {
        self.init(name: "[unnamed]")
    }
    
}

class RecipeIngredient: Food{
    var quantity: Int
    init(name: String, quantity: Int){
        self.quantity = quantity
        super.init(name: name)
    }
    
    override convenience init(name: String){
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) X \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}


let ingredientThree = ShoppingListItem(name: "apple", quantity: 10)

class Features{
    static var feature1 = Features()
    static var feature2 = Features()
    class func bark(){
        print("睡觉")
    }
}
Features.feature1 //用到的时候才去生成实例
Features.bark()

var aa:Int?
aa = aa ?? 0
print(aa!)


var items = [1,2,3,4]
var ss = items.map({ item in
    "\(item)"
})


var total = items.reduce(0,combine: {$0 + $1})
print(total)

var string = NSMutableString(string:"小黑") as CFMutableString
if CFStringTransform(string, nil, kCFStringTransformMandarinLatin,false) == true{
    if CFStringTransform(string,nil, kCFStringTransformStripDiacritics, false) == true{
        let ss = string as String
        print("ss\(ss)")
    }
}


let count = NSDecimalNumber(float: 1)
let price = NSDecimalNumber(float:999.0000)
let totalPrice = count.decimalNumberByMultiplyingBy(price)

let numberFormat = NSNumberFormatter()
numberFormat.numberStyle = .DecimalStyle
var result = numberFormat.stringFromNumber(totalPrice)
result = result ?? ""

var strrr = "xiaohei"
strrr.uppercaseString

let sss:String = "siaoheimemed"
let arrs = ["s","s"]
let c = String(sss.characters.first!)
let ret = arrs.contains(c)


let ii:Int?
let iis = String()

let names = ["ss","喜来登"]

func toPinYin(ss:String) -> String {
    let string = NSMutableString(string:ss) as CFMutableString
    if CFStringTransform(string, nil, kCFStringTransformMandarinLatin,false) == true{
        if CFStringTransform(string,nil, kCFStringTransformStripDiacritics, false) == true{
            return string as String
        }
    }
    return ""
}

let maps = names.map { (name) -> String in
    return toPinYin(name)
}
print(maps)


for index in 0...26{
    print(index)
}
 */

var url : String? = ""
if let u = url {
    print("非空")
}else{
    print("空的")
}

let arr = [1,2,3]
let index = arr.indexOf(2)



