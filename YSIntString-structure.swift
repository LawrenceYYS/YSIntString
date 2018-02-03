//
//  YSIntString-structure.swift
//  YSIntString
//
//  Created by 刘云玉树 on 2018/1/27.
//  Copyright © 2018年 刘云玉树. All rights reserved.
//

import Foundation

extension String {
    
    func substringWithRange(_ from : Int , to : Int) -> String{
        let ns = (self as NSString).substring(with: NSMakeRange(from-1, to-from+1))
        return ns
    }
    
    var length : Int{
        return self.count
    }
    
}

func + (left: YSIntString, right: YSIntString) -> YSIntString {
    return left.plus(right)
}

func - (left: YSIntString, right: YSIntString) -> YSIntString {
    return left.minus(right)
}

func * (left: YSIntString, right: YSIntString) -> YSIntString {
    return left.multiply(right)
}

func / (left: YSIntString, right: YSIntString) -> (quotient : YSIntString,remainder : YSIntString) {
    let a = left.dividedBy(right)
    return (a.quotient,a.remainder)
}

func ^ (left: YSIntString, right: YSIntString) -> YSIntString {
    return left.power(right)
}

func > (left: YSIntString, right: YSIntString) -> Bool {
    if (left.value != right.value)&&(left-right).negative==false {
        return true
    }else{
        return false
    }
}

func >= (left: YSIntString, right: YSIntString) -> Bool {
    if (left-right).negative==false {
        return true
    }else{
        return false
    }
}

func < (left: YSIntString, right: YSIntString) -> Bool {
    if left>=right {
        return false
    }else{
        return true
    }
}

func <= (left: YSIntString, right: YSIntString) -> Bool {
    if left>right {
        return false
    }else{
        return true
    }
}

func == (left: YSIntString, right: YSIntString) -> Bool {
    if left.value==right.value {
        return true
    }else{
        return false
    }
}

struct YSIntString {
    
    func checkString(_ intString:String)->(value : String,negative : Bool) {
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
    private(set)var negative = Bool()
    //外部访问和修改invalue
    var value : String {
        get {
            return invalue
        }
        set(intString) {
            let a = self.checkString(intString)
            invalue = a.value
            negative = a.negative
            if (a.value != intString) {
                print("YSIntString在初始化时遇到了不符合规范的值！传递参数：\"\(intString)\"，传出参数:\"\(a.value)\"")
            }
        }
    }
    
    init(_ intString : String) {
        let a = self.checkString(intString)
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
            d = self.checkString(d).value
            return YSIntString.init(d)
        }else if a.negative==true&&b.negative==true{
            avalue = avalue.substringWithRange(2, to: avalue.length)
            bvalue = bvalue.substringWithRange(2, to: bvalue.length)
            let a1 = YSIntString.init(avalue);let b1 = YSIntString.init(bvalue)
            return YSIntString.init(self.checkString("-"+a1.plus(b1).value).value)
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
                return YSIntString.init(self.checkString("-"+d).value)
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
                d = self.checkString(d).value
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
                d = self.checkString(d).value
                return YSIntString.init(d)
            }
        }else{
            return YSIntString.init(self.checkString(b.plus(a).value).value)
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
        a = self.checkString(a).value
        let b = YSIntString.init(a)
        return self.plus(b)
    }
    
    func multiply(_ intString:YSIntString)->YSIntString {
        var a = self;var b = intString;var c = 0;var d = "";var e = 1;var f = 1;var jinwei = 0;var g = YSIntString.init("0")
        if a.negative == true {c = c + 1;a = YSIntString.init(a.value.substringWithRange(2, to: a.value.length))}
        if b.negative == true {c = c + 1;b = YSIntString.init(b.value.substringWithRange(2, to: b.value.length))}
        if a.value=="0"||b.value=="0" {
            return YSIntString.init("0")
        }
        repeat{
            repeat{
                if f<a.value.length {
                    let a1 = a.value.substringWithRange(a.value.length-f+1, to: a.value.length-f+1)
                    let b1 = b.value.substringWithRange(b.value.length-e+1, to: b.value.length-e+1)
                    var c1 = Int(a1)! * Int(b1)! + jinwei;jinwei = Int(c1/10);c1 = c1 % 10
                    d = String(c1) + d
                }else{
                    let a1 = a.value.substringWithRange(1, to: 1)
                    let b1 = b.value.substringWithRange(b.value.length-e+1, to: b.value.length-e+1)
                    let c1 = Int(a1)! * Int(b1)! + jinwei
                    d = String(c1) + d
                }
                f = f + 1
            }while f<=a.value.length
            if e>1 {
                var h = e-1
                repeat{
                    d = d + "0"
                    h = h - 1
                }while h>0
            }
            jinwei = 0
            d = YSIntString.init(self.checkString(d).value).value
            g = g.plus(YSIntString.init(d))
            d = ""
            f = 1
            e = e + 1
        }while e<=b.value.length
        if c==0||c==2 {
            g  = YSIntString.init(self.checkString(g.value).value)
            return g
        }else{
            let i = self.checkString((YSIntString.init("0")-g).value).value
            return YSIntString.init(i)
        }
    }
    
    //除法函数，返回一个元组，商为quotient，余数为remainder
    func dividedBy(_ intString : YSIntString) -> (quotient : YSIntString,remainder : YSIntString) {
        var a = self;var b = intString;var c1 = 0;var c2 = 0;var d = YSIntString.init("0");var e = 0;var f = "";var anegative = false
        var quotient = "0";var remainder = "0"
        if a.negative == true {c1 = c1 + 1;a = YSIntString.init(a.value.substringWithRange(2, to: a.value.length));anegative = true}
        if b.negative == true {c1 = c1 + 1;b = YSIntString.init(b.value.substringWithRange(2, to: b.value.length))}
        if a.value=="0" {
            return (YSIntString.init("0"),YSIntString.init("0"))
        }else if b.value=="0" {
            print("YSIntString在除法中遇到了除数0，默认返回0")
            return (YSIntString.init("0"),YSIntString.init("0"))
        }
        if a.value.length < b.value.length {
            return (YSIntString.init("0"),a)
        }
        c2 = a.value.length-b.value.length+1
        if c2>1 {
            repeat{
                b.value = b.value + "0"
            }while a.value.length>b.value.length
        }
        repeat{
            repeat{
                d = a - b
                if d.negative==false {
                    a = d;e = e + 1
                }
            }while (d.value != "0"&&d.negative==false)
            f = f + String(e);e = 0;b.value = self.checkString(b.value.substringWithRange(1, to: b.value.length-1)).value
            c2 = c2 - 1
        }while c2>0
        remainder = a.value
        quotient = f
        if anegative {
            remainder = "-" + remainder
        }
        if c1==1 {
            quotient = "-"+quotient
        }
        remainder = self.checkString(remainder).value
        quotient = self.checkString(quotient).value
        return (YSIntString.init(quotient),YSIntString.init(remainder))
    }
    
    func power(_ intString : YSIntString) -> YSIntString {
        if intString.negative==true {
            print("YSIntString目前不支持求负数次幂，默认返回0")
            return YSIntString("0")
        }else if self.value=="0"&&intString.value=="0" {
            print("0的0次幂无意义，默认返回0")
            return YSIntString("0")
        }else{
            var a = self;var b = intString;let c = self
            repeat{
                a = a * c
                b = b - YSIntString("1")
            }while (b.value != "0")
            return a
        }
    }
    
}
