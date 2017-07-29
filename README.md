# YSIntString
## 编写YSIntString的原因
在2016年，我编写了一个名为“高中实用工具”的iOS软件（后因证书到期下架App Store），当时其功能主要为二进制、十进制和十六进制的相互转化。而在实际使用时，我发现当二进制或十六进制数据过长时，转化的十进制数据会超过Double类型的精度，从而出现形如“1.72947293e23”的返回值，然而这并不是软件的使用者想看到的。因此，我设计YSIntString来解决高精度的计算问题。虽然目前YSIntString还没有能力完全解决这个问题，但是我也将继续努力，使它变得更加强大。

## YSIntString使用说明
1.若要创建一个YSIntString对象，你可以使用如下代码：
```Swift
  let intString = YSIntString.init("123456")
```
2.YSIntString对象在创建之后可以修改它的值，使用如下代码：
```Swift
  intString.value = "234567"
```
3.YSIntString目前已支持加减运算，你可以使用如下代码：
```Swift
  let intString1 = YSIntString.init("123456")
  let intString2 = YSIntString.init("234567")
  let intString3 = intString1.plus(intString2) //intString1加intString2
  let intString4 = intString1.minus(intString2) //intString1减intString2
```
4.由于在设计YSIntString时重载了加减运算符，因此以下代码与上一段代码等效：
```Swift
  let intString1 = YSIntString.init("123456")
  let intString2 = YSIntString.init("234567")
  let intString3 = intString1 + intString2 //intString1加intString2
  let intString4 = intString1 - intString2 //intString1减intString2
```

## 最后说几句
我期望YSIntString的高精度计算方式能给大家带来便利，也感谢大家能够选择YSIntString。在加减法部分发布之前，我进行了30万次随机数比对，结果均正确，但仍不排除其运算出错的可能性。在未来的时间里，我将继续更新YSIntString，为它增加乘法、除法、取余、乘方等功能。同样，在本次开发过程中，我发现许多时候条件的判断需要借助变量并结合if语句，因此我也在考虑编写YSConclusion来简化条件判断。如果大家对于YSIntString和YSConclusion有任何的意见和建议，我非常愿意听到你的声音，谢谢大家的支持！
