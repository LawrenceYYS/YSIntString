//
//  YSIntStringDev.swift
//  YSIntString
//
//  Created by 刘云玉树 on 2019/9/1.
//  Copyright © 2019 刘云玉树. All rights reserved.
//

//  只支持64位，32位会当场去世哦！

import Foundation

extension String {
    /// 计算属性，检查字符串是否符合YSIntString标准，true：符合；false：不符合。该计算属性由YSIntString添加。
    var isIntString: Bool {
        let reg = "^(0|[1-9][0-9]*|-[1-9][0-9]*)$"
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        return pre.evaluate(with: self)
    }
}

/// 开发版本的YSIntString
struct YSIntStringDev: Comparable {
    static func > (lhs: YSIntStringDev, rhs: YSIntStringDev) -> Bool {
        let ln = lhs.negative, rn = rhs.negative
        //符号快速判断
        if !ln && rn {
            return true
        }else if ln && !rn {
            return false
        }
        //同符号判断
        let lc = lhs._value.count, rc = rhs._value.count
        if lc == rc {
            for i in (0..<lc).reversed() {
                if lhs._value[i] > rhs._value[i] {
                    return ln ? false : true
                }else if lhs._value[i] < rhs._value[i] {
                    return ln ? true : false
                }
            }
            return false
        }else if lc > rc {
            return ln ? false : true
        }else{
            return ln ? true : false
        }
    }
    
    static func >= (lhs: YSIntStringDev, rhs: YSIntStringDev) -> Bool {
        let ln = lhs.negative, rn = rhs.negative
        //符号快速判断
        if !ln && rn {
            return true
        }else if ln && !rn {
            return false
        }
        //同符号判断
        let lc = lhs._value.count, rc = rhs._value.count
        if lc == rc {
            for i in (0..<lc).reversed() {
                if lhs._value[i] > rhs._value[i] {
                    return ln ? false : true
                }else if lhs._value[i] < rhs._value[i] {
                    return ln ? true : false
                }
            }
            return true
        }else if lc > rc {
            return ln ? false : true
        }else{
            return ln ? true : false
        }
    }
    
    static func < (lhs: YSIntStringDev, rhs: YSIntStringDev) -> Bool {
        let ln = lhs.negative, rn = rhs.negative
        //符号快速判断
        if !ln && rn {
            return false
        }else if ln && !rn {
            return true
        }
        //同符号判断
        let lc = lhs._value.count, rc = rhs._value.count
        if lc == rc {
            for i in (0..<lc).reversed() {
                if lhs._value[i] > rhs._value[i] {
                    return ln ? true : false
                }else if lhs._value[i] < rhs._value[i] {
                    return ln ? false : true
                }
            }
            return false
        }else if lc > rc {
            return ln ? true : false
        }else{
            return ln ? false : true
        }
    }
    
    static func <= (lhs: YSIntStringDev, rhs: YSIntStringDev) -> Bool {
        let ln = lhs.negative, rn = rhs.negative
        //符号快速判断
        if !ln && rn {
            return false
        }else if ln && !rn {
            return true
        }
        //同符号判断
        let lc = lhs._value.count, rc = rhs._value.count
        if lc == rc {
            for i in (0..<lc).reversed() {
                if lhs._value[i] > rhs._value[i] {
                    return ln ? true : false
                }else if lhs._value[i] < rhs._value[i] {
                    return ln ? false : true
                }
            }
            return true
        }else if lc > rc {
            return ln ? true : false
        }else{
            return ln ? false : true
        }
    }
    
    static func == (lhs: YSIntStringDev, rhs: YSIntStringDev) -> Bool {
        if lhs.negative == rhs.negative && lhs._value == rhs._value {
            return true
        }else{
            return false
        }
    }
    
    static func + (lhs: YSIntStringDev, rhs: YSIntStringDev) -> YSIntStringDev {
        return lhs.plus(rhs)
    }
    
    static func - (lhs: YSIntStringDev, rhs: YSIntStringDev) -> YSIntStringDev {
        return lhs.minus(rhs)
    }
    
    static prefix func - (rhs: YSIntStringDev) -> YSIntStringDev {
        var newIntString = YSIntStringDev()
        newIntString._value = rhs._value
        newIntString.negative = rhs._value == [0] ? false : !rhs.negative
        return newIntString
    }
    
    /**
     返回给定YSIntString的绝对值对象。
     
     - Parameter intString: 一个YSIntString对象。
     - Returns: 一个YSIntString对象，其值为给定参数值的绝对值。
     */
    static func abs(_ intString: YSIntStringDev) -> YSIntStringDev {
        var newIntString = YSIntStringDev()
        newIntString._value = intString._value
        newIntString.negative = false
        return newIntString
    }
    
    /// 储存YSIntString值的数组，仅内部访问，若需要获取值请使用`value`
    private var _value = [Int]()
    
    /// 判断YSIntString的正负，true：负；false：正
    private(set) var negative = Bool()
    
    /// 获取/设置YSIntString的值
    var value: String {
        get {
            var tempValue = "";
            for (index, num) in _value.enumerated() {
                tempValue = String(format: index == _value.count - 1 ? "%d" : "%09d", num) + tempValue
            }
            tempValue = (negative ? "-" : "") + tempValue
            return tempValue
        }
        set(intString) {
            if intString.isIntString {
                var tempIntString = intString
                if tempIntString.hasPrefix("-") {
                    negative = true
                    let characterSet = CharacterSet(charactersIn: "-")
                    tempIntString = tempIntString.trimmingCharacters(in: characterSet)
                }else{
                    negative = false
                }
                //把数字字符串转化为数组
                let count = Int(ceil(Double(tempIntString.count) / 9.0))
                _value = [Int](repeating: 0, count: count)
                for i in 0..<count {
                    if tempIntString.count > 9 {
                        //获取最后9个字符并将其截去
                        _value[i] = Int(tempIntString.suffix(from: tempIntString.index(tempIntString.endIndex, offsetBy: -9))) ?? 0
                        tempIntString = String(tempIntString[tempIntString.startIndex...tempIntString.index(tempIntString.endIndex, offsetBy: -10)])
                    }else{
                        _value[i] = Int(tempIntString) ?? 0
                    }
                }
            }else{
                _value = [0]
                negative = false
                print("YSIntString在设置value时遇到了错误格式的字符串，传入参数：\"\(intString)\"，默认返回0。")
            }
        }
    }
    
    /**
     初始化一个YSIntString对象。
     
     - Parameter intString: 可选，一个数字字符串，负数必须以“-”开头，正数前不需要添加任何符号，不提供则默认为0。
     - Returns: 一个YSIntString对象。
     
     如果初始化参数不给出或者不合规，则对象值默认为0。
     */
    init(_ intString: String = "0") {
        if intString.isIntString {
            var tempIntString = intString
            if tempIntString.hasPrefix("-") {
                negative = true
                let characterSet = CharacterSet(charactersIn: "-")
                tempIntString = tempIntString.trimmingCharacters(in: characterSet)
            }else{
                negative = false
            }
            //把数字字符串转化为数组
            let count = Int(ceil(Double(tempIntString.count) / 9.0))
            _value = [Int](repeating: 0, count: count)
            for i in 0..<count {
                if tempIntString.count > 9 {
                    //获取最后9个字符并将其截去
                    _value[i] = Int(tempIntString.suffix(from: tempIntString.index(tempIntString.endIndex, offsetBy: -9))) ?? 0
                    tempIntString = String(tempIntString[tempIntString.startIndex...tempIntString.index(tempIntString.endIndex, offsetBy: -10)])
                }else{
                    _value[i] = Int(tempIntString) ?? 0
                }
            }
        }else{
            _value = [0]
            negative = false
            print("YSIntString在初始化时遇到了错误格式的字符串，传入参数：\"\(intString)\"，默认返回0。")
        }
    }
    
    /**
     将自身与给定YSIntString相加。
     
     - Parameter intString: 一个YSIntString对象，作为加数。
     - Returns: 一个YSIntString对象，其值为两者之和。
     */
    func plus(_ intString: YSIntStringDev) -> YSIntStringDev {
        var newIntString = YSIntStringDev()
        if !self.negative && !intString.negative {
            //正数加正数
            newIntString.negative = false;
            //按照没有进位进行预期
            let expectCount = max(self._value.count, intString._value.count)
            newIntString._value = [Int](repeating: 0, count: expectCount)
            //执行加法操作
            for i in 0..<expectCount {
                newIntString._value[i] = (i < self._value.count ? self._value[i] : 0) + (i < intString._value.count ? intString._value[i] : 0)
            }
            //检查进位
            for i in 0..<expectCount {
                if newIntString._value[i] > 1000000000 {
                    newIntString._value[i] -= 1000000000
                    if i < expectCount - 1 {
                        newIntString._value[i + 1] += 1
                    }else{
                        newIntString._value.append(1)
                    }
                }
            }
        }else if self.negative && intString.negative {
            //负数加负数
            newIntString.negative = true;
            //按照没有进位进行预期
            let expectCount = max(self._value.count, intString._value.count)
            newIntString._value = [Int](repeating: 0, count: expectCount)
            //执行加法操作
            for i in 0..<expectCount {
                newIntString._value[i] = (i < self._value.count ? self._value[i] : 0) + (i < intString._value.count ? intString._value[i] : 0)
                //检查进位
                if newIntString._value[i] > 1000000000 {
                    newIntString._value[i] -= 1000000000
                    if i < expectCount - 1 {
                        newIntString._value[i + 1] += 1
                    }else{
                        newIntString._value.append(1)
                    }
                }
            }
        }else{
            //正数加负数或负数加正数
            let sa = YSIntStringDev.abs(self)
            let ia = YSIntStringDev.abs(intString)
            if sa > ia {
                newIntString.negative = self.negative
                let expectCount = self._value.count
                newIntString._value = [Int](repeating: 0, count: expectCount)
                for i in 0..<expectCount {
                    newIntString._value[i] = self._value[i] - (i < intString._value.count ? intString._value[i] : 0)
                    //检查借位
                    if newIntString._value[i] < 0 && i < expectCount - 1 {
                        newIntString._value[i] += 1000000000
                        newIntString._value[i + 1] -= 1
                    }
                }
                //检查前导0
                for i in (1..<expectCount).reversed() {
                    if newIntString._value[i] == 0 {
                        newIntString._value.removeLast()
                    }
                }
            }else if sa < ia {
                newIntString.negative = intString.negative
                let expectCount = intString._value.count
                newIntString._value = [Int](repeating: 0, count: expectCount)
                for i in 0..<expectCount {
                    newIntString._value[i] = intString._value[i] - (i < self._value.count ? self._value[i] : 0)
                    //检查借位
                    if newIntString._value[i] < 0 && i < expectCount - 1 {
                        newIntString._value[i] += 1000000000
                        newIntString._value[i + 1] -= 1
                    }
                }
                //检查前导0
                for i in (1..<expectCount).reversed() {
                    if newIntString._value[i] == 0 {
                        newIntString._value.removeLast()
                    }
                }
            }
            //当正负数绝对值相等时，直接返回0，故此处省略else
        }
        return newIntString
    }
    
    /**
     将自身与给定YSIntString相减。
     
     - Parameter intString: 一个YSIntString对象，作为减数。
     - Returns: 一个YSIntString对象，其值为两者之差。
     */
    func minus(_ intString: YSIntStringDev) -> YSIntStringDev {
        return self + -intString
    }
}
