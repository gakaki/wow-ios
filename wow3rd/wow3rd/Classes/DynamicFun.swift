//
//  DynamicFun.swift
//  Pods
//
//  Created by g on 2016/11/6.
//
//

import Foundation

public class DynamicFun
{
    public static func fun( _ className:String ,_ fun_name : String , _ param1:Any? = nil , _ param2:Any? = nil ){
        
        if let c: NSObject.Type = NSClassFromString(className) as? NSObject.Type{

            let c_tmp = c.init()
            if  param1 == nil {
                c_tmp.perform(Selector(fun_name))
            }
            else if  param2 == nil {
                c_tmp.perform(Selector(fun_name),with:param1)
            }
            else{
                c_tmp.perform(Selector(fun_name),with:param1, with:param2 )
            }
//            c_tmp.perform(#selector(BaseProp.test_prop)
        }else{
            print("\(className)\(fun_name) not exists")
        }

    }
    
    public static func classFun( _ className:String ,_ class_fun_name : String ,_ param1:Any? = nil ,_ param2:Any? = nil ){
        
        if let c: NSObject.Type = NSClassFromString(className) as? NSObject.Type{
            
            if param1 == nil  {
                c.perform(Selector(class_fun_name))
            }
            else if  param2 == nil {
                c.perform(Selector(class_fun_name),with:param1)
            }
            else{
                c.perform(Selector(class_fun_name),with:param1, with:param2 )
            }
            
        }else{
            print("\(className)\(class_fun_name) not exists")
        }
        
    }

}
