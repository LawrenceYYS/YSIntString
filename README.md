# YSIntString

## 2019年9月19日发布说明
开发版YSIntString（暂命名YSIntStringDev）加减法发布，可以完成加减法操作。请注意：开发版代码在未来可能会有较大改动，发布前完成了数万次随机数测试比对和人工比对，但这仍不排除其给出错误答案的可能性，请谨慎使用！
开发版新特性（随时间推移可能有变化）：
1.取消了对String类型substringWithRange方法和length计算属性的扩展，新增isIntString计算属性扩展；
2.支持Comparable协议，许多运算符现以static func的形式呈现，而不需要重载运算符；
3.将内部储存形式由字符串变成整型数组，仅在取值时转化为字符串，大大简化运算；
4.大幅减少强制拆包的使用频率，为返回可选数据的函数添加了默认值，提高代码稳定性；
5.代码更加遵循规范，增强可读性……
更多新特性等你去发现哦！

## 2018年2月3日更新说明
2018年第2次更新。在本次更新中，YSIntString迎来了乘方功能（暂不支持求负数次幂），并且增加了比较运算符（包括但不限于大于、小于、等于）。使用说明全部使用结构体写法。

## YSIntString使用说明
1.若要创建一个YSIntString对象，你可以使用如下代码：
```Swift
  let intString = YSIntString("123456")
```
2.YSIntString对象在创建之后可以修改它的值，使用如下代码：
```Swift
  intString.value = "234567"
```
3.YSIntString目前已支持加减乘除和乘方运算，你可以使用如下代码：
```Swift
  let intString1 = YSIntString("123456")
  let intString2 = YSIntString("234567")
  let intString3 = intString1.plus(intString2) //intString1加intString2
  let intString4 = intString1.minus(intString2) //intString1减intString2
  let intString5 = intString1.multiply(intString2) //intString1乘intString2
  let intString6 = intString1.power(intString2) //intString1的intString2次幂
  //除法运算见第5部分
```
4.由于在设计YSIntString时重载了加减乘和乘方运算符，并且添加了比较运算符，代码变得更加简洁：
```Swift
  let intString1 = YSIntString("123456")
  let intString2 = YSIntString("234567")
  let intString3 = intString1 + intString2 //intString1加intString2
  let intString4 = intString1 - intString2 //intString1减intString2
  let intString5 = intString1 * intString2 //intString1乘intString2
  let intString6 = intString1 ^ intString2 //intString1的intString2次幂
  let a = Bool(intString1 > intString2) //a的值为false
  let b = Bool(intString1 < intString2) //b的值为true
  //除法运算见第5部分
```
5.YSIntString除法与加减乘在设计上有一些差距。除法和取余被合并在一个函数中来减少实际运用时的计算量。与加减乘相同的是，设计除法函数时也重载了除运算符。除法函数返回一个元组，你可以使用如下代码：
```Swift
  let intString1 = YSIntString("123456789")
  let intString2 = YSIntString("987")
  let intString3 = intString1.dividedBy(intString2).quotient //使用.quotient来获取整除结果
  let intString4 = intString1.dividedBy(intString2).remainder //使用.remainder来获取取余结果
```

## 注意事项
1.由于String本身的特性，在测试中发现超过5000000个字符的String在处理过程中已经占用了很多的处理器和内存资源，因此建议你在使用过程中避免使用过长的字符串。

2.YSIntString会检查传入数据的格式是否正确，以下是YSIntString发现错误并解决的示例：
```Swift
  let intString1 = YSIntString("-000123四五六")
  //此时控制台中会显示信息 YSIntString在初始化时遇到了不符合规范的值！传递参数："-000123四五六"，传出参数:"-123"
```
格式错误处理机制：YSIntString会忽略无效字符（如代码中的“四五六”），并检查字符串是否存在不必要的数字（如“-000123”会被精简为“-123”）。

## 最后说几句
我期望YSIntString的高精度计算方式能给大家带来便利，也感谢大家能够选择YSIntString。在YSIntString发布之前，我进行了50万次随机数比对，结果均正确，但仍不排除其运算出错的可能性。在未来的时间里，YSIntString将继续得到更新，以提高它的性能。如果大家对于YSIntString有任何的意见和建议，我非常愿意听到你的声音，谢谢大家的支持！
