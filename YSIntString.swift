//
//  YSIntString.swift
//  YSIntString
//
//  Created by 刘云玉树 on 2017/7/1.
//  Copyright © 2017年 刘云玉树. All rights reserved.
//

import Foundation

extension String {
    
    func substringWithRange(_ from : Int , to : Int) -> String{
        let ns = (self as NSString).substring(with: NSMakeRange(from-1, to-from+1))
        return ns
    }
    
    var length : Int{
        return self.characters.count
    }
    
}

func + (left: YSIntString, right: YSIntString) -> YSIntString {
    return left.plus(right)
}

func - (left: YSIntString, right: YSIntString) -> YSIntString {
    return left.minus(right)
}

class YSIntString : NSObject {
    
    //检查字符串函数，用于检查字符串是否符合整数格式
    class func checkString(_ intString:String)->(value : String,negative : Bool) {
        let a = intString.length;var b = 1;var returnValue = "";var returnNegative = false
        if intString=="" {return("0",false)}
        repeat{
            let c = intString.substringWithRange(b, to: b)
            if b==1&&intString.substringWithRange(1, to: 1)=="-" {
                returnValue = "-";returnNegative = true
            }else if (Int(c) != nil) {
                returnValue = returnValue + c
            }
            b = b + 1
        }while b<=a
        if returnValue.hasPrefix("0")&&returnValue.length>1 {
            repeat{
                returnValue = returnValue.substringWithRange(2, to: returnValue.length)
            }while returnValue.hasPrefix("0")&&returnValue.length>1
        }else if returnValue.hasPrefix("-0") {
            repeat{
                returnValue = returnValue.substringWithRange(2, to: returnValue.length)
            }while returnValue.hasPrefix("0")&&returnValue.length>1
            returnValue = "-"+returnValue
        }
        if returnValue == "-0" {
            returnValue = "0";returnNegative = false
        }
        return (returnValue,returnNegative)
    }
    
    //真正的值储存在invalue
    private var invalue = String()
    //外部访问和修改invalue
    var value : String {
        get {
            return invalue
        }
        set(intString) {
            let a = YSIntString.checkString(intString)
            invalue = a.value
            negative = a.negative
            if (a.value != intString) {
                print("YSIntString在初始化时遇到了不符合规范的值！传递参数：\"\(intString)\"，传出参数:\"\(a.value)\"")
            }
        }
    }
    
    private(set)var negative = Bool()
    
    init(_ intString : String) {
        let a = YSIntString.checkString(intString)
        invalue = a.value
        negative = a.negative
        if (a.value != intString) {
            print("YSIntString在初始化时遇到了不符合规范的值！传递参数：\"\(intString)\"，传出参数:\"\(a.value)\"")
        }
    }
    
    //加法函数（实际上包含减法算法）
    func plus(_ intString:YSIntString)->YSIntString {
        let a = self;let b = intString;var c = 1;var d = "";var jinwei = 0
        var avalue = a.value;var bvalue = b.value
        if a.negative==false&&b.negative==false {
            //a、b均为非负整数
            //将a、b对齐
            if avalue.length>bvalue.length {
                repeat {
                    bvalue = "0"+bvalue
                }while avalue.length>bvalue.length
            }
            if avalue.length<bvalue.length {
                repeat {
                    avalue = "0"+avalue
                }while avalue.length<bvalue.length
            }
            repeat{
                if c<avalue.length {
                    let a1 = avalue.substringWithRange(avalue.length-c+1, to: avalue.length-c+1)
                    let b1 = bvalue.substringWithRange(bvalue.length-c+1, to: bvalue.length-c+1)
                    let c1 = Int(a1)!+Int(b1)!+jinwei;jinwei = Int(c1/10)
                    d = String(c1%10) + d
                }else{
                    let a1 = avalue.substringWithRange(1, to: 1)
                    let b1 = bvalue.substringWithRange(1, to: 1)
                    let c1 = Int(a1)!+Int(b1)!+jinwei
                    d = String(c1) + d
                }
                c = c + 1
            }while c<=avalue.length
            d = YSIntString.checkString(d).value
            return YSIntString.init(d)
        }else if a.negative==true&&b.negative==true{
            avalue = avalue.substringWithRange(2, to: avalue.length)
            bvalue = bvalue.substringWithRange(2, to: bvalue.length)
            let a1 = YSIntString.init(avalue);let b1 = YSIntString.init(bvalue)
            return YSIntString.init(YSIntString.checkString("-"+a1.plus(b1).value).value)
        }else if a.negative==true&&b.negative==false {
            //a为负数，b为非负数
            avalue = avalue.substringWithRange(2, to: avalue.length)
            if avalue.length>bvalue.length {
                repeat{
                    bvalue = "0"+bvalue
                }while avalue.length>bvalue.length
                repeat{
                    let a1 = avalue.substringWithRange(avalue.length-c+1, to: avalue.length-c+1)
                    let b1 = bvalue.substringWithRange(bvalue.length-c+1, to: bvalue.length-c+1)
                    var c1 = Int(a1)!-Int(b1)!+jinwei
                    jinwei = 0
                    if c1<0 {
                        repeat{
                            c1=c1+10;jinwei=jinwei-1
                        }while c1<0
                    }
                    d = String(c1) + d
                    c = c + 1
                }while c<=avalue.length
                return YSIntString.init(YSIntString.checkString("-"+d).value)
            }else if avalue.length<bvalue.length {
                repeat{
                    avalue = "0"+avalue
                }while avalue.length<bvalue.length
                repeat{
                    let a1 = avalue.substringWithRange(avalue.length-c+1, to: avalue.length-c+1)
                    let b1 = bvalue.substringWithRange(bvalue.length-c+1, to: bvalue.length-c+1)
                    var c1 = Int(b1)!-Int(a1)!+jinwei
                    jinwei = 0
                    if c1<0 {
                        repeat{
                            c1=c1+10;jinwei=jinwei-1
                        }while c1<0
                    }
                    d = String(c1) + d
                    c = c + 1
                }while c<=avalue.length
                d = YSIntString.checkString(d).value
                return YSIntString.init(d)
            }else{
                var bigger = 0//a大为1，a小为-1，a、b一样为0
                repeat{
                    let a1 = avalue.substringWithRange(c, to: c)
                    let b1 = bvalue.substringWithRange(c, to: c)
                    let c1 = Int(a1)!-Int(b1)!
                    if c1>0 {bigger = 1}else if c1<0{bigger = -1}
                    c = c + 1
                }while c<=avalue.length&&bigger==0
                c = 1
                if bigger == 0 {
                    d = "0"
                }else if bigger == 1 {
                    repeat{
                        let a1 = avalue.substringWithRange(avalue.length-c+1, to: avalue.length-c+1)
                        let b1 = bvalue.substringWithRange(bvalue.length-c+1, to: bvalue.length-c+1)
                        var c1 = Int(a1)!-Int(b1)!+jinwei
                        jinwei = 0
                        if c1<0 {
                            repeat{
                                c1=c1+10;jinwei=jinwei-1
                            }while c1<0
                        }
                        d = String(c1) + d
                        c = c + 1
                    }while c<=avalue.length
                    d = "-" + d
                }else{
                    repeat{
                        let a1 = avalue.substringWithRange(avalue.length-c+1, to: avalue.length-c+1)
                        let b1 = bvalue.substringWithRange(bvalue.length-c+1, to: bvalue.length-c+1)
                        var c1 = Int(b1)!-Int(a1)!+jinwei
                        jinwei = 0
                        if c1<0 {
                            repeat{
                                c1=c1+10;jinwei=jinwei-1
                            }while c1<0
                        }
                        d = String(c1) + d
                        c = c + 1
                    }while c<=avalue.length
                }
                d = YSIntString.checkString(d).value
                return YSIntString.init(d)
            }
        }else{
            return YSIntString.init(YSIntString.checkString(b.plus(a).value).value)
        }
    }
    
    func minus(_ intString:YSIntString)->YSIntString {
        var a = intString.value
        if a.hasPrefix("-") {
            a = a.substringWithRange(2, to: a.length)
        }else if a=="0" {
            
        }else{
            a = "-" + a
        }
        a = YSIntString.checkString(a).value
        let b = YSIntString.init(a)
        return self.plus(b)
    }
    
}
